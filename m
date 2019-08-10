Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB688E37
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfHJUwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54086 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbfHJUnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053O-H4; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003ao-Mt; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.630985287@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 042/157] xhci: Don't let USB3 ports stuck in polling
 state prevent suspend
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit d92f2c59cc2cbca6bfb2cc54882b58ba76b15fd4 upstream.

Commit 2f31a67f01a8 ("usb: xhci: Prevent bus suspend if a port connect
change or polling state is detected") was intended to prevent ports that
were still link training from being forced to U3 suspend state mid
enumeration.
This solved enumeration issues for devices with slow link training.

Turns out some devices are stuck in the link training/polling state,
and thus that patch will prevent suspend completely for these devices.
This is seen with USB3 card readers in some MacBooks.

Instead of preventing suspend, give some time to complete the link
training. On successful training the port will end up as connected
and enabled.
If port instead is stuck in link training the bus suspend will continue
suspending after 360ms (10 * 36ms) timeout (tPollingLFPSTimeout).

Original patch was sent to stable, this one should go there as well

Fixes: 2f31a67f01a8 ("usb: xhci: Prevent bus suspend if a port connect change or polling state is detected")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c | 19 ++++++++++++-------
 drivers/usb/host/xhci.h     |  8 ++++++++
 2 files changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1199,20 +1199,25 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 	port_index = max_ports;
 	while (port_index--) {
 		u32 t1, t2;
-
+		int retries = 10;
+retry:
 		t1 = readl(port_array[port_index]);
 		t2 = xhci_port_state_to_neutral(t1);
 		portsc_buf[port_index] = 0;
 
-		/* Bail out if a USB3 port has a new device in link training */
-		if ((hcd->speed >= HCD_USB3) &&
+		/*
+		 * Give a USB3 port in link training time to finish, but don't
+		 * prevent suspend as port might be stuck
+		 */
+		if ((hcd->speed >= HCD_USB3) && retries-- &&
 		    (t1 & PORT_PLS_MASK) == XDEV_POLLING) {
-			bus_state->bus_suspended = 0;
 			spin_unlock_irqrestore(&xhci->lock, flags);
-			xhci_dbg(xhci, "Bus suspend bailout, port in polling\n");
-			return -EBUSY;
+			msleep(XHCI_PORT_POLLING_LFPS_TIME);
+			spin_lock_irqsave(&xhci->lock, flags);
+			xhci_dbg(xhci, "port %d polling in bus suspend, waiting\n",
+				 port_index);
+			goto retry;
 		}
-
 		/* suspend ports in U0, or bail out for new connect changes */
 		if ((t1 & PORT_PE) && (t1 & PORT_PLS_MASK) == XDEV_U0) {
 			if ((t1 & PORT_CSC) && wake_enabled) {
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -413,6 +413,14 @@ struct xhci_op_regs {
  */
 #define XHCI_DEFAULT_BESL	4
 
+/*
+ * USB3 specification define a 360ms tPollingLFPSTiemout for USB3 ports
+ * to complete link training. usually link trainig completes much faster
+ * so check status 10 times with 36ms sleep in places we need to wait for
+ * polling to complete.
+ */
+#define XHCI_PORT_POLLING_LFPS_TIME  36
+
 /**
  * struct xhci_intr_reg - Interrupt Register Set
  * @irq_pending:	IMAN - Interrupt Management Register.  Used to enable

