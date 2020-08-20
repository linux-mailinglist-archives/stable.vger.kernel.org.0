Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC624BFBF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgHTNxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbgHTJYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A6822CA1;
        Thu, 20 Aug 2020 09:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915470;
        bh=jIGx1oDIotA1N0j1NtNbCXqLVSh5R/KCnfPlSK6xOcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5wQIckufI2wd3bSt1baWqs8RUbnRwayo7RlM06gtQsl9gjkOvc0Pn1ehyLE/FUSy
         zDKriRLodyPalomqLMdm0E9DfB3T+11tjbpk5rnAd9yGOewbx/2z3XBInPw7bVQRys
         1Xaqny9yROcxmNgQFb7wPjMsAnhDlB74FAyGK5OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 024/232] btrfs: open device without device_list_mutex
Date:   Thu, 20 Aug 2020 11:17:55 +0200
Message-Id: <20200820091613.922748607@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 18c850fdc5a801bad4977b0f1723761d42267e45 upstream.

There's long existed a lockdep splat because we open our bdev's under
the ->device_list_mutex at mount time, which acquires the bd_mutex.
Usually this goes unnoticed, but if you do loopback devices at all
suddenly the bd_mutex comes with a whole host of other dependencies,
which results in the splat when you mount a btrfs file system.

======================================================
WARNING: possible circular locking dependency detected
5.8.0-0.rc3.1.fc33.x86_64+debug #1 Not tainted
------------------------------------------------------
systemd-journal/509 is trying to acquire lock:
ffff970831f84db0 (&fs_info->reloc_mutex){+.+.}-{3:3}, at: btrfs_record_root_in_trans+0x44/0x70 [btrfs]

but task is already holding lock:
ffff97083144d598 (sb_pagefaults){.+.+}-{0:0}, at: btrfs_page_mkwrite+0x59/0x560 [btrfs]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

 -> #6 (sb_pagefaults){.+.+}-{0:0}:
       __sb_start_write+0x13e/0x220
       btrfs_page_mkwrite+0x59/0x560 [btrfs]
       do_page_mkwrite+0x4f/0x130
       do_wp_page+0x3b0/0x4f0
       handle_mm_fault+0xf47/0x1850
       do_user_addr_fault+0x1fc/0x4b0
       exc_page_fault+0x88/0x300
       asm_exc_page_fault+0x1e/0x30

 -> #5 (&mm->mmap_lock#2){++++}-{3:3}:
       __might_fault+0x60/0x80
       _copy_from_user+0x20/0xb0
       get_sg_io_hdr+0x9a/0xb0
       scsi_cmd_ioctl+0x1ea/0x2f0
       cdrom_ioctl+0x3c/0x12b4
       sr_block_ioctl+0xa4/0xd0
       block_ioctl+0x3f/0x50
       ksys_ioctl+0x82/0xc0
       __x64_sys_ioctl+0x16/0x20
       do_syscall_64+0x52/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

 -> #4 (&cd->lock){+.+.}-{3:3}:
       __mutex_lock+0x7b/0x820
       sr_block_open+0xa2/0x180
       __blkdev_get+0xdd/0x550
       blkdev_get+0x38/0x150
       do_dentry_open+0x16b/0x3e0
       path_openat+0x3c9/0xa00
       do_filp_open+0x75/0x100
       do_sys_openat2+0x8a/0x140
       __x64_sys_openat+0x46/0x70
       do_syscall_64+0x52/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

 -> #3 (&bdev->bd_mutex){+.+.}-{3:3}:
       __mutex_lock+0x7b/0x820
       __blkdev_get+0x6a/0x550
       blkdev_get+0x85/0x150
       blkdev_get_by_path+0x2c/0x70
       btrfs_get_bdev_and_sb+0x1b/0xb0 [btrfs]
       open_fs_devices+0x88/0x240 [btrfs]
       btrfs_open_devices+0x92/0xa0 [btrfs]
       btrfs_mount_root+0x250/0x490 [btrfs]
       legacy_get_tree+0x30/0x50
       vfs_get_tree+0x28/0xc0
       vfs_kern_mount.part.0+0x71/0xb0
       btrfs_mount+0x119/0x380 [btrfs]
       legacy_get_tree+0x30/0x50
       vfs_get_tree+0x28/0xc0
       do_mount+0x8c6/0xca0
       __x64_sys_mount+0x8e/0xd0
       do_syscall_64+0x52/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

 -> #2 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
       __mutex_lock+0x7b/0x820
       btrfs_run_dev_stats+0x36/0x420 [btrfs]
       commit_cowonly_roots+0x91/0x2d0 [btrfs]
       btrfs_commit_transaction+0x4e6/0x9f0 [btrfs]
       btrfs_sync_file+0x38a/0x480 [btrfs]
       __x64_sys_fdatasync+0x47/0x80
       do_syscall_64+0x52/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

 -> #1 (&fs_info->tree_log_mutex){+.+.}-{3:3}:
       __mutex_lock+0x7b/0x820
       btrfs_commit_transaction+0x48e/0x9f0 [btrfs]
       btrfs_sync_file+0x38a/0x480 [btrfs]
       __x64_sys_fdatasync+0x47/0x80
       do_syscall_64+0x52/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

 -> #0 (&fs_info->reloc_mutex){+.+.}-{3:3}:
       __lock_acquire+0x1241/0x20c0
       lock_acquire+0xb0/0x400
       __mutex_lock+0x7b/0x820
       btrfs_record_root_in_trans+0x44/0x70 [btrfs]
       start_transaction+0xd2/0x500 [btrfs]
       btrfs_dirty_inode+0x44/0xd0 [btrfs]
       file_update_time+0xc6/0x120
       btrfs_page_mkwrite+0xda/0x560 [btrfs]
       do_page_mkwrite+0x4f/0x130
       do_wp_page+0x3b0/0x4f0
       handle_mm_fault+0xf47/0x1850
       do_user_addr_fault+0x1fc/0x4b0
       exc_page_fault+0x88/0x300
       asm_exc_page_fault+0x1e/0x30

