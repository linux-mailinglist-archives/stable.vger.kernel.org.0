Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B7920354F
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgFVLGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgFVLFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 07:05:54 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E2420739;
        Mon, 22 Jun 2020 11:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592823954;
        bh=QQnQ9zfEcXDa9cXwi6ru5QW1TtdjN++/N32/Obd/rQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px5YzpC8V4KoR1DVwMVkwX+Xo4bq/spjwdC07AiMwXOT7pF5+8KcoqWYU2SLyvN51
         a2rbN5S9ser4O5oYkpW3miDhcSQ5pFmxur/cWj3Puh/McZKRI3Ty5KYqFNs1L9HlHx
         7hhAftiGvHoz+HqQw0o4P2Fr3GMgFyrFbjDkQcpQ=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v4 2/4] spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
Date:   Mon, 22 Jun 2020 13:05:41 +0200
Message-Id: <20200622110543.5035-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622110543.5035-1-krzk@kernel.org>
References: <20200622110543.5035-1-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During shutdown, the driver should unregister the SPI controller
and stop the hardware.  Otherwise the dspi_transfer_one_message() could
wait on completion infinitely.

Additionally, calling spi_unregister_controller() first in device
shutdown reverse-matches the probe function, where SPI controller is
registered at the end.

Fixes: dc234825997e ("spi: spi-fsl-dspi: Adding shutdown hook")
Cc: <stable@vger.kernel.org>
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

kexec() not tested, only system shutdown.

Changes since v3:
1. New patch.
---
 drivers/spi/spi-fsl-dspi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index ec0fd0d366eb..ec7919d9c0d9 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1452,20 +1452,7 @@ static int dspi_remove(struct platform_device *pdev)
 
 static void dspi_shutdown(struct platform_device *pdev)
 {
-	struct spi_controller *ctlr = platform_get_drvdata(pdev);
-	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
-
-	/* Disable RX and TX */
-	regmap_update_bits(dspi->regmap, SPI_MCR,
-			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
-			   SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
-
-	/* Stop Running */
-	regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
-
-	dspi_release_dma(dspi);
-	clk_disable_unprepare(dspi->clk);
-	spi_unregister_controller(dspi->ctlr);
+	dspi_remove(pdev);
 }
 
 static struct platform_driver fsl_dspi_driver = {
-- 
2.17.1

