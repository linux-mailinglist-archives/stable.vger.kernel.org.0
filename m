Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A252F80CC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbhAOQ3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbhAOQ3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 11:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CAC7238EB;
        Fri, 15 Jan 2021 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610728130;
        bh=v7Z6FqzQSiEnJejIMuKrfqjB9pN8sOGjrrN2xz3EFGc=;
        h=Subject:To:From:Date:From;
        b=OO28xxi9SeaESjj50jINlb9AVdpRLu+xRjoaCartENqa0f+rkPqGQ+lYD9/rcO3ym
         B/fC7YGHRcBge38Bg3W/11Xe+O/rk2nkjjkqdNDqxFME8T/BR3dynIyEXBBibIBeRz
         AXfoggzbR1tsj1QdpMrRtdlD6K3jb8Q8D8T0DcCY=
Subject: patch "xhci: make sure TRB is fully written before giving it to the" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zwisler@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 17:28:48 +0100
Message-ID: <1610728128111152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: make sure TRB is fully written before giving it to the

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 576667bad341516edc4e18eb85acb0a2b4c9c9d9 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 15 Jan 2021 18:19:06 +0200
Subject: xhci: make sure TRB is fully written before giving it to the
 controller

Once the command ring doorbell is rung the xHC controller will parse all
command TRBs on the command ring that have the cycle bit set properly.

If the driver just started writing the next command TRB to the ring when
hardware finished the previous TRB, then HW might fetch an incomplete TRB
as long as its cycle bit set correctly.

A command TRB is 16 bytes (128 bits) long.
Driver writes the command TRB in four 32 bit chunks, with the chunk
containing the cycle bit last. This does however not guarantee that
chunks actually get written in that order.

This was detected in stress testing when canceling URBs with several
connected USB devices.
Two consecutive "Set TR Dequeue pointer" commands got queued right
after each other, and the second one was only partially written when
the controller parsed it, causing the dequeue pointer to be set
to bogus values. This was seen as error messages:

"Mismatch between completed Set TR Deq Ptr command & xHCI internal state"

Solution is to add a write memory barrier before writing the cycle bit.

Cc: <stable@vger.kernel.org>
Tested-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210115161907.2875631-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5677b81c0915..cf0c93a90200 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2931,6 +2931,8 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
 	trb->field[0] = cpu_to_le32(field1);
 	trb->field[1] = cpu_to_le32(field2);
 	trb->field[2] = cpu_to_le32(field3);
+	/* make sure TRB is fully written before giving it to the controller */
+	wmb();
 	trb->field[3] = cpu_to_le32(field4);
 
 	trace_xhci_queue_trb(ring, trb);
-- 
2.30.0


