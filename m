Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2D3D5E66
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhGZPHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236322AbhGZPGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1765A60F38;
        Mon, 26 Jul 2021 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314442;
        bh=5+cmeG2IgY/yCrm92xeczh+uJj71mqrquauPWx8TM1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5Oh/f6mPTZzYi9mPYMOLpA8sUPngtFXkf7C7rwODcetbWLFu6hvgNdWKsGorL7nR
         DCq/HtsfbINR0OlDrPh6shNaawUED3HrQ0lc1AwKGH8e2woHh4rtk5mYum0pDc2BvO
         57x7E/0hbmd8IaUqU6J/9R3C8wl6vaKZg6S6pEg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/82] spi: mediatek: fix fifo rx mode
Date:   Mon, 26 Jul 2021 17:38:48 +0200
Message-Id: <20210726153829.739012957@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index da28c52c9da1..e2b171057b3b 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -392,13 +392,23 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
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



