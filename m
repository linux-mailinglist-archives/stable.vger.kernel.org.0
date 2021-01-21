Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D12FE94D
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 12:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbhAULuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 06:50:17 -0500
Received: from eu-shark2.inbox.eu ([195.216.236.82]:33512 "EHLO
        eu-shark2.inbox.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbhAULuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 06:50:10 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 06:50:08 EST
Received: from eu-shark2.inbox.eu (localhost [127.0.0.1])
        by eu-shark2-out.inbox.eu (Postfix) with ESMTP id 496BE45287B;
        Thu, 21 Jan 2021 13:39:23 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.eu; s=20140211;
        t=1611229163; bh=GK2s0h0kVc/989LcR//wG4sd5XX8enKsvgA2rxADqD8=;
        h=From:To:Cc:Subject:Date;
        b=nfOL49dsd1mtctFoGM2NnGVe6aza6TVUBbbHTO3frV3G/N9+cZwzo4HPuH73VIQBn
         ZKs6Rb0uLutSiGFclEwpI7Ww546heHKcgv6JCMP4BGP1weKC9Ql8zkvZsrijf5oZrT
         r7oLmcrM8qnWMxCdLUiPYTWA38zFM3j39+24tFGo=
Received: from localhost (localhost [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id 294C1452878;
        Thu, 21 Jan 2021 13:39:23 +0200 (EET)
Received: from eu-shark2.inbox.eu ([127.0.0.1])
        by localhost (eu-shark2.inbox.eu [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id LmzsHD7PN4Y1; Thu, 21 Jan 2021 13:39:22 +0200 (EET)
Received: from mail.inbox.eu (eu-pop1 [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id 373874528BF;
        Thu, 21 Jan 2021 13:39:22 +0200 (EET)
Received: from localhost.localdomain (unknown [45.87.95.231])
        (Authenticated sender: l@damenly.su)
        by mail.inbox.eu (Postfix) with ESMTPA id BB43C1BE0122;
        Thu, 21 Jan 2021 13:39:19 +0200 (EET)
From:   Su Yue <l@damenly.su>
To:     linux-btrfs@vger.kernel.org
Cc:     l@damenly.su, stable@vger.kernel.org,
        Erhard F <erhard_f@mailbox.org>
Subject: [PATCH] btrfs: fix lockdep warning due to seqcount_mutex_init() with wrong address
Date:   Thu, 21 Jan 2021 19:39:10 +0800
Message-Id: <20210121113910.14681-1-l@damenly.su>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: OK
X-ESPOL: 885mkI9QEjm6g1u/QXjfGWREoi5VL5Pou7j6zG4qkQGaLUzwc0kLUBG1lW93SXqk
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

while running xfstests on 32 bits test box, many tests failed because of
warnings in dmesg. One of those warnings(btrfs/003):
========================================================================
[   66.441305] ------------[ cut here ]------------
[   66.441317] WARNING: CPU: 6 PID: 9251 at include/linux/seqlock.h:279 btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
[   66.441446] CPU: 6 PID: 9251 Comm: btrfs Tainted: G           O      5.11.0-rc4-custom+ #5
[   66.441449] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
[   66.441451] EIP: btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
[   66.441472] EAX: 00000000 EBX: 00000001 ECX: c576070c EDX: c6b15803
[   66.441475] ESI: 10000000 EDI: 00000000 EBP: c56fbcfc ESP: c56fbc70
[   66.441477] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
[   66.441481] CR0: 80050033 CR2: 05c8da20 CR3: 04b20000 CR4: 00350ed0
[   66.441485] Call Trace:
[   66.441510]  btrfs_relocate_chunk+0xb1/0x100 [btrfs]
[   66.441529]  ? btrfs_lookup_block_group+0x17/0x20 [btrfs]
[   66.441562]  btrfs_balance+0x8ed/0x13b0 [btrfs]
[   66.441586]  ? btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
[   66.441619]  ? __this_cpu_preempt_check+0xf/0x11
[   66.441643]  btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
[   66.441664]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[   66.441683]  btrfs_ioctl+0x414/0x2ae0 [btrfs]
[   66.441700]  ? __lock_acquire+0x35f/0x2650
[   66.441717]  ? lockdep_hardirqs_on+0x87/0x120
[   66.441720]  ? lockdep_hardirqs_on_prepare+0xd0/0x1e0
[   66.441724]  ? call_rcu+0x2d3/0x530
[   66.441731]  ? __might_fault+0x41/0x90
[   66.441736]  ? kvm_sched_clock_read+0x15/0x50
[   66.441740]  ? sched_clock+0x8/0x10
[   66.441745]  ? sched_clock_cpu+0x13/0x180
[   66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[   66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[   66.441768]  __ia32_sys_ioctl+0x165/0x8a0
[   66.441773]  ? __this_cpu_preempt_check+0xf/0x11
[   66.441785]  ? __might_fault+0x89/0x90
[   66.441791]  __do_fast_syscall_32+0x54/0x80
[   66.441796]  do_fast_syscall_32+0x32/0x70
[   66.441801]  do_SYSENTER_32+0x15/0x20
[   66.441805]  entry_SYSENTER_32+0x9f/0xf2
[   66.441808] EIP: 0xab7b5549
[   66.441814] EAX: ffffffda EBX: 00000003 ECX: c4009420 EDX: bfa91f5c
[   66.441816] ESI: 00000003 EDI: 00000001 EBP: 00000000 ESP: bfa91e98
[   66.441818] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[   66.441833] irq event stamp: 42579
[   66.441835] hardirqs last  enabled at (42585): [<c60eb065>] console_unlock+0x495/0x590
[   66.441838] hardirqs last disabled at (42590): [<c60eafd5>] console_unlock+0x405/0x590
[   66.441840] softirqs last  enabled at (41698): [<c601b76c>] call_on_stack+0x1c/0x60
[   66.441843] softirqs last disabled at (41681): [<c601b76c>] call_on_stack+0x1c/0x60
[   66.441846] ---[ end trace 7a9311b3f90a392e ]---
========================================================================

========================================================================
btrfs_remove_chunk+0x58b/0x7b0:
__seqprop_mutex_assert at linux/./include/linux/seqlock.h:279
(inlined by) btrfs_device_set_bytes_used at linux/fs/btrfs/volumes.h:212
(inlined by) btrfs_remove_chunk at linux/fs/btrfs/volumes.c:2994
========================================================================

The warning is produced by lockdep_assert_held() in
__seqprop_mutex_assert() if CONFIG_LOCKDEP is enabled.
And "volumes.c:2994" is btrfs_device_set_bytes_used() with mutex lock
&fs_info->chunk_mutex hold already.

After adding some debug prints, the cause was found that manyq
__alloc_device() are called with NULL @fs_info. Inside the function,
btrfs_device_data_ordered_init() is expanded to seqcount_mutex_init().
In this scenario, its second parameter(&info->chunk_mutex) passed is
&NULL->chunk_mutex which equals to offsetof(struct btrfs_fs_info,
chunk_mutex) unexpectly. Thus, seqcount_mutex_init() is called in wrong
way. And later btrfs_get/set_device_*() helpers triger lockdep warnings.

The complex solution is to delay the call of btrfs_device_data_ordered_
init() so the lockdep functionality can work well.
It requires that no btrfs_get/set_device_*() is called between
btrfs_alloc_device with NULL @fs_info and the delayed
btrfs_device_data_ordered_init(). Otherwise, total_bytes, disk_total_
bytes and bytes_uesed of device may be inconsistent in 32 bits
environments.

Here simply reverts commit d5c8238849e7 ("btrfs: convert data_seqcount to
seqcount_mutex_t") to fix this.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210139
Fixes: d5c8238849e7 ("btrfs: convert data_seqcount to seqcount_mutex_t")
CC: stable@vger.kernel.org # 5.10
Reported-by: Erhard F <erhard_f@mailbox.org>
Signed-off-by: Su Yue <l@damenly.su>
---
 fs/btrfs/volumes.c |  2 +-
 fs/btrfs/volumes.h | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b62be84833e9..71c4e43738ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -433,7 +433,7 @@ static struct btrfs_device *__alloc_device(struct btrfs_fs_info *fs_info)
 
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
-	btrfs_device_data_ordered_init(dev, fs_info);
+	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	extent_io_tree_init(fs_info, &dev->alloc_state,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1997a4649a66..c43663d9c22e 100644
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
@@ -76,8 +76,7 @@ struct btrfs_device {
 	blk_status_t last_flush_error;
 
 #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
-	/* A seqcount_t with associated chunk_mutex (for lockdep) */
-	seqcount_mutex_t data_seqcount;
+	seqcount_t data_seqcount;
 #endif
 
 	/* the internal btrfs device id */
@@ -168,9 +167,11 @@ btrfs_device_get_##name(const struct btrfs_device *dev)			\
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
-- 
2.30.0

