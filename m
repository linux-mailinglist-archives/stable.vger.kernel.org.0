Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66911E2F06
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbgEZSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389338AbgEZSzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E372208C7;
        Tue, 26 May 2020 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519310;
        bh=ENfyGguspCD34AD0RQik4lsmnT2YnKEPit8iBaMEZpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkZpgQUQ4JM5j49lWC6en+tBii/8RbpJPkfVum6p8ds9A6GcnprErivMIN7sfE7K/
         qScyLqVxATifJrqE8G+RR65JO735b6hAW0q5cIRhFyILEbzoRSC0p9pMajHCENZvtR
         17qSkVX/5WPRAjgwyzv8pF2m2Z+4/J2vEvRfdIQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/65] media: fix media devnode ioctl/syscall and unregister race
Date:   Tue, 26 May 2020 20:52:38 +0200
Message-Id: <20200526183913.346146501@linuxfoundation.org>
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
[bwh: Backported to 4.4: adjut filename, context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/media-device.c  | 15 ++++++++-------
 drivers/media/media-devnode.c | 19 ++++++++++++-------
 include/media/media-devnode.h | 14 ++++++++++++++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5d79cd481730..0ca9506f4654 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -405,6 +405,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (ret < 0) {
 		/* devnode free is handled in media_devnode_*() */
 		mdev->devnode = NULL;
+		media_devnode_unregister_prepare(devnode);
 		media_devnode_unregister(devnode);
 		return ret;
 	}
@@ -423,16 +424,16 @@ void media_device_unregister(struct media_device *mdev)
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
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 45bb70d27224..e887120d19aa 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -302,6 +302,17 @@ int __must_check media_devnode_register(struct media_device *mdev,
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
@@ -309,17 +320,11 @@ int __must_check media_devnode_register(struct media_device *mdev,
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
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 8b854c044032..d5ff95bf2d4b 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -93,6 +93,20 @@ struct media_devnode {
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
-- 
2.25.1



