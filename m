Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5F230BFF8
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhBBNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232898AbhBBNpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E8264F80;
        Tue,  2 Feb 2021 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273256;
        bh=woP0iE8dPNhIXznQGXtoVnm6rJl1vHV5A/i25q4V/jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4xLqp9U7CiszeZOXbL32Ud+QQXK3X5bhJ8BBRttw5+iMmbCgcTexEIPLbDhczss7
         dXFO0VYhHzCAzoLe9IsUX8vVkkl6kMYKAcULZfDEsWT/+1woMNep4BWyS8W2YBcEQC
         03o3x6G4vVRier6rZrkxZg0sGwlI44/Xc/ZFu7IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard F <erhard_f@mailbox.org>,
        Davidlohr Bueso <dbueso@suse.de>, Su Yue <l@damenly.su>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 037/142] btrfs: fix lockdep warning due to seqcount_mutex on 32bit arch
Date:   Tue,  2 Feb 2021 14:36:40 +0100
Message-Id: <20210202132959.239944698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <l@damenly.su>

commit c41ec4529d3448df8998950d7bada757a1b321cf upstream.

This effectively reverts commit d5c8238849e7 ("btrfs: convert
data_seqcount to seqcount_mutex_t").

While running fstests on 32 bits test box, many tests failed because of
warnings in dmesg. One of those warnings (btrfs/003):

  [66.441317] WARNING: CPU: 6 PID: 9251 at include/linux/seqlock.h:279 btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
  [66.441446] CPU: 6 PID: 9251 Comm: btrfs Tainted: G           O      5.11.0-rc4-custom+ #5
  [66.441449] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
  [66.441451] EIP: btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
  [66.441472] EAX: 00000000 EBX: 00000001 ECX: c576070c EDX: c6b15803
  [66.441475] ESI: 10000000 EDI: 00000000 EBP: c56fbcfc ESP: c56fbc70
  [66.441477] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
  [66.441481] CR0: 80050033 CR2: 05c8da20 CR3: 04b20000 CR4: 00350ed0
  [66.441485] Call Trace:
  [66.441510]  btrfs_relocate_chunk+0xb1/0x100 [btrfs]
  [66.441529]  ? btrfs_lookup_block_group+0x17/0x20 [btrfs]
  [66.441562]  btrfs_balance+0x8ed/0x13b0 [btrfs]
  [66.441586]  ? btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
  [66.441619]  ? __this_cpu_preempt_check+0xf/0x11
  [66.441643]  btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
  [66.441664]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
  [66.441683]  btrfs_ioctl+0x414/0x2ae0 [btrfs]
  [66.441700]  ? __lock_acquire+0x35f/0x2650
  [66.441717]  ? lockdep_hardirqs_on+0x87/0x120
  [66.441720]  ? lockdep_hardirqs_on_prepare+0xd0/0x1e0
  [66.441724]  ? call_rcu+0x2d3/0x530
  [66.441731]  ? __might_fault+0x41/0x90
  [66.441736]  ? kvm_sched_clock_read+0x15/0x50
  [66.441740]  ? sched_clock+0x8/0x10
  [66.441745]  ? sched_clock_cpu+0x13/0x180
  [66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
  [66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
  [66.441768]  __ia32_sys_ioctl+0x165/0x8a0
  [66.441773]  ? __this_cpu_preempt_check+0xf/0x11
  [66.441785]  ? __might_fault+0x89/0x90
  [66.441791]  __do_fast_syscall_32+0x54/0x80
  [66.441796]  do_fast_syscall_32+0x32/0x70
  [66.441801]  do_SYSENTER_32+0x15/0x20
  [66.441805]  entry_SYSENTER_32+0x9f/0xf2
  [66.441808] EIP: 0xab7b5549
  [66.441814] EAX: ffffffda EBX: 00000003 ECX: c4009420 EDX: bfa91f5c
  [66.441816] ESI: 00000003 EDI: 00000001 EBP: 00000000 ESP: bfa91e98
  [66.441818] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
  [66.441833] irq event stamp: 42579
  [66.441835] hardirqs last  enabled at (42585): [<c60eb065>] console_unlock+0x495/0x590
  [66.441838] hardirqs last disabled at (42590): [<c60eafd5>] console_unlock+0x405/0x590
  [66.441840] softirqs last  enabled at (41698): [<c601b76c>] call_on_stack+0x1c/0x60
  [66.441843] softirqs last disabled at (41681): [<c601b76c>] call_on_stack+0x1c/0x60

  ========================================================================
  btrfs_remove_chunk+0x58b/0x7b0:
  __seqprop_mutex_assert at linux/./include/linux/seqlock.h:279
  (inlined by) btrfs_device_set_bytes_used at linux/fs/btrfs/volumes.h:212
  (inlined by) btrfs_remove_chunk at linux/fs/btrfs/volumes.c:2994
  ========================================================================

The warning is produced by lockdep_assert_held() in
__seqprop_mutex_assert() if CONFIG_LOCKDEP is enabled.
And "olumes.c:2994 is btrfs_device_set_bytes_used() with mutex lock
fs_info->chunk_mutex held already.

After adding some debug prints, the cause was found that many
__alloc_device() are called with NULL @fs_info (during scanning ioctl).
Inside the function, btrfs_device_data_ordered_init() is expanded to
seqcount_mutex_init().  In this scenario, its second
parameter info->chunk_mutex  is &NULL->chunk_mutex which equals
to offsetof(struct btrfs_fs_info, chunk_mutex) unexpectedly. Thus,
seqcount_mutex_init() is called in wrong way. And later
btrfs_device_get/set helpers trigger lockdep warnings.

The device and filesystem object lifetimes are different and we'd have
to synchronize initialization of the btrfs_device::data_seqcount with
the fs_info, possibly using some additional synchronization. It would
still not prevent concurrent access to the seqcount lock when it's used
for read and initialization.

Commit d5c8238849e7 ("btrfs: convert data_seqcount to seqcount_mutex_t")
does not mention a particular problem being fixed so revert should not
cause any harm and we'll get the lockdep warning fixed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210139
Reported-by: Erhard F <erhard_f@mailbox.org>
Fixes: d5c8238849e7 ("btrfs: convert data_seqcount to seqcount_mutex_t")
CC: stable@vger.kernel.org # 5.10
CC: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    2 +-
 fs/btrfs/volumes.h |   11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -431,7 +431,7 @@ static struct btrfs_device *__alloc_devi
 
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
-	btrfs_device_data_ordered_init(dev, fs_info);
+	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	extent_io_tree_init(fs_info, &dev->alloc_state,
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -39,10 +39,10 @@ struct btrfs_io_geometry {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 #include <linux/seqlock.h>
 #define __BTRFS_NEED_DEVICE_DATA_ORDERED
-#define btrfs_device_data_ordered_init(device, info)				\
-	seqcount_mutex_init(&device->data_seqcount, &info->chunk_mutex)
+#define btrfs_device_data_ordered_init(device)	\
+	seqcount_init(&device->data_seqcount)
 #else
-#define btrfs_device_data_ordered_init(device, info) do { } while (0)
+#define btrfs_device_data_ordered_init(device) do { } while (0)
 #endif
 
 #define BTRFS_DEV_STATE_WRITEABLE	(0)
@@ -72,8 +72,7 @@ struct btrfs_device {
 	blk_status_t last_flush_error;
 
 #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
-	/* A seqcount_t with associated chunk_mutex (for lockdep) */
-	seqcount_mutex_t data_seqcount;
+	seqcount_t data_seqcount;
 #endif
 
 	/* the internal btrfs device id */
@@ -164,9 +163,11 @@ btrfs_device_get_##name(const struct btr
 static inline void							\
 btrfs_device_set_##name(struct btrfs_device *dev, u64 size)		\
 {									\
+	preempt_disable();						\
 	write_seqcount_begin(&dev->data_seqcount);			\
 	dev->name = size;						\
 	write_seqcount_end(&dev->data_seqcount);			\
+	preempt_enable();						\
 }
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 #define BTRFS_DEVICE_GETSET_FUNCS(name)					\


