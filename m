Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE52D47AF43
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbhLTPKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237772AbhLTPJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B79DC061376;
        Mon, 20 Dec 2021 06:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 959D8B80EDE;
        Mon, 20 Dec 2021 14:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBC0C36AE7;
        Mon, 20 Dec 2021 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012078;
        bh=5O1J5rH9cH9q+D5BVm1Jdn5MLJL/7aQJNUi+/qgXfhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slZiLb7Diwc3MdXZhC7Rv+lPOaap/gF3X0dmwtQnvjogbe35SkdAVGJ3ZlhfYv1Gb
         BgaVXcu+42JUW1+cHc/NfLrhszv/t8owczA8aU7Pq5KNjp6n6O38kMdLc97MormXJG
         kY/2u4ZKwt72M72Umy4mmAOTXPQNS9OL3wiBJlPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <l@damenly.su>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 030/177] btrfs: convert latest_bdev type to btrfs_device and rename
Date:   Mon, 20 Dec 2021 15:33:00 +0100
Message-Id: <20211220143041.103352437@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

Commit d24fa5c1da08026be9959baca309fa0adf8708bf upstream.

In preparation to fix a bug in btrfs_show_devname().

Convert fs_devices::latest_bdev type from struct block_device to struct
btrfs_device and, rename the member to fs_devices::latest_dev.
So that btrfs_show_devname() can use fs_devices::latest_dev::name.

Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c   |    6 +++---
 fs/btrfs/extent_io.c |    2 +-
 fs/btrfs/inode.c     |    2 +-
 fs/btrfs/super.c     |    2 +-
 fs/btrfs/volumes.c   |   10 +++++-----
 fs/btrfs/volumes.h   |    6 +++++-
 6 files changed, 16 insertions(+), 12 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3229,12 +3229,12 @@ int __cold open_ctree(struct super_block
 	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
 	btrfs_init_btree_inode(fs_info);
 
-	invalidate_bdev(fs_devices->latest_bdev);
+	invalidate_bdev(fs_devices->latest_dev->bdev);
 
 	/*
 	 * Read super block and check the signature bytes only
 	 */
-	disk_super = btrfs_read_dev_super(fs_devices->latest_bdev);
+	disk_super = btrfs_read_dev_super(fs_devices->latest_dev->bdev);
 	if (IS_ERR(disk_super)) {
 		err = PTR_ERR(disk_super);
 		goto fail_alloc;
@@ -3466,7 +3466,7 @@ int __cold open_ctree(struct super_block
 	 * below in btrfs_init_dev_replace().
 	 */
 	btrfs_free_extra_devids(fs_devices);
-	if (!fs_devices->latest_bdev) {
+	if (!fs_devices->latest_dev->bdev) {
 		btrfs_err(fs_info, "failed to read devices");
 		goto fail_tree_roots;
 	}
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3327,7 +3327,7 @@ static int alloc_new_bio(struct btrfs_in
 	if (wbc) {
 		struct block_device *bdev;
 
-		bdev = fs_info->fs_devices->latest_bdev;
+		bdev = fs_info->fs_devices->latest_dev->bdev;
 		bio_set_dev(bio, bdev);
 		wbc_init_bio(wbc, bio);
 	}
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7967,7 +7967,7 @@ static int btrfs_dio_iomap_begin(struct
 		iomap->type = IOMAP_MAPPED;
 	}
 	iomap->offset = start;
-	iomap->bdev = fs_info->fs_devices->latest_bdev;
+	iomap->bdev = fs_info->fs_devices->latest_dev->bdev;
 	iomap->length = len;
 
 	if (write && btrfs_use_zone_append(BTRFS_I(inode), em->block_start))
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1705,7 +1705,7 @@ static struct dentry *btrfs_mount_root(s
 		goto error_close_devices;
 	}
 
-	bdev = fs_devices->latest_bdev;
+	bdev = fs_devices->latest_dev->bdev;
 	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | SB_NOSEC,
 		 fs_info);
 	if (IS_ERR(s)) {
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1092,7 +1092,7 @@ void btrfs_free_extra_devids(struct btrf
 	list_for_each_entry(seed_dev, &fs_devices->seed_list, seed_list)
 		__btrfs_free_extra_devids(seed_dev, &latest_dev);
 
-	fs_devices->latest_bdev = latest_dev->bdev;
+	fs_devices->latest_dev = latest_dev;
 
 	mutex_unlock(&uuid_mutex);
 }
@@ -1225,7 +1225,7 @@ static int open_fs_devices(struct btrfs_
 		return -EINVAL;
 
 	fs_devices->opened = 1;
-	fs_devices->latest_bdev = latest_dev->bdev;
+	fs_devices->latest_dev = latest_dev;
 	fs_devices->total_rw_bytes = 0;
 	fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_REGULAR;
 	fs_devices->read_policy = BTRFS_READ_POLICY_PID;
@@ -1993,7 +1993,7 @@ static struct btrfs_device * btrfs_find_
 }
 
 /*
- * Helper function to check if the given device is part of s_bdev / latest_bdev
+ * Helper function to check if the given device is part of s_bdev / latest_dev
  * and replace it with the provided or the next active device, in the context
  * where this function called, there should be always be another device (or
  * this_dev) which is active.
@@ -2012,8 +2012,8 @@ void __cold btrfs_assign_next_active_dev
 			(fs_info->sb->s_bdev == device->bdev))
 		fs_info->sb->s_bdev = next_device->bdev;
 
-	if (fs_info->fs_devices->latest_bdev == device->bdev)
-		fs_info->fs_devices->latest_bdev = next_device->bdev;
+	if (fs_info->fs_devices->latest_dev->bdev == device->bdev)
+		fs_info->fs_devices->latest_dev = next_device;
 }
 
 /*
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -246,7 +246,11 @@ struct btrfs_fs_devices {
 	/* Highest generation number of seen devices */
 	u64 latest_generation;
 
-	struct block_device *latest_bdev;
+	/*
+	 * The mount device or a device with highest generation after removal
+	 * or replace.
+	 */
+	struct btrfs_device *latest_dev;
 
 	/* all of the devices in the FS, protected by a mutex
 	 * so we can safely walk it to write out the supers without


