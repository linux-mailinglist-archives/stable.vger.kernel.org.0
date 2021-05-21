Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5520138C674
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhEUM1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232820AbhEUM1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5666108B;
        Fri, 21 May 2021 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621599977;
        bh=lBl8OI2qUbmeyobk00PDOPtfn8qtMX/wy+ubtSEIWgY=;
        h=Subject:To:From:Date:From;
        b=qJCbwKxt4vOfNZrWuGyiTfK3XR+w+vGcwEe8koOOF4Iw3mGfwXqRBQzcC1HMfC/ry
         VbzVaK9NaNHXFmnUKGMrjkHBzl/7RA/v+RG/RVwu5QRkzs2mqsRQ8IlVEKLeNgBk9V
         iun2XCYR87JQYhcxPFyHmWSAhrj38uJG81ze/CB0=
Subject: patch "USB: usbfs: Don't WARN about excessively large memory allocations" added to usb-linus
To:     stern@rowland.harvard.edu, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:26:15 +0200
Message-ID: <162159997575179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usbfs: Don't WARN about excessively large memory allocations

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4f2629ea67e7225c3fd292c7fe4f5b3c9d6392de Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 18 May 2021 16:18:35 -0400
Subject: USB: usbfs: Don't WARN about excessively large memory allocations

Syzbot found that the kernel generates a WARNing if the user tries to
submit a bulk transfer through usbfs with a buffer that is way too
large.  This isn't a bug in the kernel; it's merely an invalid request
from the user and the usbfs code does handle it correctly.

In theory the same thing can happen with async transfers, or with the
packet descriptor table for isochronous transfers.

To prevent the MM subsystem from complaining about these bad
allocation requests, add the __GFP_NOWARN flag to the kmalloc calls
for these buffers.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+882a85c0c8ec4a3e2281@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210518201835.GA1140918@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 533236366a03..2218941d35a3 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1218,7 +1218,12 @@ static int do_proc_bulk(struct usb_dev_state *ps,
 	ret = usbfs_increase_memory_usage(len1 + sizeof(struct urb));
 	if (ret)
 		return ret;
-	tbuf = kmalloc(len1, GFP_KERNEL);
+
+	/*
+	 * len1 can be almost arbitrarily large.  Don't WARN if it's
+	 * too big, just fail the request.
+	 */
+	tbuf = kmalloc(len1, GFP_KERNEL | __GFP_NOWARN);
 	if (!tbuf) {
 		ret = -ENOMEM;
 		goto done;
@@ -1696,7 +1701,7 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 	if (num_sgs) {
 		as->urb->sg = kmalloc_array(num_sgs,
 					    sizeof(struct scatterlist),
-					    GFP_KERNEL);
+					    GFP_KERNEL | __GFP_NOWARN);
 		if (!as->urb->sg) {
 			ret = -ENOMEM;
 			goto error;
@@ -1731,7 +1736,7 @@ static int proc_do_submiturb(struct usb_dev_state *ps, struct usbdevfs_urb *uurb
 					(uurb_start - as->usbm->vm_start);
 		} else {
 			as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
-					GFP_KERNEL);
+					GFP_KERNEL | __GFP_NOWARN);
 			if (!as->urb->transfer_buffer) {
 				ret = -ENOMEM;
 				goto error;
-- 
2.31.1


