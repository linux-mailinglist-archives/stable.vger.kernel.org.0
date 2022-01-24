Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46CD498104
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiAXN3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:29:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42982 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243167AbiAXN3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:29:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD619B80ED1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF82C340E1;
        Mon, 24 Jan 2022 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030970;
        bh=kBiEBx94kAkHyj77bnWemVuZvONcvuHCnAzI6Dz7SEY=;
        h=Subject:To:Cc:From:Date:From;
        b=KGE49RDW3zPji/U4WfWdNI2wEjdkKYsseDgOlgNQV3aTktN9WWTdQIcOIbRu6dywl
         gTvL/URC1bHHmSm0KWlyEI3S/UR9dLlg79BfIZ1t0I2J68rM1CBTjBZK2oNto3xWCw
         7ylcV5sEtj9hBze8d+x1OXZIgJvMQMS0/YwEaZUM=
Subject: FAILED: patch "[PATCH] dmaengine: at_xdmac: Fix concurrency over xfers_list" failed to apply to 4.9-stable tree
To:     tudor.ambarus@microchip.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:29:25 +0100
Message-ID: <1643030965202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

