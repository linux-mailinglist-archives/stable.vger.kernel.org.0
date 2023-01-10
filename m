Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E269664B45
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbjAJSkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239527AbjAJSkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:40:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE2D55844
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D155DB818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12776C433D2;
        Tue, 10 Jan 2023 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375676;
        bh=jlyTK9+m0XoRtk/g6nW82n4Kstzjhp4Bqv7K+uc76sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xhhj6+3BMCC/42GbJWcUpvCPa9B/bhuqxZkzTN9XikoIc0Nt/9T3fQAefOU9P148M
         7MveSxk6Ho/9yl/TXur2GYQwwpHUgZA9yhdhKREegiKxyksIIYFE6E575FWZfXRKZ2
         DZgxJyG1LDbaZvedJIsQozyNnVj1DLbREZ5IRTC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Goffredo Baroncelli <kreijack@libero.it>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/290] btrfs: check superblock to ensure the fs was not modified at thaw time
Date:   Tue, 10 Jan 2023 19:05:56 +0100
Message-Id: <20230110180041.094494249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a05d3c9153145283ce9c58a1d7a9056fbb85f6a1 ]

[BACKGROUND]
There is an incident report that, one user hibernated the system, with
one btrfs on removable device still mounted.

Then by some incident, the btrfs got mounted and modified by another
system/OS, then back to the hibernated system.

After resuming from the hibernation, new write happened into the victim btrfs.

Now the fs is completely broken, since the underlying btrfs is no longer
the same one before the hibernation, and the user lost their data due to
various transid mismatch.

[REPRODUCER]
We can emulate the situation using the following small script:

  truncate -s 1G $dev
  mkfs.btrfs -f $dev
  mount $dev $mnt
  fsstress -w -d $mnt -n 500
  sync
  xfs_freeze -f $mnt
  cp $dev $dev.backup

  # There is no way to mount the same cloned fs on the same system,
  # as the conflicting fsid will be rejected by btrfs.
  # Thus here we have to wipe the fs using a different btrfs.
  mkfs.btrfs -f $dev.backup

  dd if=$dev.backup of=$dev bs=1M
  xfs_freeze -u $mnt
  fsstress -w -d $mnt -n 20
  umount $mnt
  btrfs check $dev

The final fsck will fail due to some tree blocks has incorrect fsid.

This is enough to emulate the problem hit by the unfortunate user.

[ENHANCEMENT]
Although such case should not be that common, it can still happen from
time to time.

>From the view of btrfs, we can detect any unexpected super block change,
and if there is any unexpected change, we just mark the fs read-only,
and thaw the fs.

By this we can limit the damage to minimal, and I hope no one would lose
their data by this anymore.

Suggested-by: Goffredo Baroncelli <kreijack@libero.it>
Link: https://lore.kernel.org/linux-btrfs/83bf3b4b-7f4c-387a-b286-9251e3991e34@bluemole.com/
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 25 ++++++++++++++-----
 fs/btrfs/disk-io.h |  4 +++-
 fs/btrfs/super.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c |  2 +-
 4 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2fd46093e5bb..6484f61c6fbb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2491,8 +2491,8 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
  * 		1, 2	2nd and 3rd backup copy
  * 	       -1	skip bytenr check
  */
