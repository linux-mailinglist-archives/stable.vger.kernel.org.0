Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64DB3B5FF2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhF1OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhF1OVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8205E61C7C;
        Mon, 28 Jun 2021 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889932;
        bh=F4hGZkVT/6CK2NX0icn6WQZQkGaXW0pQOF9EWD6fCIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jY6E7OarzNGNNr225UJHltHj//WwbssOSxv9dSVh6LpQEBJUTJ5NlpsbvSV8BWYX6
         8MEFhni/kGH0cRbH3PU0Y5TuDA9ZQmW6CJrukAk0VCWoAewCdqe+/7xEGLuWYD63by
         MuGpD36Aa++yOjhq67udYVG8+j+FvQ5byhEu/UJnUfWC0g4ZOQfUjfs8JKB5bM8DDK
         Nlcp6asPN2/mUv1t7Cv9CwopU24XMhqNwNQf5t92aJOWCz3cgFpxrrVbg1BZmBIfsL
         AoTkNKanCpTNatTIQkK/PNAqxwF1fJdjlcsyMCPOt6Kyrz3fqKxSkcZGash0tjxWr6
         gy7n5vKj4D0LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 025/110] dmaengine: xilinx: dpdma: Limit descriptor IDs to 16 bits
Date:   Mon, 28 Jun 2021 10:17:03 -0400
Message-Id: <20210628141828.31757-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 9f007e7b6643799e2a6538a5fe04f51c371c6657 ]

While the descriptor ID is stored in a 32-bit field in the hardware
descriptor, only 16 bits are used by the hardware and are reported
through the XILINX_DPDMA_CH_DESC_ID register. Failure to handle the
wrap-around results in a descriptor ID mismatch after 65536 frames. Fix
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Reviewed-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Link: https://lore.kernel.org/r/20210520152420.23986-5-laurent.pinchart@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index ff7dfb3fdeb4..6c709803203a 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -113,6 +113,7 @@
 #define XILINX_DPDMA_CH_VDO				0x020
 #define XILINX_DPDMA_CH_PYLD_SZ				0x024
 #define XILINX_DPDMA_CH_DESC_ID				0x028
+#define XILINX_DPDMA_CH_DESC_ID_MASK			GENMASK(15, 0)
 
 /* DPDMA descriptor fields */
 #define XILINX_DPDMA_DESC_CONTROL_PREEMBLE		0xa5
@@ -866,7 +867,8 @@ static void xilinx_dpdma_chan_queue_transfer(struct xilinx_dpdma_chan *chan)
 	 * will be used, but it should be enough.
 	 */
 	list_for_each_entry(sw_desc, &desc->descriptors, node)
-		sw_desc->hw.desc_id = desc->vdesc.tx.cookie;
+		sw_desc->hw.desc_id = desc->vdesc.tx.cookie
+				    & XILINX_DPDMA_CH_DESC_ID_MASK;
 
 	sw_desc = list_first_entry(&desc->descriptors,
 				   struct xilinx_dpdma_sw_desc, node);
@@ -1086,7 +1088,8 @@ static void xilinx_dpdma_chan_vsync_irq(struct  xilinx_dpdma_chan *chan)
 	if (!chan->running || !pending)
 		goto out;
 
-	desc_id = dpdma_read(chan->reg, XILINX_DPDMA_CH_DESC_ID);
+	desc_id = dpdma_read(chan->reg, XILINX_DPDMA_CH_DESC_ID)
+		& XILINX_DPDMA_CH_DESC_ID_MASK;
 
 	/* If the retrigger raced with vsync, retry at the next frame. */
 	sw_desc = list_first_entry(&pending->descriptors,
-- 
2.30.2

