Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3700315E9C
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 06:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBJFIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 00:08:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:40138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhBJFIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 00:08:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22FC6B016;
        Wed, 10 Feb 2021 05:08:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 03/20] Revert "bcache: Kill btree_io_wq"
Date:   Wed, 10 Feb 2021 13:07:25 +0800
Message-Id: <20210210050742.31237-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.

With the btree using the `system_wq`, I seem to see a lot more desktop
latency than I should.

After some more investigation, it looks like the original assumption
of 56b3077 no longer is true, and bcache has a very high potential of
congesting the `system_wq`. In turn, this introduces laggy desktop
performance, IO stalls (at least with btrfs), and input events may be
delayed.

So let's revert this. It's important to note that the semantics of
using `system_wq` previously mean that `btree_io_wq` should be created
before and destroyed after other bcache wqs to keep the same
assumptions.

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/btree.c  | 21 +++++++++++++++++++--
 drivers/md/bcache/super.c  |  4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index d7a84327b7f1..2b8c7dd2cfae 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1046,5 +1046,7 @@ void bch_debug_exit(void);
 void bch_debug_init(void);
 void bch_request_exit(void);
 int bch_request_init(void);
+void bch_btree_exit(void);
+int bch_btree_init(void);
 
 #endif /* _BCACHE_H */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 910df242c83d..952f022db5a5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -99,6 +99,8 @@
 #define PTR_HASH(c, k)							\
 	(((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
 
+static struct workqueue_struct *btree_io_wq;
+
 #define insert_lock(s, b)	((b)->level <= (s)->lock)
 
 
@@ -308,7 +310,7 @@ static void __btree_node_write_done(struct closure *cl)
 	btree_complete_write(b, w);
 
 	if (btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	closure_return_with_destructor(cl, btree_node_write_unlock);
 }
@@ -481,7 +483,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
 	BUG_ON(!i->keys);
 
 	if (!btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	set_btree_node_dirty(b);
 
@@ -2764,3 +2766,18 @@ void bch_keybuf_init(struct keybuf *buf)
 	spin_lock_init(&buf->lock);
 	array_allocator_init(&buf->freelist);
 }
+
+void bch_btree_exit(void)
+{
+	if (btree_io_wq)
+		destroy_workqueue(btree_io_wq);
+}
+
+int __init bch_btree_init(void)
+{
+	btree_io_wq = create_singlethread_workqueue("bch_btree_io");
+	if (!btree_io_wq)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e7d1b52c5cc8..85a44a0cffe0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2821,6 +2821,7 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	bch_btree_exit();
 
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
@@ -2876,6 +2877,9 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}
 
+	if (bch_btree_init())
+		goto err;
+
 	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
 	if (!bcache_wq)
 		goto err;
-- 
2.26.2

