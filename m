Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745EC2E929A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 10:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhADJbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 04:31:42 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:47581 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADJbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 04:31:42 -0500
X-Originating-IP: 90.89.98.255
Received: from localhost.localdomain (lfbn-tou-1-1535-bdcst.w90-89.abo.wanadoo.fr [90.89.98.255])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9C0981BF20E;
        Mon,  4 Jan 2021 09:30:58 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel test robot <oliver.sang@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] mtd: rawnand: nandsim: Fix the logic when selecting Hamming soft ECC engine
Date:   Mon,  4 Jan 2021 10:30:57 +0100
Message-Id: <20210104093057.31178-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have been fooled by the logic picking the right ECC engine which is
spread across two functions: *init_module() and *_attach(). I thought
this driver was not impacted by the recent changes around the ECC
engines DT parsing logic but in fact it is.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: d7157ff49a5b ("mtd: rawnand: Use the ECC framework user input parsing bits")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/nandsim.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
index f2b9250c0ea8..0750121ac371 100644
--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -2210,6 +2210,9 @@ static int ns_attach_chip(struct nand_chip *chip)
 {
 	unsigned int eccsteps, eccbytes;
 
+	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
+	chip->ecc.algo = bch ? NAND_ECC_ALGO_BCH : NAND_ECC_ALGO_HAMMING;
+
 	if (!bch)
 		return 0;
 
@@ -2233,8 +2236,6 @@ static int ns_attach_chip(struct nand_chip *chip)
 		return -EINVAL;
 	}
 
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-	chip->ecc.algo = NAND_ECC_ALGO_BCH;
 	chip->ecc.size = 512;
 	chip->ecc.strength = bch;
 	chip->ecc.bytes = eccbytes;
@@ -2273,8 +2274,6 @@ static int __init ns_init_module(void)
 	nsmtd       = nand_to_mtd(chip);
 	nand_set_controller_data(chip, (void *)ns);
 
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-	chip->ecc.algo   = NAND_ECC_ALGO_HAMMING;
 	/* The NAND_SKIP_BBTSCAN option is necessary for 'overridesize' */
 	/* and 'badblocks' parameters to work */
 	chip->options   |= NAND_SKIP_BBTSCAN;
-- 
2.20.1

