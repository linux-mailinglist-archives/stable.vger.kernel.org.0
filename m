Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FDF56FC7F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiGKJn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiGKJnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE854A0257;
        Mon, 11 Jul 2022 02:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02016612FA;
        Mon, 11 Jul 2022 09:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9BC341C8;
        Mon, 11 Jul 2022 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531297;
        bh=C11K35FyNvRX8cVJODSQIBAJ4Z/jrcH4PJmtKu348ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvsRYitccQkuXqUNrb/ixwg+ngg4IPHovRE17PkiLrJlETpEVVVN0nLy80n2Hg/e/
         7awKs7/MEmySODwtJVY7gl/VdtW/3lVHIIxzrpiq1OwvZgKa9G+KJcDk/gPyC6WSTl
         q9m0EnhbKEnfbxgKI7/YaQsxPEw7bxdHxmaJ2NPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/230] ASoC: rt5682: Fix deadlock on resume
Date:   Mon, 11 Jul 2022 11:05:11 +0200
Message-Id: <20220711090605.641585241@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 4045daf0fa87846a27f56329fddad2deeb5ca354 ]

On resume from suspend the following chain of events can happen:
A rt5682_resume() -> mod_delayed_work() for jack_detect_work
B DAPM sequence starts ( DAPM is locked now)

A1. rt5682_jack_detect_handler() scheduled
 - Takes both jdet_mutex and calibrate_mutex
 - Calls in to rt5682_headset_detect() which tries to take DAPM lock, it
   starts to wait for it as B path took it already.
B1. DAPM sequence reaches the "HP Amp", rt5682_hp_event() tries to take
    the jdet_mutex, but it is locked in A1, so it waits.

Deadlock.

To solve the deadlock, drop the jdet_mutex, use the jack_detect_work to do
the jack removal handling, move the dapm lock up one level to protect the
most of the rt5682_jack_detect_handler(), but not the jack reporting as it
might trigger a DAPM sequence.
The rt5682_headset_detect() can be changed to static as well.

Fixes: 8deb34a90f063 ("ASoC: rt5682: fix the wrong jack type detected")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220126100325.16513-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 15 ++++-----------
 sound/soc/codecs/rt5682.c     | 24 ++++++++----------------
 sound/soc/codecs/rt5682.h     |  2 --
 3 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index b17c14b8b36e..74a1fee071dd 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -59,18 +59,12 @@ static void rt5682_jd_check_handler(struct work_struct *work)
 	struct rt5682_priv *rt5682 = container_of(work, struct rt5682_priv,
 		jd_check_work.work);
 
-	if (snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
-		& RT5682_JDH_RS_MASK) {
+	if (snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL) & RT5682_JDH_RS_MASK)
 		/* jack out */
-		rt5682->jack_type = rt5682_headset_detect(rt5682->component, 0);
-
-		snd_soc_jack_report(rt5682->hs_jack, rt5682->jack_type,
-			SND_JACK_HEADSET |
-			SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-			SND_JACK_BTN_2 | SND_JACK_BTN_3);
-	} else {
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682->jack_detect_work, 0);
+	else
 		schedule_delayed_work(&rt5682->jd_check_work, 500);
-	}
 }
 
 static irqreturn_t rt5682_irq(int irq, void *data)
@@ -196,7 +190,6 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 	}
 
 	mutex_init(&rt5682->calibrate_mutex);
-	mutex_init(&rt5682->jdet_mutex);
 	rt5682_calibrate(rt5682);
 
 	rt5682_apply_patch_list(rt5682, &i2c->dev);
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index d470b9189768..1cd59e166cce 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -922,15 +922,13 @@ static void rt5682_enable_push_button_irq(struct snd_soc_component *component,
  *
  * Returns detect status.
  */
-int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
+static int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 {
 	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = &component->dapm;
 	unsigned int val, count;
 
 	if (jack_insert) {
-		snd_soc_dapm_mutex_lock(dapm);
-
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB);
@@ -981,8 +979,6 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component, RT5682_MICBIAS_2,
 			RT5682_PWR_CLK25M_MASK | RT5682_PWR_CLK1M_MASK,
 			RT5682_PWR_CLK25M_PU | RT5682_PWR_CLK1M_PU);
-
-		snd_soc_dapm_mutex_unlock(dapm);
 	} else {
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
@@ -1011,7 +1007,6 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 	dev_dbg(component->dev, "jack_type = %d\n", rt5682->jack_type);
 	return rt5682->jack_type;
 }
-EXPORT_SYMBOL_GPL(rt5682_headset_detect);
 
 static int rt5682_set_jack_detect(struct snd_soc_component *component,
 		struct snd_soc_jack *hs_jack, void *data)
@@ -1094,6 +1089,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 {
 	struct rt5682_priv *rt5682 =
 		container_of(work, struct rt5682_priv, jack_detect_work.work);
+	struct snd_soc_dapm_context *dapm;
 	int val, btn_type;
 
 	if (!rt5682->component || !rt5682->component->card ||
@@ -1104,7 +1100,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		return;
 	}
 
-	mutex_lock(&rt5682->jdet_mutex);
+	dapm = snd_soc_component_get_dapm(rt5682->component);
+
+	snd_soc_dapm_mutex_lock(dapm);
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
@@ -1164,6 +1162,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		rt5682->irq_work_delay_time = 50;
 	}
 
+	mutex_unlock(&rt5682->calibrate_mutex);
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	snd_soc_jack_report(rt5682->hs_jack, rt5682->jack_type,
 		SND_JACK_HEADSET |
 		SND_JACK_BTN_0 | SND_JACK_BTN_1 |
@@ -1176,9 +1177,6 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		else
 			cancel_delayed_work_sync(&rt5682->jd_check_work);
 	}
-
-	mutex_unlock(&rt5682->calibrate_mutex);
-	mutex_unlock(&rt5682->jdet_mutex);
 }
 EXPORT_SYMBOL_GPL(rt5682_jack_detect_handler);
 
@@ -1528,7 +1526,6 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *component =
 		snd_soc_dapm_to_component(w->dapm);
-	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
@@ -1540,17 +1537,12 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_DEPOP_1, 0x60, 0x60);
 		snd_soc_component_update_bits(component,
 			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0080);
-
-		mutex_lock(&rt5682->jdet_mutex);
-
 		snd_soc_component_update_bits(component, RT5682_HP_CTRL_2,
 			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN,
 			RT5682_HP_C2_DAC_L_EN | RT5682_HP_C2_DAC_R_EN);
 		usleep_range(5000, 10000);
 		snd_soc_component_update_bits(component, RT5682_CHARGE_PUMP_1,
 			RT5682_CP_SW_SIZE_MASK, RT5682_CP_SW_SIZE_L);
-
-		mutex_unlock(&rt5682->jdet_mutex);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index f866d207d1bd..539a9fe26294 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1462,7 +1462,6 @@ struct rt5682_priv {
 
 	int jack_type;
 	int irq_work_delay_time;
-	struct mutex jdet_mutex;
 };
 
 extern const char *rt5682_supply_names[RT5682_NUM_SUPPLIES];
@@ -1472,7 +1471,6 @@ int rt5682_sel_asrc_clk_src(struct snd_soc_component *component,
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev);
 
-int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert);
 void rt5682_jack_detect_handler(struct work_struct *work);
 
 bool rt5682_volatile_register(struct device *dev, unsigned int reg);
-- 
2.35.1



