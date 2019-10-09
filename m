Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF7D130E
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbfJIPi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 11:38:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40881 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJIPi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 11:38:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so2968341ljw.7;
        Wed, 09 Oct 2019 08:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IOgY95F7SAkBcHWELp/HRRu/NsS+nMHwkVpkJBv5wWE=;
        b=gwdfM9lgYXWZ9c0oGJkSqcAdPGSeAM765ziwd/fBKIQN3JxUCigt85/jdMON/wzR4Y
         lKowiiVfK8VJE7jHukkvOgUGOuw9xMm+B/vgpO9Q9i3tBVINkJXva7YQ3qbKyaWcKuUu
         jZc2iHZYv2m0oHC41hHUg6OvplpzlWCmHlW2tBJGlkDZrnGh0zwXV8aBa2JFn1/bVhkB
         j7iVo3c3Aw2bovJpMvGY+d8QQJL/R1kEPzpPq6arFPRoRjKqRfvHMJY1GXlo3I14H2d2
         6QNMKzWhs7VnGXpC7E1QbWcLKccZpBRg7MyVxfjNzYOn8imOPgijS2uos7pnTHbejvWO
         +RyA==
X-Gm-Message-State: APjAAAUYCTW6SMGAUpisCnrW7syQw0tEkh7wHWi2fyGf1ttYRiWfs60G
        e3Nv6wCZN2HaD2+eo1vgY31m6gQA
X-Google-Smtp-Source: APXvYqyMxaLW2Wi4wqJjBUSaLG5bnSH9nJEALMC9vUhlvUISqd2iZss3Ar56VxVWpM+LKv4kxaxGyQ==
X-Received: by 2002:a2e:a0d6:: with SMTP id f22mr2836942ljm.81.1570635533896;
        Wed, 09 Oct 2019 08:38:53 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id y204sm593197lfa.64.2019.10.09.08.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:38:51 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIE3J-0002H2-Fl; Wed, 09 Oct 2019 17:39:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/5] USB: ldusb: fix NULL-derefs on driver unbind
Date:   Wed,  9 Oct 2019 17:38:46 +0200
Message-Id: <20191009153848.8664-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009153848.8664-1-johan@kernel.org>
References: <20191009153848.8664-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was using its struct usb_interface pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg, dev_warn and dev_err statements in
the completion handlers which relies on said pointer.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/ldusb.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 6581774bdfa4..f3108d85e768 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -153,6 +153,7 @@ MODULE_PARM_DESC(min_interrupt_out_interval, "Minimum interrupt out interval in
 struct ld_usb {
 	struct mutex		mutex;		/* locks this structure */
 	struct usb_interface	*intf;		/* save off the usb interface pointer */
+	unsigned long		disconnected:1;
 
 	int			open_count;	/* number of times this port has been opened */
 
@@ -192,12 +193,10 @@ static void ld_usb_abort_transfers(struct ld_usb *dev)
 	/* shutdown transfer */
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running = 0;
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
 	if (dev->interrupt_out_busy)
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_out_urb);
+		usb_kill_urb(dev->interrupt_out_urb);
 }
 
 /**
@@ -205,8 +204,6 @@ static void ld_usb_abort_transfers(struct ld_usb *dev)
  */
 static void ld_usb_delete(struct ld_usb *dev)
 {
-	ld_usb_abort_transfers(dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -263,7 +260,7 @@ static void ld_usb_interrupt_in_callback(struct urb *urb)
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && !dev->buffer_overflow && dev->intf) {
+	if (dev->interrupt_in_running && !dev->buffer_overflow) {
 		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval) {
 			dev_err(&dev->intf->dev,
@@ -392,7 +389,7 @@ static int ld_usb_release(struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		mutex_unlock(&dev->mutex);
 		/* unlock here as ld_usb_delete frees dev */
@@ -423,7 +420,7 @@ static __poll_t ld_usb_poll(struct file *file, poll_table *wait)
 
 	dev = file->private_data;
 
-	if (!dev->intf)
+	if (dev->disconnected)
 		return EPOLLERR | EPOLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -462,7 +459,7 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -542,7 +539,7 @@ static ssize_t ld_usb_write(struct file *file, const char __user *buffer,
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -764,6 +761,9 @@ static void ld_usb_disconnect(struct usb_interface *intf)
 	/* give back our minor */
 	usb_deregister_dev(intf, &ld_usb_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->mutex);
 
 	/* if the device is not opened, then we clean up right now */
@@ -771,7 +771,7 @@ static void ld_usb_disconnect(struct usb_interface *intf)
 		mutex_unlock(&dev->mutex);
 		ld_usb_delete(dev);
 	} else {
-		dev->intf = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
-- 
2.23.0

