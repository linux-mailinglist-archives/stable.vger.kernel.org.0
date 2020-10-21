Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89869294B65
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 12:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388699AbgJUKpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 06:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392101AbgJUKpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 06:45:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A891C0613CF
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 03:45:46 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kVBcj-000800-De; Wed, 21 Oct 2020 12:45:41 +0200
Received: from sha by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kVBci-0005cs-Q4; Wed, 21 Oct 2020 12:45:40 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-spi@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Christian Eggers <ceggers@arri.de>, stable@vger.kernel.org
Subject: [PATCH] spi: imx: fix runtime pm support for !CONFIG_PM
Date:   Wed, 21 Oct 2020 12:45:13 +0200
Message-Id: <20201021104513.21560-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

525c9e5a32bd introduced pm_runtime support for the i.MX SPI driver. With
this pm_runtime is used to bring up the clocks initially. When CONFIG_PM
is disabled the clocks are no longer enabled and the driver doesn't work
anymore. Fix this by enabling the clocks in the probe function and
telling pm_runtime that the device is active using
pm_runtime_set_active().

Fixes: 525c9e5a32bd spi: imx: enable runtime pm support
Tested-by: Christian Eggers <ceggers@arri.de> [tested for !CONFIG_PM only]
Cc: stable@vger.kernel.org  # 5.9.x only
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/spi/spi-imx.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 38a5f1304cec..c796e937dc6a 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1674,15 +1674,18 @@ static int spi_imx_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	pm_runtime_enable(spi_imx->dev);
+	ret = clk_prepare_enable(spi_imx->clk_per);
+	if (ret)
+		goto out_master_put;
+
+	ret = clk_prepare_enable(spi_imx->clk_ipg);
+	if (ret)
+		goto out_put_per;
+
 	pm_runtime_set_autosuspend_delay(spi_imx->dev, MXC_RPM_TIMEOUT);
 	pm_runtime_use_autosuspend(spi_imx->dev);
-
-	ret = pm_runtime_get_sync(spi_imx->dev);
-	if (ret < 0) {
-		dev_err(spi_imx->dev, "failed to enable clock\n");
-		goto out_runtime_pm_put;
-	}
+	pm_runtime_set_active(spi_imx->dev);
+	pm_runtime_enable(spi_imx->dev);
 
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
 	/*
@@ -1719,8 +1722,12 @@ static int spi_imx_probe(struct platform_device *pdev)
 
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
-	pm_runtime_put_sync(spi_imx->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(spi_imx->dev);
+
+	clk_disable_unprepare(spi_imx->clk_ipg);
+out_put_per:
+	clk_disable_unprepare(spi_imx->clk_per);
 out_master_put:
 	spi_master_put(master);
 
-- 
2.20.1

