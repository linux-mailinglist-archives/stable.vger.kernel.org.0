Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5823F6682
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhHXRZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241000AbhHXRXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE7F61AF8;
        Tue, 24 Aug 2021 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824620;
        bh=MSbu1neapRlMUuym5EKpLXNK+liHInZpCf98VFak1Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoBaMA8Bdna7zuoHRbGtnWy7TA2ESZuXsUEugu+fZLHcZTAsGRMGq1l/msnXUYdwb
         mPoFXkt9srZVuC+jwC1j3Z31/CdmcC0p+RSWfppjIN4KfBHEazZPBN3lLzNfKwFuUj
         kMiOR7+48tR/QlFCSVJvM4ywVuDBzV2LWo6rpOaUuu/UIho5HYNQFYGdNnYre/j1WP
         YqASXvgpBtpPAJWCm84Lkxwg1f5my+uchv+o3PoMIXcDRRhmlk9ebxr+lTJnz5nYev
         XJiMbgrHWRK5TVxznDII5heyVGh54YIzF5wm4cbAJ4kQM7e/EZ6epNauDNX+whY9jg
         sAGdphrs4J6cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/84] dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers
Date:   Tue, 24 Aug 2021 13:02:16 -0400
Message-Id: <20210824170250.710392-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index 0c5668e897fe..d891ec05bc48 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -332,6 +332,7 @@ struct xilinx_dma_tx_descriptor {
  * @genlock: Support genlock mode
  * @err: Channel has errors
  * @idle: Check for channel idle
+ * @terminating: Check for channel being synchronized by user
  * @tasklet: Cleanup work after irq
  * @config: Device configuration info
  * @flush_on_fsync: Flush on Frame sync
@@ -369,6 +370,7 @@ struct xilinx_dma_chan {
 	bool genlock;
 	bool err;
 	bool idle;
+	bool terminating;
 	struct tasklet_struct tasklet;
 	struct xilinx_vdma_config config;
 	bool flush_on_fsync;
@@ -843,6 +845,13 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
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
@@ -1612,6 +1621,8 @@ static dma_cookie_t xilinx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (desc->cyclic)
 		chan->cyclic = true;
 
+	chan->terminating = false;
+
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	return cookie;
@@ -2068,6 +2079,7 @@ static int xilinx_dma_terminate_all(struct dma_chan *dchan)
 	}
 
 	/* Remove and free all of the descriptors in the lists */
+	chan->terminating = true;
 	xilinx_dma_free_descriptors(chan);
 	chan->idle = true;
 
-- 
2.30.2

