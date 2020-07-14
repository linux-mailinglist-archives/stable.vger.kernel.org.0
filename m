Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05C021FA0B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgGNSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729430AbgGNSsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA4522B2A;
        Tue, 14 Jul 2020 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752526;
        bh=sT7ggtf5xuADU4WreWsFa4XiGl6IOswFVMXjHa0dmG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwfQitboMIEn8U73wdihNy9NfXULwlcOz/yOIBb9yLj7KOX/CI0sFsU6W9NxiDpPo
         nQRjfX5mu5GL42nSo4vJD/nDqNzRn4bfumT7K0VvR5EcYUPAl7CaERqSgV4XRYnXfe
         ogUnCzVmHc46mJZN1q9wnUYQjibE1BJa/iLwVyv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/109] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
Date:   Tue, 14 Jul 2020 20:43:06 +0200
Message-Id: <20200714184105.673355471@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7684580d45bd3d84ed9b453a4cadf7a9a5605a3f ]

During device removal, the driver should unregister the SPI controller
and stop the hardware.  Otherwise the dspi_transfer_one_message() could
wait on completion infinitely.

Additionally, calling spi_unregister_controller() first in device
removal reverse-matches the probe function, where SPI controller is
registered at the end.

Fixes: 05209f457069 ("spi: fsl-dspi: add missing clk_disable_unprepare() in dspi_remove()")
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200622110543.5035-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index e34278a00b708..3e0e27731922e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1164,11 +1164,20 @@ static int dspi_remove(struct platform_device *pdev)
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
 	if (dspi->irq)
 		free_irq(dspi->irq, dspi);
 	clk_disable_unprepare(dspi->clk);
-	spi_unregister_controller(dspi->ctlr);
 
 	return 0;
 }
-- 
2.25.1



