Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4935E3E2
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhDMQ2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:28:07 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:59785 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhDMQ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:28:04 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id D2FDBD927A
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 16:19:06 +0000 (UTC)
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 3CF33FF80A;
        Tue, 13 Apr 2021 16:18:45 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Subject: [PATCH v3 4/7] mtd: rawnand: ndfc: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 18:18:37 +0200
Message-Id: <20210413161840.345208-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413161840.345208-1-miquel.raynal@bootlin.com>
References: <20210413161840.345208-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to either
initialize the engine before using any one of his functions or use one
of the bare helpers which only perform the calculations. As there is no
actual need for a proper ECC initialization, let's just use the bare
helper instead of the rawnand one.

Fixes: 90ccf0a0192f ("mtd: nand: ecc-hamming: Rename the exported functions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/ndfc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 338d6b1a189e..98d5a94c3a24 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -22,6 +22,7 @@
 #include <linux/mtd/ndfc.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/io.h>
@@ -100,6 +101,15 @@ static int ndfc_calculate_ecc(struct nand_chip *chip,
 	return 0;
 }
 
+static int ndfc_correct_ecc(struct nand_chip *chip,
+			    unsigned char *buf,
+			    unsigned char *read_ecc,
+			    unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 /*
  * Speedups for buffer read/write/verify
  *
@@ -145,7 +155,7 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 	chip->controller = &ndfc->ndfc_control;
 	chip->legacy.read_buf = ndfc_read_buf;
 	chip->legacy.write_buf = ndfc_write_buf;
-	chip->ecc.correct = rawnand_sw_hamming_correct;
+	chip->ecc.correct = ndfc_correct_ecc;
 	chip->ecc.hwctl = ndfc_enable_hwecc;
 	chip->ecc.calculate = ndfc_calculate_ecc;
 	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_ON_HOST;
-- 
2.27.0

