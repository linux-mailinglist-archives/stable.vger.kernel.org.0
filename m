Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7ED696AF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbfGOOEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387849AbfGOOEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:04:10 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D6C2081C;
        Mon, 15 Jul 2019 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199449;
        bh=mSly9/QB6NgeDVXk7wAa+JBqfFX3uXKExoFhgAGyqtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsoFL5OvGFAxQ8K18CCWHGKNKA9hIgLro0b+0bgEgWIygcaXDM0oJSFICG3RVf7iK
         HIMYUSUhqfV0N4Q63YonjpER0SohrKhs5YyxUn/ycDuwyr8XgZc2MqYO2vPl26jdc+
         LYmHGibWloIF9sGdm2WBZlOyJkNVznLdIb4V+YSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 007/219] spi: rockchip: turn down tx dma bursts
Date:   Mon, 15 Jul 2019 10:00:08 -0400
Message-Id: <20190715140341.6443-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

[ Upstream commit 47300728fb213486a830565d2af49da967c9d16a ]

This fixes tx and bi-directional dma transfers on rk3399-gru-kevin.

It seems the SPI fifo must have room for 2 bursts when the dma_tx_req
signal is generated or it might skip some words. This in turn makes
the rx dma channel never complete for bi-directional transfers.

Fix it by setting tx burst length to fifo_len / 4 and the dma
watermark to fifo_len / 2.

However the rk3399 TRM says (sic):
"DMAC support incrementing-address burst and fixed-address burst. But in
the case of access SPI and UART at byte or halfword size, DMAC only
support fixed-address burst and the address must be aligned to word."

So this relies on fifo_len being a multiple of 16 such that the
burst length (= fifo_len / 4) is a multiple of 4 and the addresses
will be word-aligned.

Fixes: dcfc861d24ec ("spi: rockchip: adjust dma watermark and burstlen")
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 3912526ead66..19f6a76f1c07 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -425,7 +425,7 @@ static int rockchip_spi_prepare_dma(struct rockchip_spi *rs,
 			.direction = DMA_MEM_TO_DEV,
 			.dst_addr = rs->dma_addr_tx,
 			.dst_addr_width = rs->n_bytes,
-			.dst_maxburst = rs->fifo_len / 2,
+			.dst_maxburst = rs->fifo_len / 4,
 		};
 
 		dmaengine_slave_config(master->dma_tx, &txconf);
@@ -526,7 +526,7 @@ static void rockchip_spi_config(struct rockchip_spi *rs,
 	else
 		writel_relaxed(rs->fifo_len / 2 - 1, rs->regs + ROCKCHIP_SPI_RXFTLR);
 
-	writel_relaxed(rs->fifo_len / 2 - 1, rs->regs + ROCKCHIP_SPI_DMATDLR);
+	writel_relaxed(rs->fifo_len / 2, rs->regs + ROCKCHIP_SPI_DMATDLR);
 	writel_relaxed(0, rs->regs + ROCKCHIP_SPI_DMARDLR);
 	writel_relaxed(dmacr, rs->regs + ROCKCHIP_SPI_DMACR);
 
-- 
2.20.1

