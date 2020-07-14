Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6536E21FCF2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgGNSqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbgGNSqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C8C2231B;
        Tue, 14 Jul 2020 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752395;
        bh=TBbQn+etMoDwuMvwPuEKZvhf+pALDsm9CwIkR1OVwSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJvgaad8ooynnOHSUr/4oASBMqZzZpAwT6W8V5uXtSuYdhAMMgT/hx0fwGBS+L6DV
         84jY+AxwDMTt0IA75lfGszAedeuaehjipDT0P+YnPSp8moNeqFcLOgR1rHG64eTw1t
         y1/V0asMgGIcrUcW2T4M/ulaiuVUUen9uAPEr8LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/58] spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths
Date:   Tue, 14 Jul 2020 20:43:38 +0200
Message-Id: <20200714184056.409888312@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 3d87b613d6a3c6f0980e877ab0895785a2dde581 ]

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
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622110543.5035-3-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 9ab8c52a5ba6d..2844c9a72a980 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -897,6 +897,8 @@ static int dspi_suspend(struct device *dev)
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct fsl_dspi *dspi = spi_master_get_devdata(master);
 
+	if (dspi->irq)
+		disable_irq(dspi->irq);
 	spi_master_suspend(master);
 	clk_disable_unprepare(dspi->clk);
 
@@ -917,6 +919,8 @@ static int dspi_resume(struct device *dev)
 	if (ret)
 		return ret;
 	spi_master_resume(master);
+	if (dspi->irq)
+		enable_irq(dspi->irq);
 
 	return 0;
 }
@@ -1094,8 +1098,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
-	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
-			       IRQF_SHARED, pdev->name, dspi);
+	ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
+				   IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
 		goto out_clk_put;
@@ -1105,7 +1109,7 @@ static int dspi_probe(struct platform_device *pdev)
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "can't get dma channels\n");
-			goto out_clk_put;
+			goto out_free_irq;
 		}
 	}
 
@@ -1118,11 +1122,14 @@ static int dspi_probe(struct platform_device *pdev)
 	ret = spi_register_master(master);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI master\n");
-		goto out_clk_put;
+		goto out_free_irq;
 	}
 
 	return ret;
 
+out_free_irq:
+	if (dspi->irq)
+		free_irq(dspi->irq, dspi);
 out_clk_put:
 	clk_disable_unprepare(dspi->clk);
 out_master_put:
@@ -1148,6 +1155,8 @@ static int dspi_remove(struct platform_device *pdev)
 	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
 
 	dspi_release_dma(dspi);
+	if (dspi->irq)
+		free_irq(dspi->irq, dspi);
 	clk_disable_unprepare(dspi->clk);
 
 	return 0;
-- 
2.25.1



