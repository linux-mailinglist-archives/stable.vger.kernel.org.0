Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469CD3E8138
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhHJR4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237491AbhHJRyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4198E61362;
        Tue, 10 Aug 2021 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617464;
        bh=mKNQYnYs2OEZJVlsQbQtp/ephxEcDsIXoY6LnBlS5Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4OkjgyPrRaQJnWLlDOZEK/IDLxgr8f1uIF+tETg887TLCFeRbyn8oyNUXKlf6R/8
         Z9tKLZBDGKFxCg/9bmshMsFmzUKeEzi8witTsLiVLEH/N+0GXQk2pV8166LvrIYapy
         fgFl4YR+kPtELjWMEw5sBrA2lfQI1A9mHT+Q7/fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/175] io-wq: fix no lock protection of acct->nr_worker
Date:   Tue, 10 Aug 2021 19:29:39 +0200
Message-Id: <20210810173003.279129470@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit 3d4e4face9c1548752a2891e98b38b100feee336 ]

There is an acct->nr_worker visit without lock protection. Think about
the case: two callers call io_wqe_wake_worker(), one is the original
context and the other one is an io-worker(by calling
io_wqe_enqueue(wqe, linked)), on two cpus paralelly, this may cause
nr_worker to be larger than max_worker.
Let's fix it by adding lock for it, and let's do nr_workers++ before
create_io_worker. There may be a edge cause that the first caller fails
to create an io-worker, but the second caller doesn't know it and then
quit creating io-worker as well:

say nr_worker = max_worker - 1
        cpu 0                        cpu 1
   io_wqe_wake_worker()          io_wqe_wake_worker()
      nr_worker < max_worker
      nr_worker++
      create_io_worker()         nr_worker == max_worker
         failed                  return
      return

But the chance of this case is very slim.

Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
[axboe: fix unconditional create_io_worker() call]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9efecdf025b9..e00ac0969470 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -248,10 +248,19 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	ret = io_wqe_activate_free_worker(wqe);
 	rcu_read_unlock();
 
-	if (!ret && acct->nr_workers < acct->max_workers) {
-		atomic_inc(&acct->nr_running);
-		atomic_inc(&wqe->wq->worker_refs);
-		create_io_worker(wqe->wq, wqe, acct->index);
+	if (!ret) {
+		bool do_create = false;
+
+		raw_spin_lock_irq(&wqe->lock);
+		if (acct->nr_workers < acct->max_workers) {
+			atomic_inc(&acct->nr_running);
+			atomic_inc(&wqe->wq->worker_refs);
+			acct->nr_workers++;
+			do_create = true;
+		}
+		raw_spin_unlock_irq(&wqe->lock);
+		if (do_create)
+			create_io_worker(wqe->wq, wqe, acct->index);
 	}
 }
 
@@ -640,6 +649,9 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		kfree(worker);
 fail:
 		atomic_dec(&acct->nr_running);
+		raw_spin_lock_irq(&wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock_irq(&wqe->lock);
 		io_worker_ref_put(wq);
 		return;
 	}
@@ -655,9 +667,8 @@ fail:
 	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
+	if ((acct->nr_workers == 1) && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
-	acct->nr_workers++;
 	raw_spin_unlock_irq(&wqe->lock);
 	wake_up_new_task(tsk);
 }
-- 
2.30.2



