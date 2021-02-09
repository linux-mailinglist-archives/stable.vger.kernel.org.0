Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8BE3147B6
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhBIExX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBIExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:11 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84151C0617AB
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:57 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s3so21892121edi.7
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fz7TC4lv21r3oiKSo78gV7ZqqZF+k/bhoq0zw/cytOQ=;
        b=SYjNvwc2MpEncBKHA9xEqcjNy9r92oxPO0T7Jqti3T1rFVn9unEmW1bAX+Ju/10d35
         tzJ6w3hYMtVchBf0wqJD4JONKQpREXhL/7FfP7Hn2ZMVqbaeqbD0VmLNgscO+81XFLqK
         zaR3f/kJg4XaVJe54LXbfd1PxMyhSr7MD1td6roGKnJQLKIWeFMat5yQyZFNf0PzIlfo
         xKq7YufjCVoN2YvnIr7lhAi68RFpooLpffkKe4YBDRrTLwTMl1dvjkmasoJxr/qgrM4r
         I8pAzdpzdKw//E0IQunKNlAKO6rLU/cq28bw7URBz9yJPl9dmIMU9Lb2Z5h3YjhPNbY8
         DaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fz7TC4lv21r3oiKSo78gV7ZqqZF+k/bhoq0zw/cytOQ=;
        b=Zbm9MK6f7t2jpxwPg2AXh9r2X+M905UkvwCqLxQ+fnHDNX6C4h/IjTyFlueYu29kJp
         F3SUB7fc8fVkJoK5/BZsteB7KHNws/ZdKfWhvI88ifH/Zr1o+UMawnt9zg9Q7XGA9rXq
         YR+uzykbxnhgdHchbdDCg9jPMFMogZp7kBsCDQGFsndhLrwmH/KXE/VITFIp7BIp2OXU
         bdrLCndzR22I4UkH9V7+84zgK6Hs1wB+M4jIZQCOF1g4VM8OG+mmDEhqpS1H7sJvuc5i
         Cl1ENdK83Io3eLtdnmCxGuyChlMKXL+R0gp5dDVQhG1FOttc5CkOsV6atH8wWsDYdD+2
         3ouA==
X-Gm-Message-State: AOAM530G8oCwTtxilaXum8ZYg2ZIqe1X8J9aktEYIG8aORPGefQ61VCw
        LsY3wNKPpENcMDmdBfjchoztcmIng8Y=
X-Google-Smtp-Source: ABdhPJydKq0WT1Lo6oePAqxpbNYozRpWQnVr8Ygbt3apajoOQZr5oijVyzqvxOgrCVimr3cPBvtJyQ==
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr21219038edx.78.1612846316025;
        Mon, 08 Feb 2021 20:51:56 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
Subject: [PATCH 11/16] io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
Date:   Tue,  9 Feb 2021 04:47:45 +0000
Message-Id: <c750da780dd8f9a136727a7be05664afe26b00bf.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3ae0daf97f7..03c1185270d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8586,30 +8586,31 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
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
-
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
+		int inflight;
 
-		/* We need to keep going until we don't find a matching req */
-		if (!found)
+		inflight = io_uring_count_inflight(ctx, task, files);
+		if (!inflight)
 			break;
 
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
@@ -8617,7 +8618,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
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
-- 
2.24.0

