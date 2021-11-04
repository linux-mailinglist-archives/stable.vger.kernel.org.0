Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7024454DC
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhKDOSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhKDORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941C5611F2;
        Thu,  4 Nov 2021 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035303;
        bh=1Y1KOPdt+6QP48a/iSMNe2JsSc8bk6efZqXl53F5c+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPvbglNJ8Tb62ct+Sx3yz9s8rscKHn9vNaUfDLoZ6jrqvIiFg0zJMa/ZBM9UHrWjS
         ygkP4no/wCQcyILu6aUoWVe7EKlu7/LjznQHihFptLxosJ3Z6xx5ZXwbcGllLv5/w5
         t63Tk5iQOffR1uLbkIkrZtUP06on87D5ufQe6s+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.10 02/16] Revert "io_uring: reinforce cancel on flush during exit"
Date:   Thu,  4 Nov 2021 15:12:41 +0100
Message-Id: <20211104141159.644024875@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

This reverts commit 88dbd085a51ec78c83dde79ad63bca8aa4272a9d.

Causes the following Syzkaller reported issue:

BUG: kernel NULL pointer dereference, address: 0000000000000010
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 546 Comm: syz-executor631 Tainted: G    B             5.10.76-syzkaller-01178-g4944ec82ebb9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 prepare_to_wait+0x9c/0x290 syzkaller/managers/android-5-10/kernel/kernel/sched/wait.c:248
 io_uring_cancel_files syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8690 [inline]
 io_uring_cancel_task_requests+0x16a9/0x1ed0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8760
 io_uring_flush+0x170/0x6d0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8923
 filp_close+0xb0/0x150 syzkaller/managers/android-5-10/kernel/fs/open.c:1319
 close_files syzkaller/managers/android-5-10/kernel/fs/file.c:401 [inline]
 put_files_struct+0x1d4/0x350 syzkaller/managers/android-5-10/kernel/fs/file.c:429
 exit_files+0x80/0xa0 syzkaller/managers/android-5-10/kernel/fs/file.c:458
 do_exit+0x6d9/0x23a0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:808
 do_group_exit+0x16a/0x2d0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:910
 get_signal+0x133e/0x1f80 syzkaller/managers/android-5-10/kernel/kernel/signal.c:2790
 arch_do_signal+0x8d/0x620 syzkaller/managers/android-5-10/kernel/arch/x86/kernel/signal.c:805
 exit_to_user_mode_loop syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0xaa/0xe0 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x24/0x40 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:266
 do_syscall_64+0x3d/0x70 syzkaller/managers/android-5-10/kernel/arch/x86/entry/common.c:56
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc6d1589a89
Code: Unable to access opcode bytes at RIP 0x7fc6d1589a5f.
RSP: 002b:00007ffd2b5da728 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffdfc RBX: 0000000000005193 RCX: 00007fc6d1589a89
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fc6d161142c
RBP: 0000000000000032 R08: 00007ffd2b5eb0b8 R09: 0000000000000000
R10: 00007ffd2b5da750 R11: 0000000000000246 R12: 00007fc6d161142c
R13: 00007ffd2b5da750 R14: 00007ffd2b5da770 R15: 0000000000000000
Modules linked in:
CR2: 0000000000000010
---[ end trace fe8044f7dc4d8d65 ]---
RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	e8 d5 29 09 fd       	callq  0xfd0929dc
   7:	4c 89 e7             	mov    %r12,%rdi
   a:	be 04 00 00 00       	mov    $0x4,%esi
   f:	e8 c8 29 09 fd       	callq  0xfd0929dc
  14:	42 8a 04 3b          	mov    (%rbx,%r15,1),%al
  18:	84 c0                	test   %al,%al
  1a:	0f 85 be 00 00 00    	jne    0xde
  20:	8b 44 24 40          	mov    0x40(%rsp),%eax
  24:	b9 01 00 00 00       	mov    $0x1,%ecx
* 29:	f0 41 0f b1 4d 00    	lock cmpxchg %ecx,0x0(%r13) <-- trapping instruction
  2f:	75 45                	jne    0x76
  31:	48 c7 44 24 20 0e 36 	movq   $0x45e0360e,0x20(%rsp)
  38:	e0 45
  3a:	4b                   	rex.WXB
  3b:	c7                   	.byte 0xc7
  3c:	04 37                	add    $0x37,%al

Link: https://syzkaller.appspot.com/bug?extid=b0003676644cf0d6acc4
Reported-by: syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8759,9 +8759,10 @@ static void io_uring_cancel_task_request
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
-	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);


