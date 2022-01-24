Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79698498E7B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiAXTmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37498 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355098AbiAXTkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D7D61523;
        Mon, 24 Jan 2022 19:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E309C340E5;
        Mon, 24 Jan 2022 19:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053199;
        bh=Jxtv+A1161cRIGR/Gk7IFvyFKod5JdGJGCILTRds53I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txNtJGR/Epvaq8MkmgwEtWJ6NTHCniCAssO7nTA6Ce2HUgp7b4GdZrwqP0D/7cWmw
         x19iE08VDaxKLeH76msEOD34MyOpJ+RfYWBTp7v6Es/IyOorMNbZm7tOqRty7zBPwt
         OMvSav/oUz6bQdGe8JWtJxipwsoGx/BkytyIebxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 307/320] dmaengine: at_xdmac: Fix concurrency over xfers_list
Date:   Mon, 24 Jan 2022 19:44:51 +0100
Message-Id: <20220124184004.387740545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 18deddea9184b62941395889ff7659529c877326 upstream.

Since tx_submit can be called from a hard IRQ, xfers_list must be
protected with a lock to avoid concurency on the list's elements.
Since at_xdmac_handle_cyclic() is called from a tasklet, spin_lock_irq
is enough to protect from a hard IRQ.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-8-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1564,14 +1564,17 @@ static void at_xdmac_handle_cyclic(struc
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


