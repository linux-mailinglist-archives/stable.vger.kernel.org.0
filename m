Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551353D5F50
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhGZPRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237454AbhGZPPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C29460F57;
        Mon, 26 Jul 2021 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314961;
        bh=SEbEwsMH/Af4mYm6ntjbdU3aCmJFneFwqdmEwLIXWAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwfzspk5p4GXybV88Fgvh2BJysJG0Z1iotTSlN3W3rNhkcYrYK1KRuXgwSVydfDi7
         4G+AaBmfePXzuO4e+h5nq/gTwAhTqCvUwCFWPcBDe3jo48LGRDUP7cWcErvjh+GpbX
         O+DxQ0gjl547guqjnQxkKteL0DcjB4Up6mNDPLYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/108] spi: mediatek: fix fifo rx mode
Date:   Mon, 26 Jul 2021 17:38:36 +0200
Message-Id: <20210726153832.822618350@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Hess <peter.hess@ph-home.de>

[ Upstream commit 3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43 ]

In FIFO mode were two problems:
- RX mode was never handled and
- in this case the tx_buf pointer was NULL and caused an exception

fix this by handling RX mode in mtk_spi_fifo_transfer

Fixes: a568231f4632 ("spi: mediatek: Add spi bus for Mediatek MT8173")
Signed-off-by: Peter Hess <peter.hess@ph-home.de>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20210706121609.680534-1-linux@fw-web.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 8acf24f7c5d4..81eac9fbd08c 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -427,13 +427,23 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
 	mtk_spi_setup_packet(master);
 
 	cnt = xfer->len / 4;
-	iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
+	if (xfer->tx_buf)
+		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
+
+	if (xfer->rx_buf)
+		ioread32_rep(mdata->base + SPI_RX_DATA_REG, xfer->rx_buf, cnt);
 
 	remainder = xfer->len % 4;
 	if (remainder > 0) {
 		reg_val = 0;
-		memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
-		writel(reg_val, mdata->base + SPI_TX_DATA_REG);
+		if (xfer->tx_buf) {
+			memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
+			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
+		}
+		if (xfer->rx_buf) {
+			reg_val = readl(mdata->base + SPI_RX_DATA_REG);
+			memcpy(xfer->rx_buf + (cnt * 4), &reg_val, remainder);
+		}
 	}
 
 	mtk_spi_enable_transfer(master);
-- 
2.30.2



