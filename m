Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C957627ECD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiKNMvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiKNMvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:51:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2704C24F22
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92FD3CE100E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52326C433D6;
        Mon, 14 Nov 2022 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430301;
        bh=ORRFoSwpVvlYo19bXnpoKZguKsegfIe5e82Mslmz0BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05Svxtkh+gxAVsDoCLG6pWkMpKz02hkRd4e8m5zc9fTPwAmuvD7393MD7H3Iinl4Z
         ukIMNDdfVafvJhGXokxK5KCRZLa37jDLXSmJBdQ486liBn6M/MP5NP1bievUzk58aj
         2410ofY5VFV00N2zzcxyWe9ZYpCAQpGpHvnwMnME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 85/95] dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()
Date:   Mon, 14 Nov 2022 13:46:19 +0100
Message-Id: <20221114124446.063844509@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit c6babed879fbe82796a601bf097649e07382db46 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   49 ++++---------------------------------------------
 1 file changed, 4 insertions(+), 45 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -467,67 +467,26 @@ atc_chain_complete(struct at_dma_chan *a
 }
 
 /**
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
-/**
  * atc_advance_work - at the end of a transaction, move forward
  * @atchan: channel where the transaction ended
  */
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
 


