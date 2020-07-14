Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFC21FCFF
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGNSpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgGNSpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:45:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAA9222E9;
        Tue, 14 Jul 2020 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752354;
        bh=v7i3vODcfsNt9qz80CBL3nKZlwMLOBfzh+PZ/J8FKLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEP6KLJ/V/ftyPDIQqiLUt7DAMtYFJKByLrAFfAUW5FxsLYt0Sr9ZF53ZEwk4g4b0
         R42vQjdqc5Ubd4QTwpjxEqq6ryJMjZqzcLJgTx7SdZM2u/DzSttyqUnHXGi0epgrt/
         mLmr+kSTr+/KhwxXRCtwkZqyJF5MkVKayBeNXUy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Ma <peng.ma@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/58] spi: spi-fsl-dspi: Adding shutdown hook
Date:   Tue, 14 Jul 2020 20:43:35 +0200
Message-Id: <20200714184056.265252863@linuxfoundation.org>
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

From: Peng Ma <peng.ma@nxp.com>

[ Upstream commit dc234825997ec6ff05980ca9e2204f4ac3f8d695 ]

We need to ensure dspi controller could be stopped in order for kexec
to start the next kernel.
So add the shutdown operation support.

Signed-off-by: Peng Ma <peng.ma@nxp.com>
Link: https://lore.kernel.org/r/20200424061216.27445-1-peng.ma@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 3082e72e4f6c6..9296bcbbd32ce 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 //
 // Copyright 2013 Freescale Semiconductor, Inc.
+// Copyright 2020 NXP
 //
 // Freescale DSPI driver
 // This file contains a driver for the Freescale DSPI
@@ -43,6 +44,9 @@
 #define SPI_MCR_CLR_TXF	(1 << 11)
 #define SPI_MCR_CLR_RXF	(1 << 10)
 #define SPI_MCR_XSPI		(1 << 3)
+#define SPI_MCR_DIS_TXF		(1 << 13)
+#define SPI_MCR_DIS_RXF		(1 << 12)
+#define SPI_MCR_HALT		(1 << 0)
 
 #define SPI_TCR			0x08
 #define SPI_TCR_GET_TCNT(x)	(((x) & 0xffff0000) >> 16)
@@ -1140,6 +1144,24 @@ static int dspi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void dspi_shutdown(struct platform_device *pdev)
+{
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
+
+	/* Disable RX and TX */
+	regmap_update_bits(dspi->regmap, SPI_MCR,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
+
+	/* Stop Running */
+	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
+
+	dspi_release_dma(dspi);
+	clk_disable_unprepare(dspi->clk);
+	spi_unregister_controller(dspi->master);
+}
+
 static struct platform_driver fsl_dspi_driver = {
 	.driver.name    = DRIVER_NAME,
 	.driver.of_match_table = fsl_dspi_dt_ids,
@@ -1147,6 +1169,7 @@ static struct platform_driver fsl_dspi_driver = {
 	.driver.pm = &dspi_pm,
 	.probe          = dspi_probe,
 	.remove		= dspi_remove,
+	.shutdown	= dspi_shutdown,
 };
 module_platform_driver(fsl_dspi_driver);
 
-- 
2.25.1



