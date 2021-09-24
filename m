Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F685417467
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346329AbhIXNFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345539AbhIXNDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7E2161407;
        Fri, 24 Sep 2021 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488108;
        bh=k85xBrx2PPOGcRaRvq/slb79ZXmiDRmMCawFaktg+fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nw6eaJXUWUrSWRvFhMOoopRLiu+hBwWH7LHwyghy/db5+WC/WrHmRv1OvXXRSt66+
         5yx4NBGpXSalMHawbUX81HlgbfBbuG0OeK3/C0piCzXFn/7wPf/kmRcn5IW+uD/7sl
         IKNp8/r5ou85XMKOKYp1KssrTeNIO9omO4B3FAqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 070/100] btrfs: delay blkdev_put until after the device remove
Date:   Fri, 24 Sep 2021 14:44:19 +0200
Message-Id: <20210924124343.781831923@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3fa421dedbc82f985f030c5a6480ea2d784334c3 ]

When removing the device we call blkdev_put() on the device once we've
removed it, and because we have an EXCL open we need to take the
->open_mutex on the block device to clean it up.  Unfortunately during
device remove we are holding the sb writers lock, which results in the
following lockdep splat:

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc2+ #407 Not tainted
------------------------------------------------------
losetup/11595 is trying to acquire lock:
ffff973ac35dd138 ((wq_completion)loop0){+.+.}-{0:0}, at: flush_workqueue+0x67/0x5e0

but task is already holding lock:
ffff973ac9812c68 (&lo->lo_mutex){+.+.}-{3:3}, at: __loop_clr_fd+0x41/0x660 [loop]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #4 (&lo->lo_mutex){+.+.}-{3:3}:
       __mutex_lock+0x7d/0x750
       lo_open+0x28/0x60 [loop]
       blkdev_get_whole+0x25/0xf0
       blkdev_get_by_dev.part.0+0x168/0x3c0
       blkdev_open+0xd2/0xe0
       do_dentry_open+0x161/0x390
       path_openat+0x3cc/0xa20
       do_filp_open+0x96/0x120
       do_sys_openat2+0x7b/0x130
       __x64_sys_openat+0x46/0x70
       do_syscall_64+0x38/0x90
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #3 (&disk->open_mutex){+.+.}-{3:3}:
       __mutex_lock+0x7d/0x750
       blkdev_put+0x3a/0x220
       btrfs_rm_device.cold+0x62/0xe5
       btrfs_ioctl+0x2a31/0x2e70
       __x64_sys_ioctl+0x80/0xb0
       do_syscall_64+0x38/0x90
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #2 (sb_writers#12){.+.+}-{0:0}:
       lo_write_bvec+0xc2/0x240 [loop]
       loop_process_work+0x238/0xd00 [loop]
       process_one_work+0x26b/0x560
       worker_thread+0x55/0x3c0
       kthread+0x140/0x160
       ret_from_fork+0x1f/0x30

-> #1 ((work_completion)(&lo->rootcg_work)){+.+.}-{0:0}:
       process_one_work+0x245/0x560
       worker_thread+0x55/0x3c0
       kthread+0x140/0x160
       ret_from_fork+0x1f/0x30

-> #0 ((wq_completion)loop0){+.+.}-{0:0}:
       __lock_acquire+0x10ea/0x1d90
       lock_acquire+0xb5/0x2b0
       flush_workqueue+0x91/0x5e0
       drain_workqueue+0xa0/0x110
       destroy_workqueue+0x36/0x250
       __loop_clr_fd+0x9a/0x660 [loop]
       block_ioctl+0x3f/0x50
       __x64_sys_ioctl+0x80/0xb0
       do_syscall_64+0x38/0x90
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  (wq_completion)loop0 --> &disk->open_mutex --> &lo->lo_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&lo->lo_mutex);
                               lock(&disk->open_mutex);
                               lock(&lo->lo_mutex);
  lock((wq_completion)loop0);

 *** DEADLOCK ***

1 lock held by losetup/11595:
 #0: ffff973ac9812c68 (&lo->lo_mutex){+.+.}-{3:3}, at: __loop_clr_fd+0x41/0x660 [loop]

