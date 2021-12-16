Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794B647700E
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 12:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhLPLRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 06:17:42 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43117 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhLPLRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 06:17:41 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 8CB58E0010;
        Thu, 16 Dec 2021 11:17:38 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        <linux-mtd@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
Cc:     Julien Su <juliensu@mxic.com.tw>,
        Jaime Liao <jaimeliao@mxic.com.tw>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, Mason Yang <masonccyang@mxic.com.tw>,
        Zhengxun Li <zhengxunli@mxic.com.tw>
Subject: [PATCH v6 24/28] spi: mxic: Fix the transmit path
Date:   Thu, 16 Dec 2021 12:16:50 +0100
Message-Id: <20211216111654.238086-25-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211216111654.238086-1-miquel.raynal@bootlin.com>
References: <20211216111654.238086-1-miquel.raynal@bootlin.com>
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
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-mxic.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index 8c8c929c87b5..3d6561a3ff8b 100644
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

