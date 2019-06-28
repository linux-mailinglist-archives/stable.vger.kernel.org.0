Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA76599F5
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfF1MCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:02:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbfF1MCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA8CCB627;
        Fri, 28 Jun 2019 12:02:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 35/37] bcache: fix race in btree_flush_write()
Date:   Fri, 28 Jun 2019 19:59:58 +0800
Message-Id: <20190628120000.40753-36-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a race between mca_reap(), btree_node_free() and journal code
btree_flush_write(), which results very rare and strange deadlock or
panic and are very hard to reproduce.

Let me explain how the race happens. In btree_flush_write() one btree
node with oldest journal pin is selected, then it is flushed to cache
device, the select-and-flush is a two steps operation. Between these two
steps, there are something may happen inside the race window,
- The selected btree node was reaped by mca_reap() and allocated to
  other requesters for other btree node.
- The slected btree node was selected, flushed and released by mca
  shrink callback bch_mca_scan().
When btree_flush_write() tries to flush the selected btree node, firstly
b->write_lock is held by mutex_lock(). If the race happens and the
memory of selected btree node is allocated to other btree node, if that
btree node's write_lock is held already, a deadlock very probably
happens here. A worse case is the memory of the selected btree node is
released, then all references to this btree node (e.g. b->write_lock)
will trigger NULL pointer deference panic.

This race was introduced in commit cafe56359144 ("bcache: A block layer
cache"), and enlarged by commit c4dc2497d50d ("bcache: fix high CPU
occupancy during journal"), which selected 128 btree nodes and flushed
them one-by-one in a quite long time period.

Such race is not easy to reproduce before. On a Lenovo SR650 server with
48 Xeon cores, and configure 1 NVMe SSD as cache device, a MD raid0
device assembled by 3 NVMe SSDs as backing device, this race can be
observed around every 10,000 times btree_flush_write() gets called. Both
deadlock and kernel panic all happened as aftermath of the race.

The idea of the fix is to add a btree flag BTREE_NODE_journal_flush. It
is set when selecting btree nodes, and cleared after btree nodes
flushed. Then when mca_reap() selects a btree node with this bit set,
this btree node will be skipped. Since mca_reap() only reaps btree node
without BTREE_NODE_journal_flush flag, such race is avoided.

Once corner case should be noticed, that is btree_node_free(). It might
be called in some error handling code path. For example the following
code piece from btree_split(),
        2149 err_free2:
        2150         bkey_put(b->c, &n2->key);
        2151         btree_node_free(n2);
        2152         rw_unlock(true, n2);
        2153 err_free1:
        2154         bkey_put(b->c, &n1->key);
        2155         btree_node_free(n1);
        2156         rw_unlock(true, n1);
At line 2151 and 2155, the btree node n2 and n1 are released without
mac_reap(), so BTREE_NODE_journal_flush also needs to be checked here.
If btree_node_free() is called directly in such error handling path,
and the selected btree node has BTREE_NODE_journal_flush bit set, just
delay for 1 us and retry again. In this case this btree node won't
be skipped, just retry until the BTREE_NODE_journal_flush bit cleared,
and free the btree node memory.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Coly Li <colyli@suse.de>
Reported-and-tested-by: kbuild test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/btree.c   | 28 +++++++++++++++++++++++++++-
 drivers/md/bcache/btree.h   |  2 ++
 drivers/md/bcache/journal.c |  7 +++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 846306c3a887..ba434d9ac720 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -35,7 +35,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
 #include <linux/rculist.h>
-
+#include <linux/delay.h>
 #include <trace/events/bcache.h>
 
 /*
@@ -659,12 +659,25 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 		up(&b->io_mutex);
 	}
 
+retry:
 	/*
 	 * BTREE_NODE_dirty might be cleared in btree_flush_btree() by
 	 * __bch_btree_node_write(). To avoid an extra flush, acquire
 	 * b->write_lock before checking BTREE_NODE_dirty bit.
 	 */
 	mutex_lock(&b->write_lock);
+	/*
+	 * If this btree node is selected in btree_flush_write() by journal
+	 * code, delay and retry until the node is flushed by journal code
+	 * and BTREE_NODE_journal_flush bit cleared by btree_flush_write().
+	 */
+	if (btree_node_journal_flush(b)) {
+		pr_debug("bnode %p is flushing by journal, retry", b);
+		mutex_unlock(&b->write_lock);
+		udelay(1);
+		goto retry;
+	}
+
 	if (btree_node_dirty(b))
 		__bch_btree_node_write(b, &cl);
 	mutex_unlock(&b->write_lock);
@@ -1081,7 +1094,20 @@ static void btree_node_free(struct btree *b)
 
 	BUG_ON(b == b->c->root);
 
+retry:
 	mutex_lock(&b->write_lock);
+	/*
+	 * If the btree node is selected and flushing in btree_flush_write(),
+	 * delay and retry until the BTREE_NODE_journal_flush bit cleared,
+	 * then it is safe to free the btree node here. Otherwise this btree
+	 * node will be in race condition.
+	 */
+	if (btree_node_journal_flush(b)) {
+		mutex_unlock(&b->write_lock);
+		pr_debug("bnode %p journal_flush set, retry", b);
+		udelay(1);
+		goto retry;
+	}
 
 	if (btree_node_dirty(b)) {
 		btree_complete_write(b, btree_current_write(b));
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index d1c72ef64edf..76cfd121a486 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -158,11 +158,13 @@ enum btree_flags {
 	BTREE_NODE_io_error,
 	BTREE_NODE_dirty,
 	BTREE_NODE_write_idx,
+	BTREE_NODE_journal_flush,
 };
 
 BTREE_FLAG(io_error);
 BTREE_FLAG(dirty);
 BTREE_FLAG(write_idx);
+BTREE_FLAG(journal_flush);
 
 static inline struct btree_write *btree_current_write(struct btree *b)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 1218e3cada3c..a1e3e1fcea6e 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -430,6 +430,7 @@ static void btree_flush_write(struct cache_set *c)
 retry:
 	best = NULL;
 
+	mutex_lock(&c->bucket_lock);
 	for_each_cached_btree(b, c, i)
 		if (btree_current_write(b)->journal) {
 			if (!best)
@@ -442,15 +443,21 @@ static void btree_flush_write(struct cache_set *c)
 		}
 
 	b = best;
+	if (b)
+		set_btree_node_journal_flush(b);
+	mutex_unlock(&c->bucket_lock);
+
 	if (b) {
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
+			clear_bit(BTREE_NODE_journal_flush, &b->flags);
 			mutex_unlock(&b->write_lock);
 			/* We raced */
 			goto retry;
 		}
 
 		__bch_btree_node_write(b, NULL);
+		clear_bit(BTREE_NODE_journal_flush, &b->flags);
 		mutex_unlock(&b->write_lock);
 	}
 }
-- 
2.16.4

