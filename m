Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D364147F5C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgAXLBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387719AbgAXLBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9E221569;
        Fri, 24 Jan 2020 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863696;
        bh=TPdzRK4yi6WzRSGxw5I3i6Zr6dLsI48d/b7PBWZp19M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbALmTGFeRwdkoL6ibs36r9RttMe7kMoqAV3+r9wmDc+kOi/IZW374IWzbC1CIiCw
         SB4Fh7HYWS6SfpASIO/f9Fta3mcw/CBk22i9jWxwPO3rfrten0DK/W6W8v9E0Zn/Ry
         oxoOEEzB0Gq0vlqWfDk2HNPmb75GcvfU4Mq0c3ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/639] ASoC: wm97xx: fix uninitialized regmap pointer problem
Date:   Fri, 24 Jan 2020 10:23:53 +0100
Message-Id: <20200124093055.300860548@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 576ce4075bfa0f03e0e91a89eecc539b3b828b08 ]

gcc notices that without either the ac97 bus or the pdata, we never
initialize the regmap pointer, which leads to an uninitialized variable
access:

sound/soc/codecs/wm9712.c: In function 'wm9712_soc_probe':
sound/soc/codecs/wm9712.c:666:2: error: 'regmap' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Since that configuration is invalid, it's better to return an error
here. I tried to avoid adding complexity to the conditions, and turned
the #ifdef into a regular if(IS_ENABLED()) check for readability.
This in turn requires moving some header file declarations out of
an #ifdef.

The same code is used in three drivers, all of which I'm changing
the same way.

Fixes: 2ed1a8e0ce8d ("ASoC: wm9712: add ac97 new bus support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h       |  2 +-
 sound/soc/codecs/wm9705.c | 10 ++++------
 sound/soc/codecs/wm9712.c | 10 ++++------
 sound/soc/codecs/wm9713.c | 10 ++++------
 4 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 41cec42fb456a..88aa48e5485f9 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -548,12 +548,12 @@ static inline void snd_soc_jack_free_gpios(struct snd_soc_jack *jack, int count,
 }
 #endif
 
-#ifdef CONFIG_SND_SOC_AC97_BUS
 struct snd_ac97 *snd_soc_alloc_ac97_component(struct snd_soc_component *component);
 struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 	unsigned int id, unsigned int id_mask);
 void snd_soc_free_ac97_component(struct snd_ac97 *ac97);
 
+#ifdef CONFIG_SND_SOC_AC97_BUS
 int snd_soc_set_ac97_ops(struct snd_ac97_bus_ops *ops);
 int snd_soc_set_ac97_ops_of_reset(struct snd_ac97_bus_ops *ops,
 		struct platform_device *pdev);
diff --git a/sound/soc/codecs/wm9705.c b/sound/soc/codecs/wm9705.c
index ccdf088461b7f..54c306707c02c 100644
--- a/sound/soc/codecs/wm9705.c
+++ b/sound/soc/codecs/wm9705.c
@@ -325,8 +325,7 @@ static int wm9705_soc_probe(struct snd_soc_component *component)
 	if (wm9705->mfd_pdata) {
 		wm9705->ac97 = wm9705->mfd_pdata->ac97;
 		regmap = wm9705->mfd_pdata->regmap;
-	} else {
-#ifdef CONFIG_SND_SOC_AC97_BUS
+	} else if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS)) {
 		wm9705->ac97 = snd_soc_new_ac97_component(component, WM9705_VENDOR_ID,
 						      WM9705_VENDOR_ID_MASK);
 		if (IS_ERR(wm9705->ac97)) {
@@ -339,7 +338,8 @@ static int wm9705_soc_probe(struct snd_soc_component *component)
 			snd_soc_free_ac97_component(wm9705->ac97);
 			return PTR_ERR(regmap);
 		}
-#endif
+	} else {
+		return -ENXIO;
 	}
 
 	snd_soc_component_set_drvdata(component, wm9705->ac97);
