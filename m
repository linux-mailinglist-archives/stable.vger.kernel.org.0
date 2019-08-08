Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDE86049
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbfHHKn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 06:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbfHHKn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 06:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358062084D;
        Thu,  8 Aug 2019 10:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565261007;
        bh=njdDYQdbblAsY+EAzZlJvU5Pep8o85Nomejto1bRD7Q=;
        h=Subject:To:From:Date:From;
        b=Ah2SMZeZSY3GKlTwYgN4lg38tywrSE5XBhAnGP4aH8knDC/lDzcOCk+IB0KSBXt/s
         EB0oLy4rLt2LQWoW/hDPxF8MGB3c+s4TD0g81QfmiuNzfGVD3RMUnMj+px3vpGA2aI
         BMH4gD8OkSC7Lw2LkEF+D5Akce5G/WeRcqNMaTq0=
Subject: patch "Revert "USB: rio500: simplify locking"" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Aug 2019 12:43:25 +0200
Message-ID: <1565261005779@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "USB: rio500: simplify locking"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2ca359f4f8b954b3a9d15a89f22a8b7283e7669f Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 8 Aug 2019 11:28:54 +0200
Subject: Revert "USB: rio500: simplify locking"

This reverts commit d710734b06770814de2bfa2819420fb5df7f3a81.
This simplification causes a deadlock.

Reported-by: syzbot+7bbcbe9c9ff0cd49592a@syzkaller.appspotmail.com
Fixes: d710734b0677 ("USB: rio500: simplify locking")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808092854.23519-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/rio500.c | 43 ++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 27e9c78a791e..a32d61a79ab8 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -51,6 +51,7 @@ struct rio_usb_data {
         char *obuf, *ibuf;              /* transfer buffers */
         char bulk_in_ep, bulk_out_ep;   /* Endpoint assignments */
         wait_queue_head_t wait_q;       /* for timeouts */
+	struct mutex lock;          /* general race avoidance */
 };
 
 static DEFINE_MUTEX(rio500_mutex);
@@ -62,8 +63,10 @@ static int open_rio(struct inode *inode, struct file *file)
 
 	/* against disconnect() */
 	mutex_lock(&rio500_mutex);
+	mutex_lock(&(rio->lock));
 
 	if (rio->isopen || !rio->present) {
+		mutex_unlock(&(rio->lock));
 		mutex_unlock(&rio500_mutex);
 		return -EBUSY;
 	}
@@ -71,6 +74,7 @@ static int open_rio(struct inode *inode, struct file *file)
 
 	init_waitqueue_head(&rio->wait_q);
 
+	mutex_unlock(&(rio->lock));
 
 	dev_info(&rio->rio_dev->dev, "Rio opened.\n");
 	mutex_unlock(&rio500_mutex);
@@ -84,6 +88,7 @@ static int close_rio(struct inode *inode, struct file *file)
 
 	/* against disconnect() */
 	mutex_lock(&rio500_mutex);
+	mutex_lock(&(rio->lock));
 
 	rio->isopen = 0;
 	if (!rio->present) {
@@ -95,6 +100,7 @@ static int close_rio(struct inode *inode, struct file *file)
 	} else {
 		dev_info(&rio->rio_dev->dev, "Rio closed.\n");
 	}
+	mutex_unlock(&(rio->lock));
 	mutex_unlock(&rio500_mutex);
 	return 0;
 }
@@ -109,7 +115,7 @@ static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long arg)
 	int retries;
 	int retval=0;
 
-	mutex_lock(&rio500_mutex);
+	mutex_lock(&(rio->lock));
         /* Sanity check to make sure rio is connected, powered, etc */
         if (rio->present == 0 || rio->rio_dev == NULL) {
 		retval = -ENODEV;
@@ -253,7 +259,7 @@ static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long arg)
 
 
 err_out:
-	mutex_unlock(&rio500_mutex);
+	mutex_unlock(&(rio->lock));
 	return retval;
 }
 
