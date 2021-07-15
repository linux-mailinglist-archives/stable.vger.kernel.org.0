Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B613CA697
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbhGOSs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239761AbhGOSsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37604613D4;
        Thu, 15 Jul 2021 18:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374749;
        bh=l98UumLjQANUw6mZMLJC464/eEz4GzVb3MFkIc5GbkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4tj26Odj880yCbU5/c8nGuguYUfZ96fVCdWqOceEDfhWyzj2OtwKyJeRzSfJGqv9
         6vYbzbVoT4nzc+Q0hYTCfFkl0SctOPrcxUrx+iWsWsneRtfDNCqcx5e4C+uEYqvHYn
         XZbw4sw+bO1yC2cJv1OhVzvbaCUiDitZQnnXuYsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/215] clk: renesas: rcar-usb2-clock-sel: Fix error handling in .probe()
Date:   Thu, 15 Jul 2021 20:36:22 +0200
Message-Id: <20210715182600.429009456@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a20a40a8bbc2cf4b29d7248ea31e974e9103dd7f ]

The error handling paths after pm_runtime_get_sync() have no refcount
decrement, which leads to refcount leak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210415073338.22287-1-dinghao.liu@zju.edu.cn
[geert: Remove now unused variable priv]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rcar-usb2-clock-sel.c | 24 ++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/renesas/rcar-usb2-clock-sel.c b/drivers/clk/renesas/rcar-usb2-clock-sel.c
index d4c02986c34e..0ccc6e709a38 100644
--- a/drivers/clk/renesas/rcar-usb2-clock-sel.c
+++ b/drivers/clk/renesas/rcar-usb2-clock-sel.c
@@ -128,10 +128,8 @@ static int rcar_usb2_clock_sel_resume(struct device *dev)
 static int rcar_usb2_clock_sel_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct usb2_clock_sel_priv *priv = platform_get_drvdata(pdev);
 
 	of_clk_del_provider(dev->of_node);
-	clk_hw_unregister(&priv->hw);
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
 
@@ -164,9 +162,6 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->rsts))
 		return PTR_ERR(priv->rsts);
 
-	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
-
 	clk = devm_clk_get(dev, "usb_extal");
 	if (!IS_ERR(clk) && !clk_prepare_enable(clk)) {
 		priv->extal = !!clk_get_rate(clk);
@@ -183,6 +178,8 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
 	platform_set_drvdata(pdev, priv);
 	dev_set_drvdata(dev, priv);
 
@@ -193,11 +190,20 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 	init.num_parents = 0;
 	priv->hw.init = &init;
 
-	clk = clk_register(NULL, &priv->hw);
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	ret = devm_clk_hw_register(NULL, &priv->hw);
+	if (ret)
+		goto pm_put;
+
+	ret = of_clk_add_hw_provider(np, of_clk_hw_simple_get, &priv->hw);
+	if (ret)
+		goto pm_put;
+
+	return 0;
 
-	return of_clk_add_hw_provider(np, of_clk_hw_simple_get, &priv->hw);
+pm_put:
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static const struct dev_pm_ops rcar_usb2_clock_sel_pm_ops = {
-- 
2.30.2