-static int validate_super(struct btrfs_fs_info *fs_info,
-			    struct btrfs_super_block *sb, int mirror_num)
+int btrfs_validate_super(struct btrfs_fs_info *fs_info,
+			 struct btrfs_super_block *sb, int mirror_num)
 {
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
@@ -2675,7 +2675,7 @@ static int validate_super(struct btrfs_fs_info *fs_info,
  */
 static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
 {
-	return validate_super(fs_info, fs_info->super_copy, 0);
+	return btrfs_validate_super(fs_info, fs_info->super_copy, 0);
 }
 
 /*
@@ -2689,7 +2689,7 @@ static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
-	ret = validate_super(fs_info, sb, -1);
+	ret = btrfs_validate_super(fs_info, sb, -1);
 	if (ret < 0)
 		goto out;
 	if (!btrfs_supported_super_csum(btrfs_super_csum_type(sb))) {
@@ -3703,7 +3703,7 @@ static void btrfs_end_super_write(struct bio *bio)
 }
 
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
-						   int copy_num)
+						   int copy_num, bool drop_cache)
 {
 	struct btrfs_super_block *super;
 	struct page *page;
@@ -3721,6 +3721,19 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
 		return ERR_PTR(-EINVAL);
 
+	if (drop_cache) {
+		/* This should only be called with the primary sb. */
+		ASSERT(copy_num == 0);
+
+		/*
+		 * Drop the page of the primary superblock, so later read will
+		 * always read from the device.
+		 */
+		invalidate_inode_pages2_range(mapping,
+				bytenr >> PAGE_SHIFT,
+				(bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
+	}
+
 	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
 	if (IS_ERR(page))
 		return ERR_CAST(page);
@@ -3752,7 +3765,7 @@ struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev)
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	for (i = 0; i < 1; i++) {
-		super = btrfs_read_dev_one_super(bdev, i);
+		super = btrfs_read_dev_one_super(bdev, i, false);
 		if (IS_ERR(super))
 			continue;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 1b8fd3deafc9..9de0c39f63a2 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -56,10 +56,12 @@ int __cold open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
 void __cold close_ctree(struct btrfs_fs_info *fs_info);
+int btrfs_validate_super(struct btrfs_fs_info *fs_info,
+			 struct btrfs_super_block *sb, int mirror_num);
 int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev);
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
-						   int copy_num);
+						   int copy_num, bool drop_cache);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 					struct btrfs_key *key);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61b84391be58..bde5ead01c24 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2497,11 +2497,71 @@ static int btrfs_freeze(struct super_block *sb)
 	return btrfs_commit_transaction(trans);
 }
 
+static int check_dev_super(struct btrfs_device *dev)
+{
+	struct btrfs_fs_info *fs_info = dev->fs_info;
+	struct btrfs_super_block *sb;
+	int ret = 0;
+
+	/* This should be called with fs still frozen. */
+	ASSERT(test_bit(BTRFS_FS_FROZEN, &fs_info->flags));
+
+	/* Missing dev, no need to check. */
+	if (!dev->bdev)
+		return 0;
+
+	/* Only need to check the primary super block. */
+	sb = btrfs_read_dev_one_super(dev->bdev, 0, true);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
+	/* Btrfs_validate_super() includes fsid check against super->fsid. */
+	ret = btrfs_validate_super(fs_info, sb, 0);
+	if (ret < 0)
+		goto out;
+
+	if (btrfs_super_generation(sb) != fs_info->last_trans_committed) {
+		btrfs_err(fs_info, "transid mismatch, has %llu expect %llu",
+			btrfs_super_generation(sb),
+			fs_info->last_trans_committed);
+		ret = -EUCLEAN;
+		goto out;
+	}
+out:
+	btrfs_release_disk_super(sb);
+	return ret;
+}
+
 static int btrfs_unfreeze(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_device *device;
+	int ret = 0;
 
+	/*
+	 * Make sure the fs is not changed by accident (like hibernation then
+	 * modified by other OS).
+	 * If we found anything wrong, we mark the fs error immediately.
+	 *
+	 * And since the fs is frozen, no one can modify the fs yet, thus
+	 * we don't need to hold device_list_mutex.
+	 */
+	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
+		ret = check_dev_super(device);
+		if (ret < 0) {
+			btrfs_handle_fs_error(fs_info, ret,
+				"super block on devid %llu got modified unexpectedly",
+				device->devid);
+			break;
+		}
+	}
 	clear_bit(BTRFS_FS_FROZEN, &fs_info->flags);
+
+	/*
+	 * We still return 0, to allow VFS layer to unfreeze the fs even the
+	 * above checks failed. Since the fs is either fine or read-only, we're
+	 * safe to continue, without causing further damage.
+	 */
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6b86a3cec04c..f01549b8c7c5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2074,7 +2074,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 		struct page *page;
 		int ret;
 
-		disk_super = btrfs_read_dev_one_super(bdev, copy_num);
+		disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
 		if (IS_ERR(disk_super))
 			continue;
 
-- 
2.35.1



