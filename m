Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5253C557D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhGLIKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353668AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F2461CFD;
        Mon, 12 Jul 2021 07:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076587;
        bh=D253tO/PrmWtsVUdihOyE2wbESmvUFwLG7lApVK4M/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q41la9DJXKtOLiQL5zA9CGGsygl4ZSVRMrISSzlUfA5XJH4F74gCrBXWS8DwKXBIQ
         Evunvy4ddNvRpRxkur+wa9N9HfQNTqe1oiM8nca8XDoyTwEjoiTmoLFutJNfjINm8K
         RHfb4M700dZ1zYa0WDc84dw/xuSGBwNVzBfHLkNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 655/800] leds: lgm-sso: Fix clock handling
Date:   Mon, 12 Jul 2021 08:11:18 +0200
Message-Id: <20210712061036.672808625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit fba8a6f2263bc54683cf3fd75df4dbd5d041c195 ]

The clock handling has a few issues:
 - when getting second clock fails, the first one left prepared and enabled
 - on ->remove() clocks are unprepared and disabled twice

Fix all these by converting to use bulk clock operations since both clocks
are mandatory.

Fixes: c3987cd2bca3 ("leds: lgm: Add LED controller driver for LGM SoC")
Cc: Amireddy Mallikarjuna reddy <mallikarjunax.reddy@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 44 ++++++++++++-------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 6a63846d10b5..7d5f0bf2817a 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -132,8 +132,7 @@ struct sso_led_priv {
 	struct regmap *mmap;
 	struct device *dev;
 	struct platform_device *pdev;
-	struct clk *gclk;
-	struct clk *fpid_clk;
+	struct clk_bulk_data clocks[2];
 	u32 fpid_clkrate;
 	u32 gptc_clkrate;
 	u32 freq[MAX_FREQ_RANK];
@@ -763,12 +762,11 @@ static int sso_probe_gpios(struct sso_led_priv *priv)
 	return sso_gpio_gc_init(dev, priv);
 }
 
-static void sso_clk_disable(void *data)
+static void sso_clock_disable_unprepare(void *data)
 {
 	struct sso_led_priv *priv = data;
 
-	clk_disable_unprepare(priv->fpid_clk);
-	clk_disable_unprepare(priv->gclk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(priv->clocks), priv->clocks);
 }
 
 static int intel_sso_led_probe(struct platform_device *pdev)
@@ -785,36 +783,30 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 	priv->dev = dev;
 
 	/* gate clock */
-	priv->gclk = devm_clk_get(dev, "sso");
-	if (IS_ERR(priv->gclk)) {
-		dev_err(dev, "get sso gate clock failed!\n");
-		return PTR_ERR(priv->gclk);
-	}
+	priv->clocks[0].id = "sso";
+
+	/* fpid clock */
+	priv->clocks[1].id = "fpid";
 
-	ret = clk_prepare_enable(priv->gclk);
+	ret = devm_clk_bulk_get(dev, ARRAY_SIZE(priv->clocks), priv->clocks);
 	if (ret) {
-		dev_err(dev, "Failed to prepare/enable sso gate clock!\n");
+		dev_err(dev, "Getting clocks failed!\n");
 		return ret;
 	}
 
-	priv->fpid_clk = devm_clk_get(dev, "fpid");
-	if (IS_ERR(priv->fpid_clk)) {
-		dev_err(dev, "Failed to get fpid clock!\n");
-		return PTR_ERR(priv->fpid_clk);
-	}
-
-	ret = clk_prepare_enable(priv->fpid_clk);
+	ret = clk_bulk_prepare_enable(ARRAY_SIZE(priv->clocks), priv->clocks);
 	if (ret) {
-		dev_err(dev, "Failed to prepare/enable fpid clock!\n");
+		dev_err(dev, "Failed to prepare and enable clocks!\n");
 		return ret;
 	}
-	priv->fpid_clkrate = clk_get_rate(priv->fpid_clk);
 
-	ret = devm_add_action_or_reset(dev, sso_clk_disable, priv);
-	if (ret) {
-		dev_err(dev, "Failed to devm_add_action_or_reset, %d\n", ret);
+	ret = devm_add_action_or_reset(dev, sso_clock_disable_unprepare, priv);
+	if (ret)
 		return ret;
-	}
+
+	priv->fpid_clkrate = clk_get_rate(priv->clocks[1].clk);
+
+	priv->mmap = syscon_node_to_regmap(dev->of_node);
 
 	priv->mmap = syscon_node_to_regmap(dev->of_node);
 	if (IS_ERR(priv->mmap)) {
@@ -859,8 +851,6 @@ static int intel_sso_led_remove(struct platform_device *pdev)
 		sso_led_shutdown(led);
 	}
 
-	clk_disable_unprepare(priv->fpid_clk);
-	clk_disable_unprepare(priv->gclk);
 	regmap_exit(priv->mmap);
 
 	return 0;
-- 
2.30.2



