Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27FF499198
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349632AbiAXUM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36612 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378832AbiAXUJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:09:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9251960B56;
        Mon, 24 Jan 2022 20:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CCAC340E7;
        Mon, 24 Jan 2022 20:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054994;
        bh=TdBfH9yDEX18SMwX7BpD8oKnsT0/eTI2XzEfRHK2+LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlwejpFuhShu/0/fWaogsZMrCq765qpfDHwp+Hix7YTAnVg7DhW8y7LOzWpRkcOf4
         ALr2AjEYvpkTbm9sJjCwIFQDDf7+LszOR7KMOfnHQq5dpsQ/ecZ776Jq572gQgx8px
         1X/G9G3K/R7XRsqyuKdKQQ1PocJzSrbiX/dVfn4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 540/563] dmaengine: at_xdmac: Dont start transactions at tx_submit level
Date:   Mon, 24 Jan 2022 19:45:05 +0100
Message-Id: <20220124184043.114975053@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -338,9 +338,6 @@ static void at_xdmac_start_xfer(struct a
 
 	dev_vdbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, first);
 
-	if (at_xdmac_chan_is_enabled(atchan))
-		return;
-
 	/* Set transfer as active to not try to start it again. */
 	first->active_xfer = true;
 
@@ -430,9 +427,6 @@ static dma_cookie_t at_xdmac_tx_submit(s
 	dev_vdbg(chan2dev(tx->chan), "%s: atchan 0x%p, add desc 0x%p to xfers_list\n",
 		 __func__, atchan, desc);
 	list_add_tail(&desc->xfer_node, &atchan->xfers_list);
-	if (list_is_singular(&atchan->xfers_list))
-		at_xdmac_start_xfer(atchan, desc);
-
 	spin_unlock_irqrestore(&atchan->lock, irqflags);
 	return cookie;
 }


