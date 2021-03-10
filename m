Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A511333B8D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCJLhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbhCJLf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:29 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A52C0613DA
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:35:02 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id d139-20020a1c1d910000b029010b895cb6f2so10496223wmd.5
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uhwX/bzbLBSuhppqPht+JJ7EOlUtrPlfFGxS8Mv9Xb8=;
        b=Je7R3hpGlblCpVthtrNWjvzoeqByoDb3vcTD+qYU1LRrSH6l/7kk3o6i6JMXgz5+lm
         uIIwFJks1qqL2/RUwZT3B0Dxr/7B5GSKEsVADYW5W2sAgsAMoGzTxobHIBTm3ZO0ZKc1
         lCx7Yne74cChJZ2miGGZ7fMx4XjHg4S9E0EvamReSurYNhmq8IjIsq4q64ZyH3eU72Tl
         9CNQEufkmWk4L4ToZ/THoo85kP81Ec1ZZ3Fe9dWvj70iupX8AmgcafvOfRT6Ssaoavr3
         gqkrlF0FIFLHfU3uihtMW0QOCsrhvwuSsaK8gSo/YmnR+ZAdVLwL/t8rPG95pLy/LN/C
         Jxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhwX/bzbLBSuhppqPht+JJ7EOlUtrPlfFGxS8Mv9Xb8=;
        b=DosnnKILSffwBdNZpuzFvpABYIQMXE2VVxjXEHpnimKzLOFjyU+QYcv18gypSPeX/1
         giDdECFjvcQAXxDYG7ZyFpqVPUEs36o0hRXww3MvgaUoBIlZjbv6/LSKsXvlx0m1I6hV
         ujb8sQTD0yRqDs/0ger8F3kv63UUmlogD/xJ+7QOd1xEY2m9eWWy8lFrhrtoyNs2Wrgi
         sgbAGsagm/uenfaRq91CN/aQjPd1C47RCM2kDQIXvq4cCPOscDJaxZi61/PZGnDtmFdr
         /5x7OfnpWzxJ1RO1WKpDIenqlhFqj+bnvUNMt4IL2PEZiCOPuVScyvYLG9wHneHV0UU9
         BGhQ==
X-Gm-Message-State: AOAM533X4jdusNiqAWUfWTsdWolAen1UrK55KYgZ4d4PEONIyAQmzYT2
        N0HEIKig2jV/W4w84e8InyP7zVGc+Cyv1w==
X-Google-Smtp-Source: ABdhPJyZVEGyOHlvQWhomcQ3IUx/lLq2X4uVMsY5eggZOxR6F3mbUdlBaMoTK4ZI93cBssd/stYBRQ==
X-Received: by 2002:a7b:cb90:: with SMTP id m16mr2915354wmi.162.1615376100568;
        Wed, 10 Mar 2021 03:35:00 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:35:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Abaci <abaci@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH 9/9] io_uring: don't take uring_lock during iowq cancel
Date:   Wed, 10 Mar 2021 11:30:45 +0000
Message-Id: <1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 792bb6eb862333658bf1bd2260133f0507e2da8d upstream

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e9bff1eeaa0..241313278e5a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2198,7 +2198,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -6372,8 +6374,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
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

