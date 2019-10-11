Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5CD400A
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfJKM5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 08:57:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:59557 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfJKM5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 08:57:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 05:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,284,1566889200"; 
   d="scan'208";a="200781590"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Oct 2019 05:57:07 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     johan@kernel.org
Cc:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "# v5 . 3" <stable@vger.kernel.org>
Subject: [RFT PATCH] xhci: Fix use-after-free regression in xhci clear hub TT implementation
Date:   Fri, 11 Oct 2019 15:58:42 +0300
Message-Id: <1570798722-31594-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1c4b7107-f5e1-4a69-2a73-0e339c7e1072@linux.intel.com>
References: <1c4b7107-f5e1-4a69-2a73-0e339c7e1072@linux.intel.com>
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
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5cfbf9a04494..6e817686d04f 100644
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
@@ -5290,6 +5332,7 @@ static const struct hc_driver xhci_hc_driver = {
 	.free_streams =		xhci_free_streams,
 	.add_endpoint =		xhci_add_endpoint,
 	.drop_endpoint =	xhci_drop_endpoint,
+	.endpoint_disable =	xhci_endpoint_disable,
 	.endpoint_reset =	xhci_endpoint_reset,
 	.check_bandwidth =	xhci_check_bandwidth,
 	.reset_bandwidth =	xhci_reset_bandwidth,
-- 
2.7.4

