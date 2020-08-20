Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F2724BC2E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgHTMlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgHTJqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:46:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CAD2078D;
        Thu, 20 Aug 2020 09:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916792;
        bh=1cHTx30rbzMwVWXjTLu473SVH9WLuKIxD9AOHOapkAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpsnLh75JVLi1xtqJ7qQpzAAxJ9r5pil06yLdoIlkSPwoFETmbOKl28ba1N3F95Oz
         tVOCAUcLpKHV+kpHts3V1BoQpwT4tfLMSZ+jOQAU/ZzZ2iMvLSwhYFhmNCALgY0vlD
         JcM88UIhaN3ULzcaX+NIphOVu+3cdHpKR/9URgMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 017/152] btrfs: move the chunk_mutex in btrfs_read_chunk_tree
Date:   Thu, 20 Aug 2020 11:19:44 +0200
Message-Id: <20200820091554.527061070@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 01d01caf19ff7c537527d352d169c4368375c0a1 upstream.

We are currently getting this lockdep splat in btrfs/161:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc5+ #20 Tainted: G            E
  ------------------------------------------------------
  mount/678048 is trying to acquire lock:
  ffff9b769f15b6e0 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: clone_fs_devices+0x4d/0x170 [btrfs]

  but task is already holding lock:
  ffff9b76abdb08d0 (&fs_info->chunk_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x6a/0x800 [btrfs]

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (&fs_info->chunk_mutex){+.+.}-{3:3}:
	 __mutex_lock+0x8b/0x8f0
	 btrfs_init_new_device+0x2d2/0x1240 [btrfs]
	 btrfs_ioctl+0x1de/0x2d20 [btrfs]
	 ksys_ioctl+0x87/0xc0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x52/0xb0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
	 __lock_acquire+0x1240/0x2460
	 lock_acquire+0xab/0x360
	 __mutex_lock+0x8b/0x8f0
	 clone_fs_devices+0x4d/0x170 [btrfs]
	 btrfs_read_chunk_tree+0x330/0x800 [btrfs]
	 open_ctree+0xb7c/0x18ce [btrfs]
	 btrfs_mount_root.cold+0x13/0xfa [btrfs]
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 fc_mount+0xe/0x40
	 vfs_kern_mount.part.0+0x71/0x90
	 btrfs_mount+0x13b/0x3e0 [btrfs]
	 legacy_get_tree+0x30/0x50
	 vfs_get_tree+0x28/0xc0
	 do_mount+0x7de/0xb30
	 __x64_sys_mount+0x8e/0xd0
	 do_syscall_64+0x52/0xb0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&fs_info->chunk_mutex);
				 lock(&fs_devs->device_list_mutex);
				 lock(&fs_info->chunk_mutex);
    lock(&fs_devs->device_list_mutex);

   *** DEADLOCK ***

  3 locks held by mount/678048:
   #0: ffff9b75ff5fb0e0 (&type->s_umount_key#63/1){+.+.}-{3:3}, at: alloc_super+0xb5/0x380
   #1: ffffffffc0c2fbc8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x54/0x800 [btrfs]
   #2: ffff9b76abdb08d0 (&fs_info->chunk_mutex){+.+.}-{3:3}, at: btrfs_read_chunk_tree+0x6a/0x800 [btrfs]

  stack backtrace:
  CPU: 2 PID: 678048 Comm: mount Tainted: G            E     5.8.0-rc5+ #20
  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./890FX Deluxe5, BIOS P1.40 05/03/2011
  Call Trace:
   dump_stack+0x96/0xd0
   check_noncircular+0x162/0x180
   __lock_acquire+0x1240/0x2460
   ? asm_sysvec_apic_timer_interrupt+0x12/0x20
   lock_acquire+0xab/0x360
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   __mutex_lock+0x8b/0x8f0
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   ? rcu_read_lock_sched_held+0x52/0x60
   ? cpumask_next+0x16/0x20
   ? module_assert_mutex_or_preempt+0x14/0x40
   ? __module_address+0x28/0xf0
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   ? static_obj+0x4f/0x60
   ? lockdep_init_map_waits+0x43/0x200
   ? clone_fs_devices+0x4d/0x170 [btrfs]
   clone_fs_devices+0x4d/0x170 [btrfs]
   btrfs_read_chunk_tree+0x330/0x800 [btrfs]
   open_ctree+0xb7c/0x18ce [btrfs]
   ? super_setup_bdi_name+0x79/0xd0
   btrfs_mount_root.cold+0x13/0xfa [btrfs]
   ? vfs_parse_fs_string+0x84/0xb0
   ? rcu_read_lock_sched_held+0x52/0x60
   ? kfree+0x2b5/0x310
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   fc_mount+0xe/0x40
   vfs_kern_mount.part.0+0x71/0x90
   btrfs_mount+0x13b/0x3e0 [btrfs]
   ? cred_has_capability+0x7c/0x120
   ? rcu_read_lock_sched_held+0x52/0x60
   ? legacy_get_tree+0x30/0x50
   legacy_get_tree+0x30/0x50
   vfs_get_tree+0x28/0xc0
   do_mount+0x7de/0xb30
   ? memdup_user+0x4e/0x90
   __x64_sys_mount+0x8e/0xd0
   do_syscall_64+0x52/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is because btrfs_read_chunk_tree() can come upon DEV_EXTENT's and
then read the device, which takes the device_list_mutex.  The
device_list_mutex needs to be taken before the chunk_mutex, so this is a
problem.  We only really need the chunk mutex around adding the chunk,
so move the mutex around read_one_chunk.

An argument could be made that we don't even need the chunk_mutex here
as it's during mount, and we are protected by various other locks.
However we already have special rules for ->device_list_mutex, and I'd
rather not have another special case for ->chunk_mutex.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7282,7 +7282,6 @@ int btrfs_read_chunk_tree(struct btrfs_f
 	 * otherwise we don't need it.
 	 */
 	mutex_lock(&uuid_mutex);
-	mutex_lock(&fs_info->chunk_mutex);
 
 	/*
 	 * It is possible for mount and umount to race in such a way that
@@ -7327,7 +7326,9 @@ int btrfs_read_chunk_tree(struct btrfs_f
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+			mutex_lock(&fs_info->chunk_mutex);
 			ret = read_one_chunk(&found_key, leaf, chunk);
+			mutex_unlock(&fs_info->chunk_mutex);
 			if (ret)
 				goto error;
 		}
@@ -7357,7 +7358,6 @@ int btrfs_read_chunk_tree(struct btrfs_f
 	}
 	ret = 0;
 error:
-	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_free_path(path);


