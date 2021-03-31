Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DFE34417B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCVMdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhCVMc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D84BF619A6;
        Mon, 22 Mar 2021 12:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416377;
        bh=EFDnB3WoNVk9gyb2gRnm2fXLjPkIU6fjClEcWeY1Y+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEq87SSRhSqnOTJ7exfzN6+wYmYR6T1YCy1XXoXNIrc/yTdl8EDvYOkFTQQAOUcEQ
         XCXP28uecoImc4udBcKSth8MRyKQxVnBI9Y1ivX4NgJ+Q9pxXCdobsjUqdDQFhSbXZ
         rLr4MTU9TG04N8eI0jxlz6plUpNmn4VFpDORwuUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.11 084/120] usb: dwc3: gadget: Prevent EP queuing while stopping transfers
Date:   Mon, 22 Mar 2021 13:27:47 +0100
Message-Id: <20210322121932.478878424@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit f09ddcfcb8c569675066337adac2ac205113471f upstream.

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
 drivers/usb/dwc3/gadget.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -783,8 +783,6 @@ static int __dwc3_gadget_ep_disable(stru
 
 	trace_dwc3_gadget_ep_disable(dep);
 
-	dwc3_remove_requests(dwc, dep);
-
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
 		__dwc3_gadget_ep_set_halt(dep, 0, false);
@@ -803,6 +801,8 @@ static int __dwc3_gadget_ep_disable(stru
 		dep->endpoint.desc = NULL;
 	}
 
+	dwc3_remove_requests(dwc, dep);
+
 	return 0;
 }
 
@@ -1617,7 +1617,7 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -2150,6 +2150,7 @@ static int dwc3_gadget_pullup(struct usb
 	if (!is_on) {
 		u32 count;
 
+		dwc->connected = false;
 		/*
 		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2174,7 +2175,6 @@ static int dwc3_gadget_pullup(struct usb
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
-		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
@@ -3267,8 +3267,6 @@ static void dwc3_gadget_reset_interrupt(
 {
 	u32			reg;
 
-	dwc->connected = true;
-
 	/*
 	 * WORKAROUND: DWC3 revisions <1.88a have an issue which
 	 * would cause a missing Disconnect Event if there's a
@@ -3308,6 +3306,7 @@ static void dwc3_gadget_reset_interrupt(
 	 * transfers."
 	 */
 	dwc3_stop_active_transfers(dwc);
+	dwc->connected = true;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;


