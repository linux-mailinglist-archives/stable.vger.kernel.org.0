Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65988106304
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKVGHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbfKVGBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464ED2068E;
        Fri, 22 Nov 2019 06:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402513;
        bh=GWmYEcDH9yfOpfU6HPPn3Hvudyuynf9AmwUTzHcL46A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRtt1FIuIzVGCYxy4mI1TJjl1BbDQufwjL/k67nAM51NdCw2Lf2j9Cac1r1kOA1+i
         IARErhusICOwl5lenXSqJBZ9w+y1dfyfmFyKmh60USk5dtbnvGUv/zff5LGVfBRqsi
         uWaNg9lyuhQpKbaS+wly6JrpdbxZoFQuH2Mr5d0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 22/91] mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET
Date:   Fri, 22 Nov 2019 01:00:20 -0500
Message-Id: <20191122060129.4239-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@bootlin.com>

[ Upstream commit 732774437ae01d9882e60314e303898e63c7f038 ]

The opcodes used by the controller when doing batched page prog should
be written in NFC_REG_WCMD_SET not FC_REG_RCMD_SET. Luckily, the
default NFC_REG_WCMD_SET value matches the one we set in the driver
which explains why we didn't notice the problem.

Fixes: 614049a8d904 ("mtd: nand: sunxi: add support for DMA assisted operations")
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index e26c4f880df66..886355bfa7617 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -1420,7 +1420,7 @@ static int sunxi_nfc_hw_ecc_write_page_dma(struct mtd_info *mtd,
 	sunxi_nfc_randomizer_enable(mtd);
 
 	writel((NAND_CMD_RNDIN << 8) | NAND_CMD_PAGEPROG,
-	       nfc->regs + NFC_REG_RCMD_SET);
+	       nfc->regs + NFC_REG_WCMD_SET);
 
 	dma_async_issue_pending(nfc->dmac);
 
-- 
2.20.1

