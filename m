Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8D64174EC
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346571AbhIXNLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346267AbhIXNJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BDA161251;
        Fri, 24 Sep 2021 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488263;
        bh=MhdW2QNbKB8h7StfjBYJjbLH4RQxGpELUcp8hzoaLMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zE4bCyLasm6fEhT6KhZNck1tULmT6y69zE9Mc4J3emL7o9DkpgBAFgCU5PuCa3VjK
         j6v/jZMI47dwmGf3JlVdwcl10MIHigbNzblPf3o/L2kKF7UkhEC8F0GEVerNOqyn8u
         sZXhZV7DOn5IwU8g/f2ZfHaIQ6XsAJezfvmNH7ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/63] btrfs: update the bdev time directly when closing
Date:   Fri, 24 Sep 2021 14:44:47 +0200
Message-Id: <20210924124335.891265479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 8f96a5bfa1503e0a5f3c78d51e993a1794d4aff1 ]

We update the ctime/mtime of a block device when we remove it so that
blkid knows the device changed.  However we do this by re-opening the
block device and calling filp_update_time.  This is more correct because
it'll call the inode->i_op->update_time if it exists, but the block dev
inodes do not do this.  Instead call generic_update_time() on the
bd_inode in order to avoid the blkdev_open path and get rid of the
following lockdep splat:

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc2+ #406 Not tainted
------------------------------------------------------
losetup/11596 is trying to acquire lock:
ffff939640d2f538 ((wq_completion)loop0){+.+.}-{0:0}, at: flush_workqueue+0x67/0x5e0

but task is already holding lock:
ffff939655510c68 (&lo->lo_mutex){+.+.}-{3:3}, at: __loop_clr_fd+0x41/0x660 [loop]

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
       blkdev_get_by_dev.part.0+0x56/0x3c0
       blkdev_open+0xd2/0xe0
       do_dentry_open+0x161/0x390
       path_openat+0x3cc/0xa20
       do_filp_open+0x96/0x120
       file_open_name+0xc7/0x170
       filp_open+0x2c/0x50
       btrfs_scratch_superblocks.part.0+0x10f/0x170
       btrfs_rm_device.cold+0xe8/0xed
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

1 lock held by losetup/11596:
 #0: ffff939655510c68 (&lo->lo_mutex){+.+.}-{3:3}, at: __loop_clr_fd+0x41/0x660 [loop]

stack backtrace:
CPU: 1 PID: 11596 Comm: losetup Not tainted 5.14.0-rc2+ #406
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

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b4fcc48f255b..994ec44fc597 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1855,15 +1855,17 @@ out:
  * Function to update ctime/mtime for a given device path.
  * Mainly used for ctime/mtime based probe like libblkid.
  */
-static void update_dev_time(const char *path_name)
+static void update_dev_time(struct block_device *bdev)
 {
-	struct file *filp;
+	struct inode *inode = bdev->bd_inode;
+	struct timespec64 now;
 
-	filp = filp_open(path_name, O_RDWR, 0);
-	if (IS_ERR(filp))
+	/* Shouldn't happen but just in case. */
+	if (!inode)
 		return;
-	file_update_time(filp);
-	filp_close(filp, NULL);
+
+	now = current_time(inode);
+	generic_update_time(inode, &now, S_MTIME | S_CTIME);
 }
 
 static int btrfs_rm_dev_item(struct btrfs_device *device)
@@ -2038,7 +2040,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 	btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
 	/* Update ctime/mtime for device path for libblkid */
-	update_dev_time(device_path);
+	update_dev_time(bdev);
 }
 
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
@@ -2681,7 +2683,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_forget_devices(device_path);
 
 	/* Update ctime/mtime for blkid or udev */
-	update_dev_time(device_path);
+	update_dev_time(bdev);
 
 	return ret;
 
-- 
2.33.0



