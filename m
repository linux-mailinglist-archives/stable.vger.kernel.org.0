Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14181FACF0
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 11:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgFPJly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 05:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgFPJlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 05:41:53 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273592074D;
        Tue, 16 Jun 2020 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592300512;
        bh=lgDRkShhNRgGt91Bd9G6pf+Oaz+HcEMQ4luhZ0kF6K0=;
        h=From:To:Cc:Subject:Date:From;
        b=FBboX5Bvl+zzbKZus8azFTOTf1Dqhb2ITdJsQMPnO/yJQgupxy3N7Ge+bdZdwrRfT
         l8Uz/HBzfcq/0CGEBrXey8qR4XjtEqZt1Z5ts4wZbbHOgL1yQs2NEelZmZzST2sJmh
         7JkYuc7/qKRNXmLJtwJzZSjWgmbFg6jePuguSUUQ=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths
Date:   Tue, 16 Jun 2020 11:41:06 +0200
Message-Id: <1592300467-29196-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If shared interrupt comes late, during probe error path or device remove
(could be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
dspi_interrupt() will access registers with the clock being disabled.
This leads to external abort on non-linefetch on Toradex Colibri VF50
module (with Vybrid VF5xx):

    $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind

    Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
    Internal error: : 1008 [#1] ARM
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
    Backtrace:
      (regmap_mmio_read32le)
      (regmap_mmio_read)
      (_regmap_bus_reg_read)
      (_regmap_read)
      (regmap_read)
      (dspi_interrupt)
      (free_irq)
      (devm_irq_release)
      (release_nodes)
      (devres_release_all)
      (device_release_driver_internal)

The resource-managed framework should not be used for shared interrupt
handling, because the interrupt handler might be called after releasing
other resources and disabling clocks.

Similar bug could happen during suspend - the shared interrupt handler
could be invoked after suspending the device.  Each device sharing this
interrupt line should disable the IRQ during suspend so handler will be
invoked only in following cases:
1. None suspended,
2. All devices resumed.

Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v2:
1. Go back to v1 and use non-devm interface,
2. Fix also suspend/resume paths.

Changes since v1:
1. Disable the IRQ instead of using non-devm interface.
---
 drivers/spi/spi-fsl-dspi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 58190c94561f..7ecc90ec8f2f 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1109,6 +1109,8 @@ static int dspi_suspend(struct device *dev)
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
 	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
 
+	if (dspi->irq > 0)
+		disable_irq(dspi->irq);
 	spi_controller_suspend(ctlr);
 	clk_disable_unprepare(dspi->clk);
 
@@ -1129,6 +1131,8 @@ static int dspi_resume(struct device *dev)
 	if (ret)
 		return ret;
 	spi_controller_resume(ctlr);
+	if (dspi->irq > 0)
+		enable_irq(dspi->irq);
 
 	return 0;
 }
@@ -1385,8 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto poll_mode;
 	}
 
-	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
-			       IRQF_SHARED, pdev->name, dspi);
+	ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
+				   IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
 		goto out_clk_put;
@@ -1400,7 +1404,7 @@ static int dspi_probe(struct platform_device *pdev)
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "can't get dma channels\n");
-			goto out_clk_put;
+			goto out_free_irq;
 		}
 	}
 
@@ -1415,11 +1419,14 @@ static int dspi_probe(struct platform_device *pdev)
 	ret = spi_register_controller(ctlr);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
-		goto out_clk_put;
+		goto out_free_irq;
 	}
 
 	return ret;
 
+out_free_irq:
+	if (dspi->irq > 0)
+		free_irq(dspi->irq, dspi);
 out_clk_put:
 	clk_disable_unprepare(dspi->clk);
 out_ctlr_put:
@@ -1435,6 +1442,8 @@ static int dspi_remove(struct platform_device *pdev)
 
 	/* Disconnect from the SPI framework */
 	dspi_release_dma(dspi);
+	if (dspi->irq > 0)
+		free_irq(dspi->irq, dspi);
 	clk_disable_unprepare(dspi->clk);
 	spi_unregister_controller(dspi->ctlr);
 
-- 
2.7.4

