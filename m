Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C90344151
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhCVMch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhCVMb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79203619A0;
        Mon, 22 Mar 2021 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416309;
        bh=M+QC5G0V9HXNj4mcKbiKhkpNuj8vw++9JcRtLGNS1D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBGjtyYiWdHC4hsDiac/EOGgaaFiPyQyV0RFnGZTTH7lqKRsIleL7TB5vLknH90+W
         50sPGvJ0G8u9XRm5MYVdVkkyL2x55lRiGJcS80CqVCqKvPDRM8mkrcZsI10XIuL0FV
         X4Qw9dwZO75olsCMfbbtN4Jht0J7p7+bGwUx7aXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 057/120] io_uring: ensure that SQPOLL thread is started for exit
Date:   Mon, 22 Mar 2021 13:27:20 +0100
Message-Id: <20210322121931.586233426@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 3ebba796fa251d042be42b929a2d916ee5c34a49 upstream.

If we create it in a disabled state because IORING_SETUP_R_DISABLED is
set on ring creation, we need to ensure that we've kicked the thread if
we're exiting before it's been explicitly disabled. Otherwise we can run
into a deadlock where exit is waiting go park the SQPOLL thread, but the
SQPOLL thread itself is waiting to get a signal to start.

That results in the below trace of both tasks hung, waiting on each other:

INFO: task syz-executor458:8401 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210226-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor458 state:D stack:27536 pid: 8401 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_park fs/io_uring.c:7115 [inline]
 io_sq_thread_park+0xd5/0x130 fs/io_uring.c:7103
 io_uring_cancel_task_requests+0x24c/0xd90 fs/io_uring.c:8745
 __io_uring_files_cancel+0x110/0x230 fs/io_uring.c:8840
 io_uring_files_cancel include/linux/io_uring.h:47 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43e899
RSP: 002b:00007ffe89376d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004af2f0 RCX: 000000000043e899
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004af2f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task iou-sqp-8401:8402 can't die for more than 143 seconds.
task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-sqp-8401:8402 blocked for more than 143 seconds.

Reported-by: syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2221,6 +2221,7 @@ static void __io_req_task_submit(struct
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
 
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_sq_thread_drop_mm_files();
 }
@@ -8965,6 +8966,8 @@ static void io_disable_sqo_submit(struct
 {
 	mutex_lock(&ctx->uring_lock);
 	ctx->sqo_dead = 1;
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		io_sq_offload_start(ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* make sure callers enter the ring to get error */
@@ -9980,10 +9983,7 @@ static int io_register_enable_rings(stru
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-
 	io_sq_offload_start(ctx);
-
 	return 0;
 }
 


