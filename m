Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143F544B5DF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbhKIWXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343986AbhKIWWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE7F6134F;
        Tue,  9 Nov 2021 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496301;
        bh=KWQyp4KUtiDZ2PSsjvtehTLYYsXDPgG/pPblwLRzOGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgMec/isS0i82qmGs71Nn9GhCH4HOY5WpPvAdhLUj24t8IiDsP+nDpeDC9fchLBMq
         wI8NMUdxb1kEr/MomT96g1Uq5xXcoLpCQQBsA+vBB+J+SuPfyzvxo8aD7+lwRUe0Ib
         +Eju/QustXk8UqrA7PA/+FkTjFcsdy5KTpx2AdJ7ltLROKNzv9bnhIseEZ1AwqkjZm
         dhaWCIYQqKW90MCTyTea62sMjkcatC5OGOLAcBNW8n3jrS1xf5hQSKiHKzrRzTXQCW
         VngEHBGP9fC1jKQ/09O2s32XV+BYo9nIFiD5UaYHxFneY9r3GUWy23yBJFFFQD6PEc
         zbmLTU4NzCtbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bardliao@realtek.com,
        oder_chiou@realtek.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 55/82] ASoC: rt5682: fix a little pop while playback
Date:   Tue,  9 Nov 2021 17:16:13 -0500
Message-Id: <20211109221641.1233217-55-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 4b19e4a77cc6baa0f840e8bae62ab974667f6207 ]

A little pop can be heard obviously from HP while playing a silent.
This patch fixes it by using two functions:
1. Enable HP 1bit output mode.
2. Change the charge pump switch size during playback on and off.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20211014094054.811-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 56 +++++++++++++++++++++++++++++++++------
 sound/soc/codecs/rt5682.h | 20 ++++++++++++++
 2 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 4a64cab99c55b..d550c0705c28b 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -46,6 +46,8 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_SAR_IL_CMD_1, 0x22b7},
 	{RT5682_SAR_IL_CMD_3, 0x0365},
 	{RT5682_SAR_IL_CMD_6, 0x0110},
+	{RT5682_CHARGE_PUMP_1, 0x0210},
+	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -1515,21 +1517,29 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		snd_soc_component_write(component,
-			RT5682_HP_LOGIC_CTRL_2, 0x0012);
-		snd_soc_component_write(component,
-			RT5682_HP_CTRL_2, 0x6000);
+		snd_soc_component_update_bits(component, RT5682_HP_CTRL_2,
+			RT5682_HP_C2_DAC_AMP_MUTE, 0);
+		snd_soc_component_update_bits(component, RT5682_HP_LOGIC_CTRL_2,
+			RT5682_HP_LC2_SIG_SOUR2_MASK, RT5682_HP_LC2_SIG_SOUR2_REG);
 		snd_soc_component_update_bits(component,
 			RT5682_DEPOP_1, 0x60, 0x60);
 		snd_soc_component_update_bits(component,
 			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0080);
+		snd_soc_component_update_bits(component, RT5682_HP_CTRL_2,
+			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN,
+			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN);
+		usleep_range(5000, 10000);
+		snd_soc_component_update_bits(component, RT5682_CHARGE_PUMP_1,
+			RT5682_CP_SW_SIZE_MASK, RT5682_CP_SW_SIZE_L);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
+		snd_soc_component_update_bits(component, RT5682_HP_CTRL_2,
+			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN, 0);
+		snd_soc_component_update_bits(component, RT5682_CHARGE_PUMP_1,
+			RT5682_CP_SW_SIZE_MASK, RT5682_CP_SW_SIZE_M);
 		snd_soc_component_update_bits(component,
 			RT5682_DEPOP_1, 0x60, 0x0);
-		snd_soc_component_write(component,
-			RT5682_HP_CTRL_2, 0x0000);
 		snd_soc_component_update_bits(component,
 			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0000);
 		break;
