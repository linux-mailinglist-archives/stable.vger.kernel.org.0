Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4285540B98
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351299AbiFGS3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352517AbiFGS0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:26:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E6416ABD3;
        Tue,  7 Jun 2022 10:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C1CD6137B;
        Tue,  7 Jun 2022 17:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0783C34115;
        Tue,  7 Jun 2022 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624472;
        bh=4TkevXRxOTHvzW9lOa3ykUFgFANd3p+LPqhypV6Xnnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfukVziGrYN6F9DMMY7M3GuA384evSK7CDTaJaKAlUyOQfLPDrWSwHs1GVeTcVjnG
         ZABoMjI4DVNuez9w5hRk9bk4orMEjHxOVLJJKYB7feh9sEKYGdgpBh0uT4jk6QMttr
         ftZNu7Tg5bTielxMRSVRjhQfGyBu7iGCtvtNRs6hHlmJEzkHtGdF90hLxHjUT5pyep
         qb1wrK0hncnh5RU4gusL7iFM8ltZCP/+TS8wVAYBr7kJYSnrcDI24TZz+D802RWFH7
         6FzeEQ4rMW0Q1IcM8SVSvI2gtoG8RJthmIf425w+9jM/+1JJvKheHNqy3ch87E77U1
         XaBHSRKc4ev0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, cezary.rojewski@intel.com,
        pierre-louis.bossart@linux.intel.com, yang.jie@linux.intel.com,
        hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        peter.ujfalusi@linux.intel.com, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 36/60] ASoC: rt5640: Do not manipulate pin "Platform Clock" if the "Platform Clock" is not in the DAPM
Date:   Tue,  7 Jun 2022 13:52:33 -0400
Message-Id: <20220607175259.478835-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 832296804bc7171730884e78c761c29f6d258e13 ]

The pin "Platform Clock" was only used by the Intel Byt CR platform. In the
others, the error log will be informed. The patch will set the flag to
avoid the pin "Platform Clock" manipulated by the other platforms.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Reported-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20220516103055.20003-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c             | 11 +++++++++--
 sound/soc/codecs/rt5640.h             |  2 ++
 sound/soc/intel/boards/bytcr_rt5640.c |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index e7a82565b905..f078463346e8 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2097,12 +2097,14 @@ EXPORT_SYMBOL_GPL(rt5640_sel_asrc_clk_src);
 void rt5640_enable_micbias1_for_ovcd(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct rt5640_priv *rt5640 = snd_soc_component_get_drvdata(component);
 
 	snd_soc_dapm_mutex_lock(dapm);
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "LDO2");
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS1");
 	/* OVCD is unreliable when used with RCCLK as sysclk-source */
-	snd_soc_dapm_force_enable_pin_unlocked(dapm, "Platform Clock");
+	if (rt5640->use_platform_clock)
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "Platform Clock");
 	snd_soc_dapm_sync_unlocked(dapm);
 	snd_soc_dapm_mutex_unlock(dapm);
 }
@@ -2111,9 +2113,11 @@ EXPORT_SYMBOL_GPL(rt5640_enable_micbias1_for_ovcd);
 void rt5640_disable_micbias1_for_ovcd(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct rt5640_priv *rt5640 = snd_soc_component_get_drvdata(component);
 
 	snd_soc_dapm_mutex_lock(dapm);
-	snd_soc_dapm_disable_pin_unlocked(dapm, "Platform Clock");
+	if (rt5640->use_platform_clock)
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Platform Clock");
 	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS1");
 	snd_soc_dapm_disable_pin_unlocked(dapm, "LDO2");
 	snd_soc_dapm_sync_unlocked(dapm);
@@ -2538,6 +2542,9 @@ static void rt5640_enable_jack_detect(struct snd_soc_component *component,
 		rt5640->jd_gpio_irq_requested = true;
 	}
 
+	if (jack_data && jack_data->use_platform_clock)
+		rt5640->use_platform_clock = jack_data->use_platform_clock;
+
 	ret = request_irq(rt5640->irq, rt5640_irq,
 			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			  "rt5640", rt5640);
diff --git a/sound/soc/codecs/rt5640.h b/sound/soc/codecs/rt5640.h
index 9e49b9a0ccaa..505c93514051 100644
--- a/sound/soc/codecs/rt5640.h
+++ b/sound/soc/codecs/rt5640.h
@@ -2155,11 +2155,13 @@ struct rt5640_priv {
 	bool jd_inverted;
 	unsigned int ovcd_th;
 	unsigned int ovcd_sf;
+	bool use_platform_clock;
 };
 
 struct rt5640_set_jack_data {
 	int codec_irq_override;
 	struct gpio_desc *jd_gpio;
+	bool use_platform_clock;
 };
 
 int rt5640_dmic_enable(struct snd_soc_component *component,
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 2ace32c03ec9..cc5703ecf523 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1179,12 +1179,14 @@ static int byt_rt5640_init(struct snd_soc_pcm_runtime *runtime)
 {
 	struct snd_soc_card *card = runtime->card;
 	struct byt_rt5640_private *priv = snd_soc_card_get_drvdata(card);
+	struct rt5640_set_jack_data *jack_data = &priv->jack_data;
 	struct snd_soc_component *component = asoc_rtd_to_codec(runtime, 0)->component;
 	const struct snd_soc_dapm_route *custom_map = NULL;
 	int num_routes = 0;
 	int ret;
 
 	card->dapm.idle_bias_off = true;
+	jack_data->use_platform_clock = true;
 
 	/* Start with RC clk for jack-detect (we disable MCLK below) */
 	if (byt_rt5640_quirk & BYT_RT5640_MCLK_EN)
-- 
2.35.1

