Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE22EEE3E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388158AbfKDWJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390334AbfKDWJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:02 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18B40214D8;
        Mon,  4 Nov 2019 22:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905341;
        bh=pFFbdePxjjhPoguf/Ha0ult80u4T1XctSKWMf6QgOfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLMiHNNdsOuIJtDrNVs+mHqfUiH9rO00j/+zWPXKeXf1r4QrSDvUZoguKos2u1fPa
         rSmqYyqfxmcRA96/VFSGfzde5xu9K6BcueBEuTUuzaNmk6LGkJjhDfPKmDei5S3FgP
         UuXZverWcmU8YaSzZT18tR+C0HRssKrxQDhlYgj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 112/163] xhci: Fix use-after-free regression in xhci clear hub TT implementation
Date:   Mon,  4 Nov 2019 22:45:02 +0100
Message-Id: <20191104212148.359193024@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 18b74067ac78a2dea65783314c13df98a53d071c upstream.

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
Link: https://lore.kernel.org/r/1572013829-14044-2-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   54 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3071,6 +3071,48 @@ void xhci_cleanup_stalled_ring(struct xh
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
@@ -5237,20 +5279,13 @@ static void xhci_clear_tt_buffer_complet
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
@@ -5287,6 +5322,7 @@ static const struct hc_driver xhci_hc_dr
 	.free_streams =		xhci_free_streams,
 	.add_endpoint =		xhci_add_endpoint,
 	.drop_endpoint =	xhci_drop_endpoint,
+	.endpoint_disable =	xhci_endpoint_disable,
 	.endpoint_reset =	xhci_endpoint_reset,
 	.check_bandwidth =	xhci_check_bandwidth,
 	.reset_bandwidth =	xhci_reset_bandwidth,


