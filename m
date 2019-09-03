Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C85A6A15
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 15:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 09:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfICNjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 09:39:16 -0400
Received: from zzz.localdomain (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851622339D;
        Tue,  3 Sep 2019 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567517953;
        bh=WX++lsiW5/n4fIM7J1U21PJ8GwhnB7VQJktttkSjvK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdJyn8Ctp+DxnTUsVAaOGnh0ern1YQvY+SnVrEVrcIeSu2DdSjP8e0F8uM+TEpejk
         QdKB45J1OxrhjmvZBjp99LHzNO+iXO/O9WJgUtdU6YEu7al170dFUvLtJK356bRKOJ
         GcnejJKzWUCosUW26X03lm1oAFjVeCvrQq18e1D8=
Date:   Tue, 3 Sep 2019 08:39:10 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fuse: disable irqs for fuse_iqueue::waitq.lock
Message-ID: <20190903133910.GA5144@zzz.localdomain>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <0000000000008d8eac05906691ac@google.com>
 <20190822233529.4176-1-ebiggers@kernel.org>
 <CAJfpegvHgcZGFi-Ydyo2j89zQxqAtZ1Lh0+vC6vWeU-aEFZkYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvHgcZGFi-Ydyo2j89zQxqAtZ1Lh0+vC6vWeU-aEFZkYQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:31:29AM +0200, Miklos Szeredi wrote:
> On Fri, Aug 23, 2019 at 1:35 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > When IOCB_CMD_POLL is used on the FUSE device, aio_poll() disables IRQs
> > and takes kioctx::ctx_lock, then fuse_iqueue::waitq.lock.
> 
> Not in -linus.
> 
> Which tree was this reproduced with?
> 
> Thanks,
> Miklos

Linus's tree.  Here's the full symbolized output on v5.3-rc7:

=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
5.3.0-rc7 #1 Not tainted
-----------------------------------------------------
syz_fuse/150 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
00000000c2701b26 (&fiq->waitq){+.+.}, at: spin_lock include/linux/spinlock.h:338 [inline]
00000000c2701b26 (&fiq->waitq){+.+.}, at: aio_poll fs/aio.c:1751 [inline]
00000000c2701b26 (&fiq->waitq){+.+.}, at: __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825

and this task is already holding:
00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: spin_lock_irq include/linux/spinlock.h:363 [inline]
00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: aio_poll fs/aio.c:1749 [inline]
00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: __io_submit_one.constprop.0+0x1f4/0x5b0 fs/aio.c:1825
which would create a new lock dependency:
 (&(&ctx->ctx_lock)->rlock){..-.} -> (&fiq->waitq){+.+.}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&ctx->ctx_lock)->rlock){..-.}

... which became SOFTIRQ-irq-safe at:
  lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
  _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:167
  spin_lock_irq include/linux/spinlock.h:363 [inline]
  free_ioctx_users+0x25/0x190 fs/aio.c:618
  percpu_ref_put_many include/linux/percpu-refcount.h:293 [inline]
  percpu_ref_put include/linux/percpu-refcount.h:309 [inline]
  percpu_ref_call_confirm_rcu lib/percpu-refcount.c:130 [inline]
  percpu_ref_switch_to_atomic_rcu+0x202/0x210 lib/percpu-refcount.c:165
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch+0x2ae/0x890 kernel/rcu/tree.c:2114
  rcu_core+0x13a/0x370 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0xbe/0x400 kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x8f/0xc0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x8e/0x210 arch/x86/kernel/apic/apic.c:1133
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
  arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
  default_idle+0x29/0x160 arch/x86/kernel/process.c:580
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x1e/0x30 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x1f0/0x220 kernel/sched/idle.c:263
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
  rest_init+0x18a/0x24d init/main.c:451
  arch_call_rest_init+0x9/0xc
  start_kernel+0x530/0x54e init/main.c:785
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:472
  x86_64_start_kernel+0x6d/0x71 arch/x86/kernel/head64.c:453
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

to a SOFTIRQ-irq-unsafe lock:
 (&fiq->waitq){+.+.}

