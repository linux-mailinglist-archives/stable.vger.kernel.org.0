Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B112A3CA117
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhGOPH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:07:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:57122 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235204AbhGOPH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 11:07:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="210551980"
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="210551980"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 08:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="466708932"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jul 2021 08:04:33 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] xhci: Fix lost USB 2 remote wake
Date:   Thu, 15 Jul 2021 18:06:51 +0300
Message-Id: <20210715150651.1996099-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210715150651.1996099-1-mathias.nyman@linux.intel.com>
References: <20210715150651.1996099-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's a small window where a USB 2 remote wake may be left unhandled
due to a race between hub thread and xhci port event interrupt handler.

When the resume event is detected in the xhci interrupt handler it kicks
the hub timer, which should move the port from resume to U0 once resume
has been signalled for long enough.

To keep the hub "thread" running we set a bus_state->resuming_ports flag.
This flag makes sure hub timer function kicks itself.

checking this flag was not properly protected by the spinlock. Flag was
copied to a local variable before lock was taken. The local variable was
then checked later with spinlock held.

If interrupt is handled right after copying the flag to the local variable
we end up stopping the hub thread before it can handle the USB 2 resume.

CPU0					CPU1
(hub thread)				(xhci event handler)

xhci_hub_status_data()
status = bus_state->resuming_ports;
					<Interrupt>
					handle_port_status()
					spin_lock()
					bus_state->resuming_ports = 1
					set_flag(HCD_FLAG_POLL_RH)
					spin_unlock()
spin_lock()
if (!status)
  clear_flag(HCD_FLAG_POLL_RH)
spin_unlock()

Fix this by taking the lock a bit earlier so that it covers
the resuming_ports flag copy in the hub thread

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index e9b18fc17617..151e93c4bd57 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1638,11 +1638,12 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 	 * Inform the usbcore about resume-in-progress by returning
 	 * a non-zero value even if there are no status changes.
 	 */
+	spin_lock_irqsave(&xhci->lock, flags);
+
 	status = bus_state->resuming_ports;
 
 	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC | PORT_CEC;
 
-	spin_lock_irqsave(&xhci->lock, flags);
 	/* For each port, did anything change?  If so, set that bit in buf. */
 	for (i = 0; i < max_ports; i++) {
 		temp = readl(ports[i]->addr);
-- 
2.25.1

