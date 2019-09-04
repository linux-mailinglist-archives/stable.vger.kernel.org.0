Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11283A9005
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388471AbfIDSHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389171AbfIDSHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B4652087E;
        Wed,  4 Sep 2019 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620432;
        bh=lm2ggu0B+hEIa5s9zRmKIf6P8oQ23BeKtocwhGD3hxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaw+6ce7VZjDWm5oBfOwzZIkpaYZDB70ezNUlWMuR64h2Do9EWwNM7LKNaVsfbJge
         0OKrsfAxM9puCYHOG+pyyTzVcErur2WiQr80ihBCG+z+Vt2hjFUyDqR5U63nHS4BvL
         j3B2/XBJQyyepYfNN4AjObH0tWIR2AJ2sSZTEeHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.19 57/93] usb: chipidea: udc: dont do hardware access if gadget has stopped
Date:   Wed,  4 Sep 2019 19:53:59 +0200
Message-Id: <20190904175308.051011622@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit cbe85c88ce80fb92956a0793518d415864dcead8 upstream.

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
 drivers/usb/chipidea/udc.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -708,12 +708,6 @@ static int _gadget_stop_activity(struct
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
@@ -731,6 +725,12 @@ static int _gadget_stop_activity(struct
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
 
@@ -1302,6 +1302,10 @@ static int ep_disable(struct usb_ep *ep)
 		return -EBUSY;
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
 
 	/* only internal SW should disable ctrl endpts */
 
@@ -1391,6 +1395,10 @@ static int ep_queue(struct usb_ep *ep, s
 		return -EINVAL;
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
 	retval = _ep_queue(ep, req, gfp_flags);
 	spin_unlock_irqrestore(hwep->lock, flags);
 	return retval;
@@ -1414,8 +1422,8 @@ static int ep_dequeue(struct usb_ep *ep,
 		return -EINVAL;
 
 	spin_lock_irqsave(hwep->lock, flags);
-
-	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
+	if (hwep->ci->gadget.speed != USB_SPEED_UNKNOWN)
+		hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
 	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
 		dma_pool_free(hwep->td_pool, node->ptr, node->dma);
@@ -1486,6 +1494,10 @@ static void ep_fifo_flush(struct usb_ep
 	}
 
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return;
+	}
 
 	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
 
@@ -1558,6 +1570,10 @@ static int ci_udc_wakeup(struct usb_gadg
 	int ret = 0;
 
 	spin_lock_irqsave(&ci->lock, flags);
+	if (ci->gadget.speed == USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(&ci->lock, flags);
+		return 0;
+	}
 	if (!ci->remote_wakeup) {
 		ret = -EOPNOTSUPP;
 		goto out;


