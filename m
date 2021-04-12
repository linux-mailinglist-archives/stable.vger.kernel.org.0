Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6635CBD3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244245AbhDLQZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243886AbhDLQYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6977661366;
        Mon, 12 Apr 2021 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244657;
        bh=BoVdH6KrJri0ZVRqOkfW+M41yFN1y391Hopf2LtxxdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sX5pShDMMpagXKRZfsMgmEXXnHho11sWspVvqEWKdHA8dA83HmDv8s/Le4fra2jB0
         R4q9zwewOQXlSxf4z90Ut4AyJBY6bCH0WBX3EXfjEsG1llK3jLcs6Ee7mxj/ETL0p7
         fnc4FUXhd40XElRzXIqlpL0OB+boxs9sxGucR1i5gsdK2Lpnbmdbv+nynYm1uJc2iI
         xwbQNqM+GcUhheBBJzJGGtWWJYdZoXjJJQeenhJowWElSZZf+5Q0XaMe2WZvPdzqkY
         7Snrc1SV8Ug4dGSGKWV4hVCHmg1PdBe2vNv83cbuXZfD8H/NuaOX4NpEVy+RH8ljaM
         7eLEg1FnJK4Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryan Lee <ryans.lee@maximintegrated.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 12/46] ASoC: max98373: Changed amp shutdown register as volatile
Date:   Mon, 12 Apr 2021 12:23:27 -0400
Message-Id: <20210412162401.314035-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Lee <ryans.lee@maximintegrated.com>

[ Upstream commit a23f9099ff1541f15704e96b784d3846d2a4483d ]

0x20FF(amp global enable) register was defined as non-volatile,
but it is not. Overheating, overcurrent can cause amp shutdown
in hardware.
'regmap_write' compare register readback value before writing
to avoid same value writing. 'regmap_read' just read cache
not actual hardware value for the non-volatile register.
When amp is internally shutdown by some reason, next 'AMP ON'
command can be ignored because regmap think amp is already ON.

Signed-off-by: Ryan Lee <ryans.lee@maximintegrated.com>
Link: https://lore.kernel.org/r/20210325033555.29377-1-ryans.lee@maximintegrated.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373-i2c.c | 1 +
 sound/soc/codecs/max98373-sdw.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98373-i2c.c b/sound/soc/codecs/max98373-i2c.c
index 92921e34f948..32b0c1d98365 100644
--- a/sound/soc/codecs/max98373-i2c.c
+++ b/sound/soc/codecs/max98373-i2c.c
@@ -440,6 +440,7 @@ static bool max98373_volatile_reg(struct device *dev, unsigned int reg)
 	case MAX98373_R2054_MEAS_ADC_PVDD_CH_READBACK:
 	case MAX98373_R2055_MEAS_ADC_THERM_CH_READBACK:
 	case MAX98373_R20B6_BDE_CUR_STATE_READBACK:
+	case MAX98373_R20FF_GLOBAL_SHDN:
 	case MAX98373_R21FF_REV_ID:
 		return true;
 	default:
diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index fa589d834f9a..14fd2f9a0bf3 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -214,6 +214,7 @@ static bool max98373_volatile_reg(struct device *dev, unsigned int reg)
 	case MAX98373_R2054_MEAS_ADC_PVDD_CH_READBACK:
 	case MAX98373_R2055_MEAS_ADC_THERM_CH_READBACK:
 	case MAX98373_R20B6_BDE_CUR_STATE_READBACK:
+	case MAX98373_R20FF_GLOBAL_SHDN:
 	case MAX98373_R21FF_REV_ID:
 	/* SoundWire Control Port Registers */
 	case MAX98373_R0040_SCP_INIT_STAT_1 ... MAX98373_R0070_SCP_FRAME_CTLR:
-- 
2.30.2

