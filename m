Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7035497A1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380253AbiFMN6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380623AbiFMNyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:54:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AE8022E;
        Mon, 13 Jun 2022 04:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CB27612AB;
        Mon, 13 Jun 2022 11:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2CBC3411C;
        Mon, 13 Jun 2022 11:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120124;
        bh=cTkwBkxT7ouNekw9/kv5tZUyoN0QYLavScQ60CsGa8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+F+zjO1n6L3erMavJbh59ChRtduIo7OipXtuuxlsoXuSR2DCM7Sxr2zOKw7vUoIZ
         y622jhenJqyOYgayHTqukWesGif43mgdixjCs5pXBniN8RFfTeqDVw4gfwrc8hSoBn
         YLY2n0aUAioEuxmVWbKWxKsEPCc09o7YL9BA0yHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oder Chiou <oder_chiou@realtek.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 258/339] ASoC: rt5640: Do not manipulate pin "Platform Clock" if the "Platform Clock" is not in the DAPM
Date:   Mon, 13 Jun 2022 12:11:23 +0200
Message-Id: <20220613094934.478111309@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 30c2e7cb7ed2..3559d9ecfa07 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2094,12 +2094,14 @@ EXPORT_SYMBOL_GPL(rt5640_sel_asrc_clk_src);
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
@@ -2108,9 +2110,11 @@ EXPORT_SYMBOL_GPL(rt5640_enable_micbias1_for_ovcd);
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
@@ -2535,6 +2539,9 @@ static void rt5640_enable_jack_detect(struct snd_soc_component *component,
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
index f81ae742faa7..75ec4a9322bb 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1191,12 +1191,14 @@ static int byt_rt5640_init(struct snd_soc_pcm_runtime *runtime)
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



