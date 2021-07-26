Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C1D3D5D95
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhGZPCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235736AbhGZPCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B95F260F38;
        Mon, 26 Jul 2021 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314160;
        bh=9az5U2itlPiuHHOG03B0ZpSEyguGuUd+gKEVdqBBQbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMUQ3jXQs8H4GzJjJhrD2B17wo8UYpBmxACwovfKUZilTuw572RoaYPw9DoCQmVvn
         z7xzXO8Y1bn7xP8eN0W+54dwjFpcwbykRC/F1Gn8BglAvRSl/DjH5KOAlb5Zx61UdA
         g6KzDSjqzb7Oul1i3PGYYFozAEkchNhiEhDrxT1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 33/47] xhci: Fix lost USB 2 remote wake
Date:   Mon, 26 Jul 2021 17:38:51 +0200
Message-Id: <20210726153824.026694427@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 72f68bf5c756f5ce1139b31daae2684501383ad5 upstream.

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
 drivers/usb/host/xhci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1268,11 +1268,12 @@ int xhci_hub_status_data(struct usb_hcd
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
 		temp = readl(port_array[i]);


