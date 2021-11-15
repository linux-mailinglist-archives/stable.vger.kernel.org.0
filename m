Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE71E4512F6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347607AbhKOTkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245246AbhKOTTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D496351A;
        Mon, 15 Nov 2021 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001068;
        bh=rxsXMyQBQe1V/ux9QLvBgUcCTn+GCc8WADOopU+D3sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7VZ1Q+CoXqHQQTAyiIx+70tkK00CsLC0er7ZpTnx2VM6bjPP7IVV4zQs+6PZMtxB
         0tloPgZv8jE/Emd6EkM7ifOD9RcNT7UlfBRl2NWncv6ji68l/PmUXChHqWyBEr/dXs
         ZIwVuvj3cRs/kXMnQK9nT/i1Pm+FhKy03x5bnlSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com
Subject: [PATCH 5.15 021/917] io-wq: remove worker to owner tw dependency
Date:   Mon, 15 Nov 2021 17:51:56 +0100
Message-Id: <20211115165429.448792346@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1d5f5ea7cb7d15b9fb1cc82673ebb054f02cd7d2 upstream.

INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xb44/0x5960 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_worker_exit fs/io-wq.c:183 [inline]
 io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io-wq worker may submit a task_work to the master task and upon
io_worker_exit() wait for the tw to get executed. The problem appears
when the master task is waiting in coredump.c:

468                     freezer_do_not_count();
469                     wait_for_completion(&core_state->startup);
470                     freezer_count();

Apparently having some dependency on children threads getting everything
stuck. Workaround it by cancelling the taks_work callback that causes it
before going into io_worker_exit() waiting.

p.s. probably a better option is to not submit tw elevating the refcount
in the first place, but let's leave this excercise for the future.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/142a716f4ed936feae868959059154362bfa8c19.1635509451.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -140,6 +140,7 @@ static void io_wqe_dec_running(struct io
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match);
+static void create_worker_cb(struct callback_head *cb);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -174,9 +175,44 @@ static void io_worker_ref_put(struct io_
 		complete(&wq->worker_done);
 }
 
+static void io_worker_cancel_cb(struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	atomic_dec(&acct->nr_running);
+	raw_spin_lock(&worker->wqe->lock);
+	acct->nr_workers--;
+	raw_spin_unlock(&worker->wqe->lock);
+	io_worker_ref_put(wq);
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
+}
+
+static bool io_task_worker_match(struct callback_head *cb, void *data)
+{
+	struct io_worker *worker;
+
+	if (cb->func != create_worker_cb)
+		return false;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker == data;
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	while (1) {
+		struct callback_head *cb = task_work_cancel_match(wq->task,
+						io_task_worker_match, worker);
+
+		if (!cb)
+			break;
+		io_worker_cancel_cb(worker);
+	}
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
@@ -1150,17 +1186,9 @@ static void io_wq_exit_workers(struct io
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
-		struct io_wqe_acct *acct;
 
 		worker = container_of(cb, struct io_worker, create_work);
-		acct = io_wqe_get_acct(worker);
-		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&worker->wqe->lock);
-		acct->nr_workers--;
-		raw_spin_unlock(&worker->wqe->lock);
-		io_worker_ref_put(wq);
-		clear_bit_unlock(0, &worker->create_state);
-		io_worker_release(worker);
+		io_worker_cancel_cb(worker);
 	}
 
 	rcu_read_lock();


