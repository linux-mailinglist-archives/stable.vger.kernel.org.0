Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44121B2901
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgDUOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 10:06:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:63245 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgDUOGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 10:06:11 -0400
IronPort-SDR: 7E9q1WQMLbPVGsU1WYyinM3EyW0H2cA02EdvIL0YTYJBxlXyH5wpKBZVYFWyQ98WznzXOtQwED
 z+YpygC5BeaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 07:05:52 -0700
IronPort-SDR: S4nTtBZJn0OzWgKune4epgHbGhcfbMXbhOdYPGj9NoQdt+8d9nhnsJvMioeyIOzjrO/9t5Z4Jl
 dP6qcJj5sUHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,410,1580803200"; 
   d="scan'208";a="300618777"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Apr 2020 07:05:51 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] xhci: prevent bus suspend if a roothub port detected a over-current condition
Date:   Tue, 21 Apr 2020 17:08:21 +0300
Message-Id: <20200421140822.28233-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
References: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Suspending the bus and host controller while a port is in a over-current
condition may halt the host.
Also keep the roothub running if over-current is active.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 9eca1fe81061..f37316d2c8fa 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1571,6 +1571,8 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		}
 		if ((temp & PORT_RC))
 			reset_change = true;
+		if (temp & PORT_OC)
+			status = 1;
 	}
 	if (!status && !reset_change) {
 		xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
@@ -1636,6 +1638,13 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 				 port_index);
 			goto retry;
 		}
+		/* bail out if port detected a over-current condition */
+		if (t1 & PORT_OC) {
+			bus_state->bus_suspended = 0;
+			spin_unlock_irqrestore(&xhci->lock, flags);
+			xhci_dbg(xhci, "Bus suspend bailout, port over-current detected\n");
+			return -EBUSY;
+		}
 		/* suspend ports in U0, or bail out for new connect changes */
 		if ((t1 & PORT_PE) && (t1 & PORT_PLS_MASK) == XDEV_U0) {
 			if ((t1 & PORT_CSC) && wake_enabled) {
-- 
2.17.1

