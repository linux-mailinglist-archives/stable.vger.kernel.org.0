Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2649810E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbiAXNa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:30:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52426 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239973AbiAXNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:30:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF7F61284
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A86BC340E1;
        Mon, 24 Jan 2022 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643031055;
        bh=C0uNKiKBBiRWREXfCi60HK0vOWlpwidSstvOKgKVf2o=;
        h=Subject:To:Cc:From:Date:From;
        b=kuMBHrEHYbdArFS/XLideLJl5GY6/xvgLKQcRALhZZOeN/6/4n7M0DaO/IrZYuft7
         RhV8TAmUxazxw8QPq7m2d+LyfXtpUvZs7VI52jwbnvMX+ngrL95VbIsLhjUtT83JF2
         8AXAPzSsvmJB6dXirWUoYVXrviX7Wrd4XedIsGKQ=
Subject: FAILED: patch "[PATCH] dmaengine: at_xdmac: Fix race for the tx desc callback" failed to apply to 5.4-stable tree
To:     tudor.ambarus@microchip.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:30:45 +0100
Message-ID: <164303104523438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b63e5cb94ad6947ab5fe38b5a9417dcfd0bc6122 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Wed, 15 Dec 2021 13:01:08 +0200
Subject: [PATCH] dmaengine: at_xdmac: Fix race for the tx desc callback

The transfer descriptors were wrongly moved to the free descriptors list
before calling the tx desc callback. As the DMA engine drivers drop any
locks before calling the callback function, txd could be taken again,
resulting in its callback called prematurely. Fix the race for the tx desc
callback by moving the xfer desc into the free desc list after the
callback is invoked.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-6-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 83c031207530..d5b37459f906 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1582,20 +1582,6 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	return ret;
 }
 
-/* Call must be protected by lock. */
-static void at_xdmac_remove_xfer(struct at_xdmac_chan *atchan,
-				    struct at_xdmac_desc *desc)
-{
-	dev_dbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, desc);
-
-	/*
-	 * Remove the transfer from the transfer list then move the transfer
-	 * descriptors into the free descriptors list.
-	 */
-	list_del(&desc->xfer_node);
-	list_splice_init(&desc->descs_list, &atchan->free_descs_list);
-}
-
 static void at_xdmac_advance_work(struct at_xdmac_chan *atchan)
 {
 	struct at_xdmac_desc	*desc;
@@ -1704,7 +1690,8 @@ static void at_xdmac_tasklet(struct tasklet_struct *t)
 
 		txd = &desc->tx_dma_desc;
 		dma_cookie_complete(txd);
-		at_xdmac_remove_xfer(atchan, desc);
+		/* Remove the transfer from the transfer list. */
+		list_del(&desc->xfer_node);
 		spin_unlock_irq(&atchan->lock);
 
 		if (txd->flags & DMA_PREP_INTERRUPT)
@@ -1713,6 +1700,8 @@ static void at_xdmac_tasklet(struct tasklet_struct *t)
 		dma_run_dependencies(txd);
 
 		spin_lock_irq(&atchan->lock);
+		/* Move the xfer descriptors into the free descriptors list. */
+		list_splice_init(&desc->descs_list, &atchan->free_descs_list);
 		at_xdmac_advance_work(atchan);
 		spin_unlock_irq(&atchan->lock);
 	}
@@ -1859,8 +1848,10 @@ static int at_xdmac_device_terminate_all(struct dma_chan *chan)
 		cpu_relax();
 
 	/* Cancel all pending transfers. */
-	list_for_each_entry_safe(desc, _desc, &atchan->xfers_list, xfer_node)
-		at_xdmac_remove_xfer(atchan, desc);
+	list_for_each_entry_safe(desc, _desc, &atchan->xfers_list, xfer_node) {
+		list_del(&desc->xfer_node);
+		list_splice_init(&desc->descs_list, &atchan->free_descs_list);
+	}
 
 	clear_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
 	clear_bit(AT_XDMAC_CHAN_IS_CYCLIC, &atchan->status);

