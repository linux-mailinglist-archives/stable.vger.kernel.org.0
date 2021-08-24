Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B373F65BC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHXRQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238907AbhHXRMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB31861526;
        Tue, 24 Aug 2021 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824481;
        bh=xwKgTdI88xRJjsX1OvgG/DY+JVmRisQqYP7I1OyEjiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFfcVRiamssZypbgghnTWkRgL6cgXRATCiI7TzQWSlrEmBpLH1Xx4m/S4zqgENxV1
         O6vHvbXMPtdlN7cpn1ApxzKH06080cys0sxrWVt0EnRGRm2KSI+fO/25AjBOLesvKL
         OJb5HaWgwDtINKJFjnwK46g/6edkbE9KWjp2n0RHjQMlU2lwDJsX+bSMUKJU7KOelJ
         hwqbE7iMIX9vpctC9TMjJEqS8iQTjLzKkMNzuus/TtL+ATY1AkmZkfSVZXGfNEM7ix
         yr8DVYsNttOcbc+ZbC5lMqx00RD4GZQxx01dLvsRYufrL0OgfI8240fMxz+jNF6Jkg
         W4OtEkpzX2KFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/61] dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers
Date:   Tue, 24 Aug 2021 13:00:18 -0400
Message-Id: <20210824170106.710221-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 1b5f3e9f43d7..ce18bca45ff2 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -333,6 +333,7 @@ struct xilinx_dma_tx_descriptor {
  * @genlock: Support genlock mode
  * @err: Channel has errors
  * @idle: Check for channel idle
+ * @terminating: Check for channel being synchronized by user
  * @tasklet: Cleanup work after irq
  * @config: Device configuration info
  * @flush_on_fsync: Flush on Frame sync
@@ -370,6 +371,7 @@ struct xilinx_dma_chan {
 	bool genlock;
 	bool err;
 	bool idle;
+	bool terminating;
 	struct tasklet_struct tasklet;
 	struct xilinx_vdma_config config;
 	bool flush_on_fsync;
@@ -844,6 +846,13 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
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
@@ -1618,6 +1627,8 @@ static dma_cookie_t xilinx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (desc->cyclic)
 		chan->cyclic = true;
 
+	chan->terminating = false;
+
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	return cookie;
@@ -2074,6 +2085,7 @@ static int xilinx_dma_terminate_all(struct dma_chan *dchan)
 	}
 
 	/* Remove and free all of the descriptors in the lists */
+	chan->terminating = true;
 	xilinx_dma_free_descriptors(chan);
 	chan->idle = true;
 
-- 
2.30.2