... which became SOFTIRQ-irq-unsafe at:
...
  lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  flush_bg_queue+0x91/0xf0 fs/fuse/dev.c:415
  fuse_request_queue_background+0xd1/0x140 fs/fuse/dev.c:676
  fuse_request_send_background+0x27/0x60 fs/fuse/dev.c:687
  fuse_send_init fs/fuse/inode.c:986 [inline]
  fuse_fill_super+0x656/0x681 fs/fuse/inode.c:1211
  mount_nodev+0x42/0x90 fs/super.c:1329
  fuse_mount+0x13/0x20 fs/fuse/inode.c:1236
  legacy_get_tree+0x2c/0x50 fs/fs_context.c:661
  vfs_get_tree+0x22/0xc0 fs/super.c:1413
  do_new_mount fs/namespace.c:2791 [inline]
  do_mount+0x7e3/0xa60 fs/namespace.c:3111
  ksys_mount+0x7d/0xd0 fs/namespace.c:3320
  __do_sys_mount fs/namespace.c:3334 [inline]
  __se_sys_mount fs/namespace.c:3331 [inline]
  __x64_sys_mount+0x20/0x30 fs/namespace.c:3331
  do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&fiq->waitq);
                               local_irq_disable();
                               lock(&(&ctx->ctx_lock)->rlock);
                               lock(&fiq->waitq);
  <Interrupt>
    lock(&(&ctx->ctx_lock)->rlock);

 *** DEADLOCK ***

1 lock held by syz_fuse/150:
 #0: 00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: spin_lock_irq include/linux/spinlock.h:363 [inline]
 #0: 00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: aio_poll fs/aio.c:1749 [inline]
 #0: 00000000f4c02e81 (&(&ctx->ctx_lock)->rlock){..-.}, at: __io_submit_one.constprop.0+0x1f4/0x5b0 fs/aio.c:1825

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&(&ctx->ctx_lock)->rlock){..-.} {
   IN-SOFTIRQ-W at:
                    lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
                    __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
                    _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:167
                    spin_lock_irq include/linux/spinlock.h:363 [inline]
                    free_ioctx_users+0x25/0x190 fs/aio.c:618
                    percpu_ref_put_many include/linux/percpu-refcount.h:293 [inline]
                    percpu_ref_put include/linux/percpu-refcount.h:309 [inline]
                    percpu_ref_call_confirm_rcu lib/percpu-refcount.c:130 [inline]
                    percpu_ref_switch_to_atomic_rcu+0x202/0x210 lib/percpu-refcount.c:165
                    __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
                    rcu_do_batch+0x2ae/0x890 kernel/rcu/tree.c:2114
                    rcu_core+0x13a/0x370 kernel/rcu/tree.c:2314
                    rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
                    __do_softirq+0xbe/0x400 kernel/softirq.c:292
                    invoke_softirq kernel/softirq.c:373 [inline]
                    irq_exit+0x8f/0xc0 kernel/softirq.c:413
                    exiting_irq arch/x86/include/asm/apic.h:537 [inline]
                    smp_apic_timer_interrupt+0x8e/0x210 arch/x86/kernel/apic/apic.c:1133
                    apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
                    native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
                    arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
                    default_idle+0x29/0x160 arch/x86/kernel/process.c:580
                    arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
                    default_idle_call+0x1e/0x30 kernel/sched/idle.c:94
                    cpuidle_idle_call kernel/sched/idle.c:154 [inline]
                    do_idle+0x1f0/0x220 kernel/sched/idle.c:263
                    cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
                    rest_init+0x18a/0x24d init/main.c:451
                    arch_call_rest_init+0x9/0xc
                    start_kernel+0x530/0x54e init/main.c:785
                    x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:472
                    x86_64_start_kernel+0x6d/0x71 arch/x86/kernel/head64.c:453
                    secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241
   INITIAL USE at:
                   lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
                   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
                   _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:167
                   spin_lock_irq include/linux/spinlock.h:363 [inline]
                   free_ioctx_users+0x25/0x190 fs/aio.c:618
                   percpu_ref_put_many include/linux/percpu-refcount.h:293 [inline]
                   percpu_ref_put include/linux/percpu-refcount.h:309 [inline]
                   percpu_ref_call_confirm_rcu lib/percpu-refcount.c:130 [inline]
                   percpu_ref_switch_to_atomic_rcu+0x202/0x210 lib/percpu-refcount.c:165
                   __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
                   rcu_do_batch+0x2ae/0x890 kernel/rcu/tree.c:2114
                   rcu_core+0x13a/0x370 kernel/rcu/tree.c:2314
                   rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
                   __do_softirq+0xbe/0x400 kernel/softirq.c:292
                   invoke_softirq kernel/softirq.c:373 [inline]
                   irq_exit+0x8f/0xc0 kernel/softirq.c:413
                   exiting_irq arch/x86/include/asm/apic.h:537 [inline]
                   smp_apic_timer_interrupt+0x8e/0x210 arch/x86/kernel/apic/apic.c:1133
                   apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
                   native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
                   arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
                   default_idle+0x29/0x160 arch/x86/kernel/process.c:580
                   arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
                   default_idle_call+0x1e/0x30 kernel/sched/idle.c:94
                   cpuidle_idle_call kernel/sched/idle.c:154 [inline]
                   do_idle+0x1f0/0x220 kernel/sched/idle.c:263
                   cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
                   rest_init+0x18a/0x24d init/main.c:451
                   arch_call_rest_init+0x9/0xc
                   start_kernel+0x530/0x54e init/main.c:785
                   x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:472
                   x86_64_start_kernel+0x6d/0x71 arch/x86/kernel/head64.c:453
                   secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241
 }
 ... key      at: [<ffffffff82860670>] __key.50377+0x0/0x10
 ... acquired at:
   check_prev_add+0xa7/0x950 kernel/locking/lockdep.c:2409
   check_prevs_add kernel/locking/lockdep.c:2507 [inline]
   validate_chain+0x483/0x870 kernel/locking/lockdep.c:2897
   __lock_acquire+0x447/0x7d0 kernel/locking/lockdep.c:3880
   lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:338 [inline]
   aio_poll fs/aio.c:1751 [inline]
   __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825
   io_submit_one+0x146/0x5b0 fs/aio.c:1862
   __do_sys_io_submit fs/aio.c:1921 [inline]
   __se_sys_io_submit+0x8e/0x270 fs/aio.c:1891
   __x64_sys_io_submit+0x15/0x20 fs/aio.c:1891
   do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
   entry_SYSCALL_64_after_hwframe+0x49/0xbe


