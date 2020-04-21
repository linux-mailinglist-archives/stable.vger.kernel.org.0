Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB11B28FF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 16:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgDUOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 10:06:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:63242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgDUOGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 10:06:13 -0400
IronPort-SDR: n7qBGmWkrR6aw5d0TYAekxYeKUbTdmb5sN8Lzj/sc96bPevdkUJLSbM0xw+86AE8Mh+4/o/uvB
 kYjnVlw0onwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 07:05:54 -0700
IronPort-SDR: 2kQ2yg96dEgzsaxwkEf8tr67qltQsX4naEa30Ps9z+gXmacLoLu1sKes1TxkS+q5XRLmmnss//
 QkLBa89Ck4Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,410,1580803200"; 
   d="scan'208";a="300618779"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Apr 2020 07:05:52 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] xhci: Don't clear hub TT buffer on ep0 protocol stall
Date:   Tue, 21 Apr 2020 17:08:22 +0300
Message-Id: <20200421140822.28233-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
References: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The default control endpoint ep0 can return a STALL indicating the
device does not support the control transfer requests. This is called
a protocol stall and does not halt the endpoint.

xHC behaves a bit different. Its internal endpoint state will always
be halted on any stall, even if the device side of the endpiont is not
halted. So we do need to issue the reset endpoint command to clear the
xHC host intenal endpoint halt state, but should not request the HS hub
to clear the TT buffer unless device side of endpoint is halted.

Clearing the hub TT buffer at protocol stall caused ep0 to become
unresponsive for some FS/LS devices behind HS hubs, and class drivers
failed to set the interface due to timeout:

usb 1-2.1: 1:1: usb_set_interface failed (-110)

Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
Cc: <stable@vger.kernel.org> # v5.3
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a7f4cd35da55..0fda0c0f4d31 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1876,7 +1876,6 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
 		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
 					  td);
-		xhci_clear_hub_tt_buffer(xhci, td, ep);
 	}
 	xhci_ring_cmd_db(xhci);
 }
@@ -1997,11 +1996,18 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	if (trb_comp_code == COMP_STALL_ERROR ||
 		xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 						trb_comp_code)) {
-		/* Issue a reset endpoint command to clear the host side
-		 * halt, followed by a set dequeue command to move the
-		 * dequeue pointer past the TD.
-		 * The class driver clears the device side halt later.
+		/*
+		 * xhci internal endpoint state will go to a "halt" state for
+		 * any stall, including default control pipe protocol stall.
+		 * To clear the host side halt we need to issue a reset endpoint
+		 * command, followed by a set dequeue command to move past the
+		 * TD.
+		 * Class drivers clear the device side halt from a functional
+		 * stall later. Hub TT buffer should only be cleared for FS/LS
+		 * devices behind HS hubs for functional stalls.
 		 */
+		if ((ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
+			xhci_clear_hub_tt_buffer(xhci, td, ep);
 		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
 					ep_ring->stream_id, td, EP_HARD_RESET);
 	} else {
-- 
2.17.1

