Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C464641BA01
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhI1WQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 18:16:54 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58661 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243077AbhI1WQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 18:16:51 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id BD8EE1C0002;
        Tue, 28 Sep 2021 22:15:09 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Cc:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/8] mtd: rawnand: fsmc: Fix use of SM ORDER
Date:   Wed, 29 Sep 2021 00:15:00 +0200
Message-Id: <20210928221507.199198-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210928221507.199198-1-miquel.raynal@bootlin.com>
References: <20210928221507.199198-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The introduction of the generic ECC engine API lead to a number of
changes in various drivers which broke some of them. Here is a typical
example: I expected the SM_ORDER option to be handled by the Hamming ECC
engine internals. Problem: the fsmc driver does not instantiate (yet) a
real ECC engine object so we had to use a 'bare' ECC helper instead of
the shiny rawnand functions. However, when not intializing this engine
properly and using the bare helpers, we do not get the SM ORDER feature
handled automatically. It looks like this was lost in the process so
let's ensure we use the right SM ORDER now.

Fixes: ad9ffdce4539 ("mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/nand/raw/fsmc_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index a3e66155ae40..658f0cbe7ce8 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -438,8 +438,10 @@ static int fsmc_correct_ecc1(struct nand_chip *chip,
 			     unsigned char *read_ecc,
 			     unsigned char *calc_ecc)
 {
+	bool sm_order = chip->ecc.options & NAND_ECC_SOFT_HAMMING_SM_ORDER;
+
 	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
-				      chip->ecc.size, false);
+				      chip->ecc.size, sm_order);
 }
 
 /* Count the number of 0's in buff upto a max of max_bits */
-- 
2.27.0

