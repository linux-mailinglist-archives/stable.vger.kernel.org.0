Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8983F6386
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhHXQ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhHXQ46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1511F61368;
        Tue, 24 Aug 2021 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824174;
        bh=tHeW17I9H24bnFkW/B5efT8oDfZabpe5hHSdODE6ycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IP11FTCOREryXG0OZ9OQ3z0wdy4XmFvLzmyLjStywKoiHtFnKop4nW4HTTFcdvBvP
         ox9/s87YW7WHGdjDXG7b8Tmg1gZAPSA/t+apomxbTsSXg5U86sX6IzIZRoO6s1fWmf
         mK3xguP29EsaXpQsxhV2llTc11gfi8z48xOSWZLdPnwEBJnwsK3tH+Hen1IKvW135G
         N8LGLwnro4vPBi94ue5V9JH7ENEkT5KODCsQH/0QCQfLbwg6FFgbpu/snFOMA0CzS+
         YLGTAKW4C2MA43Ou0JwzMVz4hquPXGsgvaX/DT6egHCFq8olNVC89jTE1TyLRZX4pj
         8Mtx5xVRsyzjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 005/127] dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers
Date:   Tue, 24 Aug 2021 12:54:05 -0400
Message-Id: <20210824165607.709387-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>

[ Upstream commit 7dd2dd4ff9f3abda601f22b9d01441a0869d20d7 ]

When user calls dmaengine_terminate_sync, the driver will clean up any
remaining descriptors for all the pending or active transfers that had
previously been submitted. However, this might happen whilst the tasklet is
invoking the DMA callback for the last finished transfer, so by the time it
returns and takes over the channel's spinlock, the list of completed
descriptors it was traversing is no longer valid. This leads to a
read-after-free situation.

Fix it by signalling whether a user-triggered termination has happened by
means of a boolean variable.

Signed-off-by: Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>
Link: https://lore.kernel.org/r/20210706234338.7696-3-adrian.martinezlarumbe@imgtec.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 75c0b8e904e5..4b9530a7bf65 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -394,6 +394,7 @@ struct xilinx_dma_tx_descriptor {
  * @genlock: Support genlock mode
  * @err: Channel has errors
  * @idle: Check for channel idle
+ * @terminating: Check for channel being synchronized by user
  * @tasklet: Cleanup work after irq
  * @config: Device configuration info
  * @flush_on_fsync: Flush on Frame sync
@@ -431,6 +432,7 @@ struct xilinx_dma_chan {
 	bool genlock;
 	bool err;
 	bool idle;
+	bool terminating;
 	struct tasklet_struct tasklet;
 	struct xilinx_vdma_config config;
 	bool flush_on_fsync;
@@ -1049,6 +1051,13 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
 		/* Run any dependencies, then free the descriptor */
 		dma_run_dependencies(&desc->async_tx);
 		xilinx_dma_free_tx_descriptor(chan, desc);
+
+		/*
+		 * While we ran a callback the user called a terminate function,
+		 * which takes care of cleaning up any remaining descriptors
+		 */
+		if (chan->terminating)
+			break;
 	}
 
 	spin_unlock_irqrestore(&chan->lock, flags);
@@ -1965,6 +1974,8 @@ static dma_cookie_t xilinx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (desc->cyclic)
 		chan->cyclic = true;
 
+	chan->terminating = false;
+
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	return cookie;
@@ -2436,6 +2447,7 @@ static int xilinx_dma_terminate_all(struct dma_chan *dchan)
 
 	xilinx_dma_chan_reset(chan);
 	/* Remove and free all of the descriptors in the lists */
+	chan->terminating = true;
 	xilinx_dma_free_descriptors(chan);
 	chan->idle = true;
 
-- 
2.30.2

