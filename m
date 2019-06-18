Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643BA4A3DE
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfFROZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:25:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:24098 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfFROZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 10:25:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 07:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="243006671"
Received: from mattu-haswell.fi.intel.com ([10.237.72.164])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2019 07:25:01 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "# v4 . 18+" <stable@vger.kernel.org>
Subject: [PATCH 2/2] xhci: detect USB 3.2 capable host controllers correctly
Date:   Tue, 18 Jun 2019 17:27:48 +0300
Message-Id: <1560868068-2583-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560868068-2583-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1560868068-2583-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB 3.2 capability in a host can be detected from the
xHCI Supported Protocol Capability major and minor revision fields.

If major is 0x3 and minor 0x20 then the host is USB 3.2 capable.

For USB 3.2 capable hosts set the root hub lane count to 2.

The Major Revision and Minor Revision fields contain a BCD version number.
The value of the Major Revision field is JJh and the value of the Minor
Revision field is MNh for version JJ.M.N, where JJ = major revision number,
M - minor version number, N = sub-minor version number,
e.g. version 3.1 is represented with a value of 0310h.

Also fix the extra whitespace printed out when announcing regular
SuperSpeed hosts.

Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 78a2a93..3f79f35 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5065,16 +5065,26 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	} else {
 		/*
 		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn
+		 * minor revision instead of sbrn. Minor revision is a two digit
+		 * BCD containing minor and sub-minor numbers, only show minor.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev;
-		if (minor_rev) {
+		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+
+		switch (minor_rev) {
+		case 2:
+			hcd->speed = HCD_USB32;
+			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			hcd->self.root_hub->rx_lanes = 2;
+			hcd->self.root_hub->tx_lanes = 2;
+			break;
+		case 1:
 			hcd->speed = HCD_USB31;
 			hcd->self.root_hub->speed = USB_SPEED_SUPER_PLUS;
+			break;
 		}
-		xhci_info(xhci, "Host supports USB 3.%x %s SuperSpeed\n",
+		xhci_info(xhci, "Host supports USB 3.%x %sSuperSpeed\n",
 			  minor_rev,
-			  minor_rev ? "Enhanced" : "");
+			  minor_rev ? "Enhanced " : "");
 
 		xhci->usb3_rhub.hcd = hcd;
 		/* xHCI private pointer was set in xhci_pci_probe for the second
-- 
2.7.4

