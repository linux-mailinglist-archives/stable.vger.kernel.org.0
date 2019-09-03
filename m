Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FD5A6F65
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbfICQcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731404AbfICQcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24721238C5;
        Tue,  3 Sep 2019 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528327;
        bh=7Xb6f2oKj4eI767Iq94fg4lorceFGFr158zW5etE83c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgwtS4dIxUEAB33hyLNnAqSmRFuJ9LlPoLbQx4pxVN674jT5qgtZE5A8tp7SA7ioh
         J4cZye7TIX1rstsUPt51EtsG7H1tYbvXAhtaxAMoiw4hPM+rjcRj+fed4d8XDmA9/7
         A946/NFCCCM1/z02LbAic0+WOJzVPJfyxcOHft2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, kbuild test robot <lkp@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 159/167] bcache: fix race in btree_flush_write()
Date:   Tue,  3 Sep 2019 12:25:11 -0400
Message-Id: <20190903162519.7136-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 50a260e859964002dab162513a10f91ae9d3bcd3 ]

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c   | 28 +++++++++++++++++++++++++++-
 drivers/md/bcache/btree.h   |  2 ++
 drivers/md/bcache/journal.c |  7 +++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e0468fd41b6ea..45f684689c357 100644
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
@@ -649,12 +649,25 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
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
@@ -1071,7 +1084,20 @@ static void btree_node_free(struct btree *b)
 
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
index a68d6c55783bd..4d0cca145f699 100644
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
index ec1e35a62934d..7bb15cddca5ec 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -404,6 +404,7 @@ static void btree_flush_write(struct cache_set *c)
 retry:
 	best = NULL;
 
+	mutex_lock(&c->bucket_lock);
 	for_each_cached_btree(b, c, i)
 		if (btree_current_write(b)->journal) {
 			if (!best)
@@ -416,9 +417,14 @@ static void btree_flush_write(struct cache_set *c)
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
 			atomic_long_inc(&c->retry_flush_write);
@@ -426,6 +432,7 @@ static void btree_flush_write(struct cache_set *c)
 		}
 
 		__bch_btree_node_write(b, NULL);
+		clear_bit(BTREE_NODE_journal_flush, &b->flags);
 		mutex_unlock(&b->write_lock);
 	}
 }
-- 
2.20.1

