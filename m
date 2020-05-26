Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4AA1E2F21
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgEZSzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389316AbgEZSzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F89208A9;
        Tue, 26 May 2020 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519308;
        bh=o9X6o0lP6jd6SYFq0q1p083PCWe5KFflEkWAx35edyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYDgEyb1DUXbIF9TcVgbGqr9fRWGbGvVmrXRodCiqQPIWmO7BAcuapEnyaoyV+oIR
         WrNbdSsAhlivYgVCr4YlOiz6VxQMH/+GHO9D4xCFg+sWXWRAqQuB//DahUz5IJS4Zp
         WoJEgjKVvwokZNU41Iy4ft/3MZ+nv9cmsxsPI+cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/65] media: fix use-after-free in cdev_put() when app exits after driver unbind
Date:   Tue, 26 May 2020 20:52:37 +0200
Message-Id: <20200526183912.963855505@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c  |  6 +++--
 drivers/media/media-devnode.c | 48 +++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index fb018fe1a8f7..5d79cd481730 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -396,16 +396,16 @@ int __must_check __media_device_register(struct media_device *mdev,
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
 
@@ -430,6 +430,8 @@ void media_device_unregister(struct media_device *mdev)
 	if (media_devnode_is_registered(mdev->devnode)) {
 		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
 		media_devnode_unregister(mdev->devnode);
+		/* devnode free is handled in media_devnode_*() */
+		mdev->devnode = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 000efb17b95b..45bb70d27224 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -63,13 +63,8 @@ static void media_devnode_release(struct device *cd)
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
@@ -77,6 +72,7 @@ static void media_devnode_release(struct device *cd)
 		devnode->release(devnode);
 
 	kfree(devnode);
+	pr_debug("%s: Media Devnode Deallocated\n", __func__);
 }
 
 static struct bus_type media_bus_type = {
@@ -205,6 +201,8 @@ static int media_release(struct inode *inode, struct file *filp)
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&devnode->dev);
+
+	pr_debug("%s: Media Release\n", __func__);
 	return 0;
 }
 
@@ -250,6 +248,7 @@ int __must_check media_devnode_register(struct media_device *mdev,
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
+		kfree(devnode);
 		return -ENFILE;
 	}
 
@@ -259,27 +258,31 @@ int __must_check media_devnode_register(struct media_device *mdev,
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
@@ -287,12 +290,15 @@ int __must_check media_devnode_register(struct media_device *mdev,
 
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
 
@@ -314,8 +320,12 @@ void media_devnode_unregister(struct media_devnode *devnode)
 
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
-- 
2.25.1



