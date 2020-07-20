Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1567022645A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgGTPoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgGTPoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C17042064B;
        Mon, 20 Jul 2020 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259861;
        bh=jbrqa1TlsxACgyIJ8RubZ7MWTCEb+XfE2GmkyHrhL9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQBUvSGoRwkuwgKZRWDzwTt57xDgGleMpWYA+4U9r44J1bioL6zME24zEyRdBNqw5
         P8oHN4zS+2r9e3lhLrcYV25OpnILkX5PLz8CfaoxdIzWxIFQhrGoF01cbksj2J79Eq
         l8WQ5CfEIkfd57uG40roLsYxqxwWHXXVqIzAFGaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Ma <peng.ma@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 002/125] spi: spi-fsl-dspi: Adding shutdown hook
Date:   Mon, 20 Jul 2020 17:35:41 +0200
Message-Id: <20200720152803.059182758@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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
 drivers/spi/spi-fsl-dspi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index ca013dd4ff6bb..d5b56b7814fe3 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -49,6 +49,9 @@
 #define SPI_MCR_PCSIS		(0x3F << 16)
 #define SPI_MCR_CLR_TXF	(1 << 11)
 #define SPI_MCR_CLR_RXF	(1 << 10)
+#define SPI_MCR_DIS_TXF		(1 << 13)
+#define SPI_MCR_DIS_RXF		(1 << 12)
+#define SPI_MCR_HALT		(1 << 0)
 
 #define SPI_TCR			0x08
 #define SPI_TCR_GET_TCNT(x)	(((x) & 0xffff0000) >> 16)
@@ -1074,6 +1077,24 @@ static int dspi_remove(struct platform_device *pdev)
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
@@ -1081,6 +1102,7 @@ static struct platform_driver fsl_dspi_driver = {
 	.driver.pm = &dspi_pm,
 	.probe          = dspi_probe,
 	.remove		= dspi_remove,
+	.shutdown	= dspi_shutdown,
 };
 module_platform_driver(fsl_dspi_driver);
 
-- 
2.25.1



