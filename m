Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3660F318E71
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBKP1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhBKPWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6864164E95;
        Thu, 11 Feb 2021 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055796;
        bh=Y/D9TlconG/v/RfHRvPj2cE1WCzKMekYt0QQa4iN0xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GZ3uNTzPDOyWkvTRN83FHJrjvtB24aUES6kQSASCQHUAXrZekkxPbWCIp7xnmlWw
         ILSTcHf0qjzBJeB0S4KFJ/QWbMF8A6FD7YDr7HprfASft/GBSyavMB8UYRo3T6p8qL
         5rIFv6VLNBL3MfryfWtlYLIRAWbLN3PgoY6Yuxwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 11/54] io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
Date:   Thu, 11 Feb 2021 16:01:55 +0100
Message-Id: <20210211150153.372524326@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit ca70f00bed6cb255b7a9b91aa18a2717c9217f70 ]

do not call blocking ops when !TASK_RUNNING; state=2 set at
	[<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0
	kernel/sched/wait.c:262
WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853
	__might_sleep+0xed/0x100 kernel/sched/core.c:7848
RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
Call Trace:
 __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
 io_run_cancel fs/io-wq.c:856 [inline]
 io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
 io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
 io_uring_cancel_files fs/io_uring.c:8874 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
 __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2e6/0x2490 kernel/exit.c:780
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x16b5/0x2030 kernel/signal.c:2770
 arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Rewrite io_uring_cancel_files() to mimic __io_uring_task_cancel()'s
counting scheme, so it does all the heavy work before setting
TASK_UNINTERRUPTIBLE.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: fix inverted task check]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8586,30 +8586,31 @@ static void io_cancel_defer_files(struct
 	}
 }
 
+static int io_uring_count_inflight(struct io_ring_ctx *ctx,
+				   struct task_struct *task,
+				   struct files_struct *files)
+{
+	struct io_kiocb *req;
+	int cnt = 0;
+
+	spin_lock_irq(&ctx->inflight_lock);
+	list_for_each_entry(req, &ctx->inflight_list, inflight_entry)
+		cnt += io_match_task(req, task, files);
+	spin_unlock_irq(&ctx->inflight_lock);
+	return cnt;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_task_cancel cancel = { .task = task, .files = files };
-		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
-		bool found = false;
+		int inflight;
 
-		spin_lock_irq(&ctx->inflight_lock);
-		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (!io_match_task(req, task, files))
-				continue;
-			found = true;
-			break;
-		}
-		if (found)
-			prepare_to_wait(&task->io_uring->wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&ctx->inflight_lock);
-
-		/* We need to keep going until we don't find a matching req */
-		if (!found)
+		inflight = io_uring_count_inflight(ctx, task, files);
+		if (!inflight)
 			break;
 
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
@@ -8617,7 +8618,11 @@ static void io_uring_cancel_files(struct
 		io_kill_timeouts(ctx, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
-		schedule();
+
+		prepare_to_wait(&task->io_uring->wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (inflight == io_uring_count_inflight(ctx, task, files))
+			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
 	}
 }


