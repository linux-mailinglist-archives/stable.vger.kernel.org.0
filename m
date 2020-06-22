Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28707203545
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgFVLFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgFVLFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 07:05:52 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C045820738;
        Mon, 22 Jun 2020 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592823951;
        bh=hhV13ohOHbP68epAhZTfZpOMEse5XOCpdTxhwKMk8nU=;
        h=From:To:Cc:Subject:Date:From;
        b=qBAy+YwdUrlFfbPpD1Jo/MceAHC9AJNyEKwyZ/dIP/b7k7Yq12+5dI6/KCAfbyQbB
         WcoBrHazRY0CcVZTT5itt2ILWdbfXNcwINo0OcTnV3HrBIVzYeBn0ke27uynDqGDey
         DrKHYLyK/3F0ZMp5BIiFYHrFyU1G3/e15S8v79IU=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v4 1/4] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
Date:   Mon, 22 Jun 2020 13:05:40 +0200
Message-Id: <20200622110543.5035-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During device removal, the driver should unregister the SPI controller
and stop the hardware.  Otherwise the dspi_transfer_one_message() could
wait on completion infinitely.

Additionally, calling spi_unregister_controller() first in device
removal reverse-matches the probe function, where SPI controller is
registered at the end.

Fixes: 05209f457069 ("spi: fsl-dspi: add missing clk_disable_unprepare() in dspi_remove()")
Cc: <stable@vger.kernel.org>
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v3:
1. New patch.
---
 drivers/spi/spi-fsl-dspi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 58190c94561f..ec0fd0d366eb 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1434,9 +1434,18 @@ static int dspi_remove(struct platform_device *pdev)
 	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
 
 	/* Disconnect from the SPI framework */
+	spi_unregister_controller(dspi->ctlr);
+
+	/* Disable RX and TX */
+	regmap_update_bits(dspi->regmap, SPI_MCR,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
+			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
+
+	/* Stop Running */
+	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
+
 	dspi_release_dma(dspi);
 	clk_disable_unprepare(dspi->clk);
-	spi_unregister_controller(dspi->ctlr);
 
 	return 0;
 }
-- 
2.17.1

