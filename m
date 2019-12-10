Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16143119DC8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfLJWkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfLJWcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:32:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8736D206EC;
        Tue, 10 Dec 2019 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017131;
        bh=pli3J1ZKHsfrMjLd8Vk+sjZ+RspWTMVMYprAobdGqho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Juhr8zbtK5ohnurroXy6e6ux0vue2Jh0YxeroZNejeYJrMf9Z9rfFRVsJKlntyN0s
         8AMQ0ySDxhdp3LvQ98xeNUJ8g0ZE5q6cYaaPK84MNFa/Y0f7dhgsg3oQslxtVWfBbs
         TR676p1Zd9Xes39kQfwefx4/0AtGq5Ai5UjRq9dE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Tejun Heo <tj@kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 80/91] btrfs: don't prematurely free work in run_ordered_work()
Date:   Tue, 10 Dec 2019 17:30:24 -0500
Message-Id: <20191210223035.14270-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit c495dcd6fbe1dce51811a76bb85b4675f6494938 ]

We hit the following very strange deadlock on a system with Btrfs on a
loop device backed by another Btrfs filesystem:

1. The top (loop device) filesystem queues an async_cow work item from
   cow_file_range_async(). We'll call this work X.
2. Worker thread A starts work X (normal_work_helper()).
3. Worker thread A executes the ordered work for the top filesystem
   (run_ordered_work()).
4. Worker thread A finishes the ordered work for work X and frees X
   (work->ordered_free()).
5. Worker thread A executes another ordered work and gets blocked on I/O
   to the bottom filesystem (still in run_ordered_work()).
6. Meanwhile, the bottom filesystem allocates and queues an async_cow
   work item which happens to be the recently-freed X.
7. The workqueue code sees that X is already being executed by worker
   thread A, so it schedules X to be executed _after_ worker thread A
   finishes (see the find_worker_executing_work() call in
   process_one_work()).

Now, the top filesystem is waiting for I/O on the bottom filesystem, but
the bottom filesystem is waiting for the top filesystem to finish, so we
deadlock.

This happens because we are breaking the workqueue assumption that a
work item cannot be recycled while it still depends on other work. Fix
it by waiting to free the work item until we are done with all of the
related ordered work.

P.S.:

One might ask why the workqueue code doesn't try to detect a recycled
work item. It actually does try by checking whether the work item has
the same work function (find_worker_executing_work()), but in our case
the function is the same. This is the only key that the workqueue code
has available to compare, short of adding an additional, layer-violating
"custom key". Considering that we're the only ones that have ever hit
this, we should just play by the rules.

Unfortunately, we haven't been able to create a minimal reproducer other
than our full container setup using a compress-force=zstd filesystem on
top of another compress-force=zstd filesystem.

Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/async-thread.c | 56 ++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index ff0b0be92d612..a3de11d52ad00 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -265,16 +265,17 @@ static inline void thresh_exec_hook(struct __btrfs_workqueue *wq)
 	}
 }
 
-static void run_ordered_work(struct __btrfs_workqueue *wq)
+static void run_ordered_work(struct __btrfs_workqueue *wq,
+			     struct btrfs_work *self)
 {
 	struct list_head *list = &wq->ordered_list;
 	struct btrfs_work *work;
 	spinlock_t *lock = &wq->list_lock;
 	unsigned long flags;
+	void *wtag;
+	bool free_self = false;
 
 	while (1) {
-		void *wtag;
-
 		spin_lock_irqsave(lock, flags);
 		if (list_empty(list))
 			break;
@@ -300,16 +301,47 @@ static void run_ordered_work(struct __btrfs_workqueue *wq)
 		list_del(&work->ordered_list);
 		spin_unlock_irqrestore(lock, flags);
 
-		/*
-		 * We don't want to call the ordered free functions with the
-		 * lock held though. Save the work as tag for the trace event,
-		 * because the callback could free the structure.
-		 */
-		wtag = work;
-		work->ordered_free(work);
-		trace_btrfs_all_work_done(wq->fs_info, wtag);
+		if (work == self) {
+			/*
+			 * This is the work item that the worker is currently
+			 * executing.
+			 *
+			 * The kernel workqueue code guarantees non-reentrancy
+			 * of work items. I.e., if a work item with the same
+			 * address and work function is queued twice, the second
+			 * execution is blocked until the first one finishes. A
+			 * work item may be freed and recycled with the same
+			 * work function; the workqueue code assumes that the
+			 * original work item cannot depend on the recycled work
+			 * item in that case (see find_worker_executing_work()).
+			 *
+			 * Note that the work of one Btrfs filesystem may depend
+			 * on the work of another Btrfs filesystem via, e.g., a
+			 * loop device. Therefore, we must not allow the current
+			 * work item to be recycled until we are really done,
+			 * otherwise we break the above assumption and can
+			 * deadlock.
+			 */
+			free_self = true;
+		} else {
+			/*
+			 * We don't want to call the ordered free functions with
+			 * the lock held though. Save the work as tag for the
+			 * trace event, because the callback could free the
+			 * structure.
+			 */
+			wtag = work;
+			work->ordered_free(work);
+			trace_btrfs_all_work_done(wq->fs_info, wtag);
+		}
 	}
 	spin_unlock_irqrestore(lock, flags);
+
+	if (free_self) {
+		wtag = self;
+		self->ordered_free(self);
+		trace_btrfs_all_work_done(wq->fs_info, wtag);
+	}
 }
 
 static void normal_work_helper(struct btrfs_work *work)
@@ -337,7 +369,7 @@ static void normal_work_helper(struct btrfs_work *work)
 	work->func(work);
 	if (need_order) {
 		set_bit(WORK_DONE_BIT, &work->flags);
-		run_ordered_work(wq);
+		run_ordered_work(wq, work);
 	}
 	if (!need_order)
 		trace_btrfs_all_work_done(wq->fs_info, wtag);
-- 
2.20.1

