Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC27F7D0A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbfKKSw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730274AbfKKSwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490A0204EC;
        Mon, 11 Nov 2019 18:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498343;
        bh=dguNy2Uy53wWhZ5XJNoj++7yvyxtrq34d78ej4hQFm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlRWc6Rfrn37VHAmJriUoDWnze0/JpXPGIugJTOairpq9Xq3HWVFi6mdZgMxjqHBM
         6oHirgjhV+s1lhani/QcUCkEKBFM8GHFObH8mrmjXqBcnY/0W5uwhefSNQ8Rbh25aG
         VlIX655NjpVkOF8XMt6/ZsTxkvK5hu1p9flsZ/KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenfang Wang <zhenfang.wang@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 092/193] dmaengine: sprd: Fix the link-list pointer register configuration issue
Date:   Mon, 11 Nov 2019 19:27:54 +0100
Message-Id: <20191111181507.930056795@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenfang Wang <zhenfang.wang@unisoc.com>

[ Upstream commit 8b6bc5fd71e677864d1a3b896b3069a6e0c5e214 ]

We will set the link-list pointer register point to next link-list
configuration's physical address, which can load DMA configuration
from the link-list node automatically.

But the link-list node's physical address can be larger than 32bits,
and now Spreadtrum DMA driver only supports 32bits physical address,
which may cause loading a incorrect DMA configuration when starting
the link-list transfer mode. According to the DMA datasheet, we can
use SRC_BLK_STEP register (bit28 - bit31) to save the high bits of the
link-list node's physical address to fix this issue.

Fixes: 4ac695464763 ("dmaengine: sprd: Support DMA link-list mode")
Signed-off-by: Zhenfang Wang <zhenfang.wang@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Link: https://lore.kernel.org/r/eadfe9295499efa003e1c344e67e2890f9d1d780.1568267061.git.baolin.wang@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 525dc7338fe3b..a4a91f233121a 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -134,6 +134,10 @@
 #define SPRD_DMA_SRC_TRSF_STEP_OFFSET	0
 #define SPRD_DMA_TRSF_STEP_MASK		GENMASK(15, 0)
 
+/* SPRD DMA_SRC_BLK_STEP register definition */
+#define SPRD_DMA_LLIST_HIGH_MASK	GENMASK(31, 28)
+#define SPRD_DMA_LLIST_HIGH_SHIFT	28
+
 /* define DMA channel mode & trigger mode mask */
 #define SPRD_DMA_CHN_MODE_MASK		GENMASK(7, 0)
 #define SPRD_DMA_TRG_MODE_MASK		GENMASK(7, 0)
@@ -717,6 +721,7 @@ static int sprd_dma_fill_desc(struct dma_chan *chan,
 	u32 int_mode = flags & SPRD_DMA_INT_MASK;
 	int src_datawidth, dst_datawidth, src_step, dst_step;
 	u32 temp, fix_mode = 0, fix_en = 0;
+	phys_addr_t llist_ptr;
 
 	if (dir == DMA_MEM_TO_DEV) {
 		src_step = sprd_dma_get_step(slave_cfg->src_addr_width);
@@ -814,13 +819,16 @@ static int sprd_dma_fill_desc(struct dma_chan *chan,
 		 * Set the link-list pointer point to next link-list
 		 * configuration's physical address.
 		 */
-		hw->llist_ptr = schan->linklist.phy_addr + temp;
+		llist_ptr = schan->linklist.phy_addr + temp;
+		hw->llist_ptr = lower_32_bits(llist_ptr);
+		hw->src_blk_step = (upper_32_bits(llist_ptr) << SPRD_DMA_LLIST_HIGH_SHIFT) &
+			SPRD_DMA_LLIST_HIGH_MASK;
 	} else {
 		hw->llist_ptr = 0;
+		hw->src_blk_step = 0;
 	}
 
 	hw->frg_step = 0;
-	hw->src_blk_step = 0;
 	hw->des_blk_step = 0;
 	return 0;
 }
-- 
2.20.1