stack backtrace:
CPU: 0 PID: 11595 Comm: losetup Not tainted 5.14.0-rc2+ #407
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
Call Trace:
 dump_stack_lvl+0x57/0x72
 check_noncircular+0xcf/0xf0
 ? stack_trace_save+0x3b/0x50
 __lock_acquire+0x10ea/0x1d90
 lock_acquire+0xb5/0x2b0
 ? flush_workqueue+0x67/0x5e0
 ? lockdep_init_map_type+0x47/0x220
 flush_workqueue+0x91/0x5e0
 ? flush_workqueue+0x67/0x5e0
 ? verify_cpu+0xf0/0x100
 drain_workqueue+0xa0/0x110
 destroy_workqueue+0x36/0x250
 __loop_clr_fd+0x9a/0x660 [loop]
 ? blkdev_ioctl+0x8d/0x2a0
 block_ioctl+0x3f/0x50
 __x64_sys_ioctl+0x80/0xb0
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc21255d4cb

So instead save the bdev and do the put once we've dropped the sb
writers lock in order to avoid the lockdep recursion.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c   | 15 +++++++++++----
 fs/btrfs/volumes.c | 23 +++++++++++++++++------
 fs/btrfs/volumes.h |  3 ++-
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ba98e08a029..50e12989e84a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3205,6 +3205,8 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	struct block_device *bdev = NULL;
+	fmode_t mode;
 	int ret;
 	bool cancel = false;
 
@@ -3237,9 +3239,9 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	/* Exclusive operation is now claimed */
 
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID)
-		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
+		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid, &bdev, &mode);
 	else
-		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
+		ret = btrfs_rm_device(fs_info, vol_args->name, 0, &bdev, &mode);
 
 	btrfs_exclop_finish(fs_info);
 
@@ -3255,6 +3257,8 @@ out:
 	kfree(vol_args);
 err_drop:
 	mnt_drop_write_file(file);
+	if (bdev)
+		blkdev_put(bdev, mode);
 	return ret;
 }
 
@@ -3263,6 +3267,8 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_vol_args *vol_args;
+	struct block_device *bdev = NULL;
+	fmode_t mode;
 	int ret;
 	bool cancel;
 
@@ -3284,7 +3290,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	ret = exclop_start_or_cancel_reloc(fs_info, BTRFS_EXCLOP_DEV_REMOVE,
 					   cancel);
 	if (ret == 0) {
-		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
+		ret = btrfs_rm_device(fs_info, vol_args->name, 0, &bdev, &mode);
 		if (!ret)
 			btrfs_info(fs_info, "disk deleted %s", vol_args->name);
 		btrfs_exclop_finish(fs_info);
@@ -3293,7 +3299,8 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	kfree(vol_args);
 out_drop_write:
 	mnt_drop_write_file(file);
-
+	if (bdev)
+		blkdev_put(bdev, mode);
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d4e0c4aa6d4d..d6ffb38a0869 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2122,7 +2122,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
-		    u64 devid)
+		    u64 devid, struct block_device **bdev, fmode_t *mode)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
@@ -2236,15 +2236,26 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	/*
-	 * at this point, the device is zero sized and detached from
-	 * the devices list.  All that's left is to zero out the old
-	 * supers and free the device.
+	 * At this point, the device is zero sized and detached from the
+	 * devices list.  All that's left is to zero out the old supers and
+	 * free the device.
+	 *
+	 * We cannot call btrfs_close_bdev() here because we're holding the sb
+	 * write lock, and blkdev_put() will pull in the ->open_mutex on the
+	 * block device and it's dependencies.  Instead just flush the device
+	 * and let the caller do the final blkdev_put.
 	 */
-	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		btrfs_scratch_superblocks(fs_info, device->bdev,
 					  device->name->str);
+		if (device->bdev) {
+			sync_blockdev(device->bdev);
+			invalidate_bdev(device->bdev);
+		}
+	}
 
-	btrfs_close_bdev(device);
+	*bdev = device->bdev;
+	*mode = device->mode;
 	synchronize_rcu();
 	btrfs_free_device(device);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 55a8ba244716..f77f869dfd2c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -472,7 +472,8 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u8 *uuid);
 void btrfs_free_device(struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
-		    const char *device_path, u64 devid);
+		    const char *device_path, u64 devid,
+		    struct block_device **bdev, fmode_t *mode);
 void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
-- 
2.33.0



