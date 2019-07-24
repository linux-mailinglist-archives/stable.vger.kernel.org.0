Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C877C73CD3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392247AbfGXUL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392007AbfGXT5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4796020665;
        Wed, 24 Jul 2019 19:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998250;
        bh=Q9ILO/D091rKnyjvBUocEpW/ZTIH9aUPJHu9nA4RPUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=up2iabAXhO9xysRYtaHv7A6e8aY6mvTdLQknoo8fF7UwtYemApquNxJ0E9JCgTCsL
         C8DVTTzuS/DoZ/yPSMV3hZSlEEvqqNSckf+zofsr8xGgWDJucRvPyzXYMrYYiEtQGR
         whG2wqxgGSRp87m9kOc/sy5W/Plb6AO+QU0Xwd50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Tang Junhui <tang.junhui.linux@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 257/371] bcache: Revert "bcache: fix high CPU occupancy during journal"
Date:   Wed, 24 Jul 2019 21:20:09 +0200
Message-Id: <20190724191743.890667838@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 249a5f6da57c28a903c75d81505d58ec8c10030d upstream.

This reverts commit c4dc2497d50d9c6fb16aa0d07b6a14f3b2adb1e0.

This patch enlarges a race between normal btree flush code path and
flush_btree_write(), which causes deadlock when journal space is
exhausted. Reverts this patch makes the race window from 128 btree
nodes to only 1 btree nodes.

Fixes: c4dc2497d50d ("bcache: fix high CPU occupancy during journal")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Tang Junhui <tang.junhui.linux@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bcache.h  |    2 -
 drivers/md/bcache/journal.c |   47 ++++++++++++++------------------------------
 drivers/md/bcache/util.h    |    2 -
 3 files changed, 15 insertions(+), 36 deletions(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -726,8 +726,6 @@ struct cache_set {
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
-
-	DECLARE_HEAP(struct btree *, flush_btree);
 };
 
 struct bbio {
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -390,12 +390,6 @@ err:
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
@@ -403,35 +397,25 @@ static void btree_flush_write(struct cac
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
-			}
-
-		for (i = c->flush_btree.used / 2 - 1; i >= 0; --i)
-			heap_sift(&c->flush_btree, i, journal_min_cmp);
-	}
+	best = NULL;
 
-	b = NULL;
-	heap_pop(&c->flush_btree, b, journal_min_cmp);
-	spin_unlock(&c->journal.lock);
+	for_each_cached_btree(b, c, i)
+		if (btree_current_write(b)->journal) {
+			if (!best)
+				best = b;
+			else if (journal_pin_cmp(c,
+					btree_current_write(best)->journal,
+					btree_current_write(b)->journal)) {
+				best = b;
+			}
+		}
 
+	b = best;
 	if (b) {
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
@@ -873,8 +857,7 @@ int bch_journal_alloc(struct cache_set *
 	j->w[0].c = c;
 	j->w[1].c = c;
 
-	if (!(init_heap(&c->flush_btree, 128, GFP_KERNEL)) ||
-	    !(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
+	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
 	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)) ||
 	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)))
 		return -ENOMEM;
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -113,8 +113,6 @@ do {									\
 
 #define heap_full(h)	((h)->used == (h)->size)
 
-#define heap_empty(h)	((h)->used == 0)
-
 #define DECLARE_FIFO(type, name)					\
 	struct {							\
 		size_t front, back, size, mask;				\


