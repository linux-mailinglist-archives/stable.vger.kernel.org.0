Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D94A636F
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiBASRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50914 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiBASRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C636CE1A60;
        Tue,  1 Feb 2022 18:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644CCC340EC;
        Tue,  1 Feb 2022 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739426;
        bh=33h7VBUyIm5zQzYADCSmeBzNWKBmBLqu5CMgNceDrso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWm6xbVexhKhoCn95YLz5/IoW7Jph3pwUJafo98l1rad5hluqPcCkRFNo2QAaShxM
         DK3GNGsGIoULYunI3qlraMPtu0oWjZqIko30ybpYmb23P+0KNBxX3fytPv7c/wufYW
         XPtgHCM61WqhmN5g05WFEsc7geRKmZCJd2bm9Ju4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+76629376e06e2c2ad626@syzkaller.appspotmail.com
Subject: [PATCH 4.4 12/25] USB: core: Fix hang in usb_kill_urb by adding memory barriers
Date:   Tue,  1 Feb 2022 19:16:36 +0100
Message-Id: <20220201180822.549390207@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 26fbe9772b8c459687930511444ce443011f86bf upstream.

The syzbot fuzzer has identified a bug in which processes hang waiting
for usb_kill_urb() to return.  It turns out the issue is not unlinking
the URB; that works just fine.  Rather, the problem arises when the
wakeup notification that the URB has completed is not received.

The reason is memory-access ordering on SMP systems.  In outline form,
usb_kill_urb() and __usb_hcd_giveback_urb() operating concurrently on
different CPUs perform the following actions:

CPU 0					CPU 1
----------------------------		---------------------------------
usb_kill_urb():				__usb_hcd_giveback_urb():
  ...					  ...
  atomic_inc(&urb->reject);		  atomic_dec(&urb->use_count);
  ...					  ...
  wait_event(usb_kill_urb_queue,
	atomic_read(&urb->use_count) == 0);
					  if (atomic_read(&urb->reject))
						wake_up(&usb_kill_urb_queue);

Confining your attention to urb->reject and urb->use_count, you can
see that the overall pattern of accesses on CPU 0 is:

	write urb->reject, then read urb->use_count;

whereas the overall pattern of accesses on CPU 1 is:

	write urb->use_count, then read urb->reject.

This pattern is referred to in memory-model circles as SB (for "Store
Buffering"), and it is well known that without suitable enforcement of
the desired order of accesses -- in the form of memory barriers -- it
is entirely possible for one or both CPUs to execute their reads ahead
of their writes.  The end result will be that sometimes CPU 0 sees the
old un-decremented value of urb->use_count while CPU 1 sees the old
un-incremented value of urb->reject.  Consequently CPU 0 ends up on
the wait queue and never gets woken up, leading to the observed hang
in usb_kill_urb().

The same pattern of accesses occurs in usb_poison_urb() and the
failure pathway of usb_hcd_submit_urb().

The problem is fixed by adding suitable memory barriers.  To provide
proper memory-access ordering in the SB pattern, a full barrier is
required on both CPUs.  The atomic_inc() and atomic_dec() accesses
themselves don't provide any memory ordering, but since they are
present, we can use the optimized smp_mb__after_atomic() memory
barrier in the various routines to obtain the desired effect.

This patch adds the necessary memory barriers.

CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+76629376e06e2c2ad626@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/Ye8K0QYee0Q0Nna2@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |   14 ++++++++++++++
 drivers/usb/core/urb.c |   12 ++++++++++++
 2 files changed, 26 insertions(+)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1642,6 +1642,13 @@ int usb_hcd_submit_urb (struct urb *urb,
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
+		/*
+		 * Order the write of urb->use_count above before the read
+		 * of urb->reject below.  Pairs with the memory barriers in
+		 * usb_kill_urb() and usb_poison_urb().
+		 */
+		smp_mb__after_atomic();
+
 		atomic_dec(&urb->dev->urbnum);
 		if (atomic_read(&urb->reject))
 			wake_up(&usb_kill_urb_queue);
@@ -1751,6 +1758,13 @@ static void __usb_hcd_giveback_urb(struc
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
+	/*
+	 * Order the write of urb->use_count above before the read
+	 * of urb->reject below.  Pairs with the memory barriers in
+	 * usb_kill_urb() and usb_poison_urb().
+	 */
+	smp_mb__after_atomic();
+
 	if (unlikely(atomic_read(&urb->reject)))
 		wake_up(&usb_kill_urb_queue);
 	usb_put_urb(urb);
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -686,6 +686,12 @@ void usb_kill_urb(struct urb *urb)
 	if (!(urb && urb->dev && urb->ep))
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	usb_hcd_unlink_urb(urb, -ENOENT);
 	wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
@@ -727,6 +733,12 @@ void usb_poison_urb(struct urb *urb)
 	if (!urb)
 		return;
 	atomic_inc(&urb->reject);
+	/*
+	 * Order the write of urb->reject above before the read
+	 * of urb->use_count below.  Pairs with the barriers in
+	 * __usb_hcd_giveback_urb() and usb_hcd_submit_urb().
+	 */
+	smp_mb__after_atomic();
 
 	if (!urb->dev || !urb->ep)
 		return;


