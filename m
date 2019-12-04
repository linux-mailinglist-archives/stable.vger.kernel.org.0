Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C262E113369
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbfLDSLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbfLDSLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:11:17 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E7D02084B;
        Wed,  4 Dec 2019 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483076;
        bh=GWmYEcDH9yfOpfU6HPPn3Hvudyuynf9AmwUTzHcL46A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ry9RaZ667NjPlBm3bkGc+TZc/8UnqjLCZBz+DsGLVsxNeBUssu7tQvjs5NVTN0TYl
         zxHO9HM5Lof3SatiQmbvDCEGk/7NHEPJhaPUK4oZBrLfptL5xunRppRp15sTWmTweB
         xO1Uws1up2a2lv4d93I7FZwav/MCsFw1Q5o7EWro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/125] mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET
Date:   Wed,  4 Dec 2019 18:55:40 +0100
Message-Id: <20191204175321.118373915@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



