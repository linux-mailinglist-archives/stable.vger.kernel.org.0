Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77EA31F26A
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBRWhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 17:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBRWhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 17:37:32 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9559C0613D6;
        Thu, 18 Feb 2021 14:36:51 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id a132so5121908wmc.0;
        Thu, 18 Feb 2021 14:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GibyTGV+B5xsNkZJ26GNbrzMdDaqK1DVh86XCoj0ot8=;
        b=PAtNqDAeDi0QGBf480TnyC2MxAJnBfL8pPYyh+M6Yt5adyS0yaN2AorU/dQGwKNQ4d
         oSRn3tJ/tbYeto7YB4qfWVKmvWyhgVZtIKZhXk2CmWPUXup8VHB/KnuIZYuUrdms8CRh
         ZGXBUiYloimFWXRvJaoHQQCMBAH0Eq9LqvwSdbinetvrm39LdjWLkwUczTmDwyM1r7wU
         jBI1GLl5MXYTj/Cv5zgRlEAMYBjXB8eldELYy6waTOJv2BlTxv1kozTd/PCDpcLhZJRD
         34KxEliLZ5SfmXvAHUKMJH9GhkPTzAVu/gkTWjYID1Epm9XWS0jqYCpIzyeee1LrpaNv
         1mew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GibyTGV+B5xsNkZJ26GNbrzMdDaqK1DVh86XCoj0ot8=;
        b=AlYNXPLzyZ76hhVCCs0WZ29bofPrtWWCAQxHEq5d6bFk1xKrNyqgm+MbY9ggnnfNMj
         yqp7WnES8JapPfbXWlcX0lDUJO7iYPtHpR/9THxPtRwjaeZ7WmONxckxHGvTkOV5ZhLS
         KjfvQdl2o/DszA/RrF8hb9mwjExJSjqYgC0fXUbRrmwL74fvCsIQw5CIy8EuQrv3gZmU
         WreMF6bqlZUDc8Q9f92T9saUls/RZbWVFXxH9tO1TsLZHSY7ZSREYCrU6XLCb0TIC/F3
         g3BByNd/L3UgbRPAQlbOv3z7V02REpecyaLHaAzHaPTQ/B86CSzxJjXWcAz/1Uoj90Rq
         ivZw==
X-Gm-Message-State: AOAM532nxDbgv9ebLyCICLgttc9LZdJKk3QS/S8fmI5Z1CVEWVf9zoR0
        z04lzley6WP0PM30PiGFGMs=
X-Google-Smtp-Source: ABdhPJwYU6tP+XA8Zd03Fruxr4XV4jD1ATdV0K7Xd2Mqk0lmf0UOYRVn3446p2ja1SEHD9kJSUvdCQ==
X-Received: by 2002:a05:600c:21ca:: with SMTP id x10mr5589548wmj.94.1613687810463;
        Thu, 18 Feb 2021 14:36:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id w13sm9807439wrt.49.2021.02.18.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 14:36:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH 1/3] io_uring: don't take uring_lock during iowq cancel
Date:   Thu, 18 Feb 2021 22:32:51 +0000
Message-Id: <33d2525d823c02fa008e3b655a4480ec9780d1d1.1613687339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613687339.git.asml.silence@gmail.com>
References: <cover.1613687339.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[   97.866748] a.out/2890 is trying to acquire lock:
[   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
io_wq_submit_work+0x155/0x240
[   97.869735]
[   97.869735] but task is already holding lock:
[   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.873074]
[   97.873074] other info that might help us debug this:
[   97.874520]  Possible unsafe locking scenario:
[   97.874520]
[   97.875845]        CPU0
[   97.876440]        ----
[   97.877048]   lock(&ctx->uring_lock);
[   97.877961]   lock(&ctx->uring_lock);
[   97.878881]
[   97.878881]  *** DEADLOCK ***
[   97.878881]
[   97.880341]  May be due to missing lock nesting notation
[   97.880341]
[   97.881952] 1 lock held by a.out/2890:
[   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.885108]
[   97.885108] stack backtrace:
[   97.890457] Call Trace:
[   97.891121]  dump_stack+0xac/0xe3
[   97.891972]  __lock_acquire+0xab6/0x13a0
[   97.892940]  lock_acquire+0x2c3/0x390
[   97.894894]  __mutex_lock+0xae/0x9f0
[   97.901101]  io_wq_submit_work+0x155/0x240
[   97.902112]  io_wq_cancel_cb+0x162/0x490
[   97.904126]  io_async_find_and_cancel+0x3b/0x140
[   97.905247]  io_issue_sqe+0x86d/0x13e0
[   97.909122]  __io_queue_sqe+0x10b/0x550
[   97.913971]  io_queue_sqe+0x235/0x470
[   97.914894]  io_submit_sqes+0xcce/0xf10
[   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
[   97.921424]  do_syscall_64+0x2d/0x40
[   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

While holding uring_lock, e.g. from inline execution, async cancel
request may attempt cancellations through io_wq_submit_work, which may
try to grab a lock. Delay it to task_work, so we do it from a clean
context and don't have to worry about locking.

Cc: <stable@vger.kernel.org> # 5.5+
Fixes: c07e6719511e ("io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()")
Reported-by: Abaci <abaci@linux.alibaba.com>
Reported-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2fdfe5fa00b0..8dab07f42b34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2337,7 +2337,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -6426,8 +6428,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	if (work->flags & IO_WQ_WORK_CANCEL)
-		ret = -ECANCELED;
+	if (work->flags & IO_WQ_WORK_CANCEL) {
+		/* io-wq is going to take down one */
+		refcount_inc(&req->refs);
+		percpu_ref_get(&req->ctx->refs);
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+		return;
+	}
 
 	if (!ret) {
 		do {
-- 
2.24.0

