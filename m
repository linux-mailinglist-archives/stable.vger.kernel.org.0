Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716EB2FF16F
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 18:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbhAURKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 12:10:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:47266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388501AbhAURKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 12:10:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0C444AAAE;
        Thu, 21 Jan 2021 17:09:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1FFAADA6E3; Thu, 21 Jan 2021 18:07:57 +0100 (CET)
Date:   Thu, 21 Jan 2021 18:07:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Su Yue <l@damenly.su>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Erhard F <erhard_f@mailbox.org>, dave@stgolabs.net
Subject: Re: [PATCH] btrfs: fix lockdep warning due to seqcount_mutex_init()
 with wrong address
Message-ID: <20210121170756.GE6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yue <l@damenly.su>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Erhard F <erhard_f@mailbox.org>, dave@stgolabs.net
References: <20210121113910.14681-1-l@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121113910.14681-1-l@damenly.su>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding Davidlohr to CC as it's about reverting his patch.

In d5c8238849e7 ("btrfs: convert data_seqcount to seqcount_mutex_t")
the seqcount_mutex_t was added as an annotation for lockep so by revert
we'd lose that again.

On Thu, Jan 21, 2021 at 07:39:10PM +0800, Su Yue wrote:
> while running xfstests on 32 bits test box, many tests failed because of
> warnings in dmesg. One of those warnings(btrfs/003):
> ========================================================================
> [   66.441305] ------------[ cut here ]------------
> [   66.441317] WARNING: CPU: 6 PID: 9251 at include/linux/seqlock.h:279 btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
> [   66.441446] CPU: 6 PID: 9251 Comm: btrfs Tainted: G           O      5.11.0-rc4-custom+ #5
> [   66.441449] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
> [   66.441451] EIP: btrfs_remove_chunk+0x58b/0x7b0 [btrfs]
> [   66.441472] EAX: 00000000 EBX: 00000001 ECX: c576070c EDX: c6b15803
> [   66.441475] ESI: 10000000 EDI: 00000000 EBP: c56fbcfc ESP: c56fbc70
> [   66.441477] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> [   66.441481] CR0: 80050033 CR2: 05c8da20 CR3: 04b20000 CR4: 00350ed0
> [   66.441485] Call Trace:
> [   66.441510]  btrfs_relocate_chunk+0xb1/0x100 [btrfs]
> [   66.441529]  ? btrfs_lookup_block_group+0x17/0x20 [btrfs]
> [   66.441562]  btrfs_balance+0x8ed/0x13b0 [btrfs]
> [   66.441586]  ? btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
> [   66.441619]  ? __this_cpu_preempt_check+0xf/0x11
> [   66.441643]  btrfs_ioctl_balance+0x333/0x3c0 [btrfs]
> [   66.441664]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [   66.441683]  btrfs_ioctl+0x414/0x2ae0 [btrfs]
> [   66.441700]  ? __lock_acquire+0x35f/0x2650
> [   66.441717]  ? lockdep_hardirqs_on+0x87/0x120
> [   66.441720]  ? lockdep_hardirqs_on_prepare+0xd0/0x1e0
> [   66.441724]  ? call_rcu+0x2d3/0x530
> [   66.441731]  ? __might_fault+0x41/0x90
> [   66.441736]  ? kvm_sched_clock_read+0x15/0x50
> [   66.441740]  ? sched_clock+0x8/0x10
> [   66.441745]  ? sched_clock_cpu+0x13/0x180
> [   66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [   66.441750]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [   66.441768]  __ia32_sys_ioctl+0x165/0x8a0
> [   66.441773]  ? __this_cpu_preempt_check+0xf/0x11
> [   66.441785]  ? __might_fault+0x89/0x90
> [   66.441791]  __do_fast_syscall_32+0x54/0x80
> [   66.441796]  do_fast_syscall_32+0x32/0x70
> [   66.441801]  do_SYSENTER_32+0x15/0x20
> [   66.441805]  entry_SYSENTER_32+0x9f/0xf2
> [   66.441808] EIP: 0xab7b5549
> [   66.441814] EAX: ffffffda EBX: 00000003 ECX: c4009420 EDX: bfa91f5c
> [   66.441816] ESI: 00000003 EDI: 00000001 EBP: 00000000 ESP: bfa91e98
> [   66.441818] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
> [   66.441833] irq event stamp: 42579
> [   66.441835] hardirqs last  enabled at (42585): [<c60eb065>] console_unlock+0x495/0x590
> [   66.441838] hardirqs last disabled at (42590): [<c60eafd5>] console_unlock+0x405/0x590
> [   66.441840] softirqs last  enabled at (41698): [<c601b76c>] call_on_stack+0x1c/0x60
> [   66.441843] softirqs last disabled at (41681): [<c601b76c>] call_on_stack+0x1c/0x60
> [   66.441846] ---[ end trace 7a9311b3f90a392e ]---
> ========================================================================
> 
> ========================================================================
> btrfs_remove_chunk+0x58b/0x7b0:
> __seqprop_mutex_assert at linux/./include/linux/seqlock.h:279
> (inlined by) btrfs_device_set_bytes_used at linux/fs/btrfs/volumes.h:212
> (inlined by) btrfs_remove_chunk at linux/fs/btrfs/volumes.c:2994
> ========================================================================
> 
> The warning is produced by lockdep_assert_held() in
> __seqprop_mutex_assert() if CONFIG_LOCKDEP is enabled.
> And "volumes.c:2994" is btrfs_device_set_bytes_used() with mutex lock
> &fs_info->chunk_mutex hold already.
> 
> After adding some debug prints, the cause was found that manyq
> __alloc_device() are called with NULL @fs_info. Inside the function,
> btrfs_device_data_ordered_init() is expanded to seqcount_mutex_init().
> In this scenario, its second parameter(&info->chunk_mutex) passed is
> &NULL->chunk_mutex which equals to offsetof(struct btrfs_fs_info,
> chunk_mutex) unexpectly. Thus, seqcount_mutex_init() is called in wrong
> way. And later btrfs_get/set_device_*() helpers triger lockdep warnings.
> 
> The complex solution is to delay the call of btrfs_device_data_ordered_
> init() so the lockdep functionality can work well.
> It requires that no btrfs_get/set_device_*() is called between
> btrfs_alloc_device with NULL @fs_info and the delayed
> btrfs_device_data_ordered_init(). Otherwise, total_bytes, disk_total_
> bytes and bytes_uesed of device may be inconsistent in 32 bits
> environments.

If the fs_info is not available at all times, would it be possible to
set it once it is? (And reset when the fs_info is released).
