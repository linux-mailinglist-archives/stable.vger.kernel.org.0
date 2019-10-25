Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42606E4F08
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404155AbfJYO20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:28:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:10575 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbfJYO20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 10:28:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 07:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="192554841"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2019 07:28:24 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "# v5 . 3" <stable@vger.kernel.org>
Subject: [PATCH 1/3] xhci: Fix use-after-free regression in xhci clear hub TT implementation
Date:   Fri, 25 Oct 2019 17:30:27 +0300
Message-Id: <1572013829-14044-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572013829-14044-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1572013829-14044-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer") schedules work
to clear TT buffer, but causes a use-after-free regression at the same time

Make sure hub_tt_work finishes before endpoint is disabled, otherwise
the work will dereference already freed endpoint and device related
pointers.

This was triggered when usb core failed to read the configuration
descriptor of a FS/LS device during enumeration.
xhci driver queued clear_tt_work while usb core freed and reallocated
a new device for the next enumeration attempt.

EHCI driver implents ehci_endpoint_disable() that makes sure
clear_tt_work has finished before it returns, but xhci lacks this support.
usb core will call hcd->driver->endpoint_disable() callback before
disabling endpoints, so we want this in xhci as well.

The added xhci_endpoint_disable() is based on ehci_endpoint_disable()

Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
Cc: <stable@vger.kernel.org> # v5.3
Reported-by: Johan Hovold <johan@kernel.org>
Suggested-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Tested-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 54 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 517ec3206f6e..6c17e3fe181a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3071,6 +3071,48 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
 	}
 }
 
+static void xhci_endpoint_disable(struct usb_hcd *hcd,
+				  struct usb_host_endpoint *host_ep)
+{
+	struct xhci_hcd		*xhci;
+	struct xhci_virt_device	*vdev;
+	struct xhci_virt_ep	*ep;
+	struct usb_device	*udev;
+	unsigned long		flags;
+	unsigned int		ep_index;
+
+	xhci = hcd_to_xhci(hcd);
+rescan:
+	spin_lock_irqsave(&xhci->lock, flags);
+
+	udev = (struct usb_device *)host_ep->hcpriv;
+	if (!udev || !udev->slot_id)
+		goto done;
+
+	vdev = xhci->devs[udev->slot_id];
+	if (!vdev)
+		goto done;
+
+	ep_index = xhci_get_endpoint_index(&host_ep->desc);
+	ep = &vdev->eps[ep_index];
+	if (!ep)
+		goto done;
+
+	/* wait for hub_tt_work to finish clearing hub TT */
+	if (ep->ep_state & EP_CLEARING_TT) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
+		schedule_timeout_uninterruptible(1);
+		goto rescan;
+	}
+
+	if (ep->ep_state)
+		xhci_dbg(xhci, "endpoint disable with ep_state 0x%x\n",
+			 ep->ep_state);
+done:
+	host_ep->hcpriv = NULL;
+	spin_unlock_irqrestore(&xhci->lock, flags);
+}
+
 /*
  * Called after usb core issues a clear halt control message.
  * The host side of the halt should already be cleared by a reset endpoint
@@ -5238,20 +5280,13 @@ static void xhci_clear_tt_buffer_complete(struct usb_hcd *hcd,
 	unsigned int ep_index;
 	unsigned long flags;
 
-	/*
-	 * udev might be NULL if tt buffer is cleared during a failed device
-	 * enumeration due to a halted control endpoint. Usb core might
-	 * have allocated a new udev for the next enumeration attempt.
-	 */
-
 	xhci = hcd_to_xhci(hcd);
+
+	spin_lock_irqsave(&xhci->lock, flags);
 	udev = (struct usb_device *)ep->hcpriv;
-	if (!udev)
-		return;
 	slot_id = udev->slot_id;
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 
-	spin_lock_irqsave(&xhci->lock, flags);
 	xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_CLEARING_TT;
 	xhci_ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	spin_unlock_irqrestore(&xhci->lock, flags);
@@ -5288,6 +5323,7 @@ static const struct hc_driver xhci_hc_driver = {
 	.free_streams =		xhci_free_streams,
 	.add_endpoint =		xhci_add_endpoint,
 	.drop_endpoint =	xhci_drop_endpoint,
+	.endpoint_disable =	xhci_endpoint_disable,
 	.endpoint_reset =	xhci_endpoint_reset,
 	.check_bandwidth =	xhci_check_bandwidth,
 	.reset_bandwidth =	xhci_reset_bandwidth,
-- 
2.7.4

