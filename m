Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA271BC9E9
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgD1Sne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731250AbgD1Snd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91370206D6;
        Tue, 28 Apr 2020 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099413;
        bh=btMmoRmbm0aFeh7V8QPWVWglOxt22/y9OzCifBjnb+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOctV5R6rnpzMMnvQuNMuKxNshaZTr3HvncHnQ5dULXDfaY1FSlCNnFdRBnjjyNqA
         2mxAXmMI14LP3oxGDnBSQTBUlQYc0WnKELkTMZfXk6aess1IwmHNQRlBYQ5saWj0Mz
         ULdsQxesyvvRrBwq3tgj/WvZCRs+/ofRjjlgvE34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Kyungtae Kim <kt0755@gmail.com>
Subject: [PATCH 5.4 098/168] USB: core: Fix free-while-in-use bug in the USB S-Glibrary
Date:   Tue, 28 Apr 2020 20:24:32 +0200
Message-Id: <20200428182244.742339543@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
 drivers/usb/core/message.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -588,12 +588,13 @@ void usb_sg_cancel(struct usb_sg_request
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
@@ -607,6 +608,12 @@ void usb_sg_cancel(struct usb_sg_request
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
 


