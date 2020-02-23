Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42803169500
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBWCWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbgBWCWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B0C92067D;
        Sun, 23 Feb 2020 02:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424538;
        bh=B121PA6hXOFvZznG/7fDaBlo/sGgh6O5jluLJi1gRzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i29fUSWejuaamN9X2xMIwYo4nWhAJv0QZzyPOb74Efb79AsnXZS7XsiUdVT/6qBPg
         X8Rwk+RGUjVOruIlZbJW/hAhoZs9aNilRNEfRmOJYGpJRaGuX2njnyL+ptZs+IQrXR
         SLV6brBQ+vVl64Il+bfyjiWchRTagYCCoVC3FIpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Glauber Costa <glauber@scylladb.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 48/58] io-wq: don't call kXalloc_node() with non-online node
Date:   Sat, 22 Feb 2020 21:21:09 -0500
Message-Id: <20200223022119.707-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7563439adfae153b20331f1567c8b5d0e5cbd8a7 ]

Glauber reports a crash on init on a box he has:

 RIP: 0010:__alloc_pages_nodemask+0x132/0x340
 Code: 18 01 75 04 41 80 ce 80 89 e8 48 8b 54 24 08 8b 74 24 1c c1 e8 0c 48 8b 3c 24 83 e0 01 88 44 24 20 48 85 d2 0f 85 74 01 00 00 <3b> 77 08 0f 82 6b 01 00 00 48 89 7c 24 10 89 ea 48 8b 07 b9 00 02
 RSP: 0018:ffffb8be4d0b7c28 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000e8e8
 RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002080
 RBP: 0000000000012cc0 R08: 0000000000000000 R09: 0000000000000002
 R10: 0000000000000dc0 R11: ffff995c60400100 R12: 0000000000000000
 R13: 0000000000012cc0 R14: 0000000000000001 R15: ffff995c60db00f0
 FS:  00007f4d115ca900(0000) GS:ffff995c60d80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000002088 CR3: 00000017cca66002 CR4: 00000000007606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  alloc_slab_page+0x46/0x320
  new_slab+0x9d/0x4e0
  ___slab_alloc+0x507/0x6a0
  ? io_wq_create+0xb4/0x2a0
  __slab_alloc+0x1c/0x30
  kmem_cache_alloc_node_trace+0xa6/0x260
  io_wq_create+0xb4/0x2a0
  io_uring_setup+0x97f/0xaa0
  ? io_remove_personalities+0x30/0x30
  ? io_poll_trigger_evfd+0x30/0x30
  do_syscall_64+0x5b/0x1c0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f4d116cb1ed

which is due to the 'wqe' and 'worker' allocation being node affine.
But it isn't valid to call the node affine allocation if the node isn't
online.

Setup structures for even offline nodes, as usual, but skip them in
terms of thread setup to not waste resources. If the node isn't online,
just alloc memory with NUMA_NO_NODE.

Reported-by: Glauber Costa <glauber@scylladb.com>
Tested-by: Glauber Costa <glauber@scylladb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0dc4bb6de6566..25ffb6685baea 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -666,11 +666,16 @@ static int io_wq_manager(void *data)
 	/* create fixed workers */
 	refcount_set(&wq->refs, workers_to_create);
 	for_each_node(node) {
+		if (!node_online(node))
+			continue;
 		if (!create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
 			goto err;
 		workers_to_create--;
 	}
 
+	while (workers_to_create--)
+		refcount_dec(&wq->refs);
+
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
@@ -678,6 +683,9 @@ static int io_wq_manager(void *data)
 			struct io_wqe *wqe = wq->wqes[node];
 			bool fork_worker[2] = { false, false };
 
+			if (!node_online(node))
+				continue;
+
 			spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] = true;
@@ -793,7 +801,9 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
 		if (io_worker_get(worker)) {
-			ret = func(worker, data);
+			/* no task if node is/was offline */
+			if (worker->task)
+				ret = func(worker, data);
 			io_worker_release(worker);
 			if (ret)
 				break;
@@ -1006,6 +1016,8 @@ void io_wq_flush(struct io_wq *wq)
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
+		if (!node_online(node))
+			continue;
 		init_completion(&data.done);
 		INIT_IO_WORK(&data.work, io_wq_flush_func);
 		data.work.flags |= IO_WQ_WORK_INTERNAL;
@@ -1038,12 +1050,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	for_each_node(node) {
 		struct io_wqe *wqe;
+		int alloc_node = node;
 
-		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
+		if (!node_online(alloc_node))
+			alloc_node = NUMA_NO_NODE;
+		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
 		wq->wqes[node] = wqe;
-		wqe->node = node;
+		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		if (wq->user) {
@@ -1051,7 +1066,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 					task_rlimit(current, RLIMIT_NPROC);
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
-		wqe->node = node;
 		wqe->wq = wq;
 		spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
-- 
2.20.1