the dependencies between the lock to be acquired
 and SOFTIRQ-irq-unsafe lock:
-> (&fiq->waitq){+.+.} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:338 [inline]
                    flush_bg_queue+0x91/0xf0 fs/fuse/dev.c:415
                    fuse_request_queue_background+0xd1/0x140 fs/fuse/dev.c:676
                    fuse_request_send_background+0x27/0x60 fs/fuse/dev.c:687
                    fuse_send_init fs/fuse/inode.c:986 [inline]
                    fuse_fill_super+0x656/0x681 fs/fuse/inode.c:1211
                    mount_nodev+0x42/0x90 fs/super.c:1329
                    fuse_mount+0x13/0x20 fs/fuse/inode.c:1236
                    legacy_get_tree+0x2c/0x50 fs/fs_context.c:661
                    vfs_get_tree+0x22/0xc0 fs/super.c:1413
                    do_new_mount fs/namespace.c:2791 [inline]
                    do_mount+0x7e3/0xa60 fs/namespace.c:3111
                    ksys_mount+0x7d/0xd0 fs/namespace.c:3320
                    __do_sys_mount fs/namespace.c:3334 [inline]
                    __se_sys_mount fs/namespace.c:3331 [inline]
                    __x64_sys_mount+0x20/0x30 fs/namespace.c:3331
                    do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
                    entry_SYSCALL_64_after_hwframe+0x49/0xbe
   SOFTIRQ-ON-W at:
                    lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:338 [inline]
                    flush_bg_queue+0x91/0xf0 fs/fuse/dev.c:415
                    fuse_request_queue_background+0xd1/0x140 fs/fuse/dev.c:676
                    fuse_request_send_background+0x27/0x60 fs/fuse/dev.c:687
                    fuse_send_init fs/fuse/inode.c:986 [inline]
                    fuse_fill_super+0x656/0x681 fs/fuse/inode.c:1211
                    mount_nodev+0x42/0x90 fs/super.c:1329
                    fuse_mount+0x13/0x20 fs/fuse/inode.c:1236
                    legacy_get_tree+0x2c/0x50 fs/fs_context.c:661
                    vfs_get_tree+0x22/0xc0 fs/super.c:1413
                    do_new_mount fs/namespace.c:2791 [inline]
                    do_mount+0x7e3/0xa60 fs/namespace.c:3111
                    ksys_mount+0x7d/0xd0 fs/namespace.c:3320
                    __do_sys_mount fs/namespace.c:3334 [inline]
                    __se_sys_mount fs/namespace.c:3331 [inline]
                    __x64_sys_mount+0x20/0x30 fs/namespace.c:3331
                    do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
                    entry_SYSCALL_64_after_hwframe+0x49/0xbe
   INITIAL USE at:
                   lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
                   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                   _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
                   spin_lock include/linux/spinlock.h:338 [inline]
                   flush_bg_queue+0x91/0xf0 fs/fuse/dev.c:415
                   fuse_request_queue_background+0xd1/0x140 fs/fuse/dev.c:676
                   fuse_request_send_background+0x27/0x60 fs/fuse/dev.c:687
                   fuse_send_init fs/fuse/inode.c:986 [inline]
                   fuse_fill_super+0x656/0x681 fs/fuse/inode.c:1211
                   mount_nodev+0x42/0x90 fs/super.c:1329
                   fuse_mount+0x13/0x20 fs/fuse/inode.c:1236
                   legacy_get_tree+0x2c/0x50 fs/fs_context.c:661
                   vfs_get_tree+0x22/0xc0 fs/super.c:1413
                   do_new_mount fs/namespace.c:2791 [inline]
                   do_mount+0x7e3/0xa60 fs/namespace.c:3111
                   ksys_mount+0x7d/0xd0 fs/namespace.c:3320
                   __do_sys_mount fs/namespace.c:3334 [inline]
                   __se_sys_mount fs/namespace.c:3331 [inline]
                   __x64_sys_mount+0x20/0x30 fs/namespace.c:3331
                   do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
                   entry_SYSCALL_64_after_hwframe+0x49/0xbe
 }
 ... key      at: [<ffffffff82863ea0>] __key.40870+0x0/0x10
 ... acquired at:
   check_prev_add+0xa7/0x950 kernel/locking/lockdep.c:2409
   check_prevs_add kernel/locking/lockdep.c:2507 [inline]
   validate_chain+0x483/0x870 kernel/locking/lockdep.c:2897
   __lock_acquire+0x447/0x7d0 kernel/locking/lockdep.c:3880
   lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:338 [inline]
   aio_poll fs/aio.c:1751 [inline]
   __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825
   io_submit_one+0x146/0x5b0 fs/aio.c:1862
   __do_sys_io_submit fs/aio.c:1921 [inline]
   __se_sys_io_submit+0x8e/0x270 fs/aio.c:1891
   __x64_sys_io_submit+0x15/0x20 fs/aio.c:1891
   do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
   entry_SYSCALL_64_after_hwframe+0x49/0xbe


