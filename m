Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F3F3ED62D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhHPNSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239688AbhHPNQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EDF9632DE;
        Mon, 16 Aug 2021 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119575;
        bh=Wc2BVso07DLh/87F9IUZdCUnJHImYyIaShQUXQwsb9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GalRB0NEy7vz0KlNMcmpf/jfBxRyeLrMRahuYXkKlt3YnCkLpUYizHlaEdPRJU6qf
         BJsh4UVq7fiT6fw3gZ27LEk8QlW+aTG1YbDheR7qBGza3cYDHxe0N7IfzpqmEMxAmA
         lQFMI/2+j9NLYHZEcCWa8KAZIVtQtkFfZLokuSRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/151] io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()
Date:   Mon, 16 Aug 2021 15:01:49 +0200
Message-Id: <20210816125446.680361459@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit 47cae0c71f7a126903f930191e6e9f103674aca1 ]

There may be cases like:
        A                                 B
spin_lock(wqe->lock)
nr_workers is 0
nr_workers++
spin_unlock(wqe->lock)
                                     spin_lock(wqe->lock)
                                     nr_wokers is 1
                                     nr_workers++
                                     spin_unlock(wqe->lock)
create_io_worker()
  acct->worker is 1
                                     create_io_worker()
                                       acct->worker is 1

There should be one worker marked IO_WORKER_F_FIXED, but no one is.
Fix this by introduce a new agrument for create_io_worker() to indicate
if it is the first worker.

Fixes: 3d4e4face9c1 ("io-wq: fix no lock protection of acct->nr_worker")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210808135434.68667-3-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2c8a9a394884..91b0d1fb90eb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -130,7 +130,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first);
 static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
@@ -249,18 +249,20 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	rcu_read_unlock();
 
 	if (!ret) {
-		bool do_create = false;
+		bool do_create = false, first = false;
 
 		raw_spin_lock_irq(&wqe->lock);
 		if (acct->nr_workers < acct->max_workers) {
 			atomic_inc(&acct->nr_running);
 			atomic_inc(&wqe->wq->worker_refs);
+			if (!acct->nr_workers)
+				first = true;
 			acct->nr_workers++;
 			do_create = true;
 		}
 		raw_spin_unlock_irq(&wqe->lock);
 		if (do_create)
-			create_io_worker(wqe->wq, wqe, acct->index);
+			create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -283,7 +285,7 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
-	bool do_create = false;
+	bool do_create = false, first = false;
 
 	cwd = container_of(cb, struct create_worker_data, work);
 	wqe = cwd->wqe;
@@ -291,12 +293,14 @@ static void create_worker_cb(struct callback_head *cb)
 	acct = &wqe->acct[cwd->index];
 	raw_spin_lock_irq(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
 		acct->nr_workers++;
 		do_create = true;
 	}
 	raw_spin_unlock_irq(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, cwd->wqe, cwd->index);
+		create_io_worker(wq, wqe, cwd->index, first);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -642,7 +646,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock_irq(&worker->wqe->lock);
 }
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -683,7 +687,7 @@ fail:
 	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	if ((acct->nr_workers == 1) && (worker->flags & IO_WORKER_F_BOUND))
+	if (first && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
 	raw_spin_unlock_irq(&wqe->lock);
 	wake_up_new_task(tsk);
-- 
2.30.2



