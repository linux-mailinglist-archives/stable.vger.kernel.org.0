Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409452A5324
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732936AbgKCU6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbgKCU6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989E52053B;
        Tue,  3 Nov 2020 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437086;
        bh=skUxmWK3uMQLNfiAm43a28Pzoz9TI0jZMxaY7vlP97Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3F3t8lvZXK0PsJXjLX4YsNqfgsdv9+Xrmhm9mY7KZpUEwhi2aBa20crsH6DGHjnF
         eUNkOLRneq1I7uNLdVDk7hJUE373wtkCIe9juHTE9+Z8tng5WqY0TUu0tK0zzGTFqT
         noWpqPjqbJlX7DuDwS9HL9CTpcI8Fc83M2g0n870=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 140/214] usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
Date:   Tue,  3 Nov 2020 21:36:28 +0100
Message-Id: <20201103203303.956391252@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit d97c78a1908e59a1fdbcbece87cd0440b5d7a1f2 upstream.

According the programming guide (for all DWC3 IPs), when the driver
handles ClearFeature(halt) request, it should issue CLEAR_STALL command
_after_ the END_TRANSFER command completes. The END_TRANSFER command may
take some time to complete. So, delay the ClearFeature(halt) request
control status stage and wait for END_TRANSFER command completion
interrupt. Only after END_TRANSFER command completes that the driver
may issue CLEAR_STALL command.

Cc: stable@vger.kernel.org
Fixes: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.h   |    1 +
 drivers/usb/dwc3/ep0.c    |   16 ++++++++++++++++
 drivers/usb/dwc3/gadget.c |   40 ++++++++++++++++++++++++++++++++--------
 drivers/usb/dwc3/gadget.h |    1 +
 4 files changed, 50 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -700,6 +700,7 @@ struct dwc3_ep {
 #define DWC3_EP_END_TRANSFER_PENDING BIT(4)
 #define DWC3_EP_PENDING_REQUEST	BIT(5)
 #define DWC3_EP_DELAY_START	BIT(6)
+#define DWC3_EP_PENDING_CLEAR_STALL	BIT(11)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN		BIT(31)
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -524,6 +524,11 @@ static int dwc3_ep0_handle_endpoint(stru
 		ret = __dwc3_gadget_ep_set_halt(dep, set, true);
 		if (ret)
 			return -EINVAL;
+
+		/* ClearFeature(Halt) may need delayed status */
+		if (!set && (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
+			return USB_GADGET_DELAYED_STATUS;
+
 		break;
 	default:
 		return -EINVAL;
@@ -1049,6 +1054,17 @@ static void dwc3_ep0_do_control_status(s
 	__dwc3_ep0_do_control_status(dwc, dep);
 }
 
+void dwc3_ep0_send_delayed_status(struct dwc3 *dwc)
+{
+	unsigned int direction = !dwc->ep0_expect_in;
+
+	if (dwc->ep0state != EP0_STATUS_PHASE)
+		return;
+
+	dwc->delayed_status = false;
+	__dwc3_ep0_do_control_status(dwc, dwc->eps[direction]);
+}
+
 static void dwc3_ep0_end_control_data(struct dwc3 *dwc, struct dwc3_ep *dep)
 {
 	struct dwc3_gadget_ep_cmd_params params;
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1719,6 +1719,18 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 			return 0;
 		}
 
+		dwc3_stop_active_transfer(dep, true, true);
+
+		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
+			dwc3_gadget_move_cancelled_request(req);
+
+		if (dep->flags & DWC3_EP_END_TRANSFER_PENDING) {
+			dep->flags |= DWC3_EP_PENDING_CLEAR_STALL;
+			return 0;
+		}
+
+		dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+
 		ret = dwc3_send_clear_stall_ep_cmd(dep);
 		if (ret) {
 			dev_err(dwc->dev, "failed to clear STALL on %s\n",
@@ -1728,14 +1740,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc
 
 		dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
 
-		dwc3_stop_active_transfer(dep, true, true);
-
-		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
-			dwc3_gadget_move_cancelled_request(req);
-
-		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING))
-			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
-
 		if ((dep->flags & DWC3_EP_DELAY_START) &&
 		    !usb_endpoint_xfer_isoc(dep->endpoint.desc))
 			__dwc3_gadget_kick_transfer(dep);
@@ -2767,6 +2771,26 @@ static void dwc3_endpoint_interrupt(stru
 			dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 			dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+
+			if (dep->flags & DWC3_EP_PENDING_CLEAR_STALL) {
+				struct dwc3 *dwc = dep->dwc;
+
+				dep->flags &= ~DWC3_EP_PENDING_CLEAR_STALL;
+				if (dwc3_send_clear_stall_ep_cmd(dep)) {
+					struct usb_ep *ep0 = &dwc->eps[0]->endpoint;
+
+					dev_err(dwc->dev, "failed to clear STALL on %s\n",
+						dep->name);
+					if (dwc->delayed_status)
+						__dwc3_gadget_ep0_set_halt(ep0, 1);
+					return;
+				}
+
+				dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
+				if (dwc->delayed_status)
+					dwc3_ep0_send_delayed_status(dwc);
+			}
+
 			if ((dep->flags & DWC3_EP_DELAY_START) &&
 			    !usb_endpoint_xfer_isoc(dep->endpoint.desc))
 				__dwc3_gadget_kick_transfer(dep);
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -111,6 +111,7 @@ int dwc3_gadget_ep0_set_halt(struct usb_
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
+void dwc3_ep0_send_delayed_status(struct dwc3 *dwc);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW


