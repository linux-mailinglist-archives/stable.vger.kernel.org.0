Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF71F8875
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgFNK4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 06:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbgFNK4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 06:56:02 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD0B20739;
        Sun, 14 Jun 2020 10:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592132161;
        bh=0+f7COukvRhk0sJvGOAJHgAJ8nVeYg/rGLOd/Bfrh9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=1N2bgfp9vuZZf1cXB5D172/ioERkLuGv1fAgKgZ67CEvIViGGInqU8uo+si0bhx2X
         9VSirgyXyKQu5Dfnoz2PZTvKdX0MmEZb79WD1tyQe3xgOaUAu4VcBkXUkuM9GSLjHa
         IJ6vhsA9kIE23IirMz4Bd2p1xV0pEpg3B5pBk8rw=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt in exit paths
Date:   Sun, 14 Jun 2020 12:55:53 +0200
Message-Id: <1592132154-20175-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If interrupt comes late, during probe error path or device remove (could
be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
dspi_interrupt() will access registers with the clock being disabled.  This
leads to external abort on non-linefetch on Toradex Colibri VF50 module
(with Vybrid VF5xx):

    $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind

    Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
    Internal error: : 1008 [#1] ARM
    CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
      (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
      (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
      (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
      (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
      (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
      (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
      (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
      (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
      (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
      (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)

The resource-managed framework should not be used for interrupt handling,
because the resource will be released too late - after disabling clocks.
The interrupt handler is not prepared for such case.

Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

This is an follow up of my other patch for I2C IMX driver [1]. Let's fix the
issues consistently.

[1] https://lore.kernel.org/lkml/1592130544-19759-2-git-send-email-krzk@kernel.org/T/#u
---
 drivers/spi/spi-fsl-dspi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 58190c94561f..57e7a626ba00 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1385,8 +1385,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto poll_mode;
 	}
 
-	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
-			       IRQF_SHARED, pdev->name, dspi);
+	ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
+				   IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
 		goto out_clk_put;
@@ -1400,7 +1400,7 @@ static int dspi_probe(struct platform_device *pdev)
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "can't get dma channels\n");
-			goto out_clk_put;
+			goto out_free_irq;
 		}
 	}
 
@@ -1415,11 +1415,14 @@ static int dspi_probe(struct platform_device *pdev)
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
@@ -1435,6 +1438,8 @@ static int dspi_remove(struct platform_device *pdev)
 
 	/* Disconnect from the SPI framework */
 	dspi_release_dma(dspi);
+	if (dspi->irq > 0)
+		free_irq(dspi->irq, dspi);
 	clk_disable_unprepare(dspi->clk);
 	spi_unregister_controller(dspi->ctlr);
 
-- 
2.7.4

