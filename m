Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9751162435
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgBRKFj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 18 Feb 2020 05:05:39 -0500
Received: from skedge03.snt-world.com ([91.208.41.68]:45796 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgBRKFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 05:05:39 -0500
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id 7E93667A5A8;
        Tue, 18 Feb 2020 11:05:36 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 18 Feb
 2020 11:05:36 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 18 Feb 2020 11:05:36 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: [PATCH v3 3/3] mtd: spinand: Do not erase the block before writing a
 bad block marker
Thread-Topic: [PATCH v3 3/3] mtd: spinand: Do not erase the block before
 writing a bad block marker
Thread-Index: AQHV5kL2fn0Iiu4Eq0WB3PT4XCneCA==
Date:   Tue, 18 Feb 2020 10:05:35 +0000
Message-ID: <20200218100432.32433-4-frieder.schrempf@kontron.de>
References: <20200218100432.32433-1-frieder.schrempf@kontron.de>
In-Reply-To: <20200218100432.32433-1-frieder.schrempf@kontron.de>
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
X-SnT-MailScanner-ID: 7E93667A5A8.ADBEE
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, git-commits@allycomm.com,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, miquel.raynal@bootlin.com,
        richard@nod.at, stable@vger.kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Currently when marking a block, we use spinand_erase_op() to erase
the block before writing the marker to the OOB area. Doing so without
waiting for the operation to finish can lead to the marking failing
silently and no bad block marker being written to the flash.

In fact we don't need to do an erase at all before writing the BBM.
The ECC is disabled for raw accesses to the OOB data and we don't
need to work around any issues with chips reporting ECC errors as it
is known to be the case for raw NAND.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
Changes in v3:
 * Fix the subject line and the commit message
 * Add Boris' R-b tag

Changes in v2:
 * Instead of waiting for the erase operation to finish, just don't
   do an erase at all, as it is not needed.
 * Update the commit message
---
 drivers/mtd/nand/spi/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index a94287884453..8dda51bbdd11 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -613,7 +613,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 	};
 	int ret;
 
-	/* Erase block before marking it bad. */
 	ret = spinand_select_target(spinand, pos->target);
 	if (ret)
 		return ret;
@@ -622,8 +621,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 	if (ret)
 		return ret;
 
-	spinand_erase_op(spinand, pos);
-
 	return spinand_write_page(spinand, &req);
 }
 
-- 
2.17.1
