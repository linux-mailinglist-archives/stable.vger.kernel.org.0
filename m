Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEDF37B76A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELIHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:07:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:32313 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELIHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:07:40 -0400
IronPort-SDR: 2rHsHs9Dwrq9AYJBNN+egV/Sup5tRhrpaP7ufkdraZKR5xgHKzFdR60YP+sCc+2bR0TVwjcXNy
 VeUWUHJQ4leA==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="220616884"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="220616884"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:06:33 -0700
IronPort-SDR: mM3PWfd+TPH+5m9Afuq5InNCihSSdrARQvOKkxYzy+7n52KMREq4iTavlFARPAlmFbBvl3MY+o
 XJ6YIQ9NzidQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="625208243"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2021 01:06:31 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] xhci: Fix giving back cancelled URBs even if halted endpoint can't reset
Date:   Wed, 12 May 2021 11:08:13 +0300
Message-Id: <20210512080816.866037-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
References: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9ebf30007858 ("xhci: Fix halted endpoint at stop endpoint command
completion") in 5.12 changes how cancelled URBs are given back.

To cancel a URB xhci driver needs to stop the endpoint first.
To clear a halted endpoint xhci driver needs to reset the endpoint.

In rare cases when an endpoint halt (error) races with a endpoint stop we
need to clear the reset before removing, and giving back the cancelled URB.

The above change in 5.12 takes care of this, but it also relies on the
reset endpoint completion handler to give back the cancelled URBs.

There are cases when driver refuses to queue reset endpoint commands,
for example when a link suddenly goes to an inactive error state.
In this case the cancelled URB is never given back.

Fix this by giving back the URB in the stop endpoint if queuing a reset
endpoint command fails.

Fixes: 9ebf30007858 ("xhci: Fix halted endpoint at stop endpoint command completion")
CC: <stable@vger.kernel.org> # 5.12
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 05c38dd3ee36..a8e4189277da 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -862,7 +862,7 @@ static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
 	return ret;
 }
 
-static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
+static int xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 				struct xhci_virt_ep *ep, unsigned int stream_id,
 				struct xhci_td *td,
 				enum xhci_ep_reset_type reset_type)
@@ -875,7 +875,7 @@ static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
 	if (ep->vdev->flags & VDEV_PORT_ERROR)
-		return;
+		return -ENODEV;
 
 	/* add td to cancelled list and let reset ep handler take care of it */
 	if (reset_type == EP_HARD_RESET) {
@@ -888,16 +888,18 @@ static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 
 	if (ep->ep_state & EP_HALTED) {
 		xhci_dbg(xhci, "Reset ep command already pending\n");
-		return;
+		return 0;
 	}
 
 	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
 	if (err)
-		return;
+		return err;
 
 	ep->ep_state |= EP_HALTED;
 
 	xhci_ring_cmd_db(xhci);
+
+	return 0;
 }
 
 /*
@@ -1014,6 +1016,7 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 	struct xhci_td *td = NULL;
 	enum xhci_ep_reset_type reset_type;
 	struct xhci_command *command;
+	int err;
 
 	if (unlikely(TRB_TO_SUSPEND_PORT(le32_to_cpu(trb->generic.field[3])))) {
 		if (!xhci->devs[slot_id])
@@ -1058,7 +1061,10 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 					td->status = -EPROTO;
 			}
 			/* reset ep, reset handler cleans up cancelled tds */
-			xhci_handle_halted_endpoint(xhci, ep, 0, td, reset_type);
+			err = xhci_handle_halted_endpoint(xhci, ep, 0, td,
+							  reset_type);
+			if (err)
+				break;
 			xhci_stop_watchdog_timer_in_irq(xhci, ep);
 			return;
 		case EP_STATE_RUNNING:
-- 
2.25.1

