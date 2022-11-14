Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B8B627BD7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiKNLOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiKNLOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:14:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2520BEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B0EB80DE1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C321EC433D6;
        Mon, 14 Nov 2022 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424200;
        bh=794Snemdwub42LB5l8H/s1QpOXb4CtVW19zYPxvGE9g=;
        h=Subject:To:Cc:From:Date:From;
        b=cgdeX0YAqrjmHkNvb6j96f4ctJwuvO0PxqzRnB5VfhGy+K4YKFELF8oHy30j+7nyF
         vocVSyh7BfdNnChdKXzq3SpKT26fHbvkpkaZIxMeZkw5C3MchCAMwXmiDNdxBjWXll
         6IvoOqKqh74ZH3qbBJQFTGNk5JyEDAa09ABHy8d0=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix concurrency over the active list" failed to apply to 4.14-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:09:49 +0100
Message-ID: <1668424189217177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

03ed9ba357cc ("dmaengine: at_hdmac: Fix concurrency over the active list")
6ba826cbb57d ("dmaengine: at_hdmac: Free the memset buf without holding the chan lock")
06988949df8c ("dmaengine: at_hdmac: Fix concurrency over descriptor")
c6babed879fb ("dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03ed9ba357cc78116164b90b87f45eacab60b561 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:44 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix concurrency over the active list

The tasklet (atc_advance_work()) did not held the channel lock when
retrieving the first active descriptor, causing concurrency problems if
issue_pending() was called in between. If issue_pending() was called
exactly after the lock was released in the tasklet (atc_advance_work()),
atc_chain_complete() could complete a descriptor for which the controller
has not yet raised an interrupt.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-11-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 0fb44f622d35..b53a9fc15dd9 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -462,8 +462,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	if (!atc_chan_is_cyclic(atchan))
 		dma_cookie_complete(txd);
 
-	/* Remove transfer node from the active list. */
-	list_del_init(&desc->desc_node);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	dma_descriptor_unmap(txd);
@@ -495,6 +493,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	struct at_desc *desc;
 	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
@@ -502,9 +501,12 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 	spin_lock_irqsave(&atchan->lock, flags);
 	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
 		return spin_unlock_irqrestore(&atchan->lock, flags);
-	spin_unlock_irqrestore(&atchan->lock, flags);
 
-	atc_chain_complete(atchan, atc_first_active(atchan));
+	desc = atc_first_active(atchan);
+	/* Remove the transfer node from the active list. */
+	list_del_init(&desc->desc_node);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+	atc_chain_complete(atchan, desc);
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);

