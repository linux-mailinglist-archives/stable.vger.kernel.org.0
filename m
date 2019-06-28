Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D26B59266
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 06:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfF1EP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 00:15:58 -0400
Received: from smtp2207-205.mail.aliyun.com ([121.197.207.205]:38260 "EHLO
        smtp2207-205.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbfF1EP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 00:15:58 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08664834|-1;CH=green;DM=CONTINUE|CONTINUE|true|0.11304-0.0102429-0.876717;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03301;MF=liaoweixiong@allwinnertech.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.Er4GNk4_1561695320;
Received: from PC-liaoweixiong.allwinnertech.com(mailfrom:liaoweixiong@allwinnertech.com fp:SMTPD_---.Er4GNk4_1561695320)
          by smtp.aliyun-inc.com(10.147.41.143);
          Fri, 28 Jun 2019 12:15:53 +0800
From:   liaoweixiong <liaoweixiong@allwinnertech.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@exceet.de>,
        Peter Pan <peterpandong@micron.com>,
        Jeff Kletsky <git-commits@allycomm.com>,
        Schrempf Frieder <frieder.schrempf@kontron.De>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] mtd: spinand: read return badly if the last page has bitflips
Date:   Fri, 28 Jun 2019 12:14:46 +0800
Message-Id: <1561695286-19265-1-git-send-email-liaoweixiong@allwinnertech.com>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case of the last page containing bitflips (ret > 0),
spinand_mtd_read() will return that number of bitflips for the last
page. But to me it looks like it should instead return max_bitflips like
it does when the last page read returns with 0.

Signed-off-by: Weixiong Liao <liaoweixiong@allwinnertech.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Cc: stable@vger.kernel.org
Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
---
Changes since v2:
- Resend this patch with Cc and Fixes tags.

Changes since v1:
- More accurate description for this patch
---

 drivers/mtd/nand/spi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 556bfdb..6b9388d 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -511,12 +511,12 @@ static int spinand_mtd_read(struct mtd_info *mtd, loff_t from,
 		if (ret == -EBADMSG) {
 			ecc_failed = true;
 			mtd->ecc_stats.failed++;
-			ret = 0;
 		} else {
 			mtd->ecc_stats.corrected += ret;
 			max_bitflips = max_t(unsigned int, max_bitflips, ret);
 		}
 
+		ret = 0;
 		ops->retlen += iter.req.datalen;
 		ops->oobretlen += iter.req.ooblen;
 	}
-- 
1.9.1

