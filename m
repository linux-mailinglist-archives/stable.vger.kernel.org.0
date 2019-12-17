Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2412200B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLQAvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35170 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbfLQAvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Ma-Hq; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005ZH-IB; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Tue, 17 Dec 2019 00:46:53 +0000
Message-ID: <lsq.1576543535.380206351@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 079/136] USB: ldusb: fix read info leaks
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7a6f22d7479b7a0b68eadd308a997dd64dda7dae upstream.

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
Reported-by: syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191018151955.25135-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -478,7 +478,7 @@ static ssize_t ld_usb_read(struct file *
 
 	/* wait for data */
 	spin_lock_irq(&dev->rbsl);
-	if (dev->ring_head == dev->ring_tail) {
+	while (dev->ring_head == dev->ring_tail) {
 		dev->interrupt_in_done = 0;
 		spin_unlock_irq(&dev->rbsl);
 		if (file->f_flags & O_NONBLOCK) {
@@ -488,12 +488,17 @@ static ssize_t ld_usb_read(struct file *
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
 	actual_buffer = (size_t*)(dev->ring_buffer + dev->ring_tail*(sizeof(size_t)+dev->interrupt_in_endpoint_size));
+	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
+		retval = -EIO;
+		goto unlock_exit;
+	}
 	bytes_to_read = min(count, *actual_buffer);
 	if (bytes_to_read < *actual_buffer)
 		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
@@ -713,7 +718,9 @@ static int ld_usb_probe(struct usb_inter
 		dev_warn(&intf->dev, "Interrupt out endpoint not found (using control endpoint instead)\n");
 
 	dev->interrupt_in_endpoint_size = usb_endpoint_maxp(dev->interrupt_in_endpoint);
-	dev->ring_buffer = kmalloc(ring_buffer_size*(sizeof(size_t)+dev->interrupt_in_endpoint_size), GFP_KERNEL);
+	dev->ring_buffer = kcalloc(ring_buffer_size,
+			sizeof(size_t) + dev->interrupt_in_endpoint_size,
+			GFP_KERNEL);
 	if (!dev->ring_buffer) {
 		dev_err(&intf->dev, "Couldn't allocate ring_buffer\n");
 		goto error;

