Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E2347AE89
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbhLTPBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35496 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238714AbhLTO7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 051CBB80EEC;
        Mon, 20 Dec 2021 14:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DACBC36AE7;
        Mon, 20 Dec 2021 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012345;
        bh=TQedHHwCc6PQ4Qn3eV6w11ANM4ik+KAU7fbnKM/eMbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhh2AKz8dy3vZsCpPN5Vogg2epCxvLwYqGbG/hsSpgKUlY/h5lPE7SfGqcsfNYyV5
         WXOBZ9xU1TxfW1L58etZ5Lr2F7ENGveWOnLrtOfBmTmGP38rUW/qgnhP5/NVxcU32l
         LItwcZ1Q4HJ0oKu0Of99JM48viPGpK0HDczX8HZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com
Subject: [PATCH 5.15 167/177] io-wq: check for wq exit after adding new worker task_work
Date:   Mon, 20 Dec 2021 15:35:17 +0100
Message-Id: <20211220143045.701523905@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 71a85387546e50b1a37b0fa45dadcae3bfb35cf6 upstream.

We check IO_WQ_BIT_EXIT before attempting to create a new worker, and
wq exit cancels pending work if we have any. But it's possible to have
a race between the two, where creation checks exit finding it not set,
but we're in the process of exiting. The exit side will cancel pending
creation task_work, but there's a gap where we add task_work after we've
canceled existing creations at exit time.

Fix this by checking the EXIT bit post adding the creation task_work.
If it's set, run the same cancelation that exit does.

Reported-and-tested-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -141,6 +141,7 @@ static bool io_acct_cancel_pending_work(
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match);
 static void create_worker_cb(struct callback_head *cb);
+static void io_wq_cancel_tw_create(struct io_wq *wq);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -357,10 +358,22 @@ static bool io_queue_worker_create(struc
 	    test_and_set_bit_lock(0, &worker->create_state))
 		goto fail_release;
 
+	atomic_inc(&wq->worker_refs);
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
+		/*
+		 * EXIT may have been set after checking it above, check after
+		 * adding the task_work and remove any creation item if it is
+		 * now set. wq exit does that too, but we can have added this
+		 * work item after we canceled in io_wq_exit_workers().
+		 */
+		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
+			io_wq_cancel_tw_create(wq);
+		io_worker_ref_put(wq);
 		return true;
+	}
+	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
@@ -1193,13 +1206,9 @@ void io_wq_exit_start(struct io_wq *wq)
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 }
 
-static void io_wq_exit_workers(struct io_wq *wq)
+static void io_wq_cancel_tw_create(struct io_wq *wq)
 {
 	struct callback_head *cb;
-	int node;
-
-	if (!wq->task)
-		return;
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
@@ -1207,6 +1216,16 @@ static void io_wq_exit_workers(struct io
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
 	}
+}
+
+static void io_wq_exit_workers(struct io_wq *wq)
+{
+	int node;
+
+	if (!wq->task)
+		return;
+
+	io_wq_cancel_tw_create(wq);
 
 	rcu_read_lock();
 	for_each_node(node) {


