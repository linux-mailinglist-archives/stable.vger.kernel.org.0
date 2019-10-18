Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10BFDCED3
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443184AbfJRS6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 14:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfJRS6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 14:58:11 -0400
Received: from localhost (unknown [38.98.37.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5305820700;
        Fri, 18 Oct 2019 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571425090;
        bh=kkMxQpBF0wbqFv9262bbCHAd4JylpMZJm2wraa4dix8=;
        h=Subject:To:From:Date:From;
        b=OpPe/ypO8za7SgjFtwGM7XXD0zPwGz5p9xmKYSsS/IS35ohy/o1v31+5RPGmWp2r2
         wfCRKqI3r1pj7P6g0wql763sUl0SgOlZfwE7NrByMco6KAjXnC9Aib3M0yKNoQmnCl
         n1B7L8MAu+phvJhqyJzZyIn7LGvE9LXFjm0ZCwXM=
Subject: patch "USB: ldusb: fix read info leaks" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Oct 2019 11:57:52 -0700
Message-ID: <1571425072168120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: ldusb: fix read info leaks

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a6f22d7479b7a0b68eadd308a997dd64dda7dae Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 18 Oct 2019 17:19:54 +0200
Subject: USB: ldusb: fix read info leaks

Fix broken read implementation, which could be used to trigger slab info
leaks.

The driver failed to check if the custom ring buffer was still empty
when waking up after having waited for more data. This would happen on
every interrupt-in completion, even if no data had been added to the
ring buffer (e.g. on disconnect events).

Due to missing sanity checks and uninitialised (kmalloced) ring-buffer
entries, this meant that huge slab info leaks could easily be triggered.

Note that the empty-buffer check after wakeup is enough to fix the info
leak on disconnect, but let's clear the buffer on allocation and add a
sanity check to read() to prevent further leaks.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reported-by: syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191018151955.25135-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/ldusb.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 147c90c2a4e5..15b5f06fb0b3 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -464,7 +464,7 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 
 	/* wait for data */
 	spin_lock_irq(&dev->rbsl);
-	if (dev->ring_head == dev->ring_tail) {
+	while (dev->ring_head == dev->ring_tail) {
 		dev->interrupt_in_done = 0;
 		spin_unlock_irq(&dev->rbsl);
 		if (file->f_flags & O_NONBLOCK) {
@@ -474,12 +474,17 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 		retval = wait_event_interruptible(dev->read_wait, dev->interrupt_in_done);
 		if (retval < 0)
 			goto unlock_exit;
-	} else {
-		spin_unlock_irq(&dev->rbsl);
+
+		spin_lock_irq(&dev->rbsl);
 	}
+	spin_unlock_irq(&dev->rbsl);
 
 	/* actual_buffer contains actual_length + interrupt_in_buffer */
 	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
+	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
+		retval = -EIO;
+		goto unlock_exit;
+	}
 	bytes_to_read = min(count, *actual_buffer);
 	if (bytes_to_read < *actual_buffer)
 		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
@@ -690,10 +695,9 @@ static int ld_usb_probe(struct usb_interface *intf, const struct usb_device_id *
 		dev_warn(&intf->dev, "Interrupt out endpoint not found (using control endpoint instead)\n");
 
 	dev->interrupt_in_endpoint_size = usb_endpoint_maxp(dev->interrupt_in_endpoint);
-	dev->ring_buffer =
-		kmalloc_array(ring_buffer_size,
-			      sizeof(size_t) + dev->interrupt_in_endpoint_size,
-			      GFP_KERNEL);
+	dev->ring_buffer = kcalloc(ring_buffer_size,
+			sizeof(size_t) + dev->interrupt_in_endpoint_size,
+			GFP_KERNEL);
 	if (!dev->ring_buffer)
 		goto error;
 	dev->interrupt_in_buffer = kmalloc(dev->interrupt_in_endpoint_size, GFP_KERNEL);
-- 
2.23.0


