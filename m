Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36DE1F44A2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbgFISGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41766 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388201AbgFISGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:06:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oi-F7; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006VvJ-N4; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "" <stable@vger.kernel.org>
Date:   Tue, 09 Jun 2020 19:04:09 +0100
Message-ID: <lsq.1591725832.400889348@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 18/61] USB: core: Fix free-while-in-use bug in the
 USB S-Glibrary
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 056ad39ee9253873522f6469c3364964a322912b upstream.

FuzzUSB (a variant of syzkaller) found a free-while-still-in-use bug
in the USB scatter-gather library:

BUG: KASAN: use-after-free in atomic_read
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in usb_hcd_unlink_urb+0x5f/0x170
drivers/usb/core/hcd.c:1607
Read of size 4 at addr ffff888065379610 by task kworker/u4:1/27

CPU: 1 PID: 27 Comm: kworker/u4:1 Not tainted 5.5.11 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1ubuntu1 04/01/2014
Workqueue: scsi_tmf_2 scmd_eh_abort_handler
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xce/0x128 lib/dump_stack.c:118
 print_address_description.constprop.4+0x21/0x3c0 mm/kasan/report.c:374
 __kasan_report+0x153/0x1cb mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x152/0x1b0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
 usb_hcd_unlink_urb+0x5f/0x170 drivers/usb/core/hcd.c:1607
 usb_unlink_urb+0x72/0xb0 drivers/usb/core/urb.c:657
 usb_sg_cancel+0x14e/0x290 drivers/usb/core/message.c:602
 usb_stor_stop_transport+0x5e/0xa0 drivers/usb/storage/transport.c:937

This bug occurs when cancellation of the S-G transfer races with
transfer completion.  When that happens, usb_sg_cancel() may continue
to access the transfer's URBs after usb_sg_wait() has freed them.

The bug is caused by the fact that usb_sg_cancel() does not take any
sort of reference to the transfer, and so there is nothing to prevent
the URBs from being deallocated while the routine is trying to use
them.  The fix is to take such a reference by incrementing the
transfer's io->count field while the cancellation is in progres and
decrementing it afterward.  The transfer's URBs are not deallocated
until io->complete is triggered, which happens when io->count reaches
zero.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Kyungtae Kim <kt0755@gmail.com>
CC: <stable@vger.kernel.org>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2003281615140.14837-100000@netrider.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/message.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -584,12 +584,13 @@ void usb_sg_cancel(struct usb_sg_request
 	int i, retval;
 
 	spin_lock_irqsave(&io->lock, flags);
-	if (io->status) {
+	if (io->status || io->count == 0) {
 		spin_unlock_irqrestore(&io->lock, flags);
 		return;
 	}
 	/* shut everything down */
 	io->status = -ECONNRESET;
+	io->count++;		/* Keep the request alive until we're done */
 	spin_unlock_irqrestore(&io->lock, flags);
 
 	for (i = io->entries - 1; i >= 0; --i) {
@@ -603,6 +604,12 @@ void usb_sg_cancel(struct usb_sg_request
 			dev_warn(&io->dev->dev, "%s, unlink --> %d\n",
 				 __func__, retval);
 	}
+
+	spin_lock_irqsave(&io->lock, flags);
+	io->count--;
+	if (!io->count)
+		complete(&io->complete);
+	spin_unlock_irqrestore(&io->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_sg_cancel);
 

