Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61883D0969
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGUGag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhGUGaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:30:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAF961029;
        Wed, 21 Jul 2021 07:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851459;
        bh=joLTWpIy+S6g7NjYFrcJt9N+qfY7cXZyC0xooZ5o2Ns=;
        h=Subject:To:From:Date:From;
        b=YwgnrPyLglLbxQHpytZPlWhZ9OGi1rvQmXfVfY422XKeGjxq9GTx68AK55Pl8JlHI
         o6Qs0qoCQjxNg2aoQIZtQ4PdwUYC6vOAji0VcME62EfY6oGoyOlUXfUkbklXVXlVqP
         1cd45HookfrP6DMtj4TDcOchQzqEYogJ52tL1UJI=
Subject: patch "xhci: Fix lost USB 2 remote wake" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:10:56 +0200
Message-ID: <1626851456147224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix lost USB 2 remote wake

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 72f68bf5c756f5ce1139b31daae2684501383ad5 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 15 Jul 2021 18:06:51 +0300
Subject: xhci: Fix lost USB 2 remote wake

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
Link: https://lore.kernel.org/r/20210715150651.1996099-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.32.0


