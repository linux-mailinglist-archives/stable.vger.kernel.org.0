Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4734302C0
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbhJPNZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Oct 2021 09:25:09 -0400
Received: from aposti.net ([89.234.176.197]:55944 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240497AbhJPNZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Oct 2021 09:25:09 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/5] mtd: rawnand/davinci: Rewrite function description
Date:   Sat, 16 Oct 2021 14:22:26 +0100
Message-Id: <20211016132228.40254-3-paul@crapouillou.net>
In-Reply-To: <20211016132228.40254-1-paul@crapouillou.net>
References: <20211016132228.40254-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original comment that describes the function
nand_davinci_read_page_hwecc_oob_first() is very obscure and it is hard
to understand what it is for.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mtd/nand/raw/davinci_nand.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 2e6a0c1671be..fe2511cdcae3 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -372,17 +372,15 @@ static int nand_davinci_correct_4bit(struct nand_chip *chip, u_char *data,
 }
 
 /**
- * nand_read_page_hwecc_oob_first - hw ecc, read oob first
+ * nand_davinci_read_page_hwecc_oob_first - Hardware ECC page read with ECC
+ *                                          data read from OOB area
  * @chip: nand chip info structure
  * @buf: buffer to store read data
  * @oob_required: caller requires OOB data read to chip->oob_poi
  * @page: page number to read
  *
- * Hardware ECC for large page chips, require OOB to be read first. For this
- * ECC mode, the write_page method is re-used from ECC_HW. These methods
- * read/write ECC from the OOB area, unlike the ECC_HW_SYNDROME support with
- * multiple ECC steps, follows the "infix ECC" scheme and reads/writes ECC from
- * the data area, by overwriting the NAND manufacturer bad block markings.
+ * Hardware ECC for large page chips, which requires the ECC data to be
+ * extracted from the OOB before the actual data is read.
  */
 static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 						  uint8_t *buf,
-- 
2.33.0

