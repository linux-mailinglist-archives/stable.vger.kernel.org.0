Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE446462707
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhK2XAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbhK2W77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F2C12BCF7;
        Mon, 29 Nov 2021 10:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F17D0CE13D0;
        Mon, 29 Nov 2021 18:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D0DC53FAD;
        Mon, 29 Nov 2021 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210916;
        bh=cqtG65NkCoVsMnSQAd/aTNi784idUXHo9MF3H7vWMTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOix4Ha8p4+zR8SKenLpD+q52AN8GMh5HWgStLVYOmQoPgxvLntNRyBVkowkQlRHf
         0s+yHQPSLR3XbSPvZS5KYZ1GwDqhd0nHbjkXGUb5qJbXQCVLHuVdMgSgISSL9NrEIx
         5b9MEXtxdePERoaw5ETOGPlO2NH7dIW5HOI9oMAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com,
        syzbot+847f02ec20a6609a328b@syzkaller.appspotmail.com,
        syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com,
        syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com,
        syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable@kernel.org
Subject: [PATCH 5.15 040/179] io_uring: fix link traversal locking
Date:   Mon, 29 Nov 2021 19:17:14 +0100
Message-Id: <20211129181720.278377881@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6af3f48bf6156a7f02e91aca64e2927c4bebda03 upstream.

WARNING: inconsistent lock state
5.16.0-rc2-syzkaller #0 Not tainted
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
ffff888078e11418 (&ctx->timeout_lock
){?.+.}-{2:2}
, at: io_timeout_fn+0x6f/0x360 fs/io_uring.c:5943
{HARDIRQ-ON-W} state was registered at:
  [...]
  spin_unlock_irq include/linux/spinlock.h:399 [inline]
  __io_poll_remove_one fs/io_uring.c:5669 [inline]
  __io_poll_remove_one fs/io_uring.c:5654 [inline]
  io_poll_remove_one+0x236/0x870 fs/io_uring.c:5680
  io_poll_remove_all+0x1af/0x235 fs/io_uring.c:5709
  io_ring_ctx_wait_and_kill+0x1cc/0x322 fs/io_uring.c:9534
  io_uring_release+0x42/0x46 fs/io_uring.c:9554
  __fput+0x286/0x9f0 fs/file_table.c:280
  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
  exit_task_work include/linux/task_work.h:32 [inline]
  do_exit+0xc14/0x2b40 kernel/exit.c:832

674ee8e1b4a41 ("io_uring: correct link-list traversal locking") fixed a
data race but introduced a possible deadlock and inconsistentcy in irq
states. E.g.

io_poll_remove_all()
    spin_lock_irq(timeout_lock)
    io_poll_remove_one()
        spin_lock/unlock_irq(poll_lock);
    spin_unlock_irq(timeout_lock)

Another type of problem is freeing a request while holding
->timeout_lock, which may leads to a deadlock in
io_commit_cqring() -> io_flush_timeouts() and other places.

Having 3 nested locks is also too ugly. Add io_match_task_safe(), which
would briefly take and release timeout_lock for race prevention inside,
so the actuall request cancellation / free / etc. code doesn't have it
taken.

Reported-by: syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com
Reported-by: syzbot+847f02ec20a6609a328b@syzkaller.appspotmail.com
Reported-by: syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com
Reported-by: syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com
Reported-by: syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com
Fixes: 674ee8e1b4a41 ("io_uring: correct link-list traversal locking")
Cc: stable@kernel.org # 5.15+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/397f7ebf3f4171f1abe41f708ac1ecb5766f0b68.1637937097.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   60 ++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 18 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1204,6 +1204,7 @@ static void io_refs_resurrect(struct per
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
+	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
@@ -1219,6 +1220,44 @@ static bool io_match_task(struct io_kioc
 	return false;
 }
 
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * As io_match_task() but protected against racing with linked timeouts.
+ * User must not hold timeout_lock.
+ */
+static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+			       bool cancel_all)
+{
+	bool matched;
+
+	if (task && head->task != task)
+		return false;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
+}
+
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
@@ -5697,17 +5736,15 @@ static bool io_poll_remove_all(struct io
 	int posted = 0, i;
 
 	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task(req, tsk, cancel_all))
+			if (io_match_task_safe(req, tsk, cancel_all))
 				posted += io_poll_remove_one(req);
 		}
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 
 	if (posted)
@@ -9520,19 +9557,8 @@ static bool io_cancel_task_cb(struct io_
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_task_cancel *cancel = data;
-	bool ret;
 
-	if (!cancel->all && (req->flags & REQ_F_LINK_TIMEOUT)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
-		ret = io_match_task(req, cancel->task, cancel->all);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		ret = io_match_task(req, cancel->task, cancel->all);
-	}
-	return ret;
+	return io_match_task_safe(req, cancel->task, cancel->all);
 }
 
 static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
@@ -9542,14 +9568,12 @@ static bool io_cancel_defer_files(struct
 	LIST_HEAD(list);
 
 	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task(de->req, task, cancel_all)) {
+		if (io_match_task_safe(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;


