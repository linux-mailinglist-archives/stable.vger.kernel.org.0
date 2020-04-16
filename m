Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F48B1AC8EC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395070AbgDPPQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441377AbgDPNuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF763217D8;
        Thu, 16 Apr 2020 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044970;
        bh=TFXnfxHugoSP3Q7WZCuT3ZsZo+7q/qP8JgVFHiV9l8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMQqW2YOeM58uqXzkbAPVP9xYwJE+5x9cu3slGF5Ld4k2UtkU9h5qB5etMnXEYhUV
         3vZCnHtaidqNkaiDAseKrTbYA8ctsYSNHU9/25pi5TUY/NNaFbQiiQrm2SpNfD6Xmd
         l4ZsmFLH2rXzuOtn95UJnw+/TRyDAvOehwrmBHyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 135/232] mtd: spinand: Stop using spinand->oobbuf for buffering bad block markers
Date:   Thu, 16 Apr 2020 15:23:49 +0200
Message-Id: <20200416131331.864786637@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 2148937501ee3d663e0010e519a553fea67ad103 upstream.

For reading and writing the bad block markers, spinand->oobbuf is
currently used as a buffer for the marker bytes. During the
underlying read and write operations to actually get/set the content
of the OOB area, the content of spinand->oobbuf is reused and changed
by accessing it through spinand->oobbuf and/or spinand->databuf.

This is a flaw in the original design of the SPI NAND core and at the
latest from 13c15e07eedf ("mtd: spinand: Handle the case where
PROGRAM LOAD does not reset the cache") on, it results in not having
the bad block marker written at all, as the spinand->oobbuf is
cleared to 0xff after setting the marker bytes to zero.

To fix it, we now just store the two bytes for the marker on the
stack and let the read/write operations copy it from/to the page
buffer later.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200218100432.32433-2-frieder.schrempf@kontron.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/spi/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -568,18 +568,18 @@ static int spinand_mtd_write(struct mtd_
 static bool spinand_isbad(struct nand_device *nand, const struct nand_pos *pos)
 {
 	struct spinand_device *spinand = nand_to_spinand(nand);
+	u8 marker[2] = { };
 	struct nand_page_io_req req = {
 		.pos = *pos,
-		.ooblen = 2,
+		.ooblen = sizeof(marker),
 		.ooboffs = 0,
-		.oobbuf.in = spinand->oobbuf,
+		.oobbuf.in = marker,
 		.mode = MTD_OPS_RAW,
 	};
 
-	memset(spinand->oobbuf, 0, 2);
 	spinand_select_target(spinand, pos->target);
 	spinand_read_page(spinand, &req, false);
-	if (spinand->oobbuf[0] != 0xff || spinand->oobbuf[1] != 0xff)
+	if (marker[0] != 0xff || marker[1] != 0xff)
 		return true;
 
 	return false;
@@ -603,11 +603,12 @@ static int spinand_mtd_block_isbad(struc
 static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 {
 	struct spinand_device *spinand = nand_to_spinand(nand);
+	u8 marker[2] = { };
 	struct nand_page_io_req req = {
 		.pos = *pos,
 		.ooboffs = 0,
-		.ooblen = 2,
-		.oobbuf.out = spinand->oobbuf,
+		.ooblen = sizeof(marker),
+		.oobbuf.out = marker,
 	};
 	int ret;
 
@@ -622,7 +623,6 @@ static int spinand_markbad(struct nand_d
 
 	spinand_erase_op(spinand, pos);
 
-	memset(spinand->oobbuf, 0, 2);
 	return spinand_write_page(spinand, &req);
 }
 


