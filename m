Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556B84302BD
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 15:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhJPNZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Oct 2021 09:25:00 -0400
Received: from aposti.net ([89.234.176.197]:55924 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234966AbhJPNZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Oct 2021 09:25:00 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/5] mtd: rawnand/davinci: Avoid duplicated page read
Date:   Sat, 16 Oct 2021 14:22:25 +0100
Message-Id: <20211016132228.40254-2-paul@crapouillou.net>
In-Reply-To: <20211016132228.40254-1-paul@crapouillou.net>
References: <20211016132228.40254-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function nand_davinci_read_page_hwecc_oob_first() first reads the
OOB data, extracts the ECC information, programs the ECC hardware before
reading the actual data in a loop.

Right after the OOB data was read, it called nand_read_page_op() to
reset the read cursor to the beginning of the page. This caused the
first page to be read twice: in that call, and later in the loop.

Address that issue by changing the call to nand_read_page_op() to
nand_change_read_column_op(), which will only reset the read cursor.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mtd/nand/raw/davinci_nand.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 89de24d3bb7a..2e6a0c1671be 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -401,7 +401,8 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 	if (ret)
 		return ret;
 
-	ret = nand_read_page_op(chip, page, 0, NULL, 0);
+	/* Move read cursor to start of page */
+	ret = nand_change_read_column_op(chip, 0, NULL, 0, false);
 	if (ret)
 		return ret;
 
-- 
2.33.0

