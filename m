Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D531B816D
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390382AbfISTdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:33:12 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47147 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390364AbfISTdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 15:33:12 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 3AF66240006;
        Thu, 19 Sep 2019 19:33:07 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     <linux-mtd@lists.infradead.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Mason Yang <masonccyang@mxic.com.tw>,
        Julien Su <juliensu@mxic.com.tw>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 39/40] mtd: spinand: Fix OOB read
Date:   Thu, 19 Sep 2019 21:31:39 +0200
Message-Id: <20190919193141.7865-40-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919193141.7865-1-miquel.raynal@bootlin.com>
References: <20190919193141.7865-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So far OOB have never been used in SPI-NAND, add the missing memcpy to
make it work properly.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/spi/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 314cbdad1462..f5d2fcae5e59 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -383,6 +383,10 @@ static int spinand_read_from_cache_op(struct spinand_device *spinand,
 		memcpy(req->databuf.in, spinand->databuf + req->dataoffs,
 		       req->datalen);
 
+	if (req->ooblen)
+		memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
+		       req->ooblen);
+
 	return 0;
 }
 
-- 
2.20.1

