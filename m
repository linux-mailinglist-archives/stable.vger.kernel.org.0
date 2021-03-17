Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803E233FA18
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 21:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhCQUpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 16:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233462AbhCQUpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 16:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 613A764E74;
        Wed, 17 Mar 2021 20:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616013932;
        bh=tkhVIzatQPYgLbycABC84x5TphdlfKKXvUdC3kAXRrg=;
        h=Subject:To:From:Date:From;
        b=xXxrEOhjyYSNeYvJG7rLUymbGuOjYN7I/gb9jt2UHK3FFGxhIIC0tDGftlzR91OSa
         JkNwikSoPfD66NO4eBTKnHoLwmYeri6NzPNYG6S4GJWzY5mIARAHChoGGmlFpXEk3U
         Ojv3Q2lds/JC/1X1cvk7AIIMkS8Bc7Onv8ti9Wcw=
Subject: patch "usb: dwc3: gadget: Prevent EP queuing while stopping transfers" added to usb-linus
To:     wcheng@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Mar 2021 21:45:29 +0100
Message-ID: <161601392921452@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Prevent EP queuing while stopping transfers

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f09ddcfcb8c569675066337adac2ac205113471f Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Thu, 11 Mar 2021 15:59:02 -0800
Subject: usb: dwc3: gadget: Prevent EP queuing while stopping transfers

In the situations where the DWC3 gadget stops active transfers, once
calling the dwc3_gadget_giveback(), there is a chance where a function
driver can queue a new USB request in between the time where the dwc3
lock has been released and re-aquired.  This occurs after we've already
issued an ENDXFER command.  When the stop active transfers continues
to remove USB requests from all dep lists, the newly added request will
also be removed, while controller still has an active TRB for it.
This can lead to the controller accessing an unmapped memory address.

Fix this by ensuring parameters to prevent EP queuing are set before
calling the stop active transfers API.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1615507142-23097-1-git-send-email-wcheng@codeaurora.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index aebcf8ec0716..4a337f348651 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -783,8 +783,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	trace_dwc3_gadget_ep_disable(dep);
 
-	dwc3_remove_requests(dwc, dep);
-
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
 		__dwc3_gadget_ep_set_halt(dep, 0, false);
@@ -803,6 +801,8 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
+	dwc3_remove_requests(dwc, dep);
+
 	return 0;
 }
 
@@ -1617,7 +1617,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -2247,6 +2247,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	if (!is_on) {
 		u32 count;
 
+		dwc->connected = false;
 		/*
 		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2271,7 +2272,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
-		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
@@ -3321,8 +3321,6 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 {
 	u32			reg;
 
-	dwc->connected = true;
-
 	/*
 	 * WORKAROUND: DWC3 revisions <1.88a have an issue which
 	 * would cause a missing Disconnect Event if there's a
@@ -3362,6 +3360,7 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 	 * transfers."
 	 */
 	dwc3_stop_active_transfers(dwc);
+	dwc->connected = true;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;
-- 
2.30.2


