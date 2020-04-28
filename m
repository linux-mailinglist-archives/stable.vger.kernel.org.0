Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E771BBA1A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgD1JnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 05:43:10 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34259 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgD1JnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 05:43:10 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id DABABC0017;
        Tue, 28 Apr 2020 09:43:07 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 3/9] mtd: rawnand: onfi: Fix redundancy detection check
Date:   Tue, 28 Apr 2020 11:42:56 +0200
Message-Id: <20200428094302.14624-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428094302.14624-1-miquel.raynal@bootlin.com>
References: <20200428094302.14624-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During ONFI detection, the CRC derived from the parameter page and the
CRC supposed to be at the end of the parameter page are compared. If
they do not match, the second then the third copies of the page are
tried.

The current implementation compares the newly derived CRC with the CRC
contained in the first page only. So if this particular CRC area has
been corrupted, then the detection will fail for a wrong reason.

Fix this issue by checking the derived CRC against the right one.

Fixes: 39138c1f4a31 ("mtd: rawnand: use bit-wise majority to recover the ONFI param page")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/mtd/nand/raw/nand_onfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_onfi.c b/drivers/mtd/nand/raw/nand_onfi.c
index 0b879bd0a68c..8fe8d7bdd203 100644
--- a/drivers/mtd/nand/raw/nand_onfi.c
+++ b/drivers/mtd/nand/raw/nand_onfi.c
@@ -173,7 +173,7 @@ int nand_onfi_detect(struct nand_chip *chip)
 		}
 
 		if (onfi_crc16(ONFI_CRC_BASE, (u8 *)&p[i], 254) ==
-				le16_to_cpu(p->crc)) {
+		    le16_to_cpu(p[i].crc)) {
 			if (i)
 				memcpy(p, &p[i], sizeof(*p));
 			break;
-- 
2.20.1

