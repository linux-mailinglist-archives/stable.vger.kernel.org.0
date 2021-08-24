Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524FB3F64B4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhHXRGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239287AbhHXRE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 393A1615E2;
        Tue, 24 Aug 2021 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824366;
        bh=m6MWtSt77nDnHiKnoKPOb31isqXnEqjQVfdpnzdnvIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnxSFij6IHCe5hhb0M9DmDCFU9Vgh6J+1sA3DBhUjzhiIQY+2HFrr0U1UDYhRuW18
         Mm8bKH4YkTom3dusu/pFq2NfLyc49w28IFtECcqOddeKCblJW/+C/ymXqCQ2otiZi0
         ftn+8JnJM+SgSp9Rho3ycgrMfrCwAdFMIFk/nDqMCxur+b+e7lP4yF4UTW2nUtQ9jF
         7i/iosX4PJPFFXuykKLtdvtXy4TBIQBOzM6FmFUkMLprGbJFN1Y3eEocgsBMNjvM8U
         P7Kw4bhYH9TWDGTlNJR6i2ui3mzQFaW/rdW48nhTmUD0hHV4hw71sxVrC7G1MPUVVu
         +HDcUwE8csZUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/98] dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers
Date:   Tue, 24 Aug 2021 12:57:46 -0400
Message-Id: <20210824165908.709932-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 79777550a6ff..9ffdbeec436b 100644
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

