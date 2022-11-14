Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22816280D3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiKNNJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbiKNNJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F163025EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A758EB80EC1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EEFC433D6;
        Mon, 14 Nov 2022 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431356;
        bh=k0q58YcQtR4TiLVwKQrQbvu4NsdCobEyXC1+9RfG3DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bA8kyRFLAj1jJscxybIMcOivNcazT5xaRxA+Fvqik5SiKLKoLRuyekFquzvfSqvUv
         ZCbTvyJ2e5ilG0lbEzgwkGSaxgiklCsg7VQIskYoEK28upwu3aG2xCps9sVU0MuDzu
         PRGtIxDp8bFo0VU1nMSVzg0EYc+Or/fxwUlm4w4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 175/190] dmaengine: at_hdmac: Dont start transactions at tx_submit level
Date:   Mon, 14 Nov 2022 13:46:39 +0100
Message-Id: <20221114124506.522027046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

commit 7176a6a8982d311e50a7c1168868d26e65bbba19 upstream.

tx_submit is supposed to push the current transaction descriptor to a
pending queue, waiting for issue_pending() to be called. issue_pending()
must start the transfer, not tx_submit(), thus remove atc_dostart() from
atc_tx_submit(). Clients of at_xdmac that assume that tx_submit() starts
the transfer must be updated and call dma_async_issue_pending() if they
miss to call it.
The vdbg print was moved to after the lock is released. It is desirable to
do the prints without the lock held if possible, and because the if
statement disappears there's no reason why to do the print while holding
the lock.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-3-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -691,19 +691,11 @@ static dma_cookie_t atc_tx_submit(struct
 	spin_lock_irqsave(&atchan->lock, flags);
 	cookie = dma_cookie_assign(tx);
 
-	if (list_empty(&atchan->active_list)) {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
-				desc->txd.cookie);
-		atc_dostart(atchan, desc);
-		list_add_tail(&desc->desc_node, &atchan->active_list);
-	} else {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
-				desc->txd.cookie);
-		list_add_tail(&desc->desc_node, &atchan->queue);
-	}
-
+	list_add_tail(&desc->desc_node, &atchan->queue);
 	spin_unlock_irqrestore(&atchan->lock, flags);
 
+	dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
+		 desc->txd.cookie);
 	return cookie;
 }
 


