Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203E6157C94
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBJNnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:43:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:14982 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgBJNnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 08:43:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 05:43:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,425,1574150400"; 
   d="scan'208";a="265858449"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2020 05:43:41 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] xhci: Force Maximum Packet size for Full-speed bulk devices to valid range.
Date:   Mon, 10 Feb 2020 15:45:50 +0200
Message-Id: <20200210134553.9144-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210134553.9144-1-mathias.nyman@linux.intel.com>
References: <20200210134553.9144-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A Full-speed bulk USB audio device (DJ-Tech CTRL) with a invalid Maximum
Packet Size of 4 causes a xHC "Parameter Error" at enumeration.

This is because valid Maximum packet sizes for Full-speed bulk endpoints
are 8, 16, 32 and 64 bytes. Hosts are not required to support other values
than these. See usb 2 specs section 5.8.3 for details.

The device starts working after forcing the maximum packet size to 8.
This is most likely the case with other devices as well, so force the
maximum packet size to a valid range.

Cc: stable@vger.kernel.org
Reported-by: Rene D Obermueller <cmdrrdo@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 3b1388fa2f36..0e2701649369 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1475,9 +1475,15 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 	/* Allow 3 retries for everything but isoc, set CErr = 3 */
 	if (!usb_endpoint_xfer_isoc(&ep->desc))
 		err_count = 3;
-	/* Some devices get this wrong */
-	if (usb_endpoint_xfer_bulk(&ep->desc) && udev->speed == USB_SPEED_HIGH)
-		max_packet = 512;
+	/* HS bulk max packet should be 512, FS bulk supports 8, 16, 32 or 64 */
+	if (usb_endpoint_xfer_bulk(&ep->desc)) {
+		if (udev->speed == USB_SPEED_HIGH)
+			max_packet = 512;
+		if (udev->speed == USB_SPEED_FULL) {
+			max_packet = rounddown_pow_of_two(max_packet);
+			max_packet = clamp_val(max_packet, 8, 64);
+		}
+	}
 	/* xHCI 1.0 and 1.1 indicates that ctrl ep avg TRB Length should be 8 */
 	if (usb_endpoint_xfer_control(&ep->desc) && xhci->hci_version >= 0x100)
 		avg_trb_len = 8;
-- 
2.17.1

