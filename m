Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1F54916DB
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244681AbiARCgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44310 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343815AbiARCdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:33:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6DFFB81240;
        Tue, 18 Jan 2022 02:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EAC36AF6;
        Tue, 18 Jan 2022 02:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473199;
        bh=KuDx/9P+Wps9AtzStWZ2hI77/d8sYbhn6+5ghzmQjp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0Fuj1sham3qpyeVs82YAoQqT1EkqxrScFRua84VhZgkZaE6xP7Rz7+ucXKVBZ/6X
         JyA0hpYTfyWodUm8bPMv5fBa9s8hHwpU8tZxZ74bl2I0CWtBBDIcZQozUqkhP8DHiL
         ecIF70C3+on5+66erC1bDRitIVgpg+bCqJqYRAiVYS4Tn+gSFzRuPjnGbVRoITamii
         ZSOex0OyNqKu9ITLhKhKz7Q/bxY076y6iPi3Am5rqS0p94SY18i5WZ3N2BbtZxdE3+
         0L97nDd/ppQZaBBDu8+lX6RRLH3HMXQkhfUaMweajno4Pk9E+KSmhrW/cVwiItmj6B
         kKLiSrPBRpDBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        narmstrong@baylibre.com, khilman@baylibre.com,
        p.zabel@pengutronix.de, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 023/188] usb: dwc3: meson-g12a: fix shared reset control use
Date:   Mon, 17 Jan 2022 21:29:07 -0500
Message-Id: <20220118023152.1948105-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amjad Ouled-Ameur <aouledameur@baylibre.com>

[ Upstream commit 4ce3b45704d5ef46fb4b28083c8aba6716fabf3b ]

reset_control_(de)assert() calls are called on a shared reset line when
reset_control_reset has been used. This is not allowed by the reset
framework.

Use reset_control_rearm() call in suspend() and remove() as a way to state
that the resource is no longer used, hence the shared reset line
may be triggered again by other devices. Use reset_control_rearm() also in
case probe fails after reset() has been called.

reset_control_rearm() keeps use of triggered_count sane in the reset
framework, use of reset_control_reset() on shared reset line should be
balanced with reset_control_rearm().

Signed-off-by: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Reported-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211112162827.128319-3-aouledameur@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index d0f9b7c296b0d..bd814df3bf8b8 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -755,16 +755,16 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = dwc3_meson_g12a_get_phys(priv);
 	if (ret)
-		goto err_disable_clks;
+		goto err_rearm;
 
 	ret = priv->drvdata->setup_regmaps(priv, base);
 	if (ret)
-		goto err_disable_clks;
+		goto err_rearm;
 
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);
 		if (ret)
-			goto err_disable_clks;
+			goto err_rearm;
 	}
 
 	/* Get dr_mode */
@@ -825,6 +825,9 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	if (priv->vbus)
 		regulator_disable(priv->vbus);
 
+err_rearm:
+	reset_control_rearm(priv->reset);
+
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);
@@ -852,6 +855,8 @@ static int dwc3_meson_g12a_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
 
+	reset_control_rearm(priv->reset);
+
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);
 
@@ -892,7 +897,7 @@ static int __maybe_unused dwc3_meson_g12a_suspend(struct device *dev)
 		phy_exit(priv->phys[i]);
 	}
 
-	reset_control_assert(priv->reset);
+	reset_control_rearm(priv->reset);
 
 	return 0;
 }
@@ -902,7 +907,9 @@ static int __maybe_unused dwc3_meson_g12a_resume(struct device *dev)
 	struct dwc3_meson_g12a *priv = dev_get_drvdata(dev);
 	int i, ret;
 
-	reset_control_deassert(priv->reset);
+	ret = reset_control_reset(priv->reset);
+	if (ret)
+		return ret;
 
 	ret = priv->drvdata->usb_init(priv);
 	if (ret)
-- 
2.34.1

