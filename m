Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2883146371F
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242444AbhK3OvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:51:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56606 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242448AbhK3OvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C289CCE1A43;
        Tue, 30 Nov 2021 14:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB151C53FC1;
        Tue, 30 Nov 2021 14:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283670;
        bh=95gX2SyCyY5pvD3w7SSW5i5iMBXXLJvId/2p6erOAQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxTAjDHUD15XfL5m9QoOQ8sJ5jHSfEXqMYIRRX1Wv//rMESH3sBdS7GGLvLgPbaMe
         WTtDlpY0Or2fJnQWSBUpfYT8rBzguurdx/ekDct8YXXkK+p9FlupRpjN2HM5fdsWTB
         CrLNDljfwLb9E0aFHkRc/ooRMpjtPyvNkqvGeX3P3ZANYPsImCnDz0piw6O5ePTCIv
         X/cOwGTD8scyg/CZ2EDohqQQY5896XXkW5qCUlMYSQgbNibeO34P4xGK5/vaQBEXj8
         9Lt68Fjb8MOXCYPL1NhhI7XEQizcf+R6n4FnEz5ta0Js8cEKsACdFNZ7TcWL/Ln/Y6
         1+fHdvgFGdJrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 12/68] ASoC: rt5682: Re-detect the combo jack after resuming
Date:   Tue, 30 Nov 2021 09:46:08 -0500
Message-Id: <20211130144707.944580-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 2cd9b0ef82d936623d789bb3fbb6fcf52c500367 ]

Sometimes, end-users change the jack type under suspending,
so it needs to re-detect the combo jack type after resuming to
avoid any unexpected behaviors.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20211109095450.12950-2-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c |  1 +
 sound/soc/codecs/rt5682.c     | 23 ++++++++++++++++++++---
 sound/soc/codecs/rt5682.h     |  1 +
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index b9d5d7a0975b3..b17c14b8b36e3 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -196,6 +196,7 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 	}
 
 	mutex_init(&rt5682->calibrate_mutex);
+	mutex_init(&rt5682->jdet_mutex);
 	rt5682_calibrate(rt5682);
 
 	rt5682_apply_patch_list(rt5682, &i2c->dev);
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index cfa284855c84e..b57552a8310c0 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -49,6 +49,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_CHARGE_PUMP_1, 0x0210},
 	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
 	{RT5682_SAR_IL_CMD_2, 0xac00},
+	{RT5682_CBJ_CTRL_7, 0x0104},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -941,6 +942,10 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component,
 			RT5682_HP_CHARGE_PUMP_1,
 			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
+		rt5682_enable_push_button_irq(component, false);
+		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
+			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
+		usleep_range(55000, 60000);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_HIGH);
 
@@ -1093,6 +1098,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 	while (!rt5682->component->card->instantiated)
 		usleep_range(10000, 15000);
 
+	mutex_lock(&rt5682->jdet_mutex);
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
@@ -1166,6 +1172,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 	}
 
 	mutex_unlock(&rt5682->calibrate_mutex);
+	mutex_unlock(&rt5682->jdet_mutex);
 }
 EXPORT_SYMBOL_GPL(rt5682_jack_detect_handler);
 
@@ -1515,6 +1522,7 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *component =
 		snd_soc_dapm_to_component(w->dapm);
+	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
@@ -1526,12 +1534,17 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_DEPOP_1, 0x60, 0x60);
 		snd_soc_component_update_bits(component,
 			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0080);
+
+		mutex_lock(&rt5682->jdet_mutex);
+
 		snd_soc_component_update_bits(component, RT5682_HP_CTRL_2,
 			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN,
 			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN);
 		usleep_range(5000, 10000);
 		snd_soc_component_update_bits(component, RT5682_CHARGE_PUMP_1,
 			RT5682_CP_SW_SIZE_MASK, RT5682_CP_SW_SIZE_L);
+
+		mutex_unlock(&rt5682->jdet_mutex);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
@@ -2961,7 +2974,7 @@ static int rt5682_suspend(struct snd_soc_component *component)
 
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
-	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
+	if (rt5682->hs_jack && (rt5682->jack_type & SND_JACK_HEADSET) == SND_JACK_HEADSET) {
 		val = snd_soc_component_read(component,
 				RT5682_CBJ_CTRL_2) & RT5682_JACK_TYPE_MASK;
 
@@ -2992,6 +3005,8 @@ static int rt5682_suspend(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK,
 			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV);
+		snd_soc_component_update_bits(component, RT5682_HP_CHARGE_PUMP_1,
+			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
 	}
 
 	regcache_cache_only(rt5682->regmap, true);
@@ -3009,10 +3024,11 @@ static int rt5682_resume(struct snd_soc_component *component)
 	regcache_cache_only(rt5682->regmap, false);
 	regcache_sync(rt5682->regmap);
 
-	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
+	if (rt5682->hs_jack && (rt5682->jack_type & SND_JACK_HEADSET) == SND_JACK_HEADSET) {
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTDET_MODE_MASK | RT5682_SAR_SEL_MB1_MB2_MASK,
 			RT5682_SAR_BUTDET_POW_NORM | RT5682_SAR_SEL_MB1_MB2_AUTO);
+		usleep_range(5000, 6000);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
 			RT5682_CTRL_MB1_FSM | RT5682_CTRL_MB2_FSM);
@@ -3020,8 +3036,9 @@ static int rt5682_resume(struct snd_soc_component *component)
 			RT5682_PWR_CBJ, RT5682_PWR_CBJ);
 	}
 
+	rt5682->jack_type = 0;
 	mod_delayed_work(system_power_efficient_wq,
-		&rt5682->jack_detect_work, msecs_to_jiffies(250));
+		&rt5682->jack_detect_work, msecs_to_jiffies(0));
 
 	return 0;
 }
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index 8e3244a62c160..f866d207d1bd6 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1462,6 +1462,7 @@ struct rt5682_priv {
 
 	int jack_type;
 	int irq_work_delay_time;
+	struct mutex jdet_mutex;
 };
 
 extern const char *rt5682_supply_names[RT5682_NUM_SUPPLIES];
-- 
2.33.0

