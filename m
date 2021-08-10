Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978BF3E5D63
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbhHJOTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242940AbhHJOR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:17:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43741610CB;
        Tue, 10 Aug 2021 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604991;
        bh=ePZz+sF9yOD/Cf5qf8TlpbkemcR8a+vrRB0qNX7C4KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1kRFCiYlTf3ImCDR81JdOg5JCocvTLKlOO8/V1fBuMR/D61MqytvlbQPL3oX6KHG
         6nbOAZjlnS5lLyn9lSyX0lo3FW84CchqlSR9LuOwzJmLXsm6KRw97PWfQ8NwU/OZvS
         VetKHdFQxpkIii0ia9W052hMksjb12dS6CgKXbcdSewJi820/Te/OhlAvpLkjooK68
         jaoHKlU/cp5ruSw/Tg8RJdcuZwihFUErDBFoaCsx9qPAswQJ25qiG4747KSLkW38oN
         JBix5r6i1n+ONuQo2RSfDnMNe8Qj4IgAiDeKk5lj0hBZBwO/z8qU5p/i61LaWLYPjg
         oE897dCbzgoiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/11] dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available
Date:   Tue, 10 Aug 2021 10:16:17 -0400
Message-Id: <20210810141625.3118097-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141625.3118097-1-sashal@kernel.org>
References: <20210810141625.3118097-1-sashal@kernel.org>
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
index 8344a60c2131..a9d3ab94749b 100644
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

