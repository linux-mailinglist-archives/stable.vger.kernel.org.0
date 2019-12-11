Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5211B49A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbfLKPZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732636AbfLKPZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D36D208C3;
        Wed, 11 Dec 2019 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077912;
        bh=LnJIEGbcLgSTexKJUWuJ+bJDSkG4Zo1s3VWUvWYpOC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0WZASJBodsC+1zekh6N4ql99lJG6yW0i+MsP93/KS/TAtQWcYStkTa+08PV9BEwG
         uEnKbVqMCkEaN/jR/aMmanMFjMGduEVzqrmWiJNecKz+3GCvMgbjoxCZfChY/MeNNm
         JZynowrO8ebRNGfrvUopTRmBK4BwLaoUEcCtGXS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ladislav Michl <ladis@linux-mips.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/243] ASoC: max9867: Fix power management
Date:   Wed, 11 Dec 2019 16:05:53 +0100
Message-Id: <20191211150352.063951429@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ladislav Michl <ladis@linux-mips.org>

[ Upstream commit 29f58ff06795a923407d011d4721eaf3e8d39acc ]

Implement set_bias_level to drive shutdown bit, so device is
put to sleep when unused.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max9867.c | 72 ++++++++++++++++++++++++--------------
 sound/soc/codecs/max9867.h |  2 +-
 2 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/sound/soc/codecs/max9867.c b/sound/soc/codecs/max9867.c
index 4ea3287162ad2..e51143df4702a 100644
--- a/sound/soc/codecs/max9867.c
+++ b/sound/soc/codecs/max9867.c
@@ -248,17 +248,6 @@ static int max9867_dai_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int max9867_prepare(struct snd_pcm_substream *substream,
-			 struct snd_soc_dai *dai)
-{
-	struct snd_soc_component *component = dai->component;
-	struct max9867_priv *max9867 = snd_soc_component_get_drvdata(component);
-
-	regmap_update_bits(max9867->regmap, MAX9867_PWRMAN,
-		MAX9867_SHTDOWN_MASK, MAX9867_SHTDOWN_MASK);
-	return 0;
-}
-
 static int max9867_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_component *component = dai->component;
@@ -361,7 +350,6 @@ static int max9867_dai_set_fmt(struct snd_soc_dai *codec_dai,
 static const struct snd_soc_dai_ops max9867_dai_ops = {
 	.set_fmt = max9867_dai_set_fmt,
 	.set_sysclk	= max9867_set_dai_sysclk,
-	.prepare	= max9867_prepare,
 	.digital_mute	= max9867_mute,
 	.hw_params = max9867_dai_hw_params,
 };
@@ -392,27 +380,59 @@ static struct snd_soc_dai_driver max9867_dai[] = {
 	}
 };
 
-#ifdef CONFIG_PM_SLEEP
-static int max9867_suspend(struct device *dev)
+#ifdef CONFIG_PM
+static int max9867_suspend(struct snd_soc_component *component)
 {
-	struct max9867_priv *max9867 = dev_get_drvdata(dev);
+	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_OFF);
 
-	/* Drop down to power saving mode when system is suspended */
-	regmap_update_bits(max9867->regmap, MAX9867_PWRMAN,
-		MAX9867_SHTDOWN_MASK, ~MAX9867_SHTDOWN_MASK);
 	return 0;
 }
 
-static int max9867_resume(struct device *dev)
+static int max9867_resume(struct snd_soc_component *component)
 {
-	struct max9867_priv *max9867 = dev_get_drvdata(dev);
+	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_STANDBY);
 
-	regmap_update_bits(max9867->regmap, MAX9867_PWRMAN,
-		MAX9867_SHTDOWN_MASK, MAX9867_SHTDOWN_MASK);
 	return 0;
 }
+#else
+#define max9867_suspend	NULL
+#define max9867_resume	NULL
 #endif
 
+static int max9867_set_bias_level(struct snd_soc_component *component,
+				  enum snd_soc_bias_level level)
+{
+	int err;
+	struct max9867_priv *max9867 = snd_soc_component_get_drvdata(component);
+
+	switch (level) {
+	case SND_SOC_BIAS_STANDBY:
+		if (snd_soc_component_get_bias_level(component) == SND_SOC_BIAS_OFF) {
+			err = regcache_sync(max9867->regmap);
+			if (err)
+				return err;
+
+			err = regmap_update_bits(max9867->regmap, MAX9867_PWRMAN,
+						 MAX9867_SHTDOWN, MAX9867_SHTDOWN);
+			if (err)
+				return err;
+		}
+		break;
+	case SND_SOC_BIAS_OFF:
+		err = regmap_update_bits(max9867->regmap, MAX9867_PWRMAN,
+					 MAX9867_SHTDOWN, 0);
+		if (err)
+			return err;
+
+		regcache_mark_dirty(max9867->regmap);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_component_driver max9867_component = {
 	.controls		= max9867_snd_controls,
 	.num_controls		= ARRAY_SIZE(max9867_snd_controls),
@@ -420,6 +440,9 @@ static const struct snd_soc_component_driver max9867_component = {
 	.num_dapm_routes	= ARRAY_SIZE(max9867_audio_map),
 	.dapm_widgets		= max9867_dapm_widgets,
 	.num_dapm_widgets	= ARRAY_SIZE(max9867_dapm_widgets),
+	.suspend		= max9867_suspend,
+	.resume			= max9867_resume,
+	.set_bias_level		= max9867_set_bias_level,
 	.idle_bias_on		= 1,
 	.use_pmdown_time	= 1,
 	.endianness		= 1,
@@ -518,15 +541,10 @@ static const struct of_device_id max9867_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, max9867_of_match);
 
-static const struct dev_pm_ops max9867_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(max9867_suspend, max9867_resume)
-};
-
 static struct i2c_driver max9867_i2c_driver = {
 	.driver = {
 		.name = "max9867",
 		.of_match_table = of_match_ptr(max9867_of_match),
-		.pm = &max9867_pm_ops,
 	},
 	.probe  = max9867_i2c_probe,
 	.id_table = max9867_i2c_id,
diff --git a/sound/soc/codecs/max9867.h b/sound/soc/codecs/max9867.h
index 55cd9976ff47d..d9170850c96ea 100644
--- a/sound/soc/codecs/max9867.h
+++ b/sound/soc/codecs/max9867.h
@@ -67,7 +67,7 @@
 #define MAX9867_MICCONFIG    0x15
 #define MAX9867_MODECONFIG   0x16
 #define MAX9867_PWRMAN       0x17
-#define MAX9867_SHTDOWN_MASK (1<<7)
+#define MAX9867_SHTDOWN      0x80
 #define MAX9867_REVISION     0xff
 
 #define MAX9867_CACHEREGNUM 10
-- 
2.20.1



