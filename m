Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8891850F4E2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiDZIk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345730AbiDZIj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF0C3CA59;
        Tue, 26 Apr 2022 01:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5A3B617D2;
        Tue, 26 Apr 2022 08:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF06DC385A4;
        Tue, 26 Apr 2022 08:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961844;
        bh=E6X3ptirYwat2tUUxAHSXLZPRaN7WMBiq59cx1MfAMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/VNc29ibksIY/xSC+fu5Iu+kVWSae3k8Wv7+ffRy5eRJDnBtphUZ8jZ+FmbmCrRV
         xULkXEjJw/3TyI591Fd8seKKfwlZNxwYZj5fTUOInKIMtG/CXVZswQ0VvvpWKmJYdK
         P4r/QMprk58Vbcj0DBoDYCH4CgzGW+gfRNSP/8+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/62] ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek
Date:   Tue, 26 Apr 2022 10:20:50 +0200
Message-Id: <20220426081737.521931311@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit c775cbf62ed4911e4f0f23880f01815753123690 ]

The MCLK of the WM8731 on the AT91SAM9G20-EK board is connected to the
PCK0 output of the SoC, intended in the reference software to be supplied
using PLLB and programmed to 12MHz. As originally written for use with a
board file the audio driver was responsible for configuring the entire tree
but in the conversion to the common clock framework the registration of
the named pck0 and pllb clocks was removed so the driver has failed to
instantiate ever since.

Since the WM8731 driver has had support for managing a MCLK provided via
the common clock framework for some time we can simply drop all the clock
management code from the machine driver other than configuration of the
sysclk rate, the CODEC driver still respects that configuration from the
machine driver.

Fixes: ff78a189b0ae55f ("ARM: at91: remove old at91-specific clock driver")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220325154241.1600757-2-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/sam9g20_wm8731.c | 61 --------------------------------
 1 file changed, 61 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 05277a88e20d..d1579896f3a1 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -46,35 +46,6 @@
  */
 #undef ENABLE_MIC_INPUT
 
-static struct clk *mclk;
-
-static int at91sam9g20ek_set_bias_level(struct snd_soc_card *card,
-					struct snd_soc_dapm_context *dapm,
-					enum snd_soc_bias_level level)
-{
-	static int mclk_on;
-	int ret = 0;
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-	case SND_SOC_BIAS_PREPARE:
-		if (!mclk_on)
-			ret = clk_enable(mclk);
-		if (ret == 0)
-			mclk_on = 1;
-		break;
-
-	case SND_SOC_BIAS_OFF:
-	case SND_SOC_BIAS_STANDBY:
-		if (mclk_on)
-			clk_disable(mclk);
-		mclk_on = 0;
-		break;
-	}
-
-	return ret;
-}
-
 static const struct snd_soc_dapm_widget at91sam9g20ek_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("Int Mic", NULL),
 	SND_SOC_DAPM_SPK("Ext Spk", NULL),
@@ -135,7 +106,6 @@ static struct snd_soc_card snd_soc_at91sam9g20ek = {
 	.owner = THIS_MODULE,
 	.dai_link = &at91sam9g20ek_dai,
 	.num_links = 1,
-	.set_bias_level = at91sam9g20ek_set_bias_level,
 
 	.dapm_widgets = at91sam9g20ek_dapm_widgets,
 	.num_dapm_widgets = ARRAY_SIZE(at91sam9g20ek_dapm_widgets),
@@ -148,7 +118,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *codec_np, *cpu_np;
-	struct clk *pllb;
 	struct snd_soc_card *card = &snd_soc_at91sam9g20ek;
 	int ret;
 
@@ -162,31 +131,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/*
-	 * Codec MCLK is supplied by PCK0 - set it up.
-	 */
-	mclk = clk_get(NULL, "pck0");
-	if (IS_ERR(mclk)) {
-		dev_err(&pdev->dev, "Failed to get MCLK\n");
-		ret = PTR_ERR(mclk);
-		goto err;
-	}
-
-	pllb = clk_get(NULL, "pllb");
-	if (IS_ERR(pllb)) {
-		dev_err(&pdev->dev, "Failed to get PLLB\n");
-		ret = PTR_ERR(pllb);
-		goto err_mclk;
-	}
-	ret = clk_set_parent(mclk, pllb);
-	clk_put(pllb);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "Failed to set MCLK parent\n");
-		goto err_mclk;
-	}
-
-	clk_set_rate(mclk, MCLK_RATE);
-
 	card->dev = &pdev->dev;
 
 	/* Parse device node info */
@@ -230,9 +174,6 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_mclk:
-	clk_put(mclk);
-	mclk = NULL;
 err:
 	atmel_ssc_put_audio(0);
 	return ret;
@@ -242,8 +183,6 @@ static int at91sam9g20ek_audio_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	clk_disable(mclk);
-	mclk = NULL;
 	snd_soc_unregister_card(card);
 	atmel_ssc_put_audio(0);
 
-- 
2.35.1



