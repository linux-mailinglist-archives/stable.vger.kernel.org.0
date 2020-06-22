Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5C2037DA
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFVNXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 09:23:42 -0400
Received: from shelob.oktetlabs.ru ([91.220.146.113]:49879 "EHLO
        shelob.oktetlabs.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgFVNXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 09:23:41 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2020 09:23:39 EDT
Received: by shelob.oktetlabs.ru (Postfix, from userid 122)
        id 8ED517F5F0; Mon, 22 Jun 2020 16:16:42 +0300 (MSK)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on shelob.oktetlabs.ru
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=5.0 tests=ALL_TRUSTED,DKIM_ADSP_DISCARD
        autolearn=no autolearn_force=no version=3.4.2
Received: from varda.oktetlabs.ru (varda.oktetlabs.ru [192.168.37.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by shelob.oktetlabs.ru (Postfix) with ESMTPS id CC8C07F5DF;
        Mon, 22 Jun 2020 16:16:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 shelob.oktetlabs.ru CC8C07F5DF
Authentication-Results: shelob.oktetlabs.ru/CC8C07F5DF; dkim=none;
        dkim-atps=neutral
Received: from mkshevetskiy by varda.oktetlabs.ru with local (Exim 4.94)
        (envelope-from <mkshevetskiy@varda.oktetlabs.ru>)
        id 1jnMJO-008wpM-D2; Mon, 22 Jun 2020 16:16:34 +0300
From:   Mikhail Kshevetskiy <mikhail.kshevetskiy@oktetlabs.ru>
To:     u-boot@lists.denx.de
Cc:     scottwood@freescale.com,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 1/4] mtd: spinand: Stop using spinand->oobbuf for buffering bad block markers
Date:   Mon, 22 Jun 2020 16:16:31 +0300
Message-Id: <20200622131634.2132717-1-mikhail.kshevetskiy@oktetlabs.ru>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

For reading and writing the bad block markers, spinand->oobbuf is
currently used as a buffer for the marker bytes. During the
underlying read and write operations to actually get/set the content
of the OOB area, the content of spinand->oobbuf is reused and changed
by accessing it through spinand->oobbuf and/or spinand->databuf.

This is a flaw in the original design of the SPI NAND core and at the
latest from 13c15e07eedf ("mtd: spinand: Handle the case where
PROGRAM LOAD does not reset the cache") on, it results in not having
the bad block marker written at all, as the spinand->oobbuf is
cleared to 0xff after setting the marker bytes to zero.

To fix it, we now just store the two bytes for the marker on the
stack and let the read/write operations copy it from/to the page
buffer later.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200218100432.32433-2-frieder.schrempf@kontron.de
---
 drivers/mtd/nand/spi/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 93371fdde0..410ea2382d 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -655,16 +655,16 @@ static int spinand_mtd_write(struct mtd_info *mtd, loff_t to,
 static bool spinand_isbad(struct nand_device *nand, const struct nand_pos *pos)
 {
 	struct spinand_device *spinand = nand_to_spinand(nand);
+	u8 marker[2] = { };
 	struct nand_page_io_req req = {
 		.pos = *pos,
-		.ooblen = 2,
+		.ooblen = sizeof(marker),
 		.ooboffs = 0,
-		.oobbuf.in = spinand->oobbuf,
+		.oobbuf.in = marker,
 		.mode = MTD_OPS_RAW,
 	};
 	int ret;
 
-	memset(spinand->oobbuf, 0, 2);
 	ret = spinand_select_target(spinand, pos->target);
 	if (ret)
 		return ret;
@@ -673,7 +673,7 @@ static bool spinand_isbad(struct nand_device *nand, const struct nand_pos *pos)
 	if (ret)
 		return ret;
 
-	if (spinand->oobbuf[0] != 0xff || spinand->oobbuf[1] != 0xff)
+	if (marker[0] != 0xff || marker[1] != 0xff)
 		return true;
 
 	return false;
@@ -702,11 +702,12 @@ static int spinand_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
 static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 {
 	struct spinand_device *spinand = nand_to_spinand(nand);
+	u8 marker[2] = { };
 	struct nand_page_io_req req = {
 		.pos = *pos,
 		.ooboffs = 0,
-		.ooblen = 2,
-		.oobbuf.out = spinand->oobbuf,
+		.ooblen = sizeof(marker),
+		.oobbuf.out = marker,
 	};
 	int ret;
 
@@ -723,7 +724,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 	if (ret)
 		return ret;
 
-	memset(spinand->oobbuf, 0, 2);
 	return spinand_write_page(spinand, &req);
 }
 
-- 
2.27.0

