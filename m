Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BBF35E3DF
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDMQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 12:28:06 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:53629 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhDMQ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 12:28:04 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id E9707D7E76
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 16:19:04 +0000 (UTC)
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 971F2FF80D;
        Tue, 13 Apr 2021 16:18:42 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/7] mtd: rawnand: cs553x: Fix external use of SW Hamming ECC helper
Date:   Tue, 13 Apr 2021 18:18:34 +0200
Message-Id: <20210413161840.345208-2-miquel.raynal@bootlin.com>
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
 drivers/mtd/nand/raw/cs553x_nand.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/cs553x_nand.c b/drivers/mtd/nand/raw/cs553x_nand.c
index 6edf78c16fc8..3e41d815d5b0 100644
--- a/drivers/mtd/nand/raw/cs553x_nand.c
+++ b/drivers/mtd/nand/raw/cs553x_nand.c
@@ -240,6 +240,15 @@ static int cs_calculate_ecc(struct nand_chip *this, const u_char *dat,
 	return 0;
 }
 
+static int cs553x_ecc_correct(struct nand_chip *chip,
+			      unsigned char *buf,
+			      unsigned char *read_ecc,
+			      unsigned char *calc_ecc)
+{
+	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
+				      chip->ecc.size, false);
+}
+
 static struct cs553x_nand_controller *controllers[4];
 
 static int cs553x_attach_chip(struct nand_chip *chip)
@@ -251,7 +260,7 @@ static int cs553x_attach_chip(struct nand_chip *chip)
 	chip->ecc.bytes = 3;
 	chip->ecc.hwctl  = cs_enable_hwecc;
 	chip->ecc.calculate = cs_calculate_ecc;
-	chip->ecc.correct  = rawnand_sw_hamming_correct;
+	chip->ecc.correct  = cs553x_ecc_correct;
 	chip->ecc.strength = 1;
 
 	return 0;
-- 
2.27.0

