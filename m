Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C36540BBF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243000AbiFGSbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351387AbiFGS32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ABC17705D;
        Tue,  7 Jun 2022 10:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12CEDCE2423;
        Tue,  7 Jun 2022 17:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21344C385A5;
        Tue,  7 Jun 2022 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624509;
        bh=3Q2mqvuAauXp8KaaRGjj3t4lY5NlJlbUvBo6L/jCbFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2oMmxVyWPSlkv1Yj78MYqEnCuw1ZkMNiqVrJS46gVgucm0bxap21b/96e4xgmsRh
         o5F/cgjJsbivzATdU2nYa2q2scG2FrAxwb6uqG5MsaQVR2IneG6Qlo3Lz0CNkTTIdy
         Qvm1c75eH5/4uHbf8odSGG5a+SoX/homkg9Yhr7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/667] ASoC: samsung: Use dev_err_probe() helper
Date:   Tue,  7 Jun 2022 18:59:37 +0200
Message-Id: <20220607164944.131251258@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 27c6eaebcf75e4fac145d17c7fa76bc64b60d24c ]

Use the dev_err_probe() helper, instead of open-coding the same
operation.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20211214020843.2225831-21-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/aries_wm8994.c   | 17 +++++++----------
 sound/soc/samsung/arndale.c        |  5 ++---
 sound/soc/samsung/littlemill.c     |  5 ++---
 sound/soc/samsung/lowland.c        |  5 ++---
 sound/soc/samsung/odroid.c         |  4 +---
 sound/soc/samsung/smdk_wm8994.c    |  4 ++--
 sound/soc/samsung/smdk_wm8994pcm.c |  4 ++--
 sound/soc/samsung/snow.c           |  9 +++------
 sound/soc/samsung/speyside.c       |  5 ++---
 sound/soc/samsung/tm2_wm5110.c     |  3 +--
 sound/soc/samsung/tobermory.c      |  5 ++---
 11 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/sound/soc/samsung/aries_wm8994.c b/sound/soc/samsung/aries_wm8994.c
index 313ab650f8d9..5265e546b124 100644
--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -585,19 +585,16 @@ static int aries_audio_probe(struct platform_device *pdev)
 
 	extcon_np = of_parse_phandle(np, "extcon", 0);
 	priv->usb_extcon = extcon_find_edev_by_node(extcon_np);
-	if (IS_ERR(priv->usb_extcon)) {
-		if (PTR_ERR(priv->usb_extcon) != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get extcon device");
-		return PTR_ERR(priv->usb_extcon);
-	}
+	if (IS_ERR(priv->usb_extcon))
+		return dev_err_probe(dev, PTR_ERR(priv->usb_extcon),
+				     "Failed to get extcon device");
 	of_node_put(extcon_np);
 
 	priv->adc = devm_iio_channel_get(dev, "headset-detect");
-	if (IS_ERR(priv->adc)) {
-		if (PTR_ERR(priv->adc) != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get ADC channel");
-		return PTR_ERR(priv->adc);
-	}
+	if (IS_ERR(priv->adc))
+		return dev_err_probe(dev, PTR_ERR(priv->adc),
+				     "Failed to get ADC channel");
+
 	if (priv->adc->channel->type != IIO_VOLTAGE)
 		return -EINVAL;
 
diff --git a/sound/soc/samsung/arndale.c b/sound/soc/samsung/arndale.c
index 606ac5e33a8e..a5dc640d0d76 100644
--- a/sound/soc/samsung/arndale.c
+++ b/sound/soc/samsung/arndale.c
@@ -174,9 +174,8 @@ static int arndale_audio_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(card->dev, card);
 	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev,
-				"snd_soc_register_card() failed: %d\n", ret);
+		dev_err_probe(&pdev->dev, ret,
+			      "snd_soc_register_card() failed\n");
 		goto err_put_of_nodes;
 	}
 	return 0;
