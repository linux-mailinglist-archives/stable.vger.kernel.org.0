Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776D41B67A0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgDWXIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50900 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728656AbgDWXG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004yZ-FP; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-00E73j-4A; Fri, 24 Apr 2020 00:06:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Date:   Fri, 24 Apr 2020 00:07:48 +0100
Message-ID: <lsq.1587683028.675766430@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 241/245] [media] media-devnode: fix namespace mess
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

commit 163f1e93e995048b894c5fc86a6034d16beed740 upstream.

Along all media controller code, "mdev" is used to represent
a pointer to struct media_device, and "devnode" for a pointer
to struct media_devnode.

However, inside media-devnode.[ch], "mdev" is used to represent
a pointer to struct media_devnode.

This is very confusing and may lead to development errors.

So, let's change all occurrences at media-devnode.[ch] to
also use "devnode" for such pointers.

This patch doesn't make any functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/media-devnode.c | 110 +++++++++++++++++-----------------
 include/media/media-devnode.h |  16 ++---
 2 files changed, 63 insertions(+), 63 deletions(-)

--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -59,21 +59,21 @@ static DECLARE_BITMAP(media_devnode_nums
 /* Called when the last user of the media device exits. */
 static void media_devnode_release(struct device *cd)
 {
-	struct media_devnode *mdev = to_media_devnode(cd);
+	struct media_devnode *devnode = to_media_devnode(cd);
 
 	mutex_lock(&media_devnode_lock);
 
 	/* Delete the cdev on this minor as well */
-	cdev_del(&mdev->cdev);
+	cdev_del(&devnode->cdev);
 
 	/* Mark device node number as free */
-	clear_bit(mdev->minor, media_devnode_nums);
+	clear_bit(devnode->minor, media_devnode_nums);
 
 	mutex_unlock(&media_devnode_lock);
 
 	/* Release media_devnode and perform other cleanups as needed. */
-	if (mdev->release)
-		mdev->release(mdev);
+	if (devnode->release)
+		devnode->release(devnode);
 }
 
 static struct bus_type media_bus_type = {
@@ -83,37 +83,37 @@ static struct bus_type media_bus_type =
 static ssize_t media_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!mdev->fops->read)
+	if (!devnode->fops->read)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->read(filp, buf, sz, off);
+	return devnode->fops->read(filp, buf, sz, off);
 }
 
 static ssize_t media_write(struct file *filp, const char __user *buf,
 		size_t sz, loff_t *off)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!mdev->fops->write)
+	if (!devnode->fops->write)
 		return -EINVAL;
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
-	return mdev->fops->write(filp, buf, sz, off);
+	return devnode->fops->write(filp, buf, sz, off);
 }
 
 static unsigned int media_poll(struct file *filp,
 			       struct poll_table_struct *poll)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return POLLERR | POLLHUP;
-	if (!mdev->fops->poll)
+	if (!devnode->fops->poll)
 		return DEFAULT_POLLMASK;
-	return mdev->fops->poll(filp, poll);
+	return devnode->fops->poll(filp, poll);
 }
 
 static long
@@ -121,12 +121,12 @@ __media_ioctl(struct file *filp, unsigne
 	      long (*ioctl_func)(struct file *filp, unsigned int cmd,
 				 unsigned long arg))
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
 	if (!ioctl_func)
 		return -ENOTTY;
 
-	if (!media_devnode_is_registered(mdev))
+	if (!media_devnode_is_registered(devnode))
 		return -EIO;
 
 	return ioctl_func(filp, cmd, arg);
@@ -134,9 +134,9 @@ __media_ioctl(struct file *filp, unsigne
 
 static long media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	return __media_ioctl(filp, cmd, arg, mdev->fops->ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->ioctl);
 }
 
 #ifdef CONFIG_COMPAT
@@ -144,9 +144,9 @@ static long media_ioctl(struct file *fil
 static long media_compat_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	return __media_ioctl(filp, cmd, arg, mdev->fops->compat_ioctl);
+	return __media_ioctl(filp, cmd, arg, devnode->fops->compat_ioctl);
 }
 
 #endif /* CONFIG_COMPAT */
