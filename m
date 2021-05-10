Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E8378E71
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242446AbhEJN3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241038AbhEJMwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10575611CA;
        Mon, 10 May 2021 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620651079;
        bh=Ktj2JHvFNenH6IueBkjxq5Y2d7eJy7e6RNhDwe2Xg4s=;
        h=Subject:To:From:Date:From;
        b=0Dr1gcZa+jawZZWTyr9yUMNp9qOOSA97nI5owIfNAp1hK9PVHUpNrQfE94ZRdANX4
         hlqBSRzOqnhwaR6g07igiMVIznGY7w3FkX26SeReoZwfdTLH05zTYkMifwSC0uWWWM
         ck+W9eQJtrVJQfQ0NAyO8uuU02PAqc5vBzlscq6o=
Subject: patch "usb: dwc2: Fix gadget DMA unmap direction" added to usb-linus
To:     phil@raspberrypi.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 14:51:17 +0200
Message-ID: <162065107748229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Fix gadget DMA unmap direction

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 75a41ce46bae6cbe7d3bb2584eb844291d642874 Mon Sep 17 00:00:00 2001
From: Phil Elwell <phil@raspberrypi.com>
Date: Thu, 6 May 2021 12:22:00 +0100
Subject: usb: dwc2: Fix gadget DMA unmap direction

The dwc2 gadget support maps and unmaps DMA buffers as necessary. When
mapping and unmapping it uses the direction of the endpoint to select
the direction of the DMA transfer, but this fails for Control OUT
transfers because the unmap occurs after the endpoint direction has
been reversed for the status phase.

A possible solution would be to unmap the buffer before the direction
is changed, but a safer, less invasive fix is to remember the buffer
direction independently of the endpoint direction.

Fixes: fe0b94abcdf6 ("usb: dwc2: gadget: manage ep0 state in software")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/20210506112200.2893922-1-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h   | 2 ++
 drivers/usb/dwc2/gadget.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index da5ac4a4595b..ab6b815e0089 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -113,6 +113,7 @@ struct dwc2_hsotg_req;
  * @debugfs: File entry for debugfs file for this endpoint.
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *          means that it is sending data to the Host.
+ * @map_dir: Set to the value of dir_in when the DMA buffer is mapped.
  * @index: The index for the endpoint registers.
  * @mc: Multi Count - number of transactions per microframe
  * @interval: Interval for periodic endpoints, in frames or microframes.
@@ -162,6 +163,7 @@ struct dwc2_hsotg_ep {
 	unsigned short		fifo_index;
 
 	unsigned char           dir_in;
+	unsigned char           map_dir;
 	unsigned char           index;
 	unsigned char           mc;
 	u16                     interval;
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index e6bb1bdb2760..184964174dc0 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -422,7 +422,7 @@ static void dwc2_hsotg_unmap_dma(struct dwc2_hsotg *hsotg,
 {
 	struct usb_request *req = &hs_req->req;
 
-	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
+	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->map_dir);
 }
 
 /*
@@ -1242,6 +1242,7 @@ static int dwc2_hsotg_map_dma(struct dwc2_hsotg *hsotg,
 {
 	int ret;
 
+	hs_ep->map_dir = hs_ep->dir_in;
 	ret = usb_gadget_map_request(&hsotg->gadget, req, hs_ep->dir_in);
 	if (ret)
 		goto dma_error;
-- 
2.31.1


