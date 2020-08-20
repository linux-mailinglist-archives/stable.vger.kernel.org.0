Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5645A24BF07
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgHTNjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgHTJ3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:29:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54AC422D06;
        Thu, 20 Aug 2020 09:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915741;
        bh=io+BRFKGROeR38sVt8rmEmwA9RE4GWl4AZRy24OAa9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVF8HTJvWZDWyIrb6kwY2XW9wzsj9HC/vPy7L/Fdhmg9/SFTsBEn0xRkwaqcpsAAz
         ifYS3zh/36/7FJpPSeo7B56uy0R5yaSwrkTdITdVdSKWNB8vbE3SJCe337+C+HEuu0
         Ts7TPYAnx9hyzzz75aOIhAS2FO9hyylqaLuHQF98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 118/232] mtd: rawnand: brcmnand: ECC error handling on EDU transfers
Date:   Thu, 20 Aug 2020 11:19:29 +0200
Message-Id: <20200820091618.529746352@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 4551e78ad98add1f16b70cf286d5aad3ce7bcd4c ]

Implement ECC correctable and uncorrectable error handling for EDU
reads. If ECC correctable bitflips are encountered on EDU transfer,
read page again using PIO. This is needed due to a NAND controller
limitation where corrected data is not transferred to the DMA buffer
on ECC error. This applies to ECC correctable errors that are reported
by the controller hardware based on set number of bitflips threshold in
the controller threshold register, bitflips below the threshold are
corrected silently and are not reported by the controller hardware.

Fixes: a5d53ad26a8b ("mtd: rawnand: brcmnand: Add support for flash-edu for dma transfers")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200612212902.21347-3-kdasu.kdev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 26 ++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index ac934a715a194..a4033d32a7103 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1918,6 +1918,22 @@ static int brcmnand_edu_trans(struct brcmnand_host *host, u64 addr, u32 *buf,
 	edu_writel(ctrl, EDU_STOP, 0); /* force stop */
 	edu_readl(ctrl, EDU_STOP);
 
+	if (!ret && edu_cmd == EDU_CMD_READ) {
+		u64 err_addr = 0;
+
+		/*
+		 * check for ECC errors here, subpage ECC errors are
+		 * retained in ECC error address register
+		 */
+		err_addr = brcmnand_get_uncorrecc_addr(ctrl);
+		if (!err_addr) {
+			err_addr = brcmnand_get_correcc_addr(ctrl);
+			if (err_addr)
+				ret = -EUCLEAN;
+		} else
+			ret = -EBADMSG;
+	}
+
 	return ret;
 }
 
@@ -2124,6 +2140,7 @@ static int brcmnand_read(struct mtd_info *mtd, struct nand_chip *chip,
 	u64 err_addr = 0;
 	int err;
 	bool retry = true;
+	bool edu_err = false;
 
 	dev_dbg(ctrl->dev, "read %llx -> %p\n", (unsigned long long)addr, buf);
 
@@ -2141,6 +2158,10 @@ static int brcmnand_read(struct mtd_info *mtd, struct nand_chip *chip,
 			else
 				return -EIO;
 		}
+
+		if (has_edu(ctrl) && err_addr)
+			edu_err = true;
+
 	} else {
 		if (oob)
 			memset(oob, 0x99, mtd->oobsize);
@@ -2188,6 +2209,11 @@ static int brcmnand_read(struct mtd_info *mtd, struct nand_chip *chip,
 	if (mtd_is_bitflip(err)) {
 		unsigned int corrected = brcmnand_count_corrected(ctrl);
 
+		/* in case of EDU correctable error we read again using PIO */
+		if (edu_err)
+			err = brcmnand_read_by_pio(mtd, chip, addr, trans, buf,
+						   oob, &err_addr);
+
 		dev_dbg(ctrl->dev, "corrected error at 0x%llx\n",
 			(unsigned long long)err_addr);
 		mtd->ecc_stats.corrected += corrected;
-- 
2.25.1



