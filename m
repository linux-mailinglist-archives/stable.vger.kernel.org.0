Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C66435DC07
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhDMJ7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 05:59:40 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:59517 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhDMJ7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 05:59:38 -0400
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 0195910000D;
        Tue, 13 Apr 2021 09:59:16 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org,
        Trevor Woerner <twoerner@gmail.com>
Subject: [PATCH v2] mtd: rawnand: lpc32xx_slc: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 11:59:16 +0200
Message-Id: <20210413095916.330405-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
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

Fixes: 19b2ce184b9f ("mtd: nand: ecc-hamming: Stop using raw NAND structures")
Cc: stable@vger.kernel.org
Reported-by: Trevor Woerner <twoerner@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/lpc32xx_slc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/lpc32xx_slc.c b/drivers/mtd/nand/raw/lpc32xx_slc.c
index 6b7269cfb7d8..65663f5ba54f 100644
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -27,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/mtd/lpc32xx_slc.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 
 #define LPC32XX_MODNAME		"lpc32xx-nand"
 
@@ -344,6 +345,18 @@ static int lpc32xx_nand_ecc_calculate(struct nand_chip *chip,
 	return 0;
 }
 
+/*
+ * Corrects the data
+ */
+static int lpc32xx_nand_ecc_correct(struct nand_chip *chip,
+				    unsigned char *buf,
+				    unsigned char *read_ecc,
+				    unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 /*
  * Read a single byte from NAND device
  */
@@ -802,7 +815,7 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
 	chip->ecc.write_oob = lpc32xx_nand_write_oob_syndrome;
 	chip->ecc.read_oob = lpc32xx_nand_read_oob_syndrome;
 	chip->ecc.calculate = lpc32xx_nand_ecc_calculate;
-	chip->ecc.correct = rawnand_sw_hamming_correct;
+	chip->ecc.correct = lpc32xx_nand_ecc_correct;
 	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
 
 	/*
@@ -819,8 +832,14 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
 	return 0;
 }
 
+static void lpc32xx_nand_detach_chip(struct nand_chip *chip)
+{
+	rawnand_sw_hamming_cleanup(chip);
+}
+
 static const struct nand_controller_ops lpc32xx_nand_controller_ops = {
 	.attach_chip = lpc32xx_nand_attach_chip,
+	.detach_chip = lpc32xx_nand_detach_chip,
 };
 
 /*
-- 
2.27.0

