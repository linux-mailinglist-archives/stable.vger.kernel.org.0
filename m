Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EAD315EA3
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 06:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhBJFJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 00:09:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:40716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbhBJFJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 33018B061;
        Wed, 10 Feb 2021 05:08:10 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 05/20] bcache: Move journal work to new flush wq
Date:   Wed, 10 Feb 2021 13:07:27 +0800
Message-Id: <20210210050742.31237-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

This is potentially long running and not latency sensitive, let's get
it out of the way of other latency sensitive events.

As observed in the previous commit, the `system_wq` comes easily
congested by bcache, and this fixes a few more stalls I was observing
every once in a while.

Let's not make this `WQ_MEM_RECLAIM` as it showed to reduce performance
of boot and file system operations in my tests. Also, without
`WQ_MEM_RECLAIM`, I no longer see desktop stalls. This matches the
previous behavior as `system_wq` also does no memory reclaim:

> // workqueue.c:
> system_wq = alloc_workqueue("events", 0, 0);

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h  |  1 +
 drivers/md/bcache/journal.c |  4 ++--
 drivers/md/bcache/super.c   | 16 ++++++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2b8c7dd2cfae..848dd4db1659 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1005,6 +1005,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
+extern struct workqueue_struct *bch_flush_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index aefbdb7e003b..c6613e817333 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *c,
 		journal_try_write(c);
 	} else if (!w->dirty) {
 		w->dirty = true;
-		schedule_delayed_work(&c->journal.work,
-				      msecs_to_jiffies(c->journal_delay_ms));
+		queue_delayed_work(bch_flush_wq, &c->journal.work,
+				   msecs_to_jiffies(c->journal_delay_ms));
 		spin_unlock(&c->journal.lock);
 	} else {
 		spin_unlock(&c->journal.lock);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85a44a0cffe0..0228ccb293fc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -49,6 +49,7 @@ static int bcache_major;
 static DEFINE_IDA(bcache_device_idx);
 static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
+struct workqueue_struct *bch_flush_wq;
 struct workqueue_struct *bch_journal_wq;
 
 
@@ -2821,6 +2822,8 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	if (bch_flush_wq)
+		destroy_workqueue(bch_flush_wq);
 	bch_btree_exit();
 
 	if (bcache_major)
@@ -2884,6 +2887,19 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	/*
+	 * Let's not make this `WQ_MEM_RECLAIM` for the following reasons:
+	 *
+	 * 1. It used `system_wq` before which also does no memory reclaim.
+	 * 2. With `WQ_MEM_RECLAIM` desktop stalls, increased boot times, and
+	 *    reduced throughput can be observed.
+	 *
+	 * We still want to user our own queue to not congest the `system_wq`.
+	 */
+	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
+	if (!bch_flush_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2

