Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86F03F6813
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhHXRkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235263AbhHXRig (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D82561BFB;
        Tue, 24 Aug 2021 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824882;
        bh=xGSvjU0nc0iKr95fdCCVuHuhvuglMua4omPmd1c6baA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikkV5KjQsSN4G+Yr1S5ZEbNn/06WHdnS/uCI8qLlUQFp431AQVVBtkmh1A1xe1e01
         EWYPz1vyCQ0tcyTRhjpRc1p8kXFG0NtP/BOtIJj/FHNdJwSOL1qBaebHAyLeqVjquh
         yQohn+cSxxN5/8Yzb0MrbZuypi72deS+GeJxw8pUsWtmus7tBnFGu9zCOjRrjq5CgM
         K7beDBg2xvukyLwBxfRhI1tTMyY6+97AeZ8YS+G1wZYEMDWjUBRVmVKPXGPCcgXayu
         RfwnWRAwqMmY8WZ2JDD5hLHfUl3Glb1hLxtZx4Ot4RPJjQn0NpfvUBhfQlzQKF0knz
         2BIrlGpQdmOAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/31] dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available
Date:   Tue, 24 Aug 2021 13:07:30 -0400
Message-Id: <20210824170743.710957-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index 86c591481dfe..4a5dbf30605a 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -68,8 +68,12 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
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
@@ -80,6 +84,7 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		chan->route_data = route_data;
 	}
 
+err:
 	/*
 	 * Need to put the node back since the ofdma->of_dma_route_allocate
 	 * has taken it for generating the new, translated dma_spec
-- 
2.30.2

