Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD5B853E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404703AbfISWTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390275AbfISWTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2E521924;
        Thu, 19 Sep 2019 22:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931542;
        bh=nMVcyCBO+pu2YgbD35jIQJZ5asTgAX/Y8u6irtWayIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHvw5w0s9V34//do5Lkj7HG6WrufFkeQkZOajDHsBO/c48+rypQH+n5VEBQB4aWlT
         XdwNoH4lDO/Z1akxGu/9qB/H4tLx+7eZe7qzbSQMHAExWc3jnFMsgqRmNncHjjN8KE
         NQXY6x8HUnch7HDdbTkfL488dgXdyNiHxDNJOGj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Li <xiaolei.li@mediatek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.9 24/74] mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue
Date:   Fri, 20 Sep 2019 00:03:37 +0200
Message-Id: <20190919214807.117496666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolei Li <xiaolei.li@mediatek.com>

commit 336d4b138be2dad372b67a2388e42805c48aaa38 upstream.

One main goal of the function mtk_nfc_update_ecc_stats is to check
whether sectors are all empty. If they are empty, set these sectors's
data buffer and OOB buffer as 0xff.

But now, the sector OOB buffer pointer is wrongly assigned. We always
do memset from sector 0.

To fix this issue, pass start sector number to make OOB buffer pointer
be properly assigned.

Fixes: 1d6b1e464950 ("mtd: mediatek: driver for MTK Smart Device")
Signed-off-by: Xiaolei Li <xiaolei.li@mediatek.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/mtk_nand.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/mtd/nand/mtk_nand.c
+++ b/drivers/mtd/nand/mtk_nand.c
@@ -810,19 +810,21 @@ static int mtk_nfc_write_oob_std(struct
 	return ret & NAND_STATUS_FAIL ? -EIO : 0;
 }
 
-static int mtk_nfc_update_ecc_stats(struct mtd_info *mtd, u8 *buf, u32 sectors)
+static int mtk_nfc_update_ecc_stats(struct mtd_info *mtd, u8 *buf, u32 start,
+				    u32 sectors)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
 	struct mtk_nfc *nfc = nand_get_controller_data(chip);
 	struct mtk_nfc_nand_chip *mtk_nand = to_mtk_nand(chip);
 	struct mtk_ecc_stats stats;
+	u32 reg_size = mtk_nand->fdm.reg_size;
 	int rc, i;
 
 	rc = nfi_readl(nfc, NFI_STA) & STA_EMP_PAGE;
 	if (rc) {
 		memset(buf, 0xff, sectors * chip->ecc.size);
 		for (i = 0; i < sectors; i++)
-			memset(oob_ptr(chip, i), 0xff, mtk_nand->fdm.reg_size);
+			memset(oob_ptr(chip, start + i), 0xff, reg_size);
 		return 0;
 	}
 
@@ -842,7 +844,7 @@ static int mtk_nfc_read_subpage(struct m
 	u32 spare = mtk_nand->spare_per_sector;
 	u32 column, sectors, start, end, reg;
 	dma_addr_t addr;
-	int bitflips;
+	int bitflips = 0;
 	size_t len;
 	u8 *buf;
 	int rc;
@@ -910,14 +912,11 @@ static int mtk_nfc_read_subpage(struct m
 	if (rc < 0) {
 		dev_err(nfc->dev, "subpage done timeout\n");
 		bitflips = -EIO;
-	} else {
-		bitflips = 0;
-		if (!raw) {
-			rc = mtk_ecc_wait_done(nfc->ecc, ECC_DECODE);
-			bitflips = rc < 0 ? -ETIMEDOUT :
-				mtk_nfc_update_ecc_stats(mtd, buf, sectors);
-			mtk_nfc_read_fdm(chip, start, sectors);
-		}
+	} else if (!raw) {
+		rc = mtk_ecc_wait_done(nfc->ecc, ECC_DECODE);
+		bitflips = rc < 0 ? -ETIMEDOUT :
+			mtk_nfc_update_ecc_stats(mtd, buf, start, sectors);
+		mtk_nfc_read_fdm(chip, start, sectors);
 	}
 
 	dma_unmap_single(nfc->dev, addr, len, DMA_FROM_DEVICE);


