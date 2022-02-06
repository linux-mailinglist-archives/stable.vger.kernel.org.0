Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEF94AAF3E
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiBFMs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:48:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2891DC06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B996360F79
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B42AC340E9;
        Sun,  6 Feb 2022 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151707;
        bh=++WAjQiO4jKn3JqYgtr2ymnERF/FVuCppjyRjypQddU=;
        h=Subject:To:Cc:From:Date:From;
        b=soyqC9rvIjQF0OpjMrNaJ2HcF55szP8+VmRMnZNneu6Gfj5OkXWooRvMv590RfrAC
         +ihjQCUxjdRGVLT6KL3fw7K2t3G9oxOOVLtSaJinzCIiCfMCdoXwA9KC4QTk7ouUnJ
         IT9PVzhhr3iSse/lKFisR4wnkHT4AYxfVlUGUwUM=
Subject: FAILED: patch "[PATCH] ASoC: rt5682: Fix deadlock on resume" failed to apply to 5.10-stable tree
To:     peter.ujfalusi@linux.intel.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:48:23 +0100
Message-ID: <1644151703193161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4045daf0fa87846a27f56329fddad2deeb5ca354 Mon Sep 17 00:00:00 2001
From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Date: Wed, 26 Jan 2022 12:03:25 +0200
Subject: [PATCH] ASoC: rt5682: Fix deadlock on resume

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

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 20e0f90ea498..20fc0f3766de 100644
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
@@ -198,7 +192,6 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 	}
 
 	mutex_init(&rt5682->calibrate_mutex);
-	mutex_init(&rt5682->jdet_mutex);
 	rt5682_calibrate(rt5682);
 
 	rt5682_apply_patch_list(rt5682, &i2c->dev);
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 415ec564c82e..0a0ec4a021e1 100644
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
 
 	while (!rt5682->component)
@@ -1102,7 +1098,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 	while (!rt5682->component->card->instantiated)
 		usleep_range(10000, 15000);
 
-	mutex_lock(&rt5682->jdet_mutex);
+	dapm = snd_soc_component_get_dapm(rt5682->component);
+
+	snd_soc_dapm_mutex_lock(dapm);
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
@@ -1162,6 +1160,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		rt5682->irq_work_delay_time = 50;
 	}
 
+	mutex_unlock(&rt5682->calibrate_mutex);
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	snd_soc_jack_report(rt5682->hs_jack, rt5682->jack_type,
 		SND_JACK_HEADSET |
 		SND_JACK_BTN_0 | SND_JACK_BTN_1 |
@@ -1174,9 +1175,6 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		else
 			cancel_delayed_work_sync(&rt5682->jd_check_work);
 	}
-
-	mutex_unlock(&rt5682->calibrate_mutex);
-	mutex_unlock(&rt5682->jdet_mutex);
 }
 EXPORT_SYMBOL_GPL(rt5682_jack_detect_handler);
 
@@ -1526,7 +1524,6 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *component =
 		snd_soc_dapm_to_component(w->dapm);
-	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
@@ -1538,17 +1535,12 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
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
index c917c76200ea..52ff0d9c36c5 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1463,7 +1463,6 @@ struct rt5682_priv {
 
 	int jack_type;
 	int irq_work_delay_time;
-	struct mutex jdet_mutex;
 };
 
 extern const char *rt5682_supply_names[RT5682_NUM_SUPPLIES];
@@ -1473,7 +1472,6 @@ int rt5682_sel_asrc_clk_src(struct snd_soc_component *component,
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev);
 
-int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert);
 void rt5682_jack_detect_handler(struct work_struct *work);
 
 bool rt5682_volatile_register(struct device *dev, unsigned int reg);

