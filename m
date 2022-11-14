Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D589E627BB3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiKNLJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiKNLHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:07:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1821E06
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DEBF60FC6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E10C433D6;
        Mon, 14 Nov 2022 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668424052;
        bh=LoiRiNuNHqwLLHhselaobKbvYeyqA1JoEEGo/lk5dvQ=;
        h=Subject:To:Cc:From:Date:From;
        b=KPLr80tHQMocihpQSFVVu4FcuaQXn610+VcB9LJ+cvP8+4dI+A6ikwNT2qLL7rV5A
         QF5g816JelK/Oj2O3FgJmJ2e8iK+arJwzTBc20/ni64Qk13cSuRoRKavLDg+Rjm3QL
         XtSn7LCNMBldY3yEpqimOCBj1NmlEVNM9dhHIAAo=
Subject: FAILED: patch "[PATCH] dmaengine: at_hdmac: Fix premature completion of desc in" failed to apply to 4.19-stable tree
To:     tudor.ambarus@microchip.com, nicolas.ferre@microchip.com,
        peda@axentia.se, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:07:26 +0100
Message-ID: <166842404622095@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fcd37565efda ("dmaengine: at_hdmac: Fix premature completion of desc in issue_pending")
8a47221fc284 ("dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending")
078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fcd37565efdaffeac179d0f0ce980ac79bfdf569 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Tue, 25 Oct 2022 12:02:38 +0300
Subject: [PATCH] dmaengine: at_hdmac: Fix premature completion of desc in
 issue_pending

Multiple calls to atc_issue_pending() could result in a premature
completion of a descriptor from the atchan->active list, as the method
always completed the first active descriptor from the list. Instead,
issue_pending() should just take the first transaction descriptor from the
pending queue, move it to active_list and start the transfer.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-5-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e9d0c3632868..cb5522417db6 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1527,16 +1527,26 @@ atc_tx_status(struct dma_chan *chan,
 }
 
 /**
- * atc_issue_pending - try to finish work
+ * atc_issue_pending - takes the first transaction descriptor in the pending
+ * queue and starts the transfer.
  * @chan: target DMA channel
  */
 static void atc_issue_pending(struct dma_chan *chan)
 {
-	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_chan *atchan = to_at_dma_chan(chan);
+	struct at_desc *desc;
+	unsigned long flags;
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	atc_advance_work(atchan);
+	spin_lock_irqsave(&atchan->lock, flags);
+	if (atc_chan_is_enabled(atchan) || list_empty(&atchan->queue))
+		return spin_unlock_irqrestore(&atchan->lock, flags);
+
+	desc = atc_first_queued(atchan);
+	list_move_tail(&desc->desc_node, &atchan->active_list);
+	atc_dostart(atchan, desc);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**

