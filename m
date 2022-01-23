Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E873D4971DF
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiAWOJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:09:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59526 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbiAWOJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:09:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFF360C58
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D95C340E2;
        Sun, 23 Jan 2022 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642946997;
        bh=HQva1DbQtY/iy/dbPTbaI+QcZNzH35/PNwGzSeuEvJ0=;
        h=Subject:To:Cc:From:Date:From;
        b=DoDspuvAKiVeAwb6HbuU4Tp563WVdT1PTJcqoru0HxXmMw0AUaXkAuRAMkRZ8BJEI
         hwH6p2FFZ6SY2EMDzjqIR8vySNkiqLhPwJ0o/oTp8mEze8PQi+itUccFUDqxKTvfJz
         3qqi62B3E+lWjDJAwRZ66N2JpEu+OEfHvYl9khE0=
Subject: FAILED: patch "[PATCH] mtd: rawnand: Export nand_read_page_hwecc_oob_first()" failed to apply to 5.10-stable tree
To:     paul@crapouillou.net, miquel.raynal@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:09:55 +0100
Message-ID: <16429469953191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8466f73010faf71effb21228ae1cbf577dab130 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 16 Oct 2021 14:22:27 +0100
Subject: [PATCH] mtd: rawnand: Export nand_read_page_hwecc_oob_first()

Move the function nand_read_page_hwecc_oob_first() (previously
nand_davinci_read_page_hwecc_oob_first()) to nand_base.c, and export it
as a GPL symbol, so that it can be used by more modules.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-4-paul@crapouillou.net

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index fe2511cdcae3..45fec8c192ab 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -371,73 +371,6 @@ static int nand_davinci_correct_4bit(struct nand_chip *chip, u_char *data,
 	return corrected;
 }
 
-/**
- * nand_davinci_read_page_hwecc_oob_first - Hardware ECC page read with ECC
- *                                          data read from OOB area
- * @chip: nand chip info structure
- * @buf: buffer to store read data
- * @oob_required: caller requires OOB data read to chip->oob_poi
- * @page: page number to read
- *
- * Hardware ECC for large page chips, which requires the ECC data to be
- * extracted from the OOB before the actual data is read.
- */
-static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
-						  uint8_t *buf,
-						  int oob_required, int page)
-{
-	struct mtd_info *mtd = nand_to_mtd(chip);
-	int i, eccsize = chip->ecc.size, ret;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
-	uint8_t *p = buf;
-	uint8_t *ecc_code = chip->ecc.code_buf;
-	unsigned int max_bitflips = 0;
-
-	/* Read the OOB area first */
-	ret = nand_read_oob_op(chip, page, 0, chip->oob_poi, mtd->oobsize);
-	if (ret)
-		return ret;
-
-	/* Move read cursor to start of page */
-	ret = nand_change_read_column_op(chip, 0, NULL, 0, false);
-	if (ret)
-		return ret;
-
-	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
-					 chip->ecc.total);
-	if (ret)
-		return ret;
-
-	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
-		int stat;
-
-		chip->ecc.hwctl(chip, NAND_ECC_READ);
-
-		ret = nand_read_data_op(chip, p, eccsize, false, false);
-		if (ret)
-			return ret;
-
-		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
-		if (stat == -EBADMSG &&
-		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {
-			/* check for empty pages with bitflips */
-			stat = nand_check_erased_ecc_chunk(p, eccsize,
-							   &ecc_code[i],
-							   eccbytes, NULL, 0,
-							   chip->ecc.strength);
-		}
-
-		if (stat < 0) {
-			mtd->ecc_stats.failed++;
-		} else {
-			mtd->ecc_stats.corrected += stat;
-			max_bitflips = max_t(unsigned int, max_bitflips, stat);
-		}
-	}
-	return max_bitflips;
-}
-
 /*----------------------------------------------------------------------*/
 
 /* An ECC layout for using 4-bit ECC with small-page flash, storing
@@ -647,7 +580,7 @@ static int davinci_nand_attach_chip(struct nand_chip *chip)
 			} else if (chunks == 4 || chunks == 8) {
 				mtd_set_ooblayout(mtd,
 						  nand_get_large_page_ooblayout());
-				chip->ecc.read_page = nand_davinci_read_page_hwecc_oob_first;
+				chip->ecc.read_page = nand_read_page_hwecc_oob_first;
 			} else {
 				return -EIO;
 			}
diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 3d6c6e880520..113a2e9f43b1 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3160,6 +3160,73 @@ static int nand_read_page_hwecc(struct nand_chip *chip, uint8_t *buf,
 	return max_bitflips;
 }
 
+/**
+ * nand_read_page_hwecc_oob_first - Hardware ECC page read with ECC
+ *                                  data read from OOB area
+ * @chip: nand chip info structure
+ * @buf: buffer to store read data
+ * @oob_required: caller requires OOB data read to chip->oob_poi
+ * @page: page number to read
+ *
+ * Hardware ECC for large page chips, which requires the ECC data to be
+ * extracted from the OOB before the actual data is read.
+ */
+int nand_read_page_hwecc_oob_first(struct nand_chip *chip, uint8_t *buf,
+				   int oob_required, int page)
+{
+	struct mtd_info *mtd = nand_to_mtd(chip);
+	int i, eccsize = chip->ecc.size, ret;
+	int eccbytes = chip->ecc.bytes;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *p = buf;
+	uint8_t *ecc_code = chip->ecc.code_buf;
+	unsigned int max_bitflips = 0;
+
+	/* Read the OOB area first */
+	ret = nand_read_oob_op(chip, page, 0, chip->oob_poi, mtd->oobsize);
+	if (ret)
+		return ret;
+
+	/* Move read cursor to start of page */
+	ret = nand_change_read_column_op(chip, 0, NULL, 0, false);
+	if (ret)
+		return ret;
+
+	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
+
+	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
+		int stat;
+
+		chip->ecc.hwctl(chip, NAND_ECC_READ);
+
+		ret = nand_read_data_op(chip, p, eccsize, false, false);
+		if (ret)
+			return ret;
+
+		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
+		if (stat == -EBADMSG &&
+		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {
+			/* check for empty pages with bitflips */
+			stat = nand_check_erased_ecc_chunk(p, eccsize,
+							   &ecc_code[i],
+							   eccbytes, NULL, 0,
+							   chip->ecc.strength);
+		}
+
+		if (stat < 0) {
+			mtd->ecc_stats.failed++;
+		} else {
+			mtd->ecc_stats.corrected += stat;
+			max_bitflips = max_t(unsigned int, max_bitflips, stat);
+		}
+	}
+	return max_bitflips;
+}
+EXPORT_SYMBOL_GPL(nand_read_page_hwecc_oob_first);
+
 /**
  * nand_read_page_syndrome - [REPLACEABLE] hardware ECC syndrome based page read
  * @chip: nand chip info structure
diff --git a/include/linux/mtd/rawnand.h b/include/linux/mtd/rawnand.h
index b2f9dd3cbd69..5b88cd51fadb 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -1539,6 +1539,8 @@ int nand_read_data_op(struct nand_chip *chip, void *buf, unsigned int len,
 		      bool force_8bit, bool check_only);
 int nand_write_data_op(struct nand_chip *chip, const void *buf,
 		       unsigned int len, bool force_8bit);
+int nand_read_page_hwecc_oob_first(struct nand_chip *chip, uint8_t *buf,
+				   int oob_required, int page);
 
 /* Scan and identify a NAND device */
 int nand_scan_with_ids(struct nand_chip *chip, unsigned int max_chips,

