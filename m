Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27364980FB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbiAXN1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiAXN1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:27:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830BDC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4004CB80FAB
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAB0C340E1;
        Mon, 24 Jan 2022 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030821;
        bh=77qn10RtlAs07hVb6fXQ1r+HxU2iuERRtxI8ME6ahSw=;
        h=Subject:To:Cc:From:Date:From;
        b=LdQQ/nN647Lb+cGSLxh+IFKlxM3r1coO4XSbiGgqENDjkZ7zmbNKeGQyEqKgrqfJW
         NjA+PxH5dvoFe+14KNp2U1zB0K7P3/KOUti3E9LmCpn09Z99Up5xBUFbGJr0jmZXI1
         V6WQZCFiYGF81VKwTXyLR0P1ZKbuygoerDSp/tw4=
Subject: FAILED: patch "[PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels in" failed to apply to 4.14-stable tree
To:     tudor.ambarus@microchip.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:26:55 +0100
Message-ID: <1643030815147231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6af9b05bec63cd4d1de2a33968cd0be2a91282a Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Wed, 15 Dec 2021 13:01:05 +0200
Subject: [PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels in
 issue_pending

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 4ff12b083136..c3d3e1270236 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1778,11 +1778,9 @@ static void at_xdmac_issue_pending(struct dma_chan *chan)
 
 	dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);
 
-	if (!at_xdmac_chan_is_cyclic(atchan)) {
-		spin_lock_irqsave(&atchan->lock, flags);
-		at_xdmac_advance_work(atchan);
-		spin_unlock_irqrestore(&atchan->lock, flags);
-	}
+	spin_lock_irqsave(&atchan->lock, flags);
+	at_xdmac_advance_work(atchan);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	return;
 }

