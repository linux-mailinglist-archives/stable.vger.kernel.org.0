Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C102645C689
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354256AbhKXOKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353582AbhKXOG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CC961252;
        Wed, 24 Nov 2021 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759548;
        bh=jPKwb6IA0hLosnuCg9pzy0ztr5nx9tdqAiJOmBpmbXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbh8+rSerhcg67FR/jCtdH5vWBMHltK5CTyGro6BGW0X+iw7YsjuFgOz0hEeBWsx5
         gx3qpWhQpzI7+SNMGhNWZgk3KfvICjUgcD2oGnxU/6qdmAXdWQYrLb9rqVr43T/obC
         1qBnHYiHi0F6RlqljOQwJYXNhOLo8geRrFvH2EYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 277/279] btrfs: update device path inode time instead of bd_inode
Date:   Wed, 24 Nov 2021 12:59:24 +0100
Message-Id: <20211124115728.253967892@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 54fde91f52f515e0b1514f0f0fa146e87a672227 upstream.

Christoph pointed out that I'm updating bdev->bd_inode for the device
time when we remove block devices from a btrfs file system, however this
isn't actually exposed to anything.  The inode we want to update is the
one that's associated with the path to the device, usually on devtmpfs,
so that blkid notices the difference.

We still don't want to do the blkdev_open, so use kern_path() to get the
path to the given device and do the update time on that inode.

Fixes: 8f96a5bfa150 ("btrfs: update the bdev time directly when closing")
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -14,6 +14,7 @@
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
 #include <linux/list_sort.h>
+#include <linux/namei.h>
 #include "misc.h"
 #include "ctree.h"
 #include "extent_map.h"
@@ -1884,18 +1885,22 @@ out:
 /*
  * Function to update ctime/mtime for a given device path.
  * Mainly used for ctime/mtime based probe like libblkid.
+ *
+ * We don't care about errors here, this is just to be kind to userspace.
  */
-static void update_dev_time(struct block_device *bdev)
+static void update_dev_time(const char *device_path)
 {
-	struct inode *inode = bdev->bd_inode;
+	struct path path;
 	struct timespec64 now;
+	int ret;
 
-	/* Shouldn't happen but just in case. */
-	if (!inode)
+	ret = kern_path(device_path, LOOKUP_FOLLOW, &path);
+	if (ret)
 		return;
 
-	now = current_time(inode);
-	generic_update_time(inode, &now, S_MTIME | S_CTIME);
+	now = current_time(d_inode(path.dentry));
+	inode_update_time(d_inode(path.dentry), &now, S_MTIME | S_CTIME);
+	path_put(&path);
 }
 
 static int btrfs_rm_dev_item(struct btrfs_device *device)
@@ -2071,7 +2076,7 @@ void btrfs_scratch_superblocks(struct bt
 	btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
 	/* Update ctime/mtime for device path for libblkid */
-	update_dev_time(bdev);
+	update_dev_time(device_path);
 }
 
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
@@ -2735,7 +2740,7 @@ int btrfs_init_new_device(struct btrfs_f
 	btrfs_forget_devices(device_path);
 
 	/* Update ctime/mtime for blkid or udev */
-	update_dev_time(bdev);
+	update_dev_time(device_path);
 
 	return ret;
 


