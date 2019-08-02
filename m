Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D746C7F3A2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406692AbfHBJ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406691AbfHBJ4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 874A62064A;
        Fri,  2 Aug 2019 09:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739771;
        bh=iWFH8Skp/Cx1fKOEEqG1lkR2l7I8vs9n0RKutGL+isI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygMQASrILUOWs/86W4YqxlaTNDqe8p01rLPROcUdXlvycKk0pSPncu4msEFCu+1Xl
         q2QyUrQcSy+3T+ouOsI0z+97mCE1zHosg1jtdfBcCetppAwy5Dt/FWzJG7kxA3dI2o
         54yeWFUGitetTnVrYejQmLXWmKVXfgpKzJ/gMFPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 4.19 07/32] usb: dwc2: Fix disable all EPs on disconnect
Date:   Fri,  2 Aug 2019 11:39:41 +0200
Message-Id: <20190802092103.809416309@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <minas.harutyunyan@synopsys.com>

commit 4fe4f9fecc36956fd53c8edf96dd0c691ef98ff9 upstream.

Disabling all EP's allow to reset EP's to initial state.
Introduced new function dwc2_hsotg_ep_disable_lock() which
before calling dwc2_hsotg_ep_disable() function acquire
hsotg->lock and release on exiting.
>From dwc2_hsotg_ep_disable() function removed acquiring
hsotg->lock.
In dwc2_hsotg_core_init_disconnected() function when USB
reset interrupt asserted disabling all ep’s by
dwc2_hsotg_ep_disable() function.
This updates eliminating sparse imbalance warnings.

Reverted changes in dwc2_hostg_disconnect() function.
Introduced new function dwc2_hsotg_ep_disable_lock().
Changed dwc2_hsotg_ep_ops. Now disable point to
dwc2_hsotg_ep_disable_lock() function.
In functions dwc2_hsotg_udc_stop() and dwc2_hsotg_suspend()
dwc2_hsotg_ep_disable() function replaced by
dwc2_hsotg_ep_disable_lock() function.
In dwc2_hsotg_ep_disable() function removed acquiring
of hsotg->lock.

Fixes: dccf1bad4be7 ("usb: dwc2: Disable all EP's on disconnect")
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3107,8 +3107,6 @@ static void kill_all_requests(struct dwc
 		dwc2_hsotg_txfifo_flush(hsotg, ep->fifo_index);
 }
 
-static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
-
 /**
  * dwc2_hsotg_disconnect - disconnect service
  * @hsotg: The device state.
@@ -3130,9 +3128,11 @@ void dwc2_hsotg_disconnect(struct dwc2_h
 	/* all endpoints should be shutdown */
 	for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			kill_all_requests(hsotg, hsotg->eps_in[ep],
+					  -ESHUTDOWN);
 		if (hsotg->eps_out[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+			kill_all_requests(hsotg, hsotg->eps_out[ep],
+					  -ESHUTDOWN);
 	}
 
 	call_gadget(hsotg, disconnect);
@@ -3176,6 +3176,7 @@ static void dwc2_hsotg_irq_fifoempty(str
 			GINTSTS_PTXFEMP |  \
 			GINTSTS_RXFLVL)
 
+static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
 /**
  * dwc2_hsotg_core_init - issue softreset to the core
  * @hsotg: The device state
@@ -4004,10 +4005,8 @@ static int dwc2_hsotg_ep_disable(struct
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	int dir_in = hs_ep->dir_in;
 	int index = hs_ep->index;
-	unsigned long flags;
 	u32 epctrl_reg;
 	u32 ctrl;
-	int locked;
 
 	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
@@ -4023,10 +4022,6 @@ static int dwc2_hsotg_ep_disable(struct
 
 	epctrl_reg = dir_in ? DIEPCTL(index) : DOEPCTL(index);
 
-	locked = spin_is_locked(&hsotg->lock);
-	if (!locked)
-		spin_lock_irqsave(&hsotg->lock, flags);
-
 	ctrl = dwc2_readl(hsotg, epctrl_reg);
 
 	if (ctrl & DXEPCTL_EPENA)
@@ -4049,12 +4044,22 @@ static int dwc2_hsotg_ep_disable(struct
 	hs_ep->fifo_index = 0;
 	hs_ep->fifo_size = 0;
 
-	if (!locked)
-		spin_unlock_irqrestore(&hsotg->lock, flags);
-
 	return 0;
 }
 
+static int dwc2_hsotg_ep_disable_lock(struct usb_ep *ep)
+{
+	struct dwc2_hsotg_ep *hs_ep = our_ep(ep);
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&hsotg->lock, flags);
+	ret = dwc2_hsotg_ep_disable(ep);
+	spin_unlock_irqrestore(&hsotg->lock, flags);
+	return ret;
+}
+
 /**
  * on_list - check request is on the given endpoint
  * @ep: The endpoint to check.
@@ -4202,7 +4207,7 @@ static int dwc2_hsotg_ep_sethalt_lock(st
 
 static const struct usb_ep_ops dwc2_hsotg_ep_ops = {
 	.enable		= dwc2_hsotg_ep_enable,
-	.disable	= dwc2_hsotg_ep_disable,
+	.disable	= dwc2_hsotg_ep_disable_lock,
 	.alloc_request	= dwc2_hsotg_ep_alloc_request,
 	.free_request	= dwc2_hsotg_ep_free_request,
 	.queue		= dwc2_hsotg_ep_queue_lock,
@@ -4342,9 +4347,9 @@ static int dwc2_hsotg_udc_stop(struct us
 	/* all endpoints should be shutdown */
 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 		if (hsotg->eps_out[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+			dwc2_hsotg_ep_disable_lock(&hsotg->eps_out[ep]->ep);
 	}
 
 	spin_lock_irqsave(&hsotg->lock, flags);
@@ -4792,9 +4797,9 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg
 
 		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
-				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-				dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+				dwc2_hsotg_ep_disable_lock(&hsotg->eps_out[ep]->ep);
 		}
 	}
 


