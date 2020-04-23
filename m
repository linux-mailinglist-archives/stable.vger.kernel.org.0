Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784F71B67B6
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgDWXJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50892 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728652AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004y2-Eb; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-00E73q-8M; Fri, 24 Apr 2020 00:06:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Date:   Fri, 24 Apr 2020 00:07:49 +0100
Message-ID: <lsq.1587683028.745777592@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 242/245] [media] media-device: dynamically allocate
 struct media_devnode
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

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit a087ce704b802becbb4b0f2a20f2cb3f6911802e upstream.

struct media_devnode is currently embedded at struct media_device.

While this works fine during normal usage, it leads to a race
condition during devnode unregister. the problem is that drivers
assume that, after calling media_device_unregister(), the struct
that contains media_device can be freed. This is not true, as it
can't be freed until userspace closes all opened /dev/media devnodes.

In other words, if the media devnode is still open, and media_device
gets freed, any call to an ioctl will make the core to try to access
struct media_device, with will cause an use-after-free and even GPF.

Fix this by dynamically allocating the struct media_devnode and only
freeing it when it is safe.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[bwh: Backported to 3.16:
 - Drop change in au0828
 - Include <linux/slab.h> in media-device.c
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #include <media/media-device.h>
@@ -236,7 +237,7 @@ static long media_device_ioctl(struct fi
 			       unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -305,7 +306,7 @@ static long media_device_compat_ioctl(st
 				      unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -346,7 +347,8 @@ static const struct media_file_operation
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_device *mdev = to_media_device(to_media_devnode(cd));
+	struct media_devnode *devnode = to_media_devnode(cd);
+	struct media_device *mdev = devnode->media_dev;
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -374,6 +376,7 @@ static void media_device_release(struct
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
+	struct media_devnode *devnode;
 	int ret;
 
 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
@@ -384,17 +387,27 @@ int __must_check __media_device_register
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
+	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
+	if (!devnode)
+		return -ENOMEM;
+
 	/* Register the device node. */
-	mdev->devnode.fops = &media_device_fops;
-	mdev->devnode.parent = mdev->dev;
-	mdev->devnode.release = media_device_release;
-	ret = media_devnode_register(&mdev->devnode, owner);
-	if (ret < 0)
+	mdev->devnode = devnode;
+	devnode->fops = &media_device_fops;
+	devnode->parent = mdev->dev;
+	devnode->release = media_device_release;
+	ret = media_devnode_register(mdev, devnode, owner);
+	if (ret < 0) {
+		mdev->devnode = NULL;
+		kfree(devnode);
 		return ret;
+	}
 
-	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
+	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
-		media_devnode_unregister(&mdev->devnode);
+		mdev->devnode = NULL;
+		media_devnode_unregister(devnode);
+		kfree(devnode);
 		return ret;
 	}
 
@@ -415,8 +428,11 @@ void media_device_unregister(struct medi
 	list_for_each_entry_safe(entity, next, &mdev->entities, list)
 		media_device_unregister_entity(entity);
 
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	media_devnode_unregister(&mdev->devnode);
+	/* Check if mdev devnode was registered */
+	if (media_devnode_is_registered(mdev->devnode)) {
+		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
+		media_devnode_unregister(mdev->devnode);
+	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
+#include <media/media-device.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -74,6 +75,8 @@ static void media_devnode_release(struct
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
+
+	kfree(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -221,6 +224,7 @@ static const struct file_operations medi
 
 /**
  * media_devnode_register - register a media device node
+ * @media_dev: struct media_device we want to register a device node
  * @devnode: media device node structure we want to register
  *
  * The registration code assigns minor numbers and registers the new device node
@@ -233,7 +237,8 @@ static const struct file_operations medi
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -252,6 +257,7 @@ int __must_check media_devnode_register(
 	mutex_unlock(&media_devnode_lock);
 
 	devnode->minor = minor;
+	devnode->media_dev = mdev;
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -60,7 +60,7 @@ struct device;
 struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
-	struct media_devnode devnode;
+	struct media_devnode *devnode;
 
 	char model[32];
 	char serial[40];
@@ -84,9 +84,6 @@ struct media_device {
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
 
-/* media_devnode to media_device */
-#define to_media_device(node) container_of(node, struct media_device, devnode)
-
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1640,7 +1640,7 @@ static void uvc_delete(struct uvc_device
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
+	if (media_devnode_is_registered(dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
 #endif
 
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -33,6 +33,8 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
+struct media_device;
+
 /*
  * Flag to mark the media_devnode struct as registered. Drivers must not touch
  * this flag directly, it will be set and cleared by media_devnode_register and
@@ -63,6 +65,8 @@ struct media_file_operations {
  * before registering the node.
  */
 struct media_devnode {
+	struct media_device *media_dev;
+
 	/* device ops */
 	const struct media_file_operations *fops;
 
@@ -82,7 +86,8 @@ struct media_devnode {
 /* dev to media_devnode */
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
 
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner);
 void media_devnode_unregister(struct media_devnode *devnode);
 
@@ -93,6 +98,9 @@ static inline struct media_devnode *medi
 
 static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
+	if (!devnode)
+		return false;
+
 	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 

