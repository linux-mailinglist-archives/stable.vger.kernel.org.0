Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF429131D2
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfECQFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfECQFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 12:05:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887742087F;
        Fri,  3 May 2019 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556899550;
        bh=xfK46XlQLC7xqwYIw++KdFGNSHB90YvO0B2+EMtFSoY=;
        h=Subject:To:From:Date:From;
        b=CVdYUnJfaaQ6pnzUwzYSGYRpbKjO02T9TBX7TWWeXogCe6RWfTs6uN/+jUmLK5cj/
         crLn5iNzlgMuNbK2Wo+RbJFdOaw4WB49n5eG6E/iet4kDXVXnI6fEOCslnPOsGa+gU
         DhrcTZFz9KiygXacn+01QqCEV98Jo5GU2IN4dTYM=
Subject: patch "USB: dummy-hcd: Fix failure to give back unlinked URBs" added to usb-testing
To:     stern@rowland.harvard.edu, felipe.balbi@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 May 2019 18:05:45 +0200
Message-ID: <155689954515691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: dummy-hcd: Fix failure to give back unlinked URBs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 50896c410354432e8e7baf97fcdd7df265e683ae Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 18 Apr 2019 13:12:07 -0400
Subject: USB: dummy-hcd: Fix failure to give back unlinked URBs

The syzkaller USB fuzzer identified a failure mode in which dummy-hcd
would never give back an unlinked URB.  This causes usb_kill_urb() to
hang, leading to WARNINGs and unkillable threads.

In dummy-hcd, all URBs are given back by the dummy_timer() routine as
it scans through the list of pending URBS.  Failure to give back URBs
can be caused by failure to start or early exit from the scanning
loop.  The code currently has two such pathways: One is triggered when
an unsupported bus transfer speed is encountered, and the other by
exhausting the simulated bandwidth for USB transfers during a frame.

This patch removes those two paths, thereby allowing all unlinked URBs
to be given back in a timely manner.  It adds a check for the bus
speed when the gadget first starts running, so that dummy_timer() will
never thereafter encounter an unsupported speed.  And it prevents the
loop from exiting as soon as the total bandwidth has been used up (the
scanning loop continues, giving back unlinked URBs as they are found,
but not transferring any more data).

Thanks to Andrey Konovalov for manually running the syzkaller fuzzer
to help track down the source of the bug.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+d919b0f29d7b5a4994b9@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index baf72f95f0f1..213b52508621 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -979,8 +979,18 @@ static int dummy_udc_start(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	if (driver->max_speed == USB_SPEED_UNKNOWN)
+	switch (g->speed) {
+	/* All the speeds we support */
+	case USB_SPEED_LOW:
+	case USB_SPEED_FULL:
+	case USB_SPEED_HIGH:
+	case USB_SPEED_SUPER:
+		break;
+	default:
+		dev_err(dummy_dev(dum_hcd), "Unsupported driver max speed %d\n",
+				driver->max_speed);
 		return -EINVAL;
+	}
 
 	/*
 	 * SLAVE side init ... the layer above hardware, which
@@ -1784,9 +1794,10 @@ static void dummy_timer(struct timer_list *t)
 		/* Bus speed is 500000 bytes/ms, so use a little less */
 		total = 490000;
 		break;
-	default:
+	default:	/* Can't happen */
 		dev_err(dummy_dev(dum_hcd), "bogus device speed\n");
-		return;
+		total = 0;
+		break;
 	}
 
 	/* FIXME if HZ != 1000 this will probably misbehave ... */
@@ -1828,7 +1839,7 @@ static void dummy_timer(struct timer_list *t)
 
 		/* Used up this frame's bandwidth? */
 		if (total <= 0)
-			break;
+			continue;
 
 		/* find the gadget's ep for this request (if configured) */
 		address = usb_pipeendpoint (urb->pipe);
-- 
2.21.0


