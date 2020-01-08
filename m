Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725BB134C22
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgAHTtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43434 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730401AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oR-Ii; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dmI-QQ; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jan 2020 19:43:21 +0000
Message-ID: <lsq.1578512578.222781441@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 23/63] xhci: Fix port resume done detection for SS
 ports with LPM enabled
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 6cbcf596934c8e16d6288c7cc62dfb7ad8eadf15 upstream.

A suspended SS port in U3 link state will go to U0 when resumed, but
can almost immediately after that enter U1 or U2 link power save
states before host controller driver reads the port status.

Host controller driver only checks for U0 state, and might miss
the finished resume, leaving flags unclear and skip notifying usb
code of the wake.

Add U1 and U2 to the possible link states when checking for finished
port resume.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Mathias Nyman: backport to 3.18 stable.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 9 ++++++---
 drivers/usb/host/xhci.h      | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1645,10 +1645,13 @@ static void handle_port_status(struct xh
 		}
 	}
 
-	if ((temp & PORT_PLC) && (temp & PORT_PLS_MASK) == XDEV_U0 &&
-			DEV_SUPERSPEED(temp)) {
+	if ((temp & PORT_PLC) &&
+	    DEV_SUPERSPEED(temp) &&
+	    ((temp & PORT_PLS_MASK) == XDEV_U0 ||
+	     (temp & PORT_PLS_MASK) == XDEV_U1 ||
+	     (temp & PORT_PLS_MASK) == XDEV_U2)) {
 		xhci_dbg(xhci, "resume SS port %d finished\n", port_id);
-		/* We've just brought the device into U0 through either the
+		/* We've just brought the device into U0/1/2 through either the
 		 * Resume state after a device remote wakeup, or through the
 		 * U3Exit state after a host-initiated resume.  If it's a device
 		 * initiated remote wake, don't pass up the link state change,
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -283,6 +283,7 @@ struct xhci_op_regs {
  */
 #define PORT_PLS_MASK	(0xf << 5)
 #define XDEV_U0		(0x0 << 5)
+#define XDEV_U1		(0x1 << 5)
 #define XDEV_U2		(0x2 << 5)
 #define XDEV_U3		(0x3 << 5)
 #define XDEV_INACTIVE	(0x6 << 5)

