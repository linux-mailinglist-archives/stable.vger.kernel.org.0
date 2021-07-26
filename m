Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289CE3D61D7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhGZPdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhGZPaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF08A604AC;
        Mon, 26 Jul 2021 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315868;
        bh=Wx4TZWZ0r3DyLbZiybcvfF6PUqsP1pg/w2BFEdexEZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D06tfuUbR45w1nTTxtjXaJZo1yCH2PzDXTdVImppkDuYm3H0YjnylXYRYgXLFlVli
         GNsposDZdJ+hY+LXm4jAU/dzi4QLKFg2uYZdLg460Pg8PZ+uJVxHil8MuiJdL8s9uv
         dn31fi+/mDfqZzeA5d36K2rZ95+5F7IgTzaXC3HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/223] spi: mediatek: fix fifo rx mode
Date:   Mon, 26 Jul 2021 17:37:43 +0200
Message-Id: <20210726153848.574039034@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index 976f73b9e299..8d5fa7f1e506 100644
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



