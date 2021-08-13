Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D53EB8BB
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbhHMPQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242639AbhHMPOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E236D610EA;
        Fri, 13 Aug 2021 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867639;
        bh=zhV33bxHTbzscpqk2d6nUvGlIbFSeZCjBQt7OjAI+v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xU6CrmsyaUDcmo4jH9y6iGNgBBF5BtuJarLZQEu2lv1veiMXje4tG7qTfBlzHM6aG
         BBrgwWK4GxvrOgAKdb0DeU33lnQePzk/IgCNMmi2npjNP241NP5ySz8CodRjuJ31S7
         8LMpbFFM0kzoSd8c5nhnWfek3lO9QnVLY9VZUDw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 08/27] usb: dwc3: gadget: Prevent EP queuing while stopping transfers
Date:   Fri, 13 Aug 2021 17:07:06 +0200
Message-Id: <20210813150523.641764333@linuxfoundation.org>
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

[ Upstream commit f09ddcfcb8c569675066337adac2ac205113471f ]

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
@@ -746,8 +746,6 @@ static int __dwc3_gadget_ep_disable(stru
 
 	trace_dwc3_gadget_ep_disable(dep);
 
-	dwc3_remove_requests(dwc, dep);
-
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
 		__dwc3_gadget_ep_set_halt(dep, 0, false);
@@ -766,6 +764,8 @@ static int __dwc3_gadget_ep_disable(stru
 		dep->endpoint.desc = NULL;
 	}
 
+	dwc3_remove_requests(dwc, dep);
+
 	return 0;
 }
 
@@ -1511,7 +1511,7 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected) {
+	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
 		dev_err(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;
@@ -2043,6 +2043,7 @@ static int dwc3_gadget_pullup(struct usb
 	if (!is_on) {
 		u32 count;
 
+		dwc->connected = false;
 		/*
 		 * In the Synopsis DesignWare Cores USB3 Databook Rev. 3.30a
 		 * Section 4.1.8 Table 4-7, it states that for a device-initiated
@@ -2067,7 +2068,6 @@ static int dwc3_gadget_pullup(struct usb
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
-		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
@@ -3057,8 +3057,6 @@ static void dwc3_gadget_reset_interrupt(
 {
 	u32			reg;
 
-	dwc->connected = true;
-
 	/*
 	 * Ideally, dwc3_reset_gadget() would trigger the function
 	 * drivers to stop any active transfers through ep disable.
@@ -3107,6 +3105,7 @@ static void dwc3_gadget_reset_interrupt(
 	 * transfers."
 	 */
 	dwc3_stop_active_transfers(dwc);
+	dwc->connected = true;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg &= ~DWC3_DCTL_TSTCTRL_MASK;


