Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D4722649C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgGTPqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbgGTPqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFCB62064B;
        Mon, 20 Jul 2020 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259996;
        bh=tBQY6XQvhbfSE1Pda01B/whktDR+5uctrCZVVVFzwZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5g6zmfzE1n4DCXfjF3jyLr/eRanhl19ZUH01zG9scNx9nX8h98k1c7O0F12ftxwk
         uPlgnFsIUjGlHzLXqZeqRLT9hUGgTacGqFPYLjiKQIz4URahJ1Hm3J4HIN89V0kFcc
         GDkjRELP8KbWjmVZXfUy2ha+1FGy5FLkpPoQqSBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/125] spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
Date:   Mon, 20 Jul 2020 17:36:48 +0200
Message-Id: <20200720152806.351151572@linuxfoundation.org>
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
index dabff9718d426..cce9e34306787 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1097,20 +1097,7 @@ static int dspi_remove(struct platform_device *pdev)
 
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



