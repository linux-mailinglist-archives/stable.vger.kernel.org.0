Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD341BA49
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 00:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbhI1WZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 18:25:19 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:48595 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbhI1WY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 18:24:57 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 196BF10000D;
        Tue, 28 Sep 2021 22:23:15 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Cc:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org, Jan Hoffmann <jan@3e8.eu>,
        Kestrel seventyfour <kestrelseventyfour@gmail.com>
Subject: [PATCH 9/9] mtd: rawnand: xway: Keep the driver compatible with on-die ECC engines
Date:   Wed, 29 Sep 2021 00:22:58 +0200
Message-Id: <20210928222258.199726-20-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210928222258.199726-1-miquel.raynal@bootlin.com>
References: <20210928222258.199726-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following the introduction of the generic ECC engine infrastructure, it
was necessary to reorganize the code and move the ECC configuration in
the ->attach_chip() hook. Failing to do that properly lead to a first
series of fixes supposed to stabilize the situation. Unfortunately, this
only fixed the use of software ECC engines, preventing any other kind of
engine to be used, including on-die ones.

It is now time to (finally) fix the situation by ensuring that we still
provide a default (eg. software ECC) but will still support different
ECC engines such as on-die ECC engines if properly described in the
device tree.

There are no changes needed on the core side in order to do this, but we
just need to leverage the logic there which allows:
1- a subsystem default (set to Host engines in the raw NAND world)
2- a driver specific default (here set to software ECC engines)
3- any type of engine requested by the user (ie. described in the DT)

As the raw NAND subsystem has not yet been fully converted to the ECC
engine infrastructure, in order to provide a default ECC engine for this
driver we need to set chip->ecc.engine_type *before* calling
nand_scan(). During the initialization step, the core will consider this
entry as the default engine for this driver. This value may of course
be overloaded by the user if the usual DT properties are provided.

Fixes: d525914b5bd8 ("mtd: rawnand: xway: Move the ECC initialization to ->attach_chip()")
Cc: stable@vger.kernel.org
Cc: Jan Hoffmann <jan@3e8.eu>
Cc: Kestrel seventyfour <kestrelseventyfour@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/xway_nand.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/xway_nand.c b/drivers/mtd/nand/raw/xway_nand.c
index 26751976e502..236fd8c5a958 100644
--- a/drivers/mtd/nand/raw/xway_nand.c
+++ b/drivers/mtd/nand/raw/xway_nand.c
@@ -148,9 +148,8 @@ static void xway_write_buf(struct nand_chip *chip, const u_char *buf, int len)
 
 static int xway_attach_chip(struct nand_chip *chip)
 {
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-
-	if (chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT &&
+	    chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
 		chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
 
 	return 0;
@@ -219,6 +218,13 @@ static int xway_nand_probe(struct platform_device *pdev)
 		    | NAND_CON_SE_P | NAND_CON_WP_P | NAND_CON_PRE_P
 		    | cs_flag, EBU_NAND_CON);
 
+	/*
+	 * This driver assumes that the default ECC engine should be TYPE_SOFT.
+	 * Set ->engine_type before registering the NAND devices in order to
+	 * provide a driver specific default value.
+	 */
+	data->chip.ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
+
 	/* Scan to find existence of the device */
 	err = nand_scan(&data->chip, 1);
 	if (err)
-- 
2.27.0

