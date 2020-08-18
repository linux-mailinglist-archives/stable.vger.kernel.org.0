Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FB4248253
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRJzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRJzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:55:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1ED4206B5;
        Tue, 18 Aug 2020 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744520;
        bh=CWV8qKqmg4/yZ7b/ssYmI+NKnTUM3pt0+7XKWgSKpRg=;
        h=Subject:To:From:Date:From;
        b=2bsL40gOoga8UxKHtqdV/7xBFvCG2KZY2CMej7YDahbeZjRWhzcLfX9E+XQ8j0sSH
         GlNnx5zlPOoEzuxmhq/i66u2DHjGVjsHV5Em/Wfe8JVpvP/+l3Z1GeSpAyg23AXRwJ
         QxiE7wgJDLqZgnpMBzHHXc7tYiyv9Z+bGzRRj1rA=
Subject: patch "USB: cdc-acm: rework notification_buffer resizing" added to usb-linus
To:     trix@redhat.com, gregkh@linuxfoundation.org, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 11:55:42 +0200
Message-ID: <1597744542124212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: rework notification_buffer resizing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f4b9d8a582f738c24ebeabce5cc15f4b8159d74e Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Sat, 1 Aug 2020 08:21:54 -0700
Subject: USB: cdc-acm: rework notification_buffer resizing

Clang static analysis reports this error

cdc-acm.c:409:3: warning: Use of memory after it is freed
        acm_process_notification(acm, (unsigned char *)dr);

There are three problems, the first one is that dr is not reset

The variable dr is set with

if (acm->nb_index)
	dr = (struct usb_cdc_notification *)acm->notification_buffer;

But if the notification_buffer is too small it is resized with

		if (acm->nb_size) {
			kfree(acm->notification_buffer);
			acm->nb_size = 0;
		}
		alloc_size = roundup_pow_of_two(expected_size);
		/*
		 * kmalloc ensures a valid notification_buffer after a
		 * use of kfree in case the previous allocation was too
		 * small. Final freeing is done on disconnect.
		 */
		acm->notification_buffer =
			kmalloc(alloc_size, GFP_ATOMIC);

dr should point to the new acm->notification_buffer.

The second problem is any data in the notification_buffer is lost
when the pointer is freed.  In the normal case, the current data
is accumulated in the notification_buffer here.

	memcpy(&acm->notification_buffer[acm->nb_index],
	       urb->transfer_buffer, copy_size);

When a resize happens, anything before
notification_buffer[acm->nb_index] is garbage.

The third problem is the acm->nb_index is not reset on a
resizing buffer error.

So switch resizing to using krealloc and reassign dr and
reset nb_index.

Fixes: ea2583529cd1 ("cdc-acm: reassemble fragmented notifications")
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20200801152154.20683-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 991786876dbb..7f6f3ab5b8a6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -378,21 +378,19 @@ static void acm_ctrl_irq(struct urb *urb)
 	if (current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
-			if (acm->nb_size) {
-				kfree(acm->notification_buffer);
-				acm->nb_size = 0;
-			}
+			u8 *new_buffer;
 			alloc_size = roundup_pow_of_two(expected_size);
-			/*
-			 * kmalloc ensures a valid notification_buffer after a
-			 * use of kfree in case the previous allocation was too
-			 * small. Final freeing is done on disconnect.
-			 */
-			acm->notification_buffer =
-				kmalloc(alloc_size, GFP_ATOMIC);
-			if (!acm->notification_buffer)
+			/* Final freeing is done on disconnect. */
+			new_buffer = krealloc(acm->notification_buffer,
+					      alloc_size, GFP_ATOMIC);
+			if (!new_buffer) {
+				acm->nb_index = 0;
 				goto exit;
+			}
+
+			acm->notification_buffer = new_buffer;
 			acm->nb_size = alloc_size;
+			dr = (struct usb_cdc_notification *)acm->notification_buffer;
 		}
 
 		copy_size = min(current_size,
-- 
2.28.0


