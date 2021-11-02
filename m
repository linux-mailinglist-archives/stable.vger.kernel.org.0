Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B4B44321A
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhKBP45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 11:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhKBP44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 11:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52FC860F70;
        Tue,  2 Nov 2021 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635868461;
        bh=c613B/51b6bDm1GcoVj+H/Wzr4te9tRl8TXBB57MdsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgvXxm0TKc+l5rsOGAgBmVMLlYOtSUNL/Ckwxgw1QrW9UwRCJ9rhwfTXNmeRUDVzQ
         f0RrPctXMuCGqb58uxMMvZ5TIhbseypLUw5BwuKSNlFCXat2WpqAENQ46Q4zhKn+ZC
         +aJhIGM5TlvfgkiqAoGIC7oQ22X+3eJ8rYEmLBA4=
Date:   Tue, 2 Nov 2021 16:54:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org,
        syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
Subject: Re: [PATCH v5.10.y 1/1] Revert "io_uring: reinforce cancel on flush
 during exit"
Message-ID: <YYFfIk2CQaFI0Zdg@kroah.com>
References: <20211102154930.2282421-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102154930.2282421-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 03:49:30PM +0000, Lee Jones wrote:
> This reverts commit 88dbd085a51ec78c83dde79ad63bca8aa4272a9d.
> 
> Causes the following Syzkaller reported issue:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000010
> PGD 0 P4D 0
> Oops: 0002 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 546 Comm: syz-executor631 Tainted: G    B             5.10.76-syzkaller-01178-g4944ec82ebb9 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
> RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
> RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
> RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
> RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
> RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
> Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
> RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
> RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
> RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
> R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
> R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  prepare_to_wait+0x9c/0x290 syzkaller/managers/android-5-10/kernel/kernel/sched/wait.c:248
>  io_uring_cancel_files syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8690 [inline]
>  io_uring_cancel_task_requests+0x16a9/0x1ed0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8760
>  io_uring_flush+0x170/0x6d0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8923
>  filp_close+0xb0/0x150 syzkaller/managers/android-5-10/kernel/fs/open.c:1319
>  close_files syzkaller/managers/android-5-10/kernel/fs/file.c:401 [inline]
>  put_files_struct+0x1d4/0x350 syzkaller/managers/android-5-10/kernel/fs/file.c:429
>  exit_files+0x80/0xa0 syzkaller/managers/android-5-10/kernel/fs/file.c:458
>  do_exit+0x6d9/0x23a0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:808
>  do_group_exit+0x16a/0x2d0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:910
>  get_signal+0x133e/0x1f80 syzkaller/managers/android-5-10/kernel/kernel/signal.c:2790
>  arch_do_signal+0x8d/0x620 syzkaller/managers/android-5-10/kernel/arch/x86/kernel/signal.c:805
>  exit_to_user_mode_loop syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:161 [inline]
>  exit_to_user_mode_prepare+0xaa/0xe0 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:191
>  syscall_exit_to_user_mode+0x24/0x40 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:266
>  do_syscall_64+0x3d/0x70 syzkaller/managers/android-5-10/kernel/arch/x86/entry/common.c:56
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fc6d1589a89
> Code: Unable to access opcode bytes at RIP 0x7fc6d1589a5f.
> RSP: 002b:00007ffd2b5da728 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffdfc RBX: 0000000000005193 RCX: 00007fc6d1589a89
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fc6d161142c
> RBP: 0000000000000032 R08: 00007ffd2b5eb0b8 R09: 0000000000000000
> R10: 00007ffd2b5da750 R11: 0000000000000246 R12: 00007fc6d161142c
> R13: 00007ffd2b5da750 R14: 00007ffd2b5da770 R15: 0000000000000000
> Modules linked in:
> CR2: 0000000000000010
> ---[ end trace fe8044f7dc4d8d65 ]---
> RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
> RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
> RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
> RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
> RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
> RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
> Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
> RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
> RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
> RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
> R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
> R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:	00 00                	add    %al,(%rax)
>    2:	e8 d5 29 09 fd       	callq  0xfd0929dc
>    7:	4c 89 e7             	mov    %r12,%rdi
>    a:	be 04 00 00 00       	mov    $0x4,%esi
>    f:	e8 c8 29 09 fd       	callq  0xfd0929dc
>   14:	42 8a 04 3b          	mov    (%rbx,%r15,1),%al
>   18:	84 c0                	test   %al,%al
>   1a:	0f 85 be 00 00 00    	jne    0xde
>   20:	8b 44 24 40          	mov    0x40(%rsp),%eax
>   24:	b9 01 00 00 00       	mov    $0x1,%ecx
> * 29:	f0 41 0f b1 4d 00    	lock cmpxchg %ecx,0x0(%r13) <-- trapping instruction
>   2f:	75 45                	jne    0x76
>   31:	48 c7 44 24 20 0e 36 	movq   $0x45e0360e,0x20(%rsp)
>   38:	e0 45
>   3a:	4b                   	rex.WXB
>   3b:	c7                   	.byte 0xc7
>   3c:	04 37                	add    $0x37,%al
> 
> LINK: https://syzkaller.appspot.com/bug?extid=b0003676644cf0d6acc4

"Link:"?

> Reported-by: syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Why does the patch here cause this error?  Is it due to the backport
being different than what went into Linus's tree, or something else?

The original commit did fix a real issue, what should we do now to
resolve that issue in 5.10.y instead?

thanks,

greg k-h
