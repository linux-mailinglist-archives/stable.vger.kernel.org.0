Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169DB226725
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbgGTQJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387486AbgGTQJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDBB206E9;
        Mon, 20 Jul 2020 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261345;
        bh=iD4Sr9OwlsNAX3ujfe/kkTFXiAMIi4ON05yukDyDDUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSXrEGdDgJLLP0/ZAGfTkqDnE8WL+6CPsU13YTcow1Xc4mlnyz8vxRmv777xuJ8Pr
         uZrX5TvkCr12hERUUZpXA3rF0rMoJF8lOZS79116A5ZTmS899dBSaS5Q2Vt1vffgva
         xHxHD3ajQ/9FqYE8DR1uXxtjmzSekbF9QZLQefFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 083/244] dmaengine: ti: k3-udma: Fix delayed_work usage for tx drain workaround
Date:   Mon, 20 Jul 2020 17:35:54 +0200
Message-Id: <20200720152829.789699554@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit d964d5ff68dba21b53368656adec3fb5f50426bb ]

INIT_DELAYED_WORK_ONSTACK() must be used with on-stack delayed work, which
is not the case here.
Use normal delayed_work for the channels instead.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200618114004.6268-1-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index baf7ab64f1d7d..9760d67aa612a 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -1925,8 +1925,6 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 
 	udma_reset_rings(uc);
 
-	INIT_DELAYED_WORK_ONSTACK(&uc->tx_drain.work,
-				  udma_check_tx_completion);
 	return 0;
 
 err_irq_free:
@@ -3038,7 +3036,6 @@ static void udma_free_chan_resources(struct dma_chan *chan)
 	}
 
 	cancel_delayed_work_sync(&uc->tx_drain.work);
-	destroy_delayed_work_on_stack(&uc->tx_drain.work);
 
 	if (uc->irq_num_ring > 0) {
 		free_irq(uc->irq_num_ring, uc);
@@ -3727,6 +3724,7 @@ static int udma_probe(struct platform_device *pdev)
 		tasklet_init(&uc->vc.task, udma_vchan_complete,
 			     (unsigned long)&uc->vc);
 		init_completion(&uc->teardown_completed);
+		INIT_DELAYED_WORK(&uc->tx_drain.work, udma_check_tx_completion);
 	}
 
 	ret = dma_async_device_register(&ud->ddev);
-- 
2.25.1



