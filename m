Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E900D434DBA
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJTOaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 10:30:55 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:43759 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhJTOap (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 10:30:45 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 5C0F52000D;
        Wed, 20 Oct 2021 14:28:29 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     <linux-mtd@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Julien Su <juliensu@mxic.com.tw>,
        Jaime Liao <jaimeliao@mxic.com.tw>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Xiangsheng Hou <Xiangsheng.Hou@mediatek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, Mason Yang <masonccyang@mxic.com.tw>,
        Zhengxun Li <zhengxunli@mxic.com.tw>
Subject: [PATCH 14/18] spi: mxic: Fix the transmit path
Date:   Wed, 20 Oct 2021 16:28:05 +0200
Message-Id: <20211020142809.349347-15-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211020142809.349347-1-miquel.raynal@bootlin.com>
References: <20211020142809.349347-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By working with external hardware ECC engines, we figured out that
Under certain circumstances, it is needed for the SPI controller to
check INT_TX_EMPTY and INT_RX_NOT_EMPTY in both receive and transmit
path (not only in the receive path). The delay penalty being
negligible, move this code in the common path.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Cc: stable@vger.kernel.org
Suggested-by: Mason Yang <masonccyang@mxic.com.tw>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Zhengxun Li <zhengxunli@mxic.com.tw>
---
 drivers/spi/spi-mxic.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index 45889947afed..03fce4493aa7 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -304,25 +304,21 @@ static int mxic_spi_data_xfer(struct mxic_spi *mxic, const void *txbuf,
 
 		writel(data, mxic->regs + TXD(nbytes % 4));
 
+		ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
+					 sts & INT_TX_EMPTY, 0, USEC_PER_SEC);
+		if (ret)
+			return ret;
+
+		ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
+					 sts & INT_RX_NOT_EMPTY, 0,
+					 USEC_PER_SEC);
+		if (ret)
+			return ret;
+
+		data = readl(mxic->regs + RXD);
 		if (rxbuf) {
-			ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
-						 sts & INT_TX_EMPTY, 0,
-						 USEC_PER_SEC);
-			if (ret)
-				return ret;
-
-			ret = readl_poll_timeout(mxic->regs + INT_STS, sts,
-						 sts & INT_RX_NOT_EMPTY, 0,
-						 USEC_PER_SEC);
-			if (ret)
-				return ret;
-
-			data = readl(mxic->regs + RXD);
 			data >>= (8 * (4 - nbytes));
 			memcpy(rxbuf + pos, &data, nbytes);
-			WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
-		} else {
-			readl(mxic->regs + RXD);
 		}
 		WARN_ON(readl(mxic->regs + INT_STS) & INT_RX_NOT_EMPTY);
 
-- 
2.27.0

