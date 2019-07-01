Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489E845D9E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfFNNOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 09:14:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:45250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfFNNOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 976D6AB8C;
        Fri, 14 Jun 2019 13:14:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        stable@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>
Subject: [PATCH 01/29] bcache: Revert "bcache: fix high CPU occupancy during journal"
Date:   Fri, 14 Jun 2019 21:13:30 +0800
Message-Id: <20190614131358.2771-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit c4dc2497d50d9c6fb16aa0d07b6a14f3b2adb1e0.

This patch enlarges a race between normal btree flush code path and
flush_btree_write(), which causes deadlock when journal space is
exhausted. Reverts this patch makes the race window from 128 btree
nodes to only 1 btree nodes.

Fixes: c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Tang Junhui <tang.junhui.linux@gmail.com>
---
 drivers/md/bcache/bcache.h  |  2 --
 drivers/md/bcache/journal.c | 47 +++++++++++++++------------------------------
 drivers/md/bcache/util.h    |  2 --
 3 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index fdf75352e16a..e30a983a68cd 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -726,8 +726,6 @@ struct cache_set {
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
-
-	DECLARE_HEAP(struct btree *, flush_btree);
 };
 
 struct bbio {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 12dae9348147..621ebf5c62a5 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -391,12 +391,6 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 }
 
 /* Journalling */
-#define journal_max_cmp(l, r) \
-	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) < \
-	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
-#define journal_min_cmp(l, r) \
-	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) > \
-	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
 
 static void btree_flush_write(struct cache_set *c)
 {
@@ -404,35 +398,25 @@ static void btree_flush_write(struct cache_set *c)
 	 * Try to find the btree node with that references the oldest journal
 	 * entry, best is our current candidate and is locked if non NULL:
 	 */
-	struct btree *b;
-	int i;
+	struct btree *b, *best;
+	unsigned int i;
 
 	atomic_long_inc(&c->flush_write);
-
 retry:
-	spin_lock(&c->journal.lock);
-	if (heap_empty(&c->flush_btree)) {
-		for_each_cached_btree(b, c, i)
-			if (btree_current_write(b)->journal) {
-				if (!heap_full(&c->flush_btree))
-					heap_add(&c->flush_btree, b,
-						 journal_max_cmp);
-				else if (journal_max_cmp(b,
-					 heap_peek(&c->flush_btree))) {
-					c->flush_btree.data[0] = b;
-					heap_sift(&c->flush_btree, 0,
-						  journal_max_cmp);
-				}
+	best = NULL;
+
+	for_each_cached_btree(b, c, i)
+		if (btree_current_write(b)->journal) {
+			if (!best)
+				best = b;
+			else if (journal_pin_cmp(c,
+					btree_current_write(best)->journal,
+					btree_current_write(b)->journal)) {
+				best = b;
 			}
+		}
 
-		for (i = c->flush_btree.used / 2 - 1; i >= 0; --i)
-			heap_sift(&c->flush_btree, i, journal_min_cmp);
-	}
-
-	b = NULL;
-	heap_pop(&c->flush_btree, b, journal_min_cmp);
-	spin_unlock(&c->journal.lock);
-
+	b = best;
 	if (b) {
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
@@ -870,8 +854,7 @@ int bch_journal_alloc(struct cache_set *c)
 	j->w[0].c = c;
 	j->w[1].c = c;
 
-	if (!(init_heap(&c->flush_btree, 128, GFP_KERNEL)) ||
-	    !(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
+	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
 	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)) ||
 	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)))
 		return -ENOMEM;
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 1fbced94e4cc..c029f7443190 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -113,8 +113,6 @@ do {									\
 
 #define heap_full(h)	((h)->used == (h)->size)
 
-#define heap_empty(h)	((h)->used == 0)
-
 #define DECLARE_FIFO(type, name)					\
 	struct {							\
 		size_t front, back, size, mask;				\
-- 
2.16.4

