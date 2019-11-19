Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9986E102D8A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKSU2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfKSU2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 15:28:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD202235D;
        Tue, 19 Nov 2019 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574195319;
        bh=moPKUFZi4W35ZonUVywayWHYoCsZ1E0BQ2OoZP5hnvY=;
        h=Subject:To:From:Date:From;
        b=yyINWA1lizi5U5LspSV/fuZNM7PbIl7Uu+Ko4p0nP2B5Y2k8W5BFgzX56NvD0+xTS
         WTUA4ujQw7EKblV3efXMJvOuE1DV/DDDDBL/WJjDFnVPug5HTVCxm4eOIv4FQHl7Fu
         nhbglpy4wjy7gtC/Mz/+2Fa3XS1/21KP3v6X+lMc=
Subject: patch "serial: pl011: Fix DMA ->flush_buffer()" added to tty-next
To:     vincent.whitchurch@axis.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 19 Nov 2019 21:28:36 +0100
Message-ID: <1574195316255157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: pl011: Fix DMA ->flush_buffer()

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From f6a196477184b99a31d16366a8e826558aa11f6d Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Mon, 18 Nov 2019 10:25:47 +0100
Subject: serial: pl011: Fix DMA ->flush_buffer()

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
 drivers/tty/serial/amba-pl011.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 38e2d25f7e23..4b28134d596a 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -813,10 +813,8 @@ __acquires(&uap->port.lock)
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
-- 
2.24.0


