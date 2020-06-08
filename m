Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE101F30EA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFHXHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgFHXH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FFCB20872;
        Mon,  8 Jun 2020 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657647;
        bh=GwEbOMu8/8JRIBBYzWPx5EysyBB4jEBoWyltDTe3v+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUnAVq/M1u/jUhL8Lwy4M2r5AstnD44z/Sit1/q3/B5qnDvqqti9HnVUOrwGw8Tj5
         gw2o9PViPv5ZXH2hQhaeBhL5DJqSBylVGvQ7kIlhx+9+FPZrnEMa2edagafVfzKm93
         0k8G72AzoO2FUDcvXiaO7B+B+eei1isqLfhYIUS0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 062/274] spi: dw: Enable interrupts in accordance with DMA xfer mode
Date:   Mon,  8 Jun 2020 19:02:35 -0400
Message-Id: <20200608230607.3361041-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 43dba9f3f98c2b184a19f856f06fe22817bfd9e0 ]

It's pointless to track the Tx overrun interrupts if Rx-only SPI
transfer is issued. Similarly there is no need in handling the Rx
overrun/underrun interrupts if Tx-only SPI transfer is executed.
So lets unmask the interrupts only if corresponding SPI
transactions are implied.

Co-developed-by: Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>
Signed-off-by: Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Link: https://lore.kernel.org/r/20200522000806.7381-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-mid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 1058b8a6c8a0..e6c045ecffba 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -220,19 +220,23 @@ static struct dma_async_tx_descriptor *dw_spi_dma_prepare_rx(struct dw_spi *dws,
 
 static int mid_spi_dma_setup(struct dw_spi *dws, struct spi_transfer *xfer)
 {
-	u16 dma_ctrl = 0;
+	u16 imr = 0, dma_ctrl = 0;
 
 	dw_writel(dws, DW_SPI_DMARDLR, 0xf);
 	dw_writel(dws, DW_SPI_DMATDLR, 0x10);
 
-	if (xfer->tx_buf)
+	if (xfer->tx_buf) {
 		dma_ctrl |= SPI_DMA_TDMAE;
-	if (xfer->rx_buf)
+		imr |= SPI_INT_TXOI;
+	}
+	if (xfer->rx_buf) {
 		dma_ctrl |= SPI_DMA_RDMAE;
+		imr |= SPI_INT_RXUI | SPI_INT_RXOI;
+	}
 	dw_writel(dws, DW_SPI_DMACR, dma_ctrl);
 
 	/* Set the interrupt mask */
-	spi_umask_intr(dws, SPI_INT_TXOI | SPI_INT_RXUI | SPI_INT_RXOI);
+	spi_umask_intr(dws, imr);
 
 	dws->transfer_handler = dma_transfer;
 
-- 
2.25.1

