Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6B7233C25
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgG3X27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 19:28:59 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54294 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728846AbgG3X27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 19:28:59 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 531A9C04AD;
        Thu, 30 Jul 2020 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596151738; bh=GUaPyzyFBHqyI0rptaMyFK/a2WAsLWkpwdL82ONpC6k=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=VlpGSC1WTkb9AmB0xKdintOcjhV37QcdlxKBrvfwTn0IDt3japtbjIQT/t3ptWtEh
         cjA4+Yl9gmJfiBSyp+qWzbn62X3XnTaCEXK1KqqLuz0iArOHjS1BA6cWjTWSPFnJCG
         C+l+gAP5Tcawwq7dmAc3ZisAzzubajWApxEcq5WAJuCE2QUvdSGMITzUJNIxzH/8da
         My5mGIUnmpcVpezyh5M7ray1rxRwcGmTrg38SzN7p/lLY4d6GfDJMyPCFXuhQ4R75Z
         QwymvHLdF5lYhFAfJvEBH8yGSrs2eYjRBDDGYsov05TNUkJ/rfUGMjMLXx+FwoGYF4
         2dv6G5GZztkpw==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 23149A0096;
        Thu, 30 Jul 2020 23:28:57 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 30 Jul 2020 16:28:57 -0700
Date:   Thu, 30 Jul 2020 16:28:57 -0700
Message-Id: <5c1c044097118dfa6d56e5235a746f9fb16fc8e8.1596151437.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596151437.git.thinhn@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/3] usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/ep0.c    | 16 ++++++++++++++++
 drivers/usb/dwc3/gadget.c | 43 +++++++++++++++++++++++++++++++++----------
 drivers/usb/dwc3/gadget.h |  1 +
 4 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 2f04b3e42bf1..eb026c9cca28 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -706,6 +706,7 @@ struct dwc3_ep {
 #define DWC3_EP_IGNORE_NEXT_NOSTREAM	BIT(8)
 #define DWC3_EP_FORCE_RESTART_STREAM	BIT(9)
 #define DWC3_EP_FIRST_STREAM_PRIMED	BIT(10)
+#define DWC3_EP_PENDING_CLEAR_STALL	BIT(11)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN		BIT(31)
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 59f2e8c31bd1..92bc1044e7ab 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -524,6 +524,11 @@ static int dwc3_ep0_handle_endpoint(struct dwc3 *dwc,
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
@@ -1042,6 +1047,17 @@ static void dwc3_ep0_do_control_status(struct dwc3 *dwc,
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
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index fcd0df1e7d3f..8c89444efd9f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1764,6 +1764,19 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
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
+		dep->flags &= ~DWC3_EP_DELAY_START;
+		dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+
 		ret = dwc3_send_clear_stall_ep_cmd(dep);
 		if (ret) {
 			dev_err(dwc->dev, "failed to clear STALL on %s\n",
@@ -1772,16 +1785,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 		}
 
 		dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
-
-		dwc3_stop_active_transfer(dep, true, true);
-
-		list_for_each_entry_safe(req, tmp, &dep->started_list, list)
-			dwc3_gadget_move_cancelled_request(req);
-
-		if (!(dep->flags & DWC3_EP_END_TRANSFER_PENDING)) {
-			dep->flags &= ~DWC3_EP_DELAY_START;
-			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
-		}
 	}
 
 	return ret;
@@ -2927,6 +2930,26 @@ static void dwc3_endpoint_interrupt(struct dwc3 *dwc,
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
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index bd85eb7fa9ef..a7791cb827c4 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -113,6 +113,7 @@ int dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
+void dwc3_ep0_send_delayed_status(struct dwc3 *dwc);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
2.11.0