diff --git a/sound/soc/samsung/littlemill.c b/sound/soc/samsung/littlemill.c
index 390f2dd735ad..34067cc314ff 100644
--- a/sound/soc/samsung/littlemill.c
+++ b/sound/soc/samsung/littlemill.c
@@ -325,9 +325,8 @@ static int littlemill_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
-			ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card() failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/lowland.c b/sound/soc/samsung/lowland.c
index 998d10cf8c94..7b12ccd2a9b2 100644
--- a/sound/soc/samsung/lowland.c
+++ b/sound/soc/samsung/lowland.c
@@ -183,9 +183,8 @@ static int lowland_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
-			ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card() failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/odroid.c b/sound/soc/samsung/odroid.c
index ca643a488c3c..4ff12e2e704f 100644
--- a/sound/soc/samsung/odroid.c
+++ b/sound/soc/samsung/odroid.c
@@ -311,9 +311,7 @@ static int odroid_audio_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(dev, card);
 	if (ret < 0) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "snd_soc_register_card() failed: %d\n",
-				ret);
+		dev_err_probe(dev, ret, "snd_soc_register_card() failed\n");
 		goto err_put_clk_i2s;
 	}
 
diff --git a/sound/soc/samsung/smdk_wm8994.c b/sound/soc/samsung/smdk_wm8994.c
index 7661b637946d..821ad1eb1b79 100644
--- a/sound/soc/samsung/smdk_wm8994.c
+++ b/sound/soc/samsung/smdk_wm8994.c
@@ -179,8 +179,8 @@ static int smdk_audio_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed:%d\n", ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card() failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/smdk_wm8994pcm.c b/sound/soc/samsung/smdk_wm8994pcm.c
index 029448f5bedb..d77dc54cae9c 100644
--- a/sound/soc/samsung/smdk_wm8994pcm.c
+++ b/sound/soc/samsung/smdk_wm8994pcm.c
@@ -118,8 +118,8 @@ static int snd_smdk_probe(struct platform_device *pdev)
 
 	smdk_pcm.dev = &pdev->dev;
 	ret = devm_snd_soc_register_card(&pdev->dev, &smdk_pcm);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card failed %d\n", ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 6da674e901ca..02372109c251 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -212,12 +212,9 @@ static int snow_probe(struct platform_device *pdev)
 	snd_soc_card_set_drvdata(card, priv);
 
 	ret = devm_snd_soc_register_card(dev, card);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(&pdev->dev,
-				"snd_soc_register_card failed (%d)\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "snd_soc_register_card failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/speyside.c b/sound/soc/samsung/speyside.c
index f5f6ba00d073..37b1f4f60b21 100644
--- a/sound/soc/samsung/speyside.c
+++ b/sound/soc/samsung/speyside.c
@@ -330,9 +330,8 @@ static int speyside_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
-			ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card() failed\n");
 
 	return ret;
 }
diff --git a/sound/soc/samsung/tm2_wm5110.c b/sound/soc/samsung/tm2_wm5110.c
index a2c77e6defec..d611ec9e5325 100644
--- a/sound/soc/samsung/tm2_wm5110.c
+++ b/sound/soc/samsung/tm2_wm5110.c
@@ -612,8 +612,7 @@ static int tm2_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(dev, card);
 	if (ret < 0) {
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "Failed to register card: %d\n", ret);
+		dev_err_probe(dev, ret, "Failed to register card\n");
 		goto dai_node_put;
 	}
 
diff --git a/sound/soc/samsung/tobermory.c b/sound/soc/samsung/tobermory.c
index 15223d860cb7..8d3149a47a4c 100644
--- a/sound/soc/samsung/tobermory.c
+++ b/sound/soc/samsung/tobermory.c
@@ -229,9 +229,8 @@ static int tobermory_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
-			ret);
+	if (ret)
+		dev_err_probe(&pdev->dev, ret, "snd_soc_register_card() failed\n");
 
 	return ret;
 }
-- 
2.35.1



