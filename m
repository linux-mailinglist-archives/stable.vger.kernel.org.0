Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB7698085
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfHUQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 12:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbfHUQqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 12:46:47 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CA72339F;
        Wed, 21 Aug 2019 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566406006;
        bh=4Jm8zjZi8LCwfW7kAZQjrdlT66K1EqlB+1IQPAQRhew=;
        h=Subject:To:From:Date:From;
        b=NLrDHahtuCXwlgQq0Tm6It2E+WQ8z1zOR8wCflaHMuLWCNa0i9tLJjzCTpZzkb4ur
         Bm08MI43y6DOhfEQqlZ4Oq6iSEcBphq4BrA63OYIgHuHXuqYLw+0pWJyAtGX4hX6BN
         K+WlekWPilJEcPygUEOGDo5MeDcKF9vAqbXtvCvM=
Subject: patch "usb: chipidea: udc: don't do hardware access if gadget has stopped" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Aug 2019 09:46:44 -0700
Message-ID: <156640600412223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: udc: don't do hardware access if gadget has stopped

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cbe85c88ce80fb92956a0793518d415864dcead8 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 20 Aug 2019 02:07:58 +0000
Subject: usb: chipidea: udc: don't do hardware access if gadget has stopped

After _gadget_stop_activity is executed, we can consider the hardware
operation for gadget has finished, and the udc can be stopped and enter
low power mode. So, any later hardware operations (from usb_ep_ops APIs
or usb_gadget_ops APIs) should be considered invalid, any deinitializatons
has been covered at _gadget_stop_activity.

I meet this problem when I plug out usb cable from PC using mass_storage
gadget, my callstack like: vbus interrupt->.vbus_session->
composite_disconnect ->pm_runtime_put_sync(&_gadget->dev),
the composite_disconnect will call fsg_disable, but fsg_disable calls
usb_ep_disable using async way, there are register accesses for
usb_ep_disable. So sometimes, I get system hang due to visit register
without clock, sometimes not.

The Linux Kernel USB maintainer Alan Stern suggests this kinds of solution.
See: http://marc.info/?l=linux-usb&m=138541769810983&w=2.

Cc: <stable@vger.kernel.org> #v4.9+
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20190820020503.27080-2-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/udc.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 6a5ee8e6da10..67ad40b0a05b 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -709,12 +709,6 @@ static int _gadget_stop_activity(struct usb_gadget *gadget)
 	struct ci_hdrc    *ci = container_of(gadget, struct ci_hdrc, gadget);
 	unsigned long flags;
 
-	spin_lock_irqsave(&ci->lock, flags);
-	ci->gadget.speed = USB_SPEED_UNKNOWN;
-	ci->remote_wakeup = 0;
-	ci->suspended = 0;
-	spin_unlock_irqrestore(&ci->lock, flags);
-
 	/* flush all endpoints */
 	gadget_for_each_ep(ep, gadget) {
 		usb_ep_fifo_flush(ep);
@@ -732,6 +726,12 @@ static int _gadget_stop_activity(struct usb_gadget *gadget)
 		ci->status = NULL;
 	}
 
+	spin_lock_irqsave(&ci->lock, flags);
+	ci->gadget.speed = USB_SPEED_UNKNOWN;
+	ci->remote_wakeup = 0;
+	ci->suspended = 0;
+	spin_unlock_irqrestore(&ci->lock, flags);
+
 	return 0;
 }
 
@@ -1303,6 +1303,10 @@ static int ep_disable(struct usb_ep *ep)
 		return -EBUSY;
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
 
 	/* only internal SW should disable ctrl endpts */
 
@@ -1392,6 +1396,10 @@ static int ep_queue(struct usb_ep *ep, struct usb_request *req,
 		return -EINVAL;
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
 	retval = _ep_queue(ep, req, gfp_flags);
 	spin_unlock_irqrestore(hwep->lock, flags);
 	return retval;
@@ -1415,8 +1423,8 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_request *req)
 		return -EINVAL;
 
 	spin_lock_irqsave(hwep->lock, flags);
-
-	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
+	if (hwep->ci->gadget.speed != USB_SPEED_UNKNOWN)
+		hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
 	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
 		dma_pool_free(hwep->td_pool, node->ptr, node->dma);
@@ -1487,6 +1495,10 @@ static void ep_fifo_flush(struct usb_ep *ep)
 	}
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return;
+	}
 
 	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
@@ -1559,6 +1571,10 @@ static int ci_udc_wakeup(struct usb_gadget *_gadget)
 	int ret = 0;
 
 	spin_lock_irqsave(&ci->lock, flags);
+	if (ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(&ci->lock, flags);
+		return 0;
+	}
 	if (!ci->remote_wakeup) {
 		ret = -EOPNOTSUPP;
 		goto out;
-- 
2.23.0


