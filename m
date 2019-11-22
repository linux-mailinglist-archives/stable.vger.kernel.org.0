Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8921065EA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfKVFu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfKVFu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4A120717;
        Fri, 22 Nov 2019 05:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401826;
        bh=ZhYdnqrQS3F5kpXHrKSeIvpgv9N6bcqn9/aggzXh2+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6ElRlx0LRre2ou7+frSRVjLZ6l1L3ByvzJpPAJbORXLnfovfGcNiwsT4gfIETp2m
         ygkXSCIJv0gVHs+18iTMQfdObbVBSdRkuUCnu+RjxdnFgjs6nzh40GbmPm/mbKDeVp
         uO9+z0iSB37m/RJ/ZK5y57D/URwSJxZhqZBNi+sU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Brezillon <boris.brezillon@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 069/219] mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET
Date:   Fri, 22 Nov 2019 00:46:41 -0500
Message-Id: <20191122054911.1750-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 1f0b7ee38df56..5b5f4d25a3e12 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1397,7 +1397,7 @@ static int sunxi_nfc_hw_ecc_write_page_dma(struct mtd_info *mtd,
 	sunxi_nfc_randomizer_enable(mtd);
 
 	writel((NAND_CMD_RNDIN << 8) | NAND_CMD_PAGEPROG,
-	       nfc->regs + NFC_REG_RCMD_SET);
+	       nfc->regs + NFC_REG_WCMD_SET);
 
 	dma_async_issue_pending(nfc->dmac);
 
-- 
2.20.1