@@ -350,14 +350,12 @@ static int wm9705_soc_probe(struct snd_soc_component *component)
 
 static void wm9705_soc_remove(struct snd_soc_component *component)
 {
-#ifdef CONFIG_SND_SOC_AC97_BUS
 	struct wm9705_priv *wm9705 = snd_soc_component_get_drvdata(component);
 
-	if (!wm9705->mfd_pdata) {
+	if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS) && !wm9705->mfd_pdata) {
 		snd_soc_component_exit_regmap(component);
 		snd_soc_free_ac97_component(wm9705->ac97);
 	}
-#endif
 }
 
 static const struct snd_soc_component_driver soc_component_dev_wm9705 = {
diff --git a/sound/soc/codecs/wm9712.c b/sound/soc/codecs/wm9712.c
index e873baa9e7780..01949eaba4fd4 100644
--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -642,8 +642,7 @@ static int wm9712_soc_probe(struct snd_soc_component *component)
 	if (wm9712->mfd_pdata) {
 		wm9712->ac97 = wm9712->mfd_pdata->ac97;
 		regmap = wm9712->mfd_pdata->regmap;
-	} else {
-#ifdef CONFIG_SND_SOC_AC97_BUS
+	} else if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS)) {
 		int ret;
 
 		wm9712->ac97 = snd_soc_new_ac97_component(component, WM9712_VENDOR_ID,
@@ -660,7 +659,8 @@ static int wm9712_soc_probe(struct snd_soc_component *component)
 			snd_soc_free_ac97_component(wm9712->ac97);
 			return PTR_ERR(regmap);
 		}
-#endif
+	} else {
+		return -ENXIO;
 	}
 
 	snd_soc_component_init_regmap(component, regmap);
@@ -673,14 +673,12 @@ static int wm9712_soc_probe(struct snd_soc_component *component)
 
 static void wm9712_soc_remove(struct snd_soc_component *component)
 {
-#ifdef CONFIG_SND_SOC_AC97_BUS
 	struct wm9712_priv *wm9712 = snd_soc_component_get_drvdata(component);
 
-	if (!wm9712->mfd_pdata) {
+	if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS) && !wm9712->mfd_pdata) {
 		snd_soc_component_exit_regmap(component);
 		snd_soc_free_ac97_component(wm9712->ac97);
 	}
-#endif
 }
 
 static const struct snd_soc_component_driver soc_component_dev_wm9712 = {
diff --git a/sound/soc/codecs/wm9713.c b/sound/soc/codecs/wm9713.c
index 643863bb32e0d..5a2fdf4f69bf3 100644
--- a/sound/soc/codecs/wm9713.c
+++ b/sound/soc/codecs/wm9713.c
@@ -1214,8 +1214,7 @@ static int wm9713_soc_probe(struct snd_soc_component *component)
 	if (wm9713->mfd_pdata) {
 		wm9713->ac97 = wm9713->mfd_pdata->ac97;
 		regmap = wm9713->mfd_pdata->regmap;
-	} else {
-#ifdef CONFIG_SND_SOC_AC97_BUS
+	} else if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS)) {
 		wm9713->ac97 = snd_soc_new_ac97_component(component, WM9713_VENDOR_ID,
 						      WM9713_VENDOR_ID_MASK);
 		if (IS_ERR(wm9713->ac97))
@@ -1225,7 +1224,8 @@ static int wm9713_soc_probe(struct snd_soc_component *component)
 			snd_soc_free_ac97_component(wm9713->ac97);
 			return PTR_ERR(regmap);
 		}
-#endif
+	} else {
+		return -ENXIO;
 	}
 
 	snd_soc_component_init_regmap(component, regmap);
@@ -1238,14 +1238,12 @@ static int wm9713_soc_probe(struct snd_soc_component *component)
 
 static void wm9713_soc_remove(struct snd_soc_component *component)
 {
-#ifdef CONFIG_SND_SOC_AC97_BUS
 	struct wm9713_priv *wm9713 = snd_soc_component_get_drvdata(component);
 
-	if (!wm9713->mfd_pdata) {
+	if (IS_ENABLED(CONFIG_SND_SOC_AC97_BUS) && !wm9713->mfd_pdata) {
 		snd_soc_component_exit_regmap(component);
 		snd_soc_free_ac97_component(wm9713->ac97);
 	}
-#endif
 }
 
 static const struct snd_soc_component_driver soc_component_dev_wm9713 = {
-- 
2.20.1



