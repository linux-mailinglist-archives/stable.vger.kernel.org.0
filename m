Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE59CB7523
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbfISIa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:30:56 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34235 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387637AbfISIa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:30:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id j19so1193046lja.1;
        Thu, 19 Sep 2019 01:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOw3dGTcmm1iVIPl96Li1eNYVJdVoD8Cu2D+Apy5uOg=;
        b=VSXQm9rq2kEK26jy2gQMIrrjT+odDFyLBS05gM1R5FiDdWS5GMoYPYmNYA/g7o6oUZ
         zeFQJ8h9R4C6jxm2K0yfuImkO1mFS1NtImhkFA/29TEi3zkjI8WnnmzhBb5NBpQBn1WE
         9BKqZDAr7IQn9e3TEGshmvFA3zeoN5xLUf3J1pI0MTpPLeTnoq2AwtOxcLJfu9Efo4FR
         yW5Po6fbIOEB+kTZe40zLtRlhdBMPuEfSMKGe9MHMw6TQXUzJNJl6c2McZODB4t2VTcT
         ia53DhN1V2S5AmCWEMMhSJs/7pJqoFF4PpdDv3UuADO2UzEGlnhzTTUuMFUCEd6Zdl79
         LTVQ==
X-Gm-Message-State: APjAAAXwxM39orcJeRi0EA60QnqkNyG9A7y8ajwnCbHudnoib7A2kb/6
        s8VAYyPF4+uOmWvsDpb2ejg=
X-Google-Smtp-Source: APXvYqyWIQSjgHJuF5c2hJ/3S2Ghl17fi3f0cHmK25IEM9SRVN/sidVhGNKafEmPovwDTH1UmCxdHA==
X-Received: by 2002:a2e:9cd3:: with SMTP id g19mr4730157ljj.150.1568881852452;
        Thu, 19 Sep 2019 01:30:52 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id q19sm1636171lfj.9.2019.09.19.01.30.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:30:50 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iArpx-00083N-Rp; Thu, 19 Sep 2019 10:30:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        legousb-devel@lists.sourceforge.net,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH RESEND 3/4] USB: legousbtower: fix potential NULL-deref on disconnect
Date:   Thu, 19 Sep 2019 10:30:38 +0200
Message-Id: <20190919083039.30898-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919083039.30898-1-johan@kernel.org>
References: <20190919083039.30898-1-johan@kernel.org>
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

