Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8D2265D9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgGTP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731970AbgGTP57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EE45206E9;
        Mon, 20 Jul 2020 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260678;
        bh=mtj+mNPGKLcYYy3QzFutSBT6xxBGFplPVCbMFTnt/qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfnpVHyl3y3+tfzivKVYnqFNnFFF2Wj3IWyxrUS9xWqLRoWt+rTl4NMaSiW+1pPp9
         5isPD7VOBoOBRbQ2r7k/6vl1imgUBcLkBM/wkbrO8iL52ZwRxu3z1Awb0bEIxEkQRB
         lIsnfupcxH0ps6EcwCNVQv/eY+wb+hU6t2wUyUrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/215] spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
Date:   Mon, 20 Jul 2020 17:35:37 +0200
Message-Id: <20200720152822.830220377@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
index 3e0e27731922e..c7560d7d16276 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1184,20 +1184,7 @@ static int dspi_remove(struct platform_device *pdev)
 
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
2.25.1



