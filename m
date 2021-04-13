Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84435E3DE
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243727AbhDMQ2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:28:05 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:32903 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDMQ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:28:04 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 44F7CD90EA
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 16:19:05 +0000 (UTC)
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 43A4DFF803;
        Tue, 13 Apr 2021 16:18:43 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/7] mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 18:18:35 +0200
Message-Id: <20210413161840.345208-3-miquel.raynal@bootlin.com>
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
 drivers/mtd/nand/raw/fsmc_nand.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index a24e2f57fa68..99a4dde9825a 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
@@ -432,6 +433,15 @@ static int fsmc_read_hwecc_ecc1(struct nand_chip *chip, const u8 *data,
 	return 0;
 }
 
+static int fsmc_correct_ecc1(struct nand_chip *chip,
+			     unsigned char *buf,
+			     unsigned char *read_ecc,
+			     unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 /* Count the number of 0's in buff upto a max of max_bits */
 static int count_written_bits(u8 *buff, int size, int max_bits)
 {
@@ -917,7 +927,7 @@ static int fsmc_nand_attach_chip(struct nand_chip *nand)
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_info(host->dev, "Using 1-bit HW ECC scheme\n");
 		nand->ecc.calculate = fsmc_read_hwecc_ecc1;
-		nand->ecc.correct = rawnand_sw_hamming_correct;
+		nand->ecc.correct = fsmc_correct_ecc1;
 		nand->ecc.hwctl = fsmc_enable_hwecc;
 		nand->ecc.bytes = 3;
 		nand->ecc.strength = 1;
-- 
2.27.0