other info that might help us debug this:

Chain exists of:
  &fs_info->reloc_mutex --> &mm->mmap_lock#2 --> sb_pagefaults

Possible unsafe locking scenario:

     CPU0                    CPU1
     ----                    ----
 lock(sb_pagefaults);
                             lock(&mm->mmap_lock#2);
                             lock(sb_pagefaults);
 lock(&fs_info->reloc_mutex);

 *** DEADLOCK ***

3 locks held by systemd-journal/509:
 #0: ffff97083bdec8b8 (&mm->mmap_lock#2){++++}-{3:3}, at: do_user_addr_fault+0x12e/0x4b0
 #1: ffff97083144d598 (sb_pagefaults){.+.+}-{0:0}, at: btrfs_page_mkwrite+0x59/0x560 [btrfs]
 #2: ffff97083144d6a8 (sb_internal){.+.+}-{0:0}, at: start_transaction+0x3f8/0x500 [btrfs]

stack backtrace:
CPU: 0 PID: 509 Comm: systemd-journal Not tainted 5.8.0-0.rc3.1.fc33.x86_64+debug #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
Call Trace:
 dump_stack+0x92/0xc8
 check_noncircular+0x134/0x150
 __lock_acquire+0x1241/0x20c0
 lock_acquire+0xb0/0x400
 ? btrfs_record_root_in_trans+0x44/0x70 [btrfs]
 ? lock_acquire+0xb0/0x400
 ? btrfs_record_root_in_trans+0x44/0x70 [btrfs]
 __mutex_lock+0x7b/0x820
 ? btrfs_record_root_in_trans+0x44/0x70 [btrfs]
 ? kvm_sched_clock_read+0x14/0x30
 ? sched_clock+0x5/0x10
 ? sched_clock_cpu+0xc/0xb0
 btrfs_record_root_in_trans+0x44/0x70 [btrfs]
 start_transaction+0xd2/0x500 [btrfs]
 btrfs_dirty_inode+0x44/0xd0 [btrfs]
 file_update_time+0xc6/0x120
 btrfs_page_mkwrite+0xda/0x560 [btrfs]
 ? sched_clock+0x5/0x10
 do_page_mkwrite+0x4f/0x130
 do_wp_page+0x3b0/0x4f0
 handle_mm_fault+0xf47/0x1850
 do_user_addr_fault+0x1fc/0x4b0
 exc_page_fault+0x88/0x300
 ? asm_exc_page_fault+0x8/0x30
 asm_exc_page_fault+0x1e/0x30
RIP: 0033:0x7fa3972fdbfe
Code: Bad RIP value.

Fix this by not holding the ->device_list_mutex at this point.  The
device_list_mutex exists to protect us from modifying the device list
while the file system is running.

However it can also be modified by doing a scan on a device.  But this
action is specifically protected by the uuid_mutex, which we are holding
here.  We cannot race with opening at this point because we have the
->s_mount lock held during the mount.  Not having the
->device_list_mutex here is perfectly safe as we're not going to change
the devices at this point.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add some comments ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -245,7 +245,9 @@ static int __btrfs_map_block(struct btrf
  *
  * global::fs_devs - add, remove, updates to the global list
  *
- * does not protect: manipulation of the fs_devices::devices list!
+ * does not protect: manipulation of the fs_devices::devices list in general
+ * but in mount context it could be used to exclude list modifications by eg.
+ * scan ioctl
  *
  * btrfs_device::name - renames (write side), read is RCU
  *
@@ -258,6 +260,9 @@ static int __btrfs_map_block(struct btrf
  * may be used to exclude some operations from running concurrently without any
  * modifications to the list (see write_all_supers)
  *
+ * Is not required at mount and close times, because our device list is
+ * protected by the uuid_mutex at that point.
+ *
  * balance_mutex
  * -------------
  * protects balance structures (status, state) and context accessed from
@@ -602,6 +607,11 @@ static int btrfs_free_stale_devices(cons
 	return ret;
 }
 
+/*
+ * This is only used on mount, and we are protected from competing things
+ * messing with our fs_devices by the uuid_mutex, thus we do not need the
+ * fs_devices->device_list_mutex here.
+ */
 static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 			struct btrfs_device *device, fmode_t flags,
 			void *holder)
@@ -1229,8 +1239,14 @@ int btrfs_open_devices(struct btrfs_fs_d
 	int ret;
 
 	lockdep_assert_held(&uuid_mutex);
+	/*
+	 * The device_list_mutex cannot be taken here in case opening the
+	 * underlying device takes further locks like bd_mutex.
+	 *
+	 * We also don't need the lock here as this is called during mount and
+	 * exclusion is provided by uuid_mutex
+	 */
 
-	mutex_lock(&fs_devices->device_list_mutex);
 	if (fs_devices->opened) {
 		fs_devices->opened++;
 		ret = 0;
@@ -1238,7 +1254,6 @@ int btrfs_open_devices(struct btrfs_fs_d
 		list_sort(NULL, &fs_devices->devices, devid_cmp);
 		ret = open_fs_devices(fs_devices, flags, holder);
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	return ret;
 }


