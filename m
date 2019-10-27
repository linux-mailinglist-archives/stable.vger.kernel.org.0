Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC038E6593
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfJ0VDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbfJ0VDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:03:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8459F214AF;
        Sun, 27 Oct 2019 21:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210199;
        bh=tuhyo/2kQiRB6FSbrrp9sXMYQnq1MqaAaocMivwBshc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qycvo6BnLREkL0LxhW8qW3furPvqzmj8V3ICHWHWNh3fBsOrPGZkqoEPlNQj3mIXP
         GdZ/5a4x5yQXQR6LapDMcQTMiAzOPRMpCQ/GgfGef8Kb99ZFP6n0XSugEaEX4YrFiV
         9S4VQ2gLP3so/nxHsSFZHaPjmiLIXfAQOyz+Gxwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 24/41] USB: ldusb: fix read info leaks
Date:   Sun, 27 Oct 2019 22:01:02 +0100
Message-Id: <20191027203119.576856555@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reported-by: syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191018151955.25135-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/ldusb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -468,7 +468,7 @@ static ssize_t ld_usb_read(struct file *
 
 	/* wait for data */
 	spin_lock_irq(&dev->rbsl);
-	if (dev->ring_head == dev->ring_tail) {
+	while (dev->ring_head == dev->ring_tail) {
 		dev->interrupt_in_done = 0;
 		spin_unlock_irq(&dev->rbsl);
 		if (file->f_flags & O_NONBLOCK) {
@@ -478,12 +478,17 @@ static ssize_t ld_usb_read(struct file *
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
@@ -703,7 +708,9 @@ static int ld_usb_probe(struct usb_inter
 		dev_warn(&intf->dev, "Interrupt out endpoint not found (using control endpoint instead)\n");
 
 	dev->interrupt_in_endpoint_size = usb_endpoint_maxp(dev->interrupt_in_endpoint);
-	dev->ring_buffer = kmalloc(ring_buffer_size*(sizeof(size_t)+dev->interrupt_in_endpoint_size), GFP_KERNEL);
+	dev->ring_buffer = kcalloc(ring_buffer_size,
+			sizeof(size_t) + dev->interrupt_in_endpoint_size,
+			GFP_KERNEL);
 	if (!dev->ring_buffer) {
 		dev_err(&intf->dev, "Couldn't allocate ring_buffer\n");
 		goto error;


