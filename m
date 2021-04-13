Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334DA35E3E4
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbhDMQ2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:28:08 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:58859 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245516AbhDMQ2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:28:06 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 72AB7D9D8E
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 16:19:08 +0000 (UTC)
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 9DE86FF811;
        Tue, 13 Apr 2021 16:18:46 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Subject: [PATCH v3 6/7] mtd: rawnand: tmio: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 18:18:39 +0200
Message-Id: <20210413161840.345208-7-miquel.raynal@bootlin.com>
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
 drivers/mtd/nand/raw/tmio_nand.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/tmio_nand.c b/drivers/mtd/nand/raw/tmio_nand.c
index de8e919d0ebe..6d93dd31969b 100644
--- a/drivers/mtd/nand/raw/tmio_nand.c
+++ b/drivers/mtd/nand/raw/tmio_nand.c
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand-ecc-sw-hamming.h>
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/slab.h>
@@ -292,11 +293,12 @@ static int tmio_nand_correct_data(struct nand_chip *chip, unsigned char *buf,
 	int r0, r1;
 
 	/* assume ecc.size = 512 and ecc.bytes = 6 */
-	r0 = rawnand_sw_hamming_correct(chip, buf, read_ecc, calc_ecc);
+	r0 = ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				    chip->ecc.size, false);
 	if (r0 < 0)
 		return r0;
-	r1 = rawnand_sw_hamming_correct(chip, buf + 256, read_ecc + 3,
-					calc_ecc + 3);
+	r1 = ecc_sw_hamming_correct(buf + 256, read_ecc + 3, calc_ecc + 3,
+				    chip->ecc.size, false);
 	if (r1 < 0)
 		return r1;
 	return r0 + r1;
-- 
2.27.0

