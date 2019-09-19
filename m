Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629E7B74FB
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbfISISn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:18:43 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37593 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbfISISn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:18:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id l21so2654950lje.4;
        Thu, 19 Sep 2019 01:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOw3dGTcmm1iVIPl96Li1eNYVJdVoD8Cu2D+Apy5uOg=;
        b=Sp2qkjnMRrLkDlwRNIpk93U/EXHfN2UvnOilnFjVBfuVRCzqL8zV2M7Wi226v7bs/3
         8kgu1duRykp9N7eUHI1A3YFuqxcOTXF8vEfDwPrJhN4NEv6LNST4kmjBqX5dXmn6UXfK
         L9If+xOwYn+O3K4kS1p+iHe3y+AMbQ1k46atz10Pg05JGBFNoPsi46sNh93zWx0s1ydT
         82PZEQq9YIFaVNUehOEarAwoDoGijwXS7p2krHhM7fka9OfSlKQ9thv4g/WXeUHQgYMb
         WgS+vmQwlh7OF7cUizqS9uMTlP1YlV79t1+5Y/DQuhfHeads1wOEzl786SF7cu8jzqiV
         eBCw==
X-Gm-Message-State: APjAAAUvHT//llhZbMIOXwGa52/j5uWG7Ml8ALK/nXSong+0hzb4TMlv
        RTXpt9mu4hmKwvR2az93KIA=
X-Google-Smtp-Source: APXvYqyl9IBLYWk7cwMlWNYx+QovpnWMo+tlIMGgaAy3T26qh2BG6+Pq5zb4+dR2N/mcN8WzHvF8Gg==
X-Received: by 2002:a2e:9586:: with SMTP id w6mr4409130ljh.47.1568881118946;
        Thu, 19 Sep 2019 01:18:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id r75sm1419504lff.7.2019.09.19.01.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:18:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iAre8-0007vj-RR; Thu, 19 Sep 2019 10:18:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/4] USB: legousbtower: fix potential NULL-deref on disconnect
Date:   Thu, 19 Sep 2019 10:18:14 +0200
Message-Id: <20190919081815.30422-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919081815.30422-1-johan@kernel.org>
References: <20190919081815.30422-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver is using its struct usb_device pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg and dev_err statements in the
completion handlers which relies on said pointer.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 9d974b2a06e3 ("USB: legousbtower.c: remove err() usage")
Fixes: fef526cae700 ("USB: legousbtower: remove custom debug macro")
Fixes: 4dae99638097 ("USB: legotower: remove custom debug macro and module parameter")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/legousbtower.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 773e4188f336..4fa999882635 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -190,6 +190,7 @@ struct lego_usb_tower {
 	unsigned char		minor;		/* the starting minor number for this device */
 
 	int			open_count;	/* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char*			read_buffer;
 	size_t			read_buffer_length; /* this much came in */
@@ -289,8 +290,6 @@ static inline void lego_usb_tower_debug_data(struct device *dev,
  */
 static inline void tower_delete (struct lego_usb_tower *dev)
 {
-	tower_abort_transfers (dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -430,7 +429,8 @@ static int tower_release (struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->udev == NULL) {
+
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 
 		/* unlock here as tower_delete frees dev */
@@ -466,10 +466,9 @@ static void tower_abort_transfers (struct lego_usb_tower *dev)
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running = 0;
 		mb();
-		if (dev->udev)
-			usb_kill_urb (dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
-	if (dev->interrupt_out_busy && dev->udev)
+	if (dev->interrupt_out_busy)
 		usb_kill_urb(dev->interrupt_out_urb);
 }
 
@@ -505,7 +504,7 @@ static __poll_t tower_poll (struct file *file, poll_table *wait)
 
 	dev = file->private_data;
 
-	if (!dev->udev)
+	if (dev->disconnected)
 		return EPOLLERR | EPOLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -552,7 +551,7 @@ static ssize_t tower_read (struct file *file, char __user *buffer, size_t count,
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -638,7 +637,7 @@ static ssize_t tower_write (struct file *file, const char __user *buffer, size_t
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -748,7 +747,7 @@ static void tower_interrupt_in_callback (struct urb *urb)
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && dev->udev) {
+	if (dev->interrupt_in_running) {
 		retval = usb_submit_urb (dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval)
 			dev_err(&dev->udev->dev,
@@ -813,6 +812,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 
 	dev->udev = udev;
 	dev->open_count = 0;
+	dev->disconnected = 0;
 
 	dev->read_buffer = NULL;
 	dev->read_buffer_length = 0;
@@ -938,6 +938,10 @@ static void tower_disconnect (struct usb_interface *interface)
 	/* give back our minor and prevent further open() */
 	usb_deregister_dev (interface, &tower_class);
 
+	/* stop I/O */
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->lock);
 
 	/* if the device is not opened, then we clean up right now */
@@ -945,7 +949,7 @@ static void tower_disconnect (struct usb_interface *interface)
 		mutex_unlock(&dev->lock);
 		tower_delete (dev);
 	} else {
-		dev->udev = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
-- 
2.23.0

