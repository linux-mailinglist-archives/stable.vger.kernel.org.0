Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173D2261906
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIHSGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbgIHQMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F5B2479F;
        Tue,  8 Sep 2020 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580277;
        bh=Fwyb9jTCNk2q2vL/vLeKnXHtiCbmQM+AyT6SO048ZTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKUjFZS0aSBm1VbUoeyUg+pXmDr0AcDHzM9fApRIPlZGg/0XQUBt48xJXmPGlEAHy
         DOHnkz7o8oRcA7kKKwyHa3LTlui6fXM2KcQToQGrupOH7OHMIh6CzzIpYjzvnuwnJh
         D/G+69/aRtSlIZTYCFZ48ZQkUeWUNuTEZvk/MmL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/65] dmaengine: of-dma: Fix of_dma_router_xlates of_dma_xlate handling
Date:   Tue,  8 Sep 2020 17:25:56 +0200
Message-Id: <20200908152217.605510752@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 5b2aa9f918f6837ae943557f8cec02c34fcf80e7 ]

of_dma_xlate callback can return ERR_PTR as well NULL in case of failure.

If error code is returned (not NULL) then the route should be released and
the router should not be registered for the channel.

Fixes: 56f13c0d9524c ("dmaengine: of_dma: Support for DMA routers")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200806104928.25975-1-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/of-dma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 91fd395c90c4c..8344a60c2131b 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -72,12 +72,12 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		return NULL;
 
 	chan = ofdma_target->of_dma_xlate(&dma_spec_target, ofdma_target);
-	if (chan) {
-		chan->router = ofdma->dma_router;
-		chan->route_data = route_data;
-	} else {
+	if (IS_ERR_OR_NULL(chan)) {
 		ofdma->dma_router->route_free(ofdma->dma_router->dev,
 					      route_data);
+	} else {
+		chan->router = ofdma->dma_router;
+		chan->route_data = route_data;
 	}
 
 	/*
-- 
2.25.1



