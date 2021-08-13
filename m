Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C33EB8B4
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbhHMPP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242495AbhHMPOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2312460E9B;
        Fri, 13 Aug 2021 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867631;
        bh=EqLdFvXGY4H2cvHNvFiUQTlfLRrD+kOKIskCN9K8iGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tra7VecBoBiu8KoVLxBJGSth+arAtS5IRY24Bt3P+xumuZv9VNYS72upl98dZzY5X
         Z+gha0Jo7MfXyz+hnFFkx899SI2Rl7Y7LtjR6g+6JGfDNt4ysdxziYWG3y97RYPvU6
         bQ6MnejFQdvp5uGgOE73zCRc1jRzUOJb91zL5p7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 05/27] usb: dwc3: Stop active transfers before halting the controller
Date:   Fri, 13 Aug 2021 17:07:03 +0200
Message-Id: <20210813150523.544976151@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit ae7e86108b12351028fa7e8796a59f9b2d9e1774 ]

In the DWC3 databook, for a device initiated disconnect or bus reset, the
driver is required to send dependxfer commands for any pending transfers.
In addition, before the controller can move to the halted state, the SW
needs to acknowledge any pending events.  If the controller is not halted
properly, there is a chance the controller will continue accessing stale or
freed TRBs and buffers.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c    |    2 -
 drivers/usb/dwc3/gadget.c |   66 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -197,7 +197,7 @@ int dwc3_gadget_ep0_queue(struct usb_ep
 	int				ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	if (!dep->endpoint.desc) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		ret = -ESHUTDOWN;
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1511,7 +1511,7 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -1931,6 +1931,21 @@ static int dwc3_gadget_set_selfpowered(s
 	return 0;
 }
 
+static void dwc3_stop_active_transfers(struct dwc3 *dwc)
+{
+	u32 epnum;
+
+	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
+		struct dwc3_ep *dep;
+
+		dep = dwc->eps[epnum];
+		if (!dep)
+			continue;
+
+		dwc3_remove_requests(dwc, dep);
+	}
+}
+
 static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 {
 	u32			reg;
@@ -1976,6 +1991,9 @@ static int dwc3_gadget_run_stop(struct d
 	return 0;
 }
 
+static void dwc3_gadget_disable_irq(struct dwc3 *dwc);
+static void __dwc3_gadget_stop(struct dwc3 *dwc);
+
 static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
@@ -1999,7 +2017,46 @@ static int dwc3_gadget_pullup(struct usb
 		}
 	}
 
+	/*
+	 * Synchronize any pending event handling before executing the controller
+	 * halt routine.
+	 */
+	if (!is_on) {
+		dwc3_gadget_disable_irq(dwc);
+		synchronize_irq(dwc->irq_gadget);
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
+
+	if (!is_on) {
+		u32 count;
+
+		/*
+		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
+		 * disconnect, the SW needs to ensure that it sends "a DEPENDXFER
+		 * command for any active transfers" before clearing the RunStop
+		 * bit.
+		 */
+		dwc3_stop_active_transfers(dwc);
+		__dwc3_gadget_stop(dwc);
+
+		/*
+		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+		 * Section 1.3.4, it mentions that for the DEVCTRLHLT bit, the
+		 * "software needs to acknowledge the events that are generated
+		 * (by writing to GEVNTCOUNTn) while it is waiting for this bit
+		 * to be set to '1'."
+		 */
+		count = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+		count &= DWC3_GEVNTCOUNT_MASK;
+		if (count > 0) {
+			dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), count);
+			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
+						dwc->ev_buf->length;
+		}
+	}
+
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -3038,6 +3095,13 @@ static void dwc3_gadget_reset_interrupt(
 	}
 
 	dwc3_reset_gadget(dwc);
+	/*
+	 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
+	 * Section 4.1.2 Table 4-2, it states that during a USB reset, the SW
+	 * needs to ensure that it sends "a DEPENDXFER command for any active
+	 * transfers."
+	 */
+	dwc3_stop_active_transfers(dwc);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;