@@ -154,7 +154,7 @@ static long media_compat_ioctl(struct fi
 /* Override for the open function */
 static int media_open(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev;
+	struct media_devnode *devnode;
 	int ret;
 
 	/* Check if the media device is available. This needs to be done with
@@ -164,23 +164,23 @@ static int media_open(struct inode *inod
 	 * a crash.
 	 */
 	mutex_lock(&media_devnode_lock);
-	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
+	devnode = container_of(inode->i_cdev, struct media_devnode, cdev);
 	/* return ENXIO if the media device has been removed
 	   already or if it is not registered anymore. */
-	if (!media_devnode_is_registered(mdev)) {
+	if (!media_devnode_is_registered(devnode)) {
 		mutex_unlock(&media_devnode_lock);
 		return -ENXIO;
 	}
 	/* and increase the device refcount */
-	get_device(&mdev->dev);
+	get_device(&devnode->dev);
 	mutex_unlock(&media_devnode_lock);
 
-	filp->private_data = mdev;
+	filp->private_data = devnode;
 
-	if (mdev->fops->open) {
-		ret = mdev->fops->open(filp);
+	if (devnode->fops->open) {
+		ret = devnode->fops->open(filp);
 		if (ret) {
-			put_device(&mdev->dev);
+			put_device(&devnode->dev);
 			filp->private_data = NULL;
 			return ret;
 		}
@@ -192,16 +192,16 @@ static int media_open(struct inode *inod
 /* Override for the release function */
 static int media_release(struct inode *inode, struct file *filp)
 {
-	struct media_devnode *mdev = media_devnode_data(filp);
+	struct media_devnode *devnode = media_devnode_data(filp);
 
-	if (mdev->fops->release)
-		mdev->fops->release(filp);
+	if (devnode->fops->release)
+		devnode->fops->release(filp);
 
 	filp->private_data = NULL;
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
-	put_device(&mdev->dev);
+	put_device(&devnode->dev);
 	return 0;
 }
 
@@ -221,7 +221,7 @@ static const struct file_operations medi
 
 /**
  * media_devnode_register - register a media device node
- * @mdev: media device node structure we want to register
+ * @devnode: media device node structure we want to register
  *
  * The registration code assigns minor numbers and registers the new device node
  * with the kernel. An error is returned if no free minor number can be found,
@@ -233,7 +233,7 @@ static const struct file_operations medi
  * the media_devnode structure is *not* called, so the caller is responsible for
  * freeing any data.
  */
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner)
 {
 	int minor;
@@ -251,40 +251,40 @@ int __must_check media_devnode_register(
 	set_bit(minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
-	mdev->minor = minor;
+	devnode->minor = minor;
 
 	/* Part 2: Initialize and register the character device */
-	cdev_init(&mdev->cdev, &media_devnode_fops);
-	mdev->cdev.owner = owner;
+	cdev_init(&devnode->cdev, &media_devnode_fops);
+	devnode->cdev.owner = owner;
 
-	ret = cdev_add(&mdev->cdev, MKDEV(MAJOR(media_dev_t), mdev->minor), 1);
+	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
 		goto error;
 	}
 
 	/* Part 3: Register the media device */
-	mdev->dev.bus = &media_bus_type;
-	mdev->dev.devt = MKDEV(MAJOR(media_dev_t), mdev->minor);
-	mdev->dev.release = media_devnode_release;
-	if (mdev->parent)
-		mdev->dev.parent = mdev->parent;
-	dev_set_name(&mdev->dev, "media%d", mdev->minor);
-	ret = device_register(&mdev->dev);
+	devnode->dev.bus = &media_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release = media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	ret = device_register(&devnode->dev);
 	if (ret < 0) {
 		pr_err("%s: device_register failed\n", __func__);
 		goto error;
 	}
 
 	/* Part 4: Activate this minor. The char device can now be used. */
-	set_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 
 	return 0;
 
 error:
 	mutex_lock(&media_devnode_lock);
-	cdev_del(&mdev->cdev);
-	clear_bit(mdev->minor, media_devnode_nums);
+	cdev_del(&devnode->cdev);
+	clear_bit(devnode->minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
 	return ret;
@@ -292,7 +292,7 @@ error:
 
 /**
  * media_devnode_unregister - unregister a media device node
- * @mdev: the device node to unregister
+ * @devnode: the device node to unregister
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
@@ -300,16 +300,16 @@ error:
  * This function can safely be called if the device node has never been
  * registered or has already been unregistered.
  */
-void media_devnode_unregister(struct media_devnode *mdev)
+void media_devnode_unregister(struct media_devnode *devnode)
 {
-	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(mdev))
+	/* Check if devnode was ever registered at all */
+	if (!media_devnode_is_registered(devnode))
 		return;
 
 	mutex_lock(&media_devnode_lock);
-	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	mutex_unlock(&media_devnode_lock);
-	device_unregister(&mdev->dev);
+	device_unregister(&devnode->dev);
 }
 
 /*
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -76,24 +76,24 @@ struct media_devnode {
 	unsigned long flags;		/* Use bitops to access flags */
 
 	/* callbacks */
-	void (*release)(struct media_devnode *mdev);
+	void (*release)(struct media_devnode *devnode);
 };
 
 /* dev to media_devnode */
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
 
-int __must_check media_devnode_register(struct media_devnode *mdev,
+int __must_check media_devnode_register(struct media_devnode *devnode,
 					struct module *owner);
-void media_devnode_unregister(struct media_devnode *mdev);
+void media_devnode_unregister(struct media_devnode *devnode);
 
 static inline struct media_devnode *media_devnode_data(struct file *filp)
 {
 	return filp->private_data;
 }
 
-static inline int media_devnode_is_registered(struct media_devnode *mdev)
+static inline int media_devnode_is_registered(struct media_devnode *devnode)
 {
-	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
+	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 }
 
 #endif /* _MEDIA_DEVNODE_H */

