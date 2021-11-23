Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD945AFFE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 00:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhKWX06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 18:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236364AbhKWX0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 18:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ACBA60F9F;
        Tue, 23 Nov 2021 23:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637709824;
        bh=5mD5Ft2248hZ6MnliW2gzW5inXXajMFC3BXdha2gcpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKZH4SCjryMMRU7IGwflwTKcsyuyvsZVfJOi8HdqqujH1O9AcN1qXZpFvgQuZUE5Q
         nSi/zrN/RAoEkZ60usvpedD6E/Pqb56+1Iwk4CvJIuQzp+JNBLRp+QyL3+JhxDsTv1
         A84wCGsSqD103O0AuF8LslJ0YvTkbkkxZ2N8kIXC9kz1tX10sSvIgvF59U3kVU0QK2
         kaFFsrviqC5bTJILo2zz9cvl26ySj1r9aM1M8bqs6nZCSo8PHMBWCXP2QPb3mvgwzc
         9jJyjEs68EytXeCScmiqSIijjJenBX79hVp6uGb18hRfnqPOfpn2kp0uk59GbwE8tg
         xnXrNAwkQTcZQ==
Date:   Tue, 23 Nov 2021 15:23:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Cc:     Ramji Jiyani <ramjiyani@google.com>, arnd@arndb.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] aio: Add support for the POLLFREE
Message-ID: <YZ13/8WOXY7cxYsV@sol.localdomain>
References: <20211027011834.2497484-1-ramjiyani@google.com>
 <YZ1F4qmBJ42VpZp3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ1F4qmBJ42VpZp3@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 11:49:54AM -0800, Eric Biggers wrote:
> On Wed, Oct 27, 2021 at 01:18:34AM +0000, Ramji Jiyani wrote:
> > Add support for the POLLFREE flag to force complete iocb inline in
> > aio_poll_wake(). A thread may use it to signal it's exit and/or request
> > to cleanup while pending poll request. In this case, aio_poll_wake()
> > needs to make sure it doesn't keep any reference to the queue entry
> > before returning from wake to avoid possible use after free via
> > poll_cancel() path.
> > 
> > UAF issue was found during binder and aio interactions in certain
> > sequence of events [1].
> > 
> > The POLLFREE flag is no more exclusive to the epoll and is being
> > shared with the aio. Remove comment from poll.h to avoid confusion.
> > 
> > [1] https://lore.kernel.org/r/CAKUd0B_TCXRY4h1hTztfwWbNSFQqsudDLn2S_28csgWZmZAG3Q@mail.gmail.com/
> > 
> > Fixes: af5c72b1fc7a ("Fix aio_poll() races")
> > Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
> > Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Cc: stable@vger.kernel.org # 4.19+
> > ---
> 
> Looks good, feel free to add:
> 
> 	Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> I'm still not 100% happy with the commit message, but it's good enough.
> The actual code looks correct.
> 
> Who is going to take this patch?  This is an important fix; it shouldn't be
> sitting ignored for months.  get_maintainer.pl shows:
> 
> $ ./scripts/get_maintainer.pl fs/aio.c
> Benjamin LaHaise <bcrl@kvack.org> (supporter:AIO)
> Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS and infrastructure))
> linux-aio@kvack.org (open list:AIO)
> linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure))
> linux-kernel@vger.kernel.org (open list)

Actually, there is a bug in this patch -- it creates a lock inversion between
ctx->ctx_lock (kioctx::ctx_lock) and req->head->lock (wait_queue_head::lock).

Task 1:
	signalfd_cleanup()
	  -> wake_up_poll() [takes wait_queue_head::lock]
	    -> aio_poll_wake() [takes kioctx::ctx_lock]

Task 2:
	sys_io_cancel() [takes kioctx::ctx_lock]
	  -> aio_poll_cancel [takes wait_queue_head::lock]

Previously this was okay because the lock operation in aio_poll_wake() was only
a trylock.  This patch changes it to a regular lock, which causes a deadlock.

I am able to reproduce this deadlock.  It also generates a lockdep report, shown
below.  Unfortunately, I don't know how to fix it.  Anyone have any ideas?
Al and Christoph, it looks like you wrote most of the aio poll code?

Note, the use-after-free this patch is fixing also affects signalfd, not just
binder, since both rely on POLLFREE.  (I was testing it with signalfd.)  So we
really need to fix it one way or another...

======================================================
WARNING: possible circular locking dependency detected
5.16.0-rc2-00001-gf97efc5c03bf #22 Not tainted
------------------------------------------------------
aio/137 is trying to acquire lock:
ffff888006170158 (&ctx->ctx_lock){..-.}-{2:2}, at: aio_poll_wake+0x1ac/0x390 fs/aio.c:1693

