Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB971B67A3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgDWXIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50986 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728668AbgDWXHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:07:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004xX-8H; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-00E73z-FH; Fri, 24 Apr 2020 00:06:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Shuah Khan" <shuahkh@osg.samsung.com>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Date:   Fri, 24 Apr 2020 00:07:51 +0100
Message-ID: <lsq.1587683028.550193682@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 244/245] [media] media: fix media devnode
 ioctl/syscall and unregister race
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuahkh@osg.samsung.com>

commit 6f0dd24a084a17f9984dd49dffbf7055bf123993 upstream.

Media devnode open/ioctl could be in progress when media device unregister
is initiated. System calls and ioctls check media device registered status
at the beginning, however, there is a window where unregister could be in
progress without changing the media devnode status to unregistered.

process 1				process 2
fd = open(/dev/media0)
media_devnode_is_registered()
	(returns true here)

					media_device_unregister()
						(unregister is in progress
						and devnode isn't
						unregistered yet)
					...
ioctl(fd, ...)
__media_ioctl()
media_devnode_is_registered()
	(returns true here)
					...
					media_devnode_unregister()
					...
					(driver releases the media device
					memory)

media_device_ioctl()
	(By this point
	devnode->media_dev does not
	point to allocated memory.
	use-after free in in mutex_lock_nested)

BUG: KASAN: use-after-free in mutex_lock_nested+0x79c/0x800 at addr
ffff8801ebe914f0

Fix it by clearing register bit when unregister starts to avoid the race.

process 1                               process 2
fd = open(/dev/media0)
media_devnode_is_registered()
        (could return true here)

                                        media_device_unregister()
                                                (clear the register bit,
						 then start unregister.)
                                        ...
ioctl(fd, ...)
__media_ioctl()
media_devnode_is_registered()
        (return false here, ioctl
	 returns I/O error, and
	 will not access media
	 device memory)
                                        ...
                                        media_devnode_unregister()
                                        ...
                                        (driver releases the media device
					 memory)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reported-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Tested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[bwh: Backported to 3.16: adjut filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -407,6 +407,7 @@ int __must_check __media_device_register
 	if (ret < 0) {
 		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
+		media_devnode_unregister_prepare(devnode);
 		media_devnode_unregister(devnode);
 		return ret;
 	}
@@ -425,16 +426,16 @@ void media_device_unregister(struct medi
 	struct media_entity *entity;
 	struct media_entity *next;
 
+	/* Clear the devnode register bit to avoid races with media dev open */
+	media_devnode_unregister_prepare(mdev->devnode);
+
 	list_for_each_entry_safe(entity, next, &mdev->entities, list)
 		media_device_unregister_entity(entity);
 
-	/* Check if mdev devnode was registered */
-	if (media_devnode_is_registered(mdev->devnode)) {
-		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
-		media_devnode_unregister(mdev->devnode);
-		/* devnode free is handled in media_devnode_*() */
-		mdev->devnode = NULL;
-	}
+	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+	media_devnode_unregister(mdev->devnode);
+	/* devnode free is handled in media_devnode_*() */
+	mdev->devnode = NULL;
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -302,6 +302,17 @@ cdev_add_error:
 	return ret;
 }
 
+void media_devnode_unregister_prepare(struct media_devnode *devnode)
+{
+	/* Check if devnode was ever registered at all */
+	if (!media_devnode_is_registered(devnode))
+		return;
+
+	mutex_lock(&media_devnode_lock);
+	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
+	mutex_unlock(&media_devnode_lock);
+}
+
 /**
  * media_devnode_unregister - unregister a media device node
  * @devnode: the device node to unregister
@@ -309,17 +320,11 @@ cdev_add_error:
  * This unregisters the passed device. Future open calls will be met with
  * errors.
  *
- * This function can safely be called if the device node has never been
- * registered or has already been unregistered.
+ * Should be called after media_devnode_unregister_prepare()
  */
 void media_devnode_unregister(struct media_devnode *devnode)
 {
-	/* Check if devnode was ever registered at all */
-	if (!media_devnode_is_registered(devnode))
-		return;
-
 	mutex_lock(&media_devnode_lock);
-	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	/* Delete the cdev on this minor as well */
 	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -89,6 +89,20 @@ struct media_devnode {
 int __must_check media_devnode_register(struct media_device *mdev,
 					struct media_devnode *devnode,
 					struct module *owner);
+
+/**
+ * media_devnode_unregister_prepare - clear the media device node register bit
+ * @devnode: the device node to prepare for unregister
+ *
+ * This clears the passed device register bit. Future open calls will be met
+ * with errors. Should be called before media_devnode_unregister() to avoid
+ * races with unregister and device file open calls.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+void media_devnode_unregister_prepare(struct media_devnode *devnode);
+
 void media_devnode_unregister(struct media_devnode *devnode);
 
 static inline struct media_devnode *media_devnode_data(struct file *filp)

