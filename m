Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A931E2F24
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgEZSzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389296AbgEZSzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1607E2070A;
        Tue, 26 May 2020 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519305;
        bh=RFQHU8ppshZ34+/Hgd0H57iQCdEBzNIhkBiqtOAvyqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbjsCgdcVDr5oUQzd93PFFxZLxqKu9JLtEtLuuZX8I5fHrimMu53UwXbzM6OVR40D
         q83IugFm7iyEalsxh+yxtvYKlWxZHCG7FOPiRc9dKSI4utMi13eI+H/i+4wx82yDzP
         AAJxciomPLkQl3wgXiAxoHjuTruwW48eX0nwY8pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/65] media-device: dynamically allocate struct media_devnode
Date:   Tue, 26 May 2020 20:52:36 +0200
Message-Id: <20200526183912.438531575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4:
 - Drop change in au0828
 - Include <linux/slab.h> in media-device.c
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c       | 40 +++++++++++++++++++++---------
 drivers/media/media-devnode.c      |  8 +++++-
 drivers/media/usb/uvc/uvc_driver.c |  2 +-
 include/media/media-device.h       |  5 +---
 include/media/media-devnode.h      | 10 +++++++-
 5 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440192d6..fb018fe1a8f7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #include <media/media-device.h>
@@ -234,7 +235,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -303,7 +304,7 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
+	struct media_device *dev = devnode->media_dev;
 	long ret;
 
 	switch (cmd) {
@@ -344,7 +345,8 @@ static const struct media_file_operations media_device_fops = {
 static ssize_t show_model(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
-	struct media_device *mdev = to_media_device(to_media_devnode(cd));
+	struct media_devnode *devnode = to_media_devnode(cd);
+	struct media_device *mdev = devnode->media_dev;
 
 	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
 }
@@ -372,6 +374,7 @@ static void media_device_release(struct media_devnode *mdev)
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
+	struct media_devnode *devnode;
 	int ret;
 
 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
@@ -382,17 +385,27 @@ int __must_check __media_device_register(struct media_device *mdev,
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
 
@@ -413,8 +426,11 @@ void media_device_unregister(struct media_device *mdev)
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
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 98211c570e11..000efb17b95b 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
+#include <media/media-device.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -74,6 +75,8 @@ static void media_devnode_release(struct device *cd)
 	/* Release media_devnode and perform other cleanups as needed. */
 	if (devnode->release)
 		devnode->release(devnode);
+
+	kfree(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -221,6 +224,7 @@ static const struct file_operations media_devnode_fops = {
 
 /**
  * media_devnode_register - register a media device node
+ * @media_dev: struct media_device we want to register a device node
  * @devnode: media device node structure we want to register
  *
  * The registration code assigns minor numbers and registers the new device node
@@ -233,7 +237,8 @@ static const struct file_operations media_devnode_fops = {
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -252,6 +257,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
 	mutex_unlock(&media_devnode_lock);
 
 	devnode->minor = minor;
+	devnode->media_dev = mdev;
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 9cd0268b2767..f353ab569b8e 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1800,7 +1800,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
+	if (media_devnode_is_registered(dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
 #endif
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78f1ee2..00bbd679864a 100644
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
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 79f702d26d1f..8b854c044032 100644
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
@@ -67,6 +69,8 @@ struct media_file_operations {
  * before registering the node.
  */
 struct media_devnode {
+	struct media_device *media_dev;
+
 	/* device ops */
 	const struct media_file_operations *fops;
 
@@ -86,7 +90,8 @@ struct media_devnode {
 /* dev to media_devnode */
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
 
-int __must_check media_devnode_register(struct media_devnode *devnode,
+int __must_check media_devnode_register(struct media_device *mdev,
+					struct media_devnode *devnode,
 					struct module *owner);
 void media_devnode_unregister(struct media_devnode *devnode);
 
@@ -97,6 +102,9 @@ static inline struct media_devnode *media_devnode_data(struct file *filp)
 
 static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
+	if (!devnode)
+		return false;
+
 	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 
-- 
2.25.1



