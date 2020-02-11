Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F734159536
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 17:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgBKQmJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Feb 2020 11:42:09 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:36162 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgBKQmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 11:42:09 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 11:42:06 EST
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 384DA67A894;
        Tue, 11 Feb 2020 17:35:54 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 11 Feb
 2020 17:35:53 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 11 Feb 2020 17:35:53 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Peter Pan <peterpandong@micron.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Topic: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Index: AQHV4PlTblnHiLQcV0asTsn4OWAZ0A==
Date:   Tue, 11 Feb 2020 16:35:53 +0000
Message-ID: <20200211163452.25442-4-frieder.schrempf@kontron.de>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
In-Reply-To: <20200211163452.25442-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 384DA67A894.AE793
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, git-commits@allycomm.com,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, miquel.raynal@bootlin.com,
        peterpandong@micron.com, richard@nod.at, stable@vger.kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Currently when marking a block, we use spinand_erase_op() to erase
the block before writing the marker to the OOB area without waiting
for the operation to succeed. This can lead to the marking failing
silently and no bad block marker being written to the flash.

To fix this we reuse the spinand_erase() function, that already does
everything we need to do before actually writing the marker.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/mtd/nand/spi/core.c | 56 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 925db6269861..8a69d13639e2 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -600,6 +600,32 @@ static int spinand_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
 	return ret;
 }
 
+static int __spinand_erase(struct nand_device *nand, const struct nand_pos *pos,
+			   bool hard_fail)
+{
+	struct spinand_device *spinand = nand_to_spinand(nand);
+	u8 status;
+	int ret;
+
+	ret = spinand_select_target(spinand, pos->target);
+	if (ret)
+		return ret;
+
+	ret = spinand_write_enable_op(spinand);
+	if (ret)
+		return ret;
+
+	ret = spinand_erase_op(spinand, pos);
+	if (ret && hard_fail)
+		return ret;
+
+	ret = spinand_wait(spinand, &status);
+	if (!ret && (status & STATUS_ERASE_FAILED))
+		ret = -EIO;
+
+	return ret;
+}
+
 static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 {
 	struct spinand_device *spinand = nand_to_spinand(nand);
@@ -614,16 +640,10 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 	int ret;
 
 	/* Erase block before marking it bad. */
-	ret = spinand_select_target(spinand, pos->target);
-	if (ret)
-		return ret;
-
-	ret = spinand_write_enable_op(spinand);
+	ret = __spinand_erase(nand, pos, false);
 	if (ret)
 		return ret;
 
-	spinand_erase_op(spinand, pos);
-
 	return spinand_write_page(spinand, &req);
 }
 
@@ -644,27 +664,7 @@ static int spinand_mtd_block_markbad(struct mtd_info *mtd, loff_t offs)
 
 static int spinand_erase(struct nand_device *nand, const struct nand_pos *pos)
 {
-	struct spinand_device *spinand = nand_to_spinand(nand);
-	u8 status;
-	int ret;
-
-	ret = spinand_select_target(spinand, pos->target);
-	if (ret)
-		return ret;
-
-	ret = spinand_write_enable_op(spinand);
-	if (ret)
-		return ret;
-
-	ret = spinand_erase_op(spinand, pos);
-	if (ret)
-		return ret;
-
-	ret = spinand_wait(spinand, &status);
-	if (!ret && (status & STATUS_ERASE_FAILED))
-		ret = -EIO;
-
-	return ret;
+	return __spinand_erase(nand, pos, true);
 }
 
 static int spinand_mtd_erase(struct mtd_info *mtd,
-- 
2.17.1
