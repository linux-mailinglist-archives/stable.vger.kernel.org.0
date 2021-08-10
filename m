Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637D73E5D37
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbhHJOSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242680AbhHJOQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1939C6108F;
        Tue, 10 Aug 2021 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604971;
        bh=EI7Oty0XmL9W1SsnlEGJzpIBSMOcSDym1SN9PJNdnLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4UNqGxgJtH110cTMi6KUIPOH6H0aAvukCGL1lPMNvZuRh1tg/Ew1IEYvkVqPq3xh
         nlPwmLvbz6vSxUdMR0vqnBroa5kMMAPUqtc5KKH2XGLp7So6F7oMnpnnuIzLupdfSZ
         XMfM9NNRglKj5ETaaja+9LJ+THjiCgZCW2h1kv6Nl70tXJZ9YcRzxcdPo5WnTBRUJP
         bS/sGn+kOOhu1tZ2NVyBqF31dzJsPdBGVQIo65u7As+UER8EboyMvfDi0l/oX4Oh4O
         cieJjUo3CD0QiIlmOL0Rf/LSXGAr+LCDcmXoK5VJd1zvEnjZwHOwe9AZ4mzdQN+nvg
         pHTeu3SueiLoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/13] dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available
Date:   Tue, 10 Aug 2021 10:15:56 -0400
Message-Id: <20210810141606.3117932-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141606.3117932-1-sashal@kernel.org>
References: <20210810141606.3117932-1-sashal@kernel.org>
MIME-Version: 1.0
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

