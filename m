Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9281B67B5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgDWXJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50898 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004xG-D9; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-00E73v-B3; Fri, 24 Apr 2020 00:06:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Shuah Khan" <shuahkh@osg.samsung.com>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Date:   Fri, 24 Apr 2020 00:07:50 +0100
Message-ID: <lsq.1587683028.15461793@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 243/245] [media] media: fix use-after-free in
 cdev_put() when app exits after driver unbind
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

commit 5b28dde51d0ccc54cee70756e1800d70bed7114a upstream.

When driver unbinds while media_ioctl is in progress, cdev_put() fails with
when app exits after driver unbinds.

Add devnode struct device kobj as the cdev parent kobject. cdev_add() gets
a reference to it and releases it in cdev_del() ensuring that the devnode
is not deallocated as long as the application has the device file open.

media_devnode_register() initializes the struct device kobj before calling
cdev_add(). media_devnode_unregister() does cdev_del() and then deletes the
device. devnode is released when the last reference to the struct device is
gone.

This problem is found on uvcvideo, em28xx, and au0828 drivers and fix has
been tested on all three.

kernel: [  193.599736] BUG: KASAN: use-after-free in cdev_put+0x4e/0x50
kernel: [  193.599745] Read of size 8 by task media_device_te/1851
kernel: [  193.599792] INFO: Allocated in __media_device_register+0x54
kernel: [  193.599951] INFO: Freed in media_devnode_release+0xa4/0xc0

kernel: [  193.601083] Call Trace:
kernel: [  193.601093]  [<ffffffff81aecac3>] dump_stack+0x67/0x94
kernel: [  193.601102]  [<ffffffff815359b2>] print_trailer+0x112/0x1a0
kernel: [  193.601111]  [<ffffffff8153b5e4>] object_err+0x34/0x40
kernel: [  193.601119]  [<ffffffff8153d9d4>] kasan_report_error+0x224/0x530
kernel: [  193.601128]  [<ffffffff814a2c3d>] ? kzfree+0x2d/0x40
kernel: [  193.601137]  [<ffffffff81539d72>] ? kfree+0x1d2/0x1f0
kernel: [  193.601154]  [<ffffffff8157ca7e>] ? cdev_put+0x4e/0x50
kernel: [  193.601162]  [<ffffffff8157ca7e>] cdev_put+0x4e/0x50
kernel: [  193.601170]  [<ffffffff815767eb>] __fput+0x52b/0x6c0
kernel: [  193.601179]  [<ffffffff8117743a>] ? switch_task_namespaces+0x2a
kernel: [  193.601188]  [<ffffffff815769ee>] ____fput+0xe/0x10
kernel: [  193.601196]  [<ffffffff81170023>] task_work_run+0x133/0x1f0
kernel: [  193.601204]  [<ffffffff8117746e>] ? switch_task_namespaces+0x5e
kernel: [  193.601213]  [<ffffffff8111b50c>] do_exit+0x72c/0x2c20
kernel: [  193.601224]  [<ffffffff8111ade0>] ? release_task+0x1250/0x1250
-
-
-
kernel: [  193.601360]  [<ffffffff81003587>] ? exit_to_usermode_loop+0xe7
kernel: [  193.601368]  [<ffffffff810035c0>] exit_to_usermode_loop+0x120
kernel: [  193.601376]  [<ffffffff810061da>] syscall_return_slowpath+0x16a
kernel: [  193.601386]  [<ffffffff82848b33>] entry_SYSCALL_64_fastpath+0xa6

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Tested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/media-device.c  |  6 +++--
 drivers/media/media-devnode.c | 48 +++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 21 deletions(-)

--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -398,16 +398,16 @@ int __must_check __media_device_register
 	devnode->release = media_device_release;
 	ret = media_devnode_register(mdev, devnode, owner);
 	if (ret < 0) {
+		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
-		kfree(devnode);
 		return ret;
 	}
 
 	ret = device_create_file(&devnode->dev, &dev_attr_model);
 	if (ret < 0) {
+		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
 		media_devnode_unregister(devnode);
-		kfree(devnode);
 		return ret;
 	}
 
@@ -432,6 +432,8 @@ void media_device_unregister(struct medi
 	if (media_devnode_is_registered(mdev->devnode)) {
 		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 		media_devnode_unregister(mdev->devnode);
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -63,13 +63,8 @@ static void media_devnode_release(struct
 	struct media_devnode *devnode = to_media_devnode(cd);
 
 	mutex_lock(&media_devnode_lock);
-
-	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
-
 	/* Mark device node number as free */
 	clear_bit(devnode->minor, media_devnode_nums);
-
 	mutex_unlock(&media_devnode_lock);
 
 	/* Release media_devnode and perform other cleanups as needed. */
@@ -77,6 +72,7 @@ static void media_devnode_release(struct
 		devnode->release(devnode);
 
 	kfree(devnode);
+	pr_debug("%s: Media Devnode Deallocated\n", __func__);
 }
 
 static struct bus_type media_bus_type = {
@@ -205,6 +201,8 @@ static int media_release(struct inode *i
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&devnode->dev);
+
+	pr_debug("%s: Media Release\n", __func__);
 	return 0;
 }
 
@@ -250,6 +248,7 @@ int __must_check media_devnode_register(
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
+		kfree(devnode);
 		return -ENFILE;
 	}
 
@@ -259,27 +258,31 @@ int __must_check media_devnode_register(
 	devnode->minor = minor;
 	devnode->media_dev = mdev;
 
+	/* Part 1: Initialize dev now to use dev.kobj for cdev.kobj.parent */
+	devnode->dev.bus = &media_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
+	devnode->dev.release = media_devnode_release;
+	if (devnode->parent)
+		devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "media%d", devnode->minor);
+	device_initialize(&devnode->dev);
+
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
 	devnode->cdev.owner = owner;
+	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 
 	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
 	if (ret < 0) {
 		pr_err("%s: cdev_add failed\n", __func__);
-		goto error;
+		goto cdev_add_error;
 	}
 
-	/* Part 3: Register the media device */
-	devnode->dev.bus = &media_bus_type;
-	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
-	devnode->dev.release = media_devnode_release;
-	if (devnode->parent)
-		devnode->dev.parent = devnode->parent;
-	dev_set_name(&devnode->dev, "media%d", devnode->minor);
-	ret = device_register(&devnode->dev);
+	/* Part 3: Add the media device */
+	ret = device_add(&devnode->dev);
 	if (ret < 0) {
-		pr_err("%s: device_register failed\n", __func__);
-		goto error;
+		pr_err("%s: device_add failed\n", __func__);
+		goto device_add_error;
 	}
 
 	/* Part 4: Activate this minor. The char device can now be used. */
@@ -287,12 +290,15 @@ int __must_check media_devnode_register(
 
 	return 0;
 
-error:
-	mutex_lock(&media_devnode_lock);
+device_add_error:
 	cdev_del(&devnode->cdev);
+cdev_add_error:
+	mutex_lock(&media_devnode_lock);
 	clear_bit(devnode->minor, media_devnode_nums);
+	devnode->media_dev = NULL;
 	mutex_unlock(&media_devnode_lock);
 
+	put_device(&devnode->dev);
 	return ret;
 }
 
@@ -314,8 +320,12 @@ void media_devnode_unregister(struct med
 
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
+	/* Delete the cdev on this minor as well */
+	cdev_del(&devnode->cdev);
 	mutex_unlock(&media_devnode_lock);
-	device_unregister(&devnode->dev);
+	device_del(&devnode->dev);
+	devnode->media_dev = NULL;
+	put_device(&devnode->dev);
 }
 
 /*

