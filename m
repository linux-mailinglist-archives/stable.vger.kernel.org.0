Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884483042AC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392810AbhAZPdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 10:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391346AbhAZPc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 10:32:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BE8C061D7F;
        Tue, 26 Jan 2021 07:32:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d2so16699925edz.3;
        Tue, 26 Jan 2021 07:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GlM/movGaLFp+dEaGV7dcqUKDgwCIxEsQty8vxNBGnE=;
        b=n7RcP8YxwZau1CrcXBd8w9k5du264UU7PtLt2nj1tmH3rsJc7xOcP5ixxaO+UQhBRa
         Jl/S0exWO5UffUORVmqbJArsN6hVG5ok/3DL4qPDWGW5U8Me780EqOGNnzWSIjL7J+eH
         6MZtQcmFONK85sMwnYnGph+tfzeF9nCN0U8fCP4SjEDUK6uwSClXpkM4hJoUilpnxcmn
         X/4g9Pgpzs6oDiFtUYvS4ZRl+vjhvo0IR+xDEw6tvW6QxYAXmLZ6DBEmkx1xSUg/ychn
         Wpg3/LN9a3tmRYg56rEeAbF+rqKMFsf7o/4e3e0CYftT9SoZA+ArG0r2jL8vR/3EhVYD
         qQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GlM/movGaLFp+dEaGV7dcqUKDgwCIxEsQty8vxNBGnE=;
        b=mMKpoDvkBkKvpZKO/4J8z+7cuiOCrdnFrED4UjBN+RPjy1ckQHb6U2/fCzbKyZkXty
         PjFP5Q5RaiBRtnL1DCiUqfsgLDobTnF2HpVxIMCFeKB5BEtY/Vz3D7AY1J3ViaE094+e
         26jp4F7s1YVjUGJMII/SOPtvKmDCb8wtZTwE9VriSmzzFBKQ+NvGh6bMrcNsjmm53+9J
         u/zrcIjS+vTxpEzrb5PvRWv70GY6t6ZUKyEZHPu1n064pTVvEmeHMzQl33SB08XBI1OP
         +Zb6ju4qcNIsQom4RtCmOiXsdzBt5mToOEy7SpsbUcWjbZtdJTof6jRSj3+yDVjZM8TZ
         eR+g==
X-Gm-Message-State: AOAM531FLR/uQuDW/M90f+6r6jhcMcUU8FvH2aGroN1snY7HoMEvkJIY
        e4SJA2nSd9dIg9PvJg5M6I1r1TXs5tQ=
X-Google-Smtp-Source: ABdhPJx06Ziww/HcjlLcNhTDWDIdao3VTZ5cKhxz/FujEKolPwCfpy5zM+2YxTYuZsKBt9BmE7p5jg==
X-Received: by 2002:a05:6402:424a:: with SMTP id g10mr4970525edb.236.1611675136145;
        Tue, 26 Jan 2021 07:32:16 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id k22sm12888978edv.33.2021.01.26.07.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 07:32:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
Date:   Tue, 26 Jan 2021 15:28:27 +0000
Message-Id: <70fb7f91ecc0aeff3427c215ec7f46ceb77f88ef.1611674535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611674535.git.asml.silence@gmail.com>
References: <cover.1611674535.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09aada153a71..f3f2b37e7021 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8873,30 +8873,33 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
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
+	list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
+		if (!io_match_task(req, task, files))
+			cnt++;
+	}
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
@@ -8905,7 +8908,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		io_cqring_overflow_flush(ctx, true, task, files);
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