@@ -1637,6 +1647,23 @@ static SOC_VALUE_ENUM_SINGLE_DECL(rt5682_adcdat_pin_enum,
 static const struct snd_kcontrol_new rt5682_adcdat_pin_ctrl =
 	SOC_DAPM_ENUM("ADCDAT", rt5682_adcdat_pin_enum);
 
+static const unsigned int rt5682_hpo_sig_out_values[] = {
+	2,
+	7,
+};
+
+static const char * const rt5682_hpo_sig_out_mode[] = {
+	"Legacy",
+	"OneBit",
+};
+
+static SOC_VALUE_ENUM_SINGLE_DECL(rt5682_hpo_sig_out_enum,
+	RT5682_HP_LOGIC_CTRL_2, 0, RT5682_HP_LC2_SIG_SOUR1_MASK,
+	rt5682_hpo_sig_out_mode, rt5682_hpo_sig_out_values);
+
+static const struct snd_kcontrol_new rt5682_hpo_sig_demux =
+	SOC_DAPM_ENUM("HPO Signal Demux", rt5682_hpo_sig_out_enum);
+
 static const struct snd_soc_dapm_widget rt5682_dapm_widgets[] = {
 	SND_SOC_DAPM_SUPPLY("LDO2", RT5682_PWR_ANLG_3, RT5682_PWR_LDO2_BIT,
 		0, NULL, 0),
@@ -1820,6 +1847,10 @@ static const struct snd_soc_dapm_widget rt5682_dapm_widgets[] = {
 	SND_SOC_DAPM_SWITCH("HPOR Playback", SND_SOC_NOPM, 0, 0,
 		&hpor_switch),
 
+	SND_SOC_DAPM_OUT_DRV("HPO Legacy", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_OUT_DRV("HPO OneBit", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_DEMUX("HPO Signal Demux", SND_SOC_NOPM, 0, 0, &rt5682_hpo_sig_demux),
+
 	/* CLK DET */
 	SND_SOC_DAPM_SUPPLY("CLKDET SYS", RT5682_CLK_DET,
 		RT5682_SYS_CLK_DET_SFT,	0, NULL, 0),
@@ -1987,10 +2018,19 @@ static const struct snd_soc_dapm_route rt5682_dapm_routes[] = {
 	{"HP Amp", NULL, "Charge Pump"},
 	{"HP Amp", NULL, "CLKDET SYS"},
 	{"HP Amp", NULL, "Vref1"},
-	{"HPOL Playback", "Switch", "HP Amp"},
-	{"HPOR Playback", "Switch", "HP Amp"},
+
+	{"HPO Signal Demux", NULL, "HP Amp"},
+
+	{"HPO Legacy", "Legacy", "HPO Signal Demux"},
+	{"HPO OneBit", "OneBit", "HPO Signal Demux"},
+
+	{"HPOL Playback", "Switch", "HPO Legacy"},
+	{"HPOR Playback", "Switch", "HPO Legacy"},
+
 	{"HPOL", NULL, "HPOL Playback"},
 	{"HPOR", NULL, "HPOR Playback"},
+	{"HPOL", NULL, "HPO OneBit"},
+	{"HPOR", NULL, "HPO OneBit"},
 };
 
 static int rt5682_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index b59221048ebf9..8e3244a62c160 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -375,6 +375,14 @@
 #define RT5682_R_VOL_MASK			(0x3f)
 #define RT5682_R_VOL_SFT			0
 
+/* Headphone Amp Control 2 (0x0003) */
+#define RT5682_HP_C2_DAC_AMP_MUTE_SFT		15
+#define RT5682_HP_C2_DAC_AMP_MUTE		(0x1 << 15)
+#define RT5682_HP_C2_DAC_L_EN_SFT		14
+#define RT5682_HP_C2_DAC_L_EN			(0x1 << 14)
+#define RT5682_HP_C2_DAC_R_EN_SFT		13
+#define RT5682_HP_C2_DAC_R_EN			(0x1 << 13)
+
 /*Headphone Amp L/R Analog Gain and Digital NG2 Gain Control (0x0005 0x0006)*/
 #define RT5682_G_HP				(0xf << 8)
 #define RT5682_G_HP_SFT				8
@@ -1265,6 +1273,10 @@
 #define RT5682_HPA_CP_BIAS_6UA			(0x3 << 2)
 
 /* Charge Pump Internal Register1 (0x0125) */
+#define RT5682_CP_SW_SIZE_MASK			(0x7 << 8)
+#define RT5682_CP_SW_SIZE_L			(0x4 << 8)
+#define RT5682_CP_SW_SIZE_M			(0x2 << 8)
+#define RT5682_CP_SW_SIZE_S			(0x1 << 8)
 #define RT5682_CP_CLK_HP_MASK			(0x3 << 4)
 #define RT5682_CP_CLK_HP_100KHZ			(0x0 << 4)
 #define RT5682_CP_CLK_HP_200KHZ			(0x1 << 4)
@@ -1315,6 +1327,14 @@
 #define RT5682_DEB_STO_DAC_MASK			(0x7 << 4)
 #define RT5682_DEB_80_MS			(0x0 << 4)
 
+/* HP Behavior Logic Control 2 (0x01db) */
+#define RT5682_HP_LC2_SIG_SOUR2_MASK		(0x1 << 4)
+#define RT5682_HP_LC2_SIG_SOUR2_REG		(0x1 << 4)
+#define RT5682_HP_LC2_SIG_SOUR2_DC_CAL		(0x0 << 4)
+#define RT5682_HP_LC2_SIG_SOUR1_MASK		(0x7)
+#define RT5682_HP_LC2_SIG_SOUR1_1BIT		(0x7)
+#define RT5682_HP_LC2_SIG_SOUR1_LEGA		(0x2)
+
 /* SAR ADC Inline Command Control 1 (0x0210) */
 #define RT5682_SAR_BUTT_DET_MASK		(0x1 << 15)
 #define RT5682_SAR_BUTT_DET_EN			(0x1 << 15)
-- 
2.33.0

