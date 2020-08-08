Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F72923FB8E
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHHXgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgHHXgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C0F207FB;
        Sat,  8 Aug 2020 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929805;
        bh=vbTAb44KZTHCUUR1fLwfmZ7ptgPtMwcHogXlu5gZoe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqiUcET2QadCRQZmW3gj9AU15qUVwEnU21rfJF/SfEAt3Dg3CZ8+REML40nHh1OSM
         TOP8zEB//3OItnf0MBatwad77Rxx/vSY/JAnQBkSmPKbZPEAT3JzvBiG/RAkMkgfBP
         1Uds2rBYINq8j4hMZtIyY61j6O9ciFEph7oC5mMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Feng Tang <feng.tang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 42/72] spi: dw-dma: Fix Tx DMA channel working too fast
Date:   Sat,  8 Aug 2020 19:35:11 -0400
Message-Id: <20200808233542.3617339-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit affe93dd5b35bb0e7b0aa0505ae432dd0ac72c3f ]

It turns out having a Rx DMA channel serviced with higher priority than
a Tx DMA channel is not enough to provide a well balanced DMA-based SPI
transfer interface. There might still be moments when the Tx DMA channel
is occasionally handled faster than the Rx DMA channel. That in its turn
will eventually cause the SPI Rx FIFO overflow if SPI bus speed is high
enough to fill the SPI Rx FIFO in before it's cleared by the Rx DMA
channel. That's why having the DMA-based SPI Tx interface too optimized
is the errors prone, so the commit 0b2b66514fc9 ("spi: dw: Use DMA max
burst to set the request thresholds") though being perfectly normal from
the standard functionality point of view implicitly introduced the problem
described above. In order to fix that the Tx DMA activity is intentionally
slowed down by limiting the SPI Tx FIFO depth with a value twice bigger
than the Tx burst length calculated earlier by the
dw_spi_dma_maxburst_init() method.

Fixes: 0b2b66514fc9 ("spi: dw: Use DMA max burst to set the request thresholds")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20200721203951.2159-1-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index 5986c520b1965..bb390ff67d1d8 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -372,8 +372,20 @@ static int dw_spi_dma_setup(struct dw_spi *dws, struct spi_transfer *xfer)
 {
 	u16 imr = 0, dma_ctrl = 0;
 
+	/*
+	 * Having a Rx DMA channel serviced with higher priority than a Tx DMA
+	 * channel might not be enough to provide a well balanced DMA-based
+	 * SPI transfer interface. There might still be moments when the Tx DMA
+	 * channel is occasionally handled faster than the Rx DMA channel.
+	 * That in its turn will eventually cause the SPI Rx FIFO overflow if
+	 * SPI bus speed is high enough to fill the SPI Rx FIFO in before it's
+	 * cleared by the Rx DMA channel. In order to fix the problem the Tx
+	 * DMA activity is intentionally slowed down by limiting the SPI Tx
+	 * FIFO depth with a value twice bigger than the Tx burst length
+	 * calculated earlier by the dw_spi_dma_maxburst_init() method.
+	 */
 	dw_writel(dws, DW_SPI_DMARDLR, dws->rxburst - 1);
-	dw_writel(dws, DW_SPI_DMATDLR, dws->fifo_len - dws->txburst);
+	dw_writel(dws, DW_SPI_DMATDLR, dws->txburst);
 
 	if (xfer->tx_buf)
 		dma_ctrl |= SPI_DMA_TDMAE;
-- 
2.25.1

