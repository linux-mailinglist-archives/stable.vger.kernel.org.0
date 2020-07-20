Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B82E226AB1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbgGTQgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbgGTPwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C82D22CF7;
        Mon, 20 Jul 2020 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260341;
        bh=LPXjPPm8Og7DDV+bv6tM3wciAoaVYBbr2XOqBMBKihE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdMzDqQfMNHfc63D7Z6L1HAvDE8w/LtsEdmEqD9vbgnuMm2n6aiiAWk7em7+RM1pA
         L1Y9v8VklqAk++jCuXX5+co0/X3FCX65eM9x18FEMICQ8Z+gs8CHuQjlClst4rvTGF
         QRx9nqvQGKkm3GEW8JS29GxhgCmp7yDZ1Fyts5lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/133] spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
Date:   Mon, 20 Jul 2020 17:36:25 +0200
Message-Id: <20200720152805.559931515@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 3c525b69e8c1a9a6944e976603c7a1a713e728f9 ]

During shutdown, the driver should unregister the SPI controller
and stop the hardware.  Otherwise the dspi_transfer_one_message() could
wait on completion infinitely.

Additionally, calling spi_unregister_controller() first in device
shutdown reverse-matches the probe function, where SPI controller is
registered at the end.

Fixes: dc234825997e ("spi: spi-fsl-dspi: Adding shutdown hook")
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622110543.5035-2-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 1144d022cc582..43809fad250b6 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1164,20 +1164,7 @@ static int dspi_remove(struct platform_device *pdev)
 
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
-	spi_unregister_controller(dspi->master);
+	dspi_remove(pdev);
 }
 
 static struct platform_driver fsl_dspi_driver = {
-- 
2.25.1