stack backtrace:
CPU: 1 PID: 150 Comm: syz_fuse Not tainted 5.3.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x70/0x9a lib/dump_stack.c:113
 print_bad_irq_dependency.cold+0x380/0x3d8 kernel/locking/lockdep.c:2025
 check_irq_usage+0x337/0x400 kernel/locking/lockdep.c:2223
 check_prev_add+0xa7/0x950 kernel/locking/lockdep.c:2409
 check_prevs_add kernel/locking/lockdep.c:2507 [inline]
 validate_chain+0x483/0x870 kernel/locking/lockdep.c:2897
 __lock_acquire+0x447/0x7d0 kernel/locking/lockdep.c:3880
 lock_acquire+0x99/0x180 kernel/locking/lockdep.c:4412
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2b/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 aio_poll fs/aio.c:1751 [inline]
 __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825
 io_submit_one+0x146/0x5b0 fs/aio.c:1862
 __do_sys_io_submit fs/aio.c:1921 [inline]
 __se_sys_io_submit+0x8e/0x270 fs/aio.c:1891
 __x64_sys_io_submit+0x15/0x20 fs/aio.c:1891
 do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f1bbde7ec6d
Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f3 51 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffffa3a70e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007ffffa3a7140 RCX: 00007f1bbde7ec6d
RDX: 00007ffffa3a70f8 RSI: 0000000000000001 RDI: 00007f1bbe27d000
RBP: 0000559337c29290 R08: 0000000000000000 R09: 00007f1bbe27d000
R10: 0000000000000029 R11: 0000000000000246 R12: 0000559337c29190
R13: 00007ffffa3a72b0 R14: 0000000000000000 R15: 0000000000000000
