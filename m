Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A4F333DAD
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhCJNYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232778AbhCJNYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB20664FEE;
        Wed, 10 Mar 2021 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382652;
        bh=ff5i65+V8WEnHDqy9TM9DuoilBS+z4uGIernee2i1C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyzgQeExgGqhHX/spm2fwhmcjqE2iLaDfynv8fvGqGS0RgYM2g73KTmsXN+n/kvjl
         0gNeWAb2ZIkzM/MHZyTp4zvXjGIf+5ErU/SNdmDOTcTm6j/x42n2UZQMbetc3mbgTk
         S223h7PmW/2CF2hp2uEMNSXFGvQe4EaZiq0M/710=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Abaci <abaci@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 10/36] io_uring: dont take uring_lock during iowq cancel
Date:   Wed, 10 Mar 2021 14:23:23 +0100
Message-Id: <20210310132320.843456930@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Begunkov <asml.silence@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2198,7 +2198,9 @@ static void io_req_task_cancel(struct ca
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -6372,8 +6374,13 @@ static void io_wq_submit_work(struct io_
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


