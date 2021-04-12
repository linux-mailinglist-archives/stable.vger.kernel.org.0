Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771FB35CA8F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhDLQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:00:17 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43747 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbhDLQAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 12:00:16 -0400
X-Originating-IP: 90.89.138.59
Received: from xps13.home (lfbn-tou-1-1325-59.w90-89.abo.wanadoo.fr [90.89.138.59])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id A9B6AE0013;
        Mon, 12 Apr 2021 15:59:56 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, stable@vger.kernel.org,
        Trevor Woerner <twoerner@gmail.com>
Subject: [PATCH] mtd: rawnand: lpc32xx_slc: Fix Hamming initialization
Date:   Mon, 12 Apr 2021 17:59:56 +0200
Message-Id: <20210412155956.314283-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the Hamming software ECC engine has been updated to become a
proper and independent ECC engine, it is now mandatory to initialize the
engine before using any one of his functions. Failing to do this will
generally produce a NULL pointer dereference on the non-allocated
buffers at runtime.

Fixes: 19b2ce184b9f ("mtd: nand: ecc-hamming: Stop using raw NAND structures")
Cc: stable@vger.kernel.org
Reported-by: Trevor Woerner <twoerner@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/lpc32xx_slc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mtd/nand/raw/lpc32xx_slc.c b/drivers/mtd/nand/raw/lpc32xx_slc.c
index 6b7269cfb7d8..df3b4415438f 100644
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -773,6 +773,7 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
 	struct lpc32xx_nand_host *host = nand_get_controller_data(chip);
+	int ret;
 
 	if (chip->ecc.engine_type != NAND_ECC_ENGINE_TYPE_ON_HOST)
 		return 0;
@@ -805,6 +806,13 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
 	chip->ecc.correct = rawnand_sw_hamming_correct;
 	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
 
+	ret = rawnand_sw_hamming_init(chip);
+	if (ret) {
+		dev_err(mtd->dev.parent,
+			"SW Hamming ECC initialization failed (%d)\n", ret);
+		return ret;
+	}
+
 	/*
 	 * Use a custom BBT marker setup for small page FLASH that
 	 * won't interfere with the ECC layout. Large and huge page
@@ -819,8 +827,14 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
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

