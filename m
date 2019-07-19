Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21BE6DF74
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfGSEfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729449AbfGSEB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B653A21851;
        Fri, 19 Jul 2019 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508887;
        bh=XCD9iVH2VFQCkF776NAHQBSgULYTtbS4COICYJp0DIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ml7VersReUCqZft+LtcmO5TIJmixdPe/Tq5i+ugLuI8y4BAEp85M3fzdEVxsW/xhj
         baoRQDPjWZxmeFCGCcdZGzPpzAar766V+GbSv+Fh/S+vQ0DOH3K8O5Xe1pW1HzHlYJ
         EKk2XRYi/RFF4UQbsmBXGXL0tB2d643wU3Ojv3yA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>,
        syzbot+94324416c485d422fe15@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 138/171] io_uring: fix io_sq_thread_stop running in front of io_sq_thread
Date:   Thu, 18 Jul 2019 23:56:09 -0400
Message-Id: <20190719035643.14300-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit a4c0b3decb33fb4a2b5ecc6234a50680f0b21e7d ]

INFO: task syz-executor.5:8634 blocked for more than 143 seconds.
       Not tainted 5.2.0-rc5+ #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.5  D25632  8634   8224 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:2818 [inline]
  __schedule+0x658/0x9e0 kernel/sched/core.c:3445
  schedule+0x131/0x1d0 kernel/sched/core.c:3509
  schedule_timeout+0x9a/0x2b0 kernel/time/timer.c:1783
  do_wait_for_common+0x35e/0x5a0 kernel/sched/completion.c:83
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x47/0x60 kernel/sched/completion.c:136
  kthread_stop+0xb4/0x150 kernel/kthread.c:559
  io_sq_thread_stop fs/io_uring.c:2252 [inline]
  io_finish_async fs/io_uring.c:2259 [inline]
  io_ring_ctx_free fs/io_uring.c:2770 [inline]
  io_ring_ctx_wait_and_kill+0x268/0x880 fs/io_uring.c:2834
  io_uring_release+0x5d/0x70 fs/io_uring.c:2842
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:168 [inline]
  prepare_exit_to_usermode+0x402/0x4f0 arch/x86/entry/common.c:199
  syscall_return_slowpath+0x110/0x440 arch/x86/entry/common.c:279
  do_syscall_64+0x126/0x140 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x412fb1
Code: 80 3b 7c 0f 84 c7 02 00 00 c7 85 d0 00 00 00 00 00 00 00 48 8b 05 cf
a6 24 00 49 8b 14 24 41 b9 cb 2a 44 00 48 89 ee 48 89 df <48> 85 c0 4c 0f
45 c8 45 31 c0 31 c9 e8 0e 5b 00 00 85 c0 41 89 c7
RSP: 002b:00007ffe7ee6a180 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000412fb1
RDX: 0000001b2d920000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00000000f3a3e1f8 R09: 00000000f3a3e1fc
R10: 00007ffe7ee6a260 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 0000000000024c00 R15: 000000000075bf2c

=============================================

There is an wrong logic, when kthread_park running
in front of io_sq_thread.

CPU#0					CPU#1

io_sq_thread_stop:			int kthread(void *_create):

kthread_park()
					__kthread_parkme(self);	 <<< Wrong
kthread_stop()
    << wait for self->exited
    << clear_bit KTHREAD_SHOULD_PARK

					ret = threadfn(data);
					   |
					   |- io_sq_thread
					       |- kthread_should_park()	<< false
					       |- schedule() <<< nobody wake up

stuck CPU#0				stuck CPU#1

So, use a new variable sqo_thread_started to ensure that io_sq_thread
run first, then io_sq_thread_stop.

Reported-by: syzbot+94324416c485d422fe15@syzkaller.appspotmail.com
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ef62a45045d..fef2cd44b2ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,6 +231,7 @@ struct io_ring_ctx {
 	struct task_struct	*sqo_thread;	/* if using sq thread polling */
 	struct mm_struct	*sqo_mm;
 	wait_queue_head_t	sqo_wait;
+	struct completion	sqo_thread_started;
 
 	struct {
 		/* CQ ring */
@@ -403,6 +404,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->flags = p->flags;
 	init_waitqueue_head(&ctx->cq_wait);
 	init_completion(&ctx->ctx_done);
+	init_completion(&ctx->sqo_thread_started);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	for (i = 0; i < ARRAY_SIZE(ctx->pending_async); i++) {
@@ -2009,6 +2011,8 @@ static int io_sq_thread(void *data)
 	unsigned inflight;
 	unsigned long timeout;
 
+	complete(&ctx->sqo_thread_started);
+
 	old_fs = get_fs();
 	set_fs(USER_DS);
 
@@ -2243,6 +2247,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 {
 	if (ctx->sqo_thread) {
+		wait_for_completion(&ctx->sqo_thread_started);
 		/*
 		 * The park is a bit of a work-around, without it we get
 		 * warning spews on shutdown with SQPOLL set and affinity
-- 
2.20.1

