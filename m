Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120EB498106
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiAXN3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243148AbiAXN3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A605C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAAD6B80ED1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF62C340E1;
        Mon, 24 Jan 2022 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030980;
        bh=3TrGiZ63eQUlIWpnhu3s+ouTDAoe3MAlWhHnRWhzy5Q=;
        h=Subject:To:Cc:From:Date:From;
        b=gQxwwqsI4W5qabeEiqTp1mQ0CAKhlynvteyNoDSPQS2skNsTN0jyq1+xTdco0x6AS
         6I98pYQtgOCFkIAR6JbauEcF6RRSKsJVg6PagoyHRaCrimDKWAQTqEOLwrgpdGUU1H
         j7FjcIJkEYiNJ95zXSHffPZp/i6Ukak8gVRotu30=
Subject: FAILED: patch "[PATCH] dmaengine: at_xdmac: Fix concurrency over xfers_list" failed to apply to 4.19-stable tree
To:     tudor.ambarus@microchip.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:29:29 +0100
Message-ID: <1643030969173101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 18deddea9184b62941395889ff7659529c877326 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Wed, 15 Dec 2021 13:01:10 +0200
Subject: [PATCH] dmaengine: at_xdmac: Fix concurrency over xfers_list

Since tx_submit can be called from a hard IRQ, xfers_list must be
protected with a lock to avoid concurency on the list's elements.
Since at_xdmac_handle_cyclic() is called from a tasklet, spin_lock_irq
is enough to protect from a hard IRQ.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-8-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index b6547f1b5645..eeb03065d484 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1608,14 +1608,17 @@ static void at_xdmac_handle_cyclic(struct at_xdmac_chan *atchan)
 	struct at_xdmac_desc		*desc;
 	struct dma_async_tx_descriptor	*txd;
 
-	if (!list_empty(&atchan->xfers_list)) {
-		desc = list_first_entry(&atchan->xfers_list,
-					struct at_xdmac_desc, xfer_node);
-		txd = &desc->tx_dma_desc;
-
-		if (txd->flags & DMA_PREP_INTERRUPT)
-			dmaengine_desc_get_callback_invoke(txd, NULL);
+	spin_lock_irq(&atchan->lock);
+	if (list_empty(&atchan->xfers_list)) {
+		spin_unlock_irq(&atchan->lock);
+		return;
 	}
+	desc = list_first_entry(&atchan->xfers_list, struct at_xdmac_desc,
+				xfer_node);
+	spin_unlock_irq(&atchan->lock);
+	txd = &desc->tx_dma_desc;
+	if (txd->flags & DMA_PREP_INTERRUPT)
+		dmaengine_desc_get_callback_invoke(txd, NULL);
 }
 
 static void at_xdmac_handle_error(struct at_xdmac_chan *atchan)

