Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A24302BA
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 15:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbhJPNYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Oct 2021 09:24:54 -0400
Received: from aposti.net ([89.234.176.197]:55886 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235202AbhJPNYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Oct 2021 09:24:54 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/5] mtd: rawnand/davinci: Don't calculate ECC when reading page
Date:   Sat, 16 Oct 2021 14:22:24 +0100
Message-Id: <20211016132228.40254-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function nand_davinci_read_page_hwecc_oob_first() does read the ECC
data from the OOB area. Therefore it does not need to calculate the ECC
as it is already available.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mtd/nand/raw/davinci_nand.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 118da9944e3b..89de24d3bb7a 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -394,7 +394,6 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_code = chip->ecc.code_buf;
-	uint8_t *ecc_calc = chip->ecc.calc_buf;
 	unsigned int max_bitflips = 0;
 
 	/* Read the OOB area first */
@@ -420,8 +419,6 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 		if (ret)
 			return ret;
 
-		chip->ecc.calculate(chip, p, &ecc_calc[i]);
-
 		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
 		if (stat == -EBADMSG &&
 		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {
-- 
2.33.0

