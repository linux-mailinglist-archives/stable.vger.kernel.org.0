Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5336B7F351
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406690AbfHBJ4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406686AbfHBJ4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BE52064A;
        Fri,  2 Aug 2019 09:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739768;
        bh=IBrnpmj4G0HAPtsbrI5Ax2fDDioBBv/uhBTEH6vXM/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n026s2uFFOooSJnALxJiALqOjvx1zRfIk+LWY6SWO6yl00ntipKeBlWLv3vyymrDB
         352fQLLsbO3OAW4JmODAlz4kJkBxZ3QRAhxYo6/K43eKO0QGKPl5otffYztA1jrMEg
         +1X9ug9s9qybLycjLptElAP+nW+9WHqKXBMb0GJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 4.19 06/32] usb: dwc2: Disable all EPs on disconnect
Date:   Fri,  2 Aug 2019 11:39:40 +0200
Message-Id: <20190802092103.571518377@linuxfoundation.org>
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

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit dccf1bad4be7eaa096c1f3697bd37883f9a08ecb upstream.

Disabling all EP's allow to reset EP's to initial state.
On disconnect disable all EP's instead of just killing
all requests. Because of some platform didn't catch
disconnect event, same stuff added to
dwc2_hsotg_core_init_disconnected() function when USB
reset detected on the bus.

Changed from version 1:
Changed lock acquire flow in dwc2_hsotg_ep_disable()
function.

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/gadget.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3107,6 +3107,8 @@ static void kill_all_requests(struct dwc
 		dwc2_hsotg_txfifo_flush(hsotg, ep->fifo_index);
 }
 
+static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
+
 /**
  * dwc2_hsotg_disconnect - disconnect service
  * @hsotg: The device state.
@@ -3125,13 +3127,12 @@ void dwc2_hsotg_disconnect(struct dwc2_h
 	hsotg->connected = 0;
 	hsotg->test_mode = 0;
 
+	/* all endpoints should be shutdown */
 	for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			kill_all_requests(hsotg, hsotg->eps_in[ep],
-					  -ESHUTDOWN);
+			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
 		if (hsotg->eps_out[ep])
-			kill_all_requests(hsotg, hsotg->eps_out[ep],
-					  -ESHUTDOWN);
+			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
 	}
 
 	call_gadget(hsotg, disconnect);
@@ -3189,13 +3190,23 @@ void dwc2_hsotg_core_init_disconnected(s
 	u32 val;
 	u32 usbcfg;
 	u32 dcfg = 0;
+	int ep;
 
 	/* Kill any ep0 requests as controller will be reinitialized */
 	kill_all_requests(hsotg, hsotg->eps_out[0], -ECONNRESET);
 
-	if (!is_usb_reset)
+	if (!is_usb_reset) {
 		if (dwc2_core_reset(hsotg, true))
 			return;
+	} else {
+		/* all endpoints should be shutdown */
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
+			if (hsotg->eps_in[ep])
+				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			if (hsotg->eps_out[ep])
+				dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+		}
+	}
 
 	/*
 	 * we must now enable ep0 ready for host detection and then
@@ -3996,6 +4007,7 @@ static int dwc2_hsotg_ep_disable(struct
 	unsigned long flags;
 	u32 epctrl_reg;
 	u32 ctrl;
+	int locked;
 
 	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
@@ -4011,7 +4023,9 @@ static int dwc2_hsotg_ep_disable(struct
 
 	epctrl_reg = dir_in ? DIEPCTL(index) : DOEPCTL(index);
 
-	spin_lock_irqsave(&hsotg->lock, flags);
+	locked = spin_is_locked(&hsotg->lock);
+	if (!locked)
+		spin_lock_irqsave(&hsotg->lock, flags);
 
 	ctrl = dwc2_readl(hsotg, epctrl_reg);
 
@@ -4035,7 +4049,9 @@ static int dwc2_hsotg_ep_disable(struct
 	hs_ep->fifo_index = 0;
 	hs_ep->fifo_size = 0;
 
-	spin_unlock_irqrestore(&hsotg->lock, flags);
+	if (!locked)
+		spin_unlock_irqrestore(&hsotg->lock, flags);
+
 	return 0;
 }
 


