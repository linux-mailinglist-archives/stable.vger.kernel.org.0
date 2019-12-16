Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0A312190F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfLPRvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfLPRvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9418520700;
        Mon, 16 Dec 2019 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518678;
        bh=dMlxio4fVNiztZsJSbPZb+jiUQpKnO6vtJqb9VrvA3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPG7m4KXyncvny1jT8sEcYTlxfYBuA6XUnwjP3L4bquSvFRFVQR2v9Tgapqum25uC
         BhUcq0am55ux/secHOHw5beZ9TznzFEKWlngUSM5u0BpC2HsKJ6PVOd2Yrha77IDX1
         I5r0FHMgNGSykZfMblE3e8v8CfGPrhmjuBtxVGwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH 4.14 006/267] serial: pl011: Fix DMA ->flush_buffer()
Date:   Mon, 16 Dec 2019 18:45:32 +0100
Message-Id: <20191216174849.509808434@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit f6a196477184b99a31d16366a8e826558aa11f6d upstream.

PL011's ->flush_buffer() implementation releases and reacquires the port
lock.  Due to a race condition here, data can end up being added to the
circular buffer but neither being discarded nor being sent out.  This
leads to, for example, tcdrain(2) waiting indefinitely.

Process A                       Process B

uart_flush_buffer()
 - acquire lock
 - circ_clear
 - pl011_flush_buffer()
 -- release lock
 -- dmaengine_terminate_all()

                                uart_write()
                                - acquire lock
                                - add chars to circ buffer
                                - start_tx()
                                -- start DMA
                                - release lock

 -- acquire lock
 -- turn off DMA
 -- release lock

                                // Data in circ buffer but DMA is off

According to the comment in the code, the releasing of the lock around
dmaengine_terminate_all() is to avoid a deadlock with the DMA engine
callback.  However, since the time this code was written, the DMA engine
API documentation seems to have been clarified to say that
dmaengine_terminate_all() (in the identically implemented but
differently named dmaengine_terminate_async() variant) does not wait for
any running complete callback to be completed and can even be called
from a complete callback.  So there is no possibility of deadlock if the
DMA engine driver implements this API correctly.

So we should be able to just remove this release and reacquire of the
lock to prevent the aforementioned race condition.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191118092547.32135-1-vincent.whitchurch@axis.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -829,10 +829,8 @@ __acquires(&uap->port.lock)
 	if (!uap->using_tx_dma)
 		return;
 
-	/* Avoid deadlock with the DMA engine callback */
-	spin_unlock(&uap->port.lock);
-	dmaengine_terminate_all(uap->dmatx.chan);
-	spin_lock(&uap->port.lock);
+	dmaengine_terminate_async(uap->dmatx.chan);
+
 	if (uap->dmatx.queued) {
 		dma_unmap_sg(uap->dmatx.chan->device->dev, &uap->dmatx.sg, 1,
 			     DMA_TO_DEVICE);


