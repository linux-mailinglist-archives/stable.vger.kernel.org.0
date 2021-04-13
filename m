Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3435E3E1
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhDMQ2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:28:07 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:45737 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbhDMQ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:28:04 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 88148D9626
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 16:19:07 +0000 (UTC)
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id E45B1FF80E;
        Tue, 13 Apr 2021 16:18:45 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Subject: [PATCH v3 5/7] mtd: rawnand: sharpsl: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 18:18:38 +0200
Message-Id: <20210413161840.345208-6-miquel.raynal@bootlin.com>
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
 drivers/mtd/nand/raw/sharpsl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sharpsl.c b/drivers/mtd/nand/raw/sharpsl.c
index 5612ee628425..2f1fe464e663 100644
--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/sharpsl.h>
@@ -96,6 +97,15 @@ static int sharpsl_nand_calculate_ecc(struct nand_chip *chip,
 	return readb(sharpsl->io + ECCCNTR) != 0;
 }
 
+static int sharpsl_nand_correct_ecc(struct nand_chip *chip,
+				    unsigned char *buf,
+				    unsigned char *read_ecc,
+				    unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 static int sharpsl_attach_chip(struct nand_chip *chip)
 {
 	if (chip->ecc.engine_type != NAND_ECC_ENGINE_TYPE_ON_HOST)
@@ -106,7 +116,7 @@ static int sharpsl_attach_chip(struct nand_chip *chip)
 	chip->ecc.strength = 1;
 	chip->ecc.hwctl = sharpsl_nand_enable_hwecc;
 	chip->ecc.calculate = sharpsl_nand_calculate_ecc;
-	chip->ecc.correct = rawnand_sw_hamming_correct;
+	chip->ecc.correct = sharpsl_nand_correct_ecc;
 
 	return 0;
 }
-- 
2.27.0