but task is already holding lock:
ffff8880053a91e0 (&sighand->signalfd_wqh){....}-{2:2}, at: __wake_up_common_lock+0x5b/0xb0 kernel/sched/wait.c:137

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&sighand->signalfd_wqh){....}-{2:2}:
       __lock_acquire+0x4b4/0x960 kernel/locking/lockdep.c:5027
       lock_acquire kernel/locking/lockdep.c:5637 [inline]
       lock_acquire+0xc9/0x2e0 kernel/locking/lockdep.c:5602
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:349 [inline]
       aio_poll.constprop.0+0x15d/0x440 fs/aio.c:1773
       __io_submit_one.constprop.0+0x139/0x1b0 fs/aio.c:1847
       io_submit_one+0x134/0x640 fs/aio.c:1884
       __do_sys_io_submit fs/aio.c:1943 [inline]
       __se_sys_io_submit fs/aio.c:1913 [inline]
       __x64_sys_io_submit+0x89/0x260 fs/aio.c:1913
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&ctx->ctx_lock){..-.}-{2:2}:
       check_prev_add+0x93/0xbf0 kernel/locking/lockdep.c:3063
       check_prevs_add kernel/locking/lockdep.c:3186 [inline]
       validate_chain+0x585/0x8c0 kernel/locking/lockdep.c:3801
       __lock_acquire+0x4b4/0x960 kernel/locking/lockdep.c:5027
       lock_acquire kernel/locking/lockdep.c:5637 [inline]
       lock_acquire+0xc9/0x2e0 kernel/locking/lockdep.c:5602
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3e/0x60 kernel/locking/spinlock.c:162
       aio_poll_wake+0x1ac/0x390 fs/aio.c:1693
       __wake_up_common+0x8c/0x1a0 kernel/sched/wait.c:108
       __wake_up_common_lock+0x77/0xb0 kernel/sched/wait.c:138
       __wake_up+0xe/0x10 kernel/sched/wait.c:157
       signalfd_cleanup+0x33/0x40 fs/signalfd.c:48
       __cleanup_sighand kernel/fork.c:1613 [inline]
       __cleanup_sighand+0x27/0x50 kernel/fork.c:1610
       __exit_signal+0x236/0x380 kernel/exit.c:159
       release_task+0x180/0x3d0 kernel/exit.c:200
       wait_task_zombie+0x28a/0x600 kernel/exit.c:1114
       wait_consider_task+0x121/0x160 kernel/exit.c:1341
       do_wait_thread kernel/exit.c:1404 [inline]
       do_wait+0x21b/0x380 kernel/exit.c:1521
       kernel_wait4+0xaa/0x150 kernel/exit.c:1684
       __do_sys_wait4+0x85/0x90 kernel/exit.c:1712
       __se_sys_wait4 kernel/exit.c:1708 [inline]
       __x64_sys_wait4+0x17/0x20 kernel/exit.c:1708
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sighand->signalfd_wqh);
                               lock(&ctx->ctx_lock);
                               lock(&sighand->signalfd_wqh);
  lock(&ctx->ctx_lock);

 *** DEADLOCK ***

2 locks held by aio/137:
 #0: ffffffff81e06098 (tasklist_lock){.+.+}-{2:2}, at: release_task+0x110/0x3d0 kernel/exit.c:197
 #1: ffff8880053a91e0 (&sighand->signalfd_wqh){....}-{2:2}, at: __wake_up_common_lock+0x5b/0xb0 kernel/sched/wait.c:137

stack backtrace:
CPU: 3 PID: 137 Comm: aio Not tainted 5.16.0-rc2-00001-gf97efc5c03bf #22
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
Call Trace:
 <TASK>
 show_stack+0x3d/0x3f arch/x86/kernel/dumpstack.c:318
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x49/0x5e lib/dump_stack.c:106
 dump_stack+0x10/0x12 lib/dump_stack.c:113
 print_circular_bug.cold+0x13e/0x143 kernel/locking/lockdep.c:2021
 check_noncircular+0xfe/0x110 kernel/locking/lockdep.c:2143
 check_prev_add+0x93/0xbf0 kernel/locking/lockdep.c:3063
 check_prevs_add kernel/locking/lockdep.c:3186 [inline]
 validate_chain+0x585/0x8c0 kernel/locking/lockdep.c:3801
 __lock_acquire+0x4b4/0x960 kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0xc9/0x2e0 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3e/0x60 kernel/locking/spinlock.c:162
 aio_poll_wake+0x1ac/0x390 fs/aio.c:1693
 __wake_up_common+0x8c/0x1a0 kernel/sched/wait.c:108
 __wake_up_common_lock+0x77/0xb0 kernel/sched/wait.c:138
 __wake_up+0xe/0x10 kernel/sched/wait.c:157
 signalfd_cleanup+0x33/0x40 fs/signalfd.c:48
 __cleanup_sighand kernel/fork.c:1613 [inline]
 __cleanup_sighand+0x27/0x50 kernel/fork.c:1610
 __exit_signal+0x236/0x380 kernel/exit.c:159
 release_task+0x180/0x3d0 kernel/exit.c:200
 wait_task_zombie+0x28a/0x600 kernel/exit.c:1114
 wait_consider_task+0x121/0x160 kernel/exit.c:1341
 do_wait_thread kernel/exit.c:1404 [inline]
 do_wait+0x21b/0x380 kernel/exit.c:1521
 kernel_wait4+0xaa/0x150 kernel/exit.c:1684
 __do_sys_wait4+0x85/0x90 kernel/exit.c:1712
 __se_sys_wait4 kernel/exit.c:1708 [inline]
 __x64_sys_wait4+0x17/0x20 kernel/exit.c:1708
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f23a3b0e9ea
Code: ff e9 0a 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e c3 0f 1f 44 00 00 48 83 ec 28 89 54 24 14
RSP: 002b:00007ffcd0926098 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f23a3b0e9ea
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: 000055944067b000 R08: fffffffe7fffffff R09: fffffffe7fffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00005594406761c0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
