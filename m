Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C934256FC7D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiGKJnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiGKJnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6FE564DA;
        Mon, 11 Jul 2022 02:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21080612F3;
        Mon, 11 Jul 2022 09:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A55AC341C0;
        Mon, 11 Jul 2022 09:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531294;
        bh=rbnbSKlh3AoMb2BtRVeYiLLfeO9YqkXAZXJhdq/+F7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DN7skezbO4gJff3jCjbswR69nmDknt/vkuiPn2LIxLbyR0wKorKhollStzKo043d1
         FK8k1HK8aNSVuXJtoixdKSauTcyPzKcjGPzvungIWDgsunRL6/L+vfTCm1V8Wzu3D9
         edU69JsxI/LDcVz0WaHqQgyfYnz7G/mgB8PVLNDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/230] ASoC: rt5682: Re-detect the combo jack after resuming
Date:   Mon, 11 Jul 2022 11:05:10 +0200
Message-Id: <20220711090605.612820760@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index b9d5d7a0975b..b17c14b8b36e 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -196,6 +196,7 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 	}
 
 	mutex_init(&rt5682->calibrate_mutex);
+	mutex_init(&rt5682->jdet_mutex);
 	rt5682_calibrate(rt5682);
 
 	rt5682_apply_patch_list(rt5682, &i2c->dev);
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 949b5638db29..d470b9189768 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -49,6 +49,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_CHARGE_PUMP_1, 0x0210},
 	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
 	{RT5682_SAR_IL_CMD_2, 0xac00},
+	{RT5682_CBJ_CTRL_7, 0x0104},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -943,6 +944,10 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component,
 			RT5682_HP_CHARGE_PUMP_1,
 			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
+		rt5682_enable_push_button_irq(component, false);
+		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
+			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
+		usleep_range(55000, 60000);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_HIGH);
 
@@ -1099,6 +1104,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		return;
 	}
 
+	mutex_lock(&rt5682->jdet_mutex);
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
@@ -1172,6 +1178,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 	}
 
 	mutex_unlock(&rt5682->calibrate_mutex);
+	mutex_unlock(&rt5682->jdet_mutex);
 }
 EXPORT_SYMBOL_GPL(rt5682_jack_detect_handler);
 
@@ -1521,6 +1528,7 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *component =
 		snd_soc_dapm_to_component(w->dapm);
+	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
@@ -1532,12 +1540,17 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
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
@@ -2969,7 +2982,7 @@ static int rt5682_suspend(struct snd_soc_component *component)
 
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
-	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
+	if (rt5682->hs_jack && (rt5682->jack_type & SND_JACK_HEADSET) == SND_JACK_HEADSET) {
 		val = snd_soc_component_read(component,
 				RT5682_CBJ_CTRL_2) & RT5682_JACK_TYPE_MASK;
 
@@ -3000,6 +3013,8 @@ static int rt5682_suspend(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK,
 			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV);
+		snd_soc_component_update_bits(component, RT5682_HP_CHARGE_PUMP_1,
+			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
 	}
 
 	regcache_cache_only(rt5682->regmap, true);
@@ -3017,10 +3032,11 @@ static int rt5682_resume(struct snd_soc_component *component)
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
@@ -3028,8 +3044,9 @@ static int rt5682_resume(struct snd_soc_component *component)
 			RT5682_PWR_CBJ, RT5682_PWR_CBJ);
 	}
 
+	rt5682->jack_type = 0;
 	mod_delayed_work(system_power_efficient_wq,
-		&rt5682->jack_detect_work, msecs_to_jiffies(250));
+		&rt5682->jack_detect_work, msecs_to_jiffies(0));
 
 	return 0;
 }
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index 8e3244a62c16..f866d207d1bd 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1462,6 +1462,7 @@ struct rt5682_priv {
 
 	int jack_type;
 	int irq_work_delay_time;
+	struct mutex jdet_mutex;
 };
 
 extern const char *rt5682_supply_names[RT5682_NUM_SUPPLIES];
-- 
2.35.1



