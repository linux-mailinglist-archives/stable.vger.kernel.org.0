Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6CB5CC2
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfIRG3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730319AbfIRG0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D6D21924;
        Wed, 18 Sep 2019 06:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787990;
        bh=Wu+XqPCBnyhQtmrODD9JD8b44C8jwjxAH2GCqK3UrUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enMQSGx3EhilRc7Grc8gAg/hUfdAoz7F2WZynhJlZxhptwW6tFg/6ryNiYLaRb3gz
         b3rCQTvYaDJpLCTtYRHSA/hfmsphF1cyQZLR/evA9oPgt4l/59ZsjRGmAL2yShUGi2
         7oErTLKKFAzAl8ILWocllp0eBQgNqTVBcqiDnHL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Li <xiaolei.li@mediatek.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.2 59/85] mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue
Date:   Wed, 18 Sep 2019 08:19:17 +0200
Message-Id: <20190918061235.972681666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
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
 drivers/mtd/nand/raw/mtk_nand.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -853,19 +853,21 @@ static int mtk_nfc_write_oob_std(struct
 	return mtk_nfc_write_page_raw(chip, NULL, 1, page);
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
 
@@ -885,7 +887,7 @@ static int mtk_nfc_read_subpage(struct m
 	u32 spare = mtk_nand->spare_per_sector;
 	u32 column, sectors, start, end, reg;
 	dma_addr_t addr;
-	int bitflips;
+	int bitflips = 0;
 	size_t len;
 	u8 *buf;
 	int rc;
@@ -952,14 +954,11 @@ static int mtk_nfc_read_subpage(struct m
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


