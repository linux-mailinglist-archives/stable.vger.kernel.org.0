Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9124445ED33
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 12:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377206AbhKZMBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 07:01:01 -0500
Received: from mslow1.mail.gandi.net ([217.70.178.240]:35783 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349012AbhKZL7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 06:59:00 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 947D2C460B;
        Fri, 26 Nov 2021 11:40:19 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 082EAFF823;
        Fri, 26 Nov 2021 11:39:49 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        <linux-mtd@lists.infradead.org>
Cc:     Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        Xiangsheng Hou <Xiangsheng.Hou@mediatek.com>,
        Julien Su <juliensu@mxic.com.tw>,
        Jaime Liao <jaimeliao@mxic.com.tw>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, Mason Yang <masonccyang@mxic.com.tw>,
        Zhengxun Li <zhengxunli@mxic.com.tw>
Subject: [PATCH v2 16/20] spi: mxic: Fix the transmit path
Date:   Fri, 26 Nov 2021 12:39:20 +0100
Message-Id: <20211126113924.310459-17-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211126113924.310459-1-miquel.raynal@bootlin.com>
References: <20211126113924.310459-1-miquel.raynal@bootlin.com>
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

