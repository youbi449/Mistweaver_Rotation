local _, addonTable = ...;

--- @type MaxDps
if not MaxDps then
    return
end

local MaxDps = MaxDps;
local Monk = addonTable.Monk;
local MaxDps = MaxDps;
local UnitPower = UnitPower;

local MR = {
    TigerPalm = 100780,
    BlackoutKick = 100784,
    RisingSunKick = 107428,
    SpinningCraneKick = 101546,
    TouchofDeath = 322109,
    -- Talents
    ChiWave = 115098,
    ChiBurst = 123986,
    --
    -- Kyrian
    WeaponsofOrder = 310454,
    --
    -- Venthyr
    FallenOrder = 326860,
    --
    -- NightFae
    FaelineStomp = 327104,
    --
    -- Necrolord
    BonedustBrew = 325216
    --
};

local S = {
    Vivify = 116670,
    SoothingMist = 115175,
    EnvelopingMist = 124682,
    RenewingMist = 115151,
    FocusedThunder = 197895,
    ThunderFocusTea = 116680,
    LifeCocoon = 116849,
    EssenceFont = 191837,
    MasteryGustofMists = 117907,
    RisingSunKick = 107428,
    RisingMist = 274909,
    ChiBurst = 123986,
    RefreshingJadeWind = 196725,
    Upwelling = 274963,
    Revival = 115310,
    Yulon = 322118,
    ManaTea = 197908,
    TeachingsoftheMonastery = 116645,
    BlackoutKick = 100784,
    Innervate = 29166,
    EnvelopingBreath = 343655,
    MistWrap = 197900,
    MysticTouch = 8647,
    ChiJi = 325197,
    SummonJadeSerpentStatue = 115313,
    Roll = 109132,
    Celerity = 115173,
    Transcendence = 101643,
    TranscendenceTransfer = 119996
};

local CN = {
    None = 0,
    Kyrian = 1,
    Venthyr = 2,
    NightFae = 3,
    Necrolord = 4
};

setmetatable(MR, Monk.spellMeta);
function AoeHeal(limit, number)
    local aoe = 0
    if math.floor((UnitHealth("player") / UnitHealthMax("player")) * 100) <= limit then
        aoe = aoe + 1
    end
    for i = 1, 4 do
        local healthPercent = math.floor((UnitHealth("party" .. i) / UnitHealthMax("party" .. i)) * 100)
        if not UnitIsDead("party" .. i) then
            if UnitInRange("party" .. i) then
                if healthPercent <= limit then
                    aoe = aoe + 1
                end
            end
        end
    end
    if aoe >= number then
        return true
    else
        return false
    end
end
function Buff(buff, unit)
    for i = 1, 40 do
        name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
            UnitBuff(unit, i)
        if spellId == buff then
            return true
        end
    end
    return false
end
function Monk:Mistweaver()
    fd = MaxDps.FrameData;
    covenantId = fd.covenant.covenantId;
    targets = MaxDps:SmartAoe();
    cooldown = fd.cooldown;
    buff = fd.buff;
    debuff = fd.debuff;
    talents = fd.talents;
    targets = fd.targets;
    gcd = fd.gcd;
    targetHp = MaxDps:TargetPercentHealth() * 100;
    selfHealth = UnitHealth('player');
    selfHealthMax = UnitHealthMax('player');
    selfHealthPercent = (selfHealth / selfHealthMax) * 100;
    health = UnitHealth('target');
    healthMax = UnitHealthMax('target');
    healthPercent = (health / healthMax) * 100;
    MaxDps:GlowEssences();
    --[[ handle AOE Healing ]]
    if cooldown[S.ThunderFocusTea].ready and not Buff(S.ThunderFocusTea, 'player') then
        return S.ThunderFocusTea
    end
    if AoeHeal(85, 3) and cooldown[S.EssenceFont].ready then
        return S.EssenceFont
    end
    if UnitIsEnemy('player', 'target') then
        return Monk:selfHeal()
    else
        return Monk:TargetHeal()
    end

end

function Monk:TargetHeal()

    if healthPercent < 25 and cooldown[S.LifeCocoon].ready then
        return S.LifeCocoon
    end
    if healthPercent < 60 and not Buff(S.EnvelopingMist, 'target') and Buff(S.SoothingMist, 'target') then
        return S.EnvelopingMist
    end
    if healthPercent < 70 and Buff(S.SoothingMist, 'target') then
        return S.Vivify
    end
    if healthPercent < 90 and not Buff(S.SoothingMist, 'target') then
        return S.SoothingMist
    end
    --[[     if healthPercent < 95 and not Buff(S.RenewingMist, 'target') and cooldown[S.RenewingMist].ready then
        return S.RenewingMist
    end ]]

end
function Monk:selfHeal()

    if selfHealthPercent < 25 and cooldown[S.LifeCocoon].ready then
        return S.LifeCocoon
    end
    if selfHealthPercent < 60 and not Buff(S.EnvelopingMist, 'player') and Buff(S.SoothingMist, 'player') then
        return S.EnvelopingMist
    end
    if selfHealthPercent < 70 and Buff(S.SoothingMist, 'player') then
        return S.Vivify
    end
    if selfHealthPercent < 90 and not Buff(S.SoothingMist, 'player') then
        return S.SoothingMist
    end
    --[[     if selfHealthPercent < 95 and not Buff(S.RenewingMist, 'player') and cooldown[S.RenewingMist].ready then
        return S.RenewingMist
    end ]]

end
