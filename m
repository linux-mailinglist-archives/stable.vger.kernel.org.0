Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5B2627BC4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiKNLLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiKNLLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:11:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AB423E98
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:08:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E627B61016
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9075C433D6;
        Mon, 14 Nov 2022 11:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424119;
        bh=iHLR2Mlv+eS4ZAdSgXChoggHcPoYFfOlmMmJ3SL7Zag=;
        h=Subject:To:Cc:From:Date:From;
        b=Pg1lE/6Tx47YP7axyXYSI7WtmxXRY3JvZ1netPMrIKpMZ1lmFJl0tt5/vucw6MEnb
         X1Myat/VOlCEk7/9KPhJYi5GWBciKsKCBFeJXi+DjWVcafrmDAc7yhbGVKodwS9HJa
         ve5Sf4aX5Df7iqtd8BtPHzwxusJgi5gTTQTaDED0=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix concurrency problems by removing" failed to apply to 5.4-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:08:36 +0100
Message-ID: <1668424116123129@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c6babed879fb ("dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c6babed879fbe82796a601bf097649e07382db46 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:41 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix concurrency problems by removing
 atc_complete_all()

atc_complete_all() had concurrency bugs, thus remove it:
1/ atc_complete_all() in its entirety was buggy, as when the atchan->queue
list (the one that contains descriptors that are not yet issued to the
hardware) contained descriptors, it fired just the first from the
atchan->queue, but moved all the desc from atchan->queue to
atchan->active_list and considered them all as fired. This could result in
calling the completion of a descriptor that was not yet issued to the
hardware.
2/ when in tasklet at atc_advance_work() time, atchan->active_list was
queried without holding the lock of the chan. This can result in
atchan->active_list concurrency problems between the tasklet and
issue_pending().

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-8-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index deb4c6027436..f1e6fa6af6c2 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -485,42 +485,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	dma_run_dependencies(txd);
 }
 
-/**
- * atc_complete_all - finish work for all transactions
- * @atchan: channel to complete transactions for
- *
- * Eventually submit queued descriptors if any
- *
- * Assume channel is idle while calling this function
- * Called with atchan->lock held and bh disabled
- */
-static void atc_complete_all(struct at_dma_chan *atchan)
-{
-	struct at_desc *desc, *_desc;
-	LIST_HEAD(list);
-	unsigned long flags;
-
-	dev_vdbg(chan2dev(&atchan->chan_common), "complete all\n");
-
-	spin_lock_irqsave(&atchan->lock, flags);
-
-	/*
-	 * Submit queued descriptors ASAP, i.e. before we go through
-	 * the completed ones.
-	 */
-	if (!list_empty(&atchan->queue))
-		atc_dostart(atchan, atc_first_queued(atchan));
-	/* empty active_list now it is completed */
-	list_splice_init(&atchan->active_list, &list);
-	/* empty queue list by moving descriptors (if any) to active_list */
-	list_splice_init(&atchan->queue, &atchan->active_list);
-
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
-}
-
 /**
  * atc_advance_work - at the end of a transaction, move forward
  * @atchan: channel where the transaction ended
@@ -528,25 +492,20 @@ static void atc_complete_all(struct at_dma_chan *atchan)
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
 	unsigned long flags;
-	int ret;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
 
 	spin_lock_irqsave(&atchan->lock, flags);
-	ret = atc_chan_is_enabled(atchan);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->active_list))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
 	spin_unlock_irqrestore(&atchan->lock, flags);
-	if (ret)
-		return;
-
-	if (list_empty(&atchan->active_list) ||
-	    list_is_singular(&atchan->active_list))
-		return atc_complete_all(atchan);
 
 	atc_chain_complete(atchan, atc_first_active(atchan));
 
 	/* advance work */
 	spin_lock_irqsave(&atchan->lock, flags);
-	atc_dostart(atchan, atc_first_active(atchan));
+	if (!list_empty(&atchan->active_list))
+		atc_dostart(atchan, atc_first_active(atchan));
 	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 

