Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258413F659A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbhHXRO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239515AbhHXRMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAC8161A3B;
        Tue, 24 Aug 2021 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824484;
        bh=EI7Oty0XmL9W1SsnlEGJzpIBSMOcSDym1SN9PJNdnLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2lODKQW3HsfMY+sWPURcjjuOD5zSie73KpH+92FEAeCc2eaRhanUP2o0VwjKh/GW
         3j5bUqK4P5PXjC//f9IZwQExmhuMz9QF4biuGZ2vfJx+8k8OHvSuNVGJOtqz3ojeKk
         yW674/IzbAY6blVXJpjqKu+tYW1S5n7DeMs5IiF+mzzW5kvfNtcZjhJOkdFTzLd5XF
         L+q43GkvVXyy/F19oBfZkLGzBxAdjmHZSAzSWUJmLBSrlvGR4ShQqrqeA4EUw3gSzX
         KsJSaodWe0cCCZDKBeHJ2EeDk+WWjBwr3Hyz2ijuWI2O2Gjm/nfdmmRga7rINx/Gr8
         x43t6LlxMgBBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/61] dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available
Date:   Tue, 24 Aug 2021 13:00:21 -0400
Message-Id: <20210824170106.710221-17-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@gmail.com>

[ Upstream commit eda97cb095f2958bbad55684a6ca3e7d7af0176a ]

If the router_xlate can not find the controller in the available DMA
devices then it should return with -EPORBE_DEFER in a same way as the
of_dma_request_slave_channel() does.

The issue can be reproduced if the event router is registered before the
DMA controller itself and a driver would request for a channel before the
controller is registered.
In of_dma_request_slave_channel():
1. of_dma_find_controller() would find the dma_router
2. ofdma->of_dma_xlate() would fail and returned NULL
3. -ENODEV is returned as error code

with this patch we would return in this case the correct -EPROBE_DEFER and
the client can try to request the channel later.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210717190021.21897-1-peter.ujfalusi@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/of-dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 4bbf4172b9bf..e3f1d4ab8e4f 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -65,8 +65,12 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		return NULL;
 
 	ofdma_target = of_dma_find_controller(&dma_spec_target);
-	if (!ofdma_target)
-		return NULL;
+	if (!ofdma_target) {
+		ofdma->dma_router->route_free(ofdma->dma_router->dev,
+					      route_data);
+		chan = ERR_PTR(-EPROBE_DEFER);
+		goto err;
+	}
 
 	chan = ofdma_target->of_dma_xlate(&dma_spec_target, ofdma_target);
 	if (IS_ERR_OR_NULL(chan)) {
@@ -77,6 +81,7 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		chan->route_data = route_data;
 	}
 
+err:
 	/*
 	 * Need to put the node back since the ofdma->of_dma_route_allocate
 	 * has taken it for generating the new, translated dma_spec
-- 
2.30.2

