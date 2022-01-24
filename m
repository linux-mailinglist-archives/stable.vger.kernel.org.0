Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C5A499DA7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585942AbiAXWZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584561AbiAXWVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E4FC0424D9;
        Mon, 24 Jan 2022 12:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18692611C8;
        Mon, 24 Jan 2022 20:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12B8C340E5;
        Mon, 24 Jan 2022 20:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057446;
        bh=OdssgiM79/9ocsj19OPaOx7QxpE2D+RAnAHhWTYflIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx6WX7Qqpwo5/n3TEdjPGa4LogaAxwebF5bq/um5VhGz3whT9h6qJsKsqwDp/gqDV
         4xpqckyFWwDjdUcfG4LvRl4F0zan/9tobrCPDIYe9te46MZdBlzomHETgsT0+zao7i
         7vX931DOnMqFEofz4j1OVn+Lqtbu9MYr18tAIyfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 815/846] dmaengine: at_xdmac: Dont start transactions at tx_submit level
Date:   Mon, 24 Jan 2022 19:45:32 +0100
Message-Id: <20220124184129.025015902@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit bccfb96b59179d4f96cbbd1ddff8fac6d335eae4 upstream.

tx_submit is supposed to push the current transaction descriptor to a
pending queue, waiting for issue_pending() to be called. issue_pending()
must start the transfer, not tx_submit(), thus remove
at_xdmac_start_xfer() from at_xdmac_tx_submit(). Clients of at_xdmac that
assume that tx_submit() starts the transfer must be updated and call
dma_async_issue_pending() if they miss to call it (one example is
atmel_serial).

As the at_xdmac_start_xfer() is now called only from
at_xdmac_advance_work() when !at_xdmac_chan_is_enabled(), the
at_xdmac_chan_is_enabled() check is no longer needed in
at_xdmac_start_xfer(), thus remove it.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-2-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -385,9 +385,6 @@ static void at_xdmac_start_xfer(struct a
 
 	dev_vdbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, first);
 
-	if (at_xdmac_chan_is_enabled(atchan))
-		return;
-
 	/* Set transfer as active to not try to start it again. */
 	first->active_xfer = true;
 
@@ -479,9 +476,6 @@ static dma_cookie_t at_xdmac_tx_submit(s
 	dev_vdbg(chan2dev(tx->chan), "%s: atchan 0x%p, add desc 0x%p to xfers_list\n",
 		 __func__, atchan, desc);
 	list_add_tail(&desc->xfer_node, &atchan->xfers_list);
-	if (list_is_singular(&atchan->xfers_list))
-		at_xdmac_start_xfer(atchan, desc);
-
 	spin_unlock_irqrestore(&atchan->lock, irqflags);
 	return cookie;
 }