@@ -273,12 +279,12 @@ write_rio(struct file *file, const char __user *buffer,
 	int errn = 0;
 	int intr;
 
-	intr = mutex_lock_interruptible(&rio500_mutex);
+	intr = mutex_lock_interruptible(&(rio->lock));
 	if (intr)
 		return -EINTR;
         /* Sanity check to make sure rio is connected, powered, etc */
         if (rio->present == 0 || rio->rio_dev == NULL) {
-		mutex_unlock(&rio500_mutex);
+		mutex_unlock(&(rio->lock));
 		return -ENODEV;
 	}
 
@@ -301,7 +307,7 @@ write_rio(struct file *file, const char __user *buffer,
 				goto error;
 			}
 			if (signal_pending(current)) {
-				mutex_unlock(&rio500_mutex);
+				mutex_unlock(&(rio->lock));
 				return bytes_written ? bytes_written : -EINTR;
 			}
 
@@ -339,12 +345,12 @@ write_rio(struct file *file, const char __user *buffer,
 		buffer += copy_size;
 	} while (count > 0);
 
-	mutex_unlock(&rio500_mutex);
+	mutex_unlock(&(rio->lock));
 
 	return bytes_written ? bytes_written : -EIO;
 
 error:
-	mutex_unlock(&rio500_mutex);
+	mutex_unlock(&(rio->lock));
 	return errn;
 }
 
@@ -361,12 +367,12 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 	char *ibuf;
 	int intr;
 
-	intr = mutex_lock_interruptible(&rio500_mutex);
+	intr = mutex_lock_interruptible(&(rio->lock));
 	if (intr)
 		return -EINTR;
 	/* Sanity check to make sure rio is connected, powered, etc */
         if (rio->present == 0 || rio->rio_dev == NULL) {
-		mutex_unlock(&rio500_mutex);
+		mutex_unlock(&(rio->lock));
 		return -ENODEV;
 	}
 
@@ -377,11 +383,11 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 
 	while (count > 0) {
 		if (signal_pending(current)) {
-			mutex_unlock(&rio500_mutex);
+			mutex_unlock(&(rio->lock));
 			return read_count ? read_count : -EINTR;
 		}
 		if (!rio->rio_dev) {
-			mutex_unlock(&rio500_mutex);
+			mutex_unlock(&(rio->lock));
 			return -ENODEV;
 		}
 		this_read = (count >= IBUF_SIZE) ? IBUF_SIZE : count;
@@ -399,7 +405,7 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 			count = this_read = partial;
 		} else if (result == -ETIMEDOUT || result == 15) {	/* FIXME: 15 ??? */
 			if (!maxretry--) {
-				mutex_unlock(&rio500_mutex);
+				mutex_unlock(&(rio->lock));
 				dev_err(&rio->rio_dev->dev,
 					"read_rio: maxretry timeout\n");
 				return -ETIME;
@@ -409,19 +415,19 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 			finish_wait(&rio->wait_q, &wait);
 			continue;
 		} else if (result != -EREMOTEIO) {
-			mutex_unlock(&rio500_mutex);
+			mutex_unlock(&(rio->lock));
 			dev_err(&rio->rio_dev->dev,
 				"Read Whoops - result:%d partial:%u this_read:%u\n",
 				result, partial, this_read);
 			return -EIO;
 		} else {
-			mutex_unlock(&rio500_mutex);
+			mutex_unlock(&(rio->lock));
 			return (0);
 		}
 
 		if (this_read) {
 			if (copy_to_user(buffer, ibuf, this_read)) {
-				mutex_unlock(&rio500_mutex);
+				mutex_unlock(&(rio->lock));
 				return -EFAULT;
 			}
 			count -= this_read;
@@ -429,7 +435,7 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 			buffer += this_read;
 		}
 	}
-	mutex_unlock(&rio500_mutex);
+	mutex_unlock(&(rio->lock));
 	return read_count;
 }
 
@@ -494,6 +500,8 @@ static int probe_rio(struct usb_interface *intf,
 	}
 	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
 
+	mutex_init(&(rio->lock));
+
 	usb_set_intfdata (intf, rio);
 	rio->present = 1;
 bail_out:
@@ -511,10 +519,12 @@ static void disconnect_rio(struct usb_interface *intf)
 	if (rio) {
 		usb_deregister_dev(intf, &usb_rio_class);
 
+		mutex_lock(&(rio->lock));
 		if (rio->isopen) {
 			rio->isopen = 0;
 			/* better let it finish - the release will do whats needed */
 			rio->rio_dev = NULL;
+			mutex_unlock(&(rio->lock));
 			mutex_unlock(&rio500_mutex);
 			return;
 		}
@@ -524,6 +534,7 @@ static void disconnect_rio(struct usb_interface *intf)
 		dev_info(&intf->dev, "USB Rio disconnected.\n");
 
 		rio->present = 0;
+		mutex_unlock(&(rio->lock));
 	}
 	mutex_unlock(&rio500_mutex);
 }
-- 
2.22.0


