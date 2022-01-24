Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4C74980FA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbiAXN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:27:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiAXN1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:27:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC4CEB80ED1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304CAC340E1;
        Mon, 24 Jan 2022 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030817;
        bh=jdw5j0Oaorqu9KOnUEVydyNA88wmTq51TnOwgPmjSyA=;
        h=Subject:To:Cc:From:Date:From;
        b=OO5O3XEcNpm6JkJmn1wnQGU4rmYbfRo0h5ZqEWrRFqnRW3qvLMkd3HDNhGamL0aXB
         vK7b8wZDudZ3fPJF6NwDJDk7yWAWWgCA9bZPRCNJ4zCHWsMZE0wGEW1PMWkee1pc7U
         OPMd44Wt/6ciEPuyCFUE8EiQ5tlCt22GDiDsmUNw=
Subject: FAILED: patch "[PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels in" failed to apply to 4.9-stable tree
To:     tudor.ambarus@microchip.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:26:52 +0100
Message-ID: <16430308121812@kroah.com>
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

