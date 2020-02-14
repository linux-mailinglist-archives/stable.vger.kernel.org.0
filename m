Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809DD15EBAE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391420AbgBNQKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391414AbgBNQKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B006424699;
        Fri, 14 Feb 2020 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696608;
        bh=H0qXnJ1K3Sw3RpXUVMkduJ52P40jqi0YznpsNIgsmFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ixDJSC4nSO62AmytrhgSCerhglsLuN++SQzJrTD9vXUVNIIw0xYpUmULCLDnHd4o
         RBbVTQ9qZlQYitV/IVxFIY9vu63HGS53MX+aLPcw6Ca2fzIzoh2MR0Yz63hHAnh+M3
         G2VX7hnHlOJZwd6mO60PQIF2fu4ttLY+ChRepBUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Guoju Fang <fangguoju@gmail.com>,
        Shuang Li <psymon@bonuscloud.io>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 392/459] bcache: avoid unnecessary btree nodes flushing in btree_flush_write()
Date:   Fri, 14 Feb 2020 11:00:42 -0500
Message-Id: <20200214160149.11681-392-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 2aa8c529387c25606fdc1484154b92f8bfbc5746 ]

the commit 91be66e1318f ("bcache: performance improvement for
btree_flush_write()") was an effort to flushing btree node with oldest
btree node faster in following methods,
- Only iterate dirty btree nodes in c->btree_cache, avoid scanning a lot
  of clean btree nodes.
- Take c->btree_cache as a LRU-like list, aggressively flushing all
  dirty nodes from tail of c->btree_cache util the btree node with
  oldest journal entry is flushed. This is to reduce the time of holding
  c->bucket_lock.

Guoju Fang and Shuang Li reported that they observe unexptected extra
write I/Os on cache device after applying the above patch. Guoju Fang
provideed more detailed diagnose information that the aggressive
btree nodes flushing may cause 10x more btree nodes to flush in his
workload. He points out when system memory is large enough to hold all
btree nodes in memory, c->btree_cache is not a LRU-like list any more.
Then the btree node with oldest journal entry is very probably not-
close to the tail of c->btree_cache list. In such situation much more
dirty btree nodes will be aggressively flushed before the target node
is flushed. When slow SATA SSD is used as cache device, such over-
aggressive flushing behavior will cause performance regression.

After spending a lot of time on debug and diagnose, I find the real
condition is more complicated, aggressive flushing dirty btree nodes
from tail of c->btree_cache list is not a good solution.
- When all btree nodes are cached in memory, c->btree_cache is not
  a LRU-like list, the btree nodes with oldest journal entry won't
  be close to the tail of the list.
- There can be hundreds dirty btree nodes reference the oldest journal
  entry, before flushing all the nodes the oldest journal entry cannot
  be reclaimed.
When the above two conditions mixed together, a simply flushing from
tail of c->btree_cache list is really NOT a good idea.

Fortunately there is still chance to make btree_flush_write() work
better. Here is how this patch avoids unnecessary btree nodes flushing,
- Only acquire c->journal.lock when getting oldest journal entry of
  fifo c->journal.pin. In rested locations check the journal entries
  locklessly, so their values can be changed on other cores
  in parallel.
- In loop list_for_each_entry_safe_reverse(), checking latest front
  point of fifo c->journal.pin. If it is different from the original
  point which we get with locking c->journal.lock, it means the oldest
  journal entry is reclaim on other cores. At this moment, all selected
  dirty nodes recorded in array btree_nodes[] are all flushed and clean
  on other CPU cores, it is unncessary to iterate c->btree_cache any
  longer. Just quit the list_for_each_entry_safe_reverse() loop and
  the following for-loop will skip all the selected clean nodes.
- Find a proper time to quit the list_for_each_entry_safe_reverse()
  loop. Check the refcount value of orignial fifo front point, if the
  value is larger than selected node number of btree_nodes[], it means
  more matching btree nodes should be scanned. Otherwise it means no
  more matching btee nodes in rest of c->btree_cache list, the loop
  can be quit. If the original oldest journal entry is reclaimed and
  fifo front point is updated, the refcount of original fifo front point
  will be 0, then the loop will be quit too.
- Not hold c->bucket_lock too long time. c->bucket_lock is also required
  for space allocation for cached data, hold it for too long time will
  block regular I/O requests. When iterating list c->btree_cache, even
  there are a lot of maching btree nodes, in order to not holding
  c->bucket_lock for too long time, only BTREE_FLUSH_NR nodes are
  selected and to flush in following for-loop.
With this patch, only btree nodes referencing oldest journal entry
are flushed to cache device, no aggressive flushing for  unnecessary
btree node any more. And in order to avoid blocking regluar I/O
requests, each time when btree_flush_write() called, at most only
BTREE_FLUSH_NR btree nodes are selected to flush, even there are more
maching btree nodes in list c->btree_cache.

At last, one more thing to explain: Why it is safe to read front point
of c->journal.pin without holding c->journal.lock inside the
list_for_each_entry_safe_reverse() loop ?

Here is my answer: When reading the front point of fifo c->journal.pin,
we don't need to know the exact value of front point, we just want to
check whether the value is different from the original front point
(which is accurate value because we get it while c->jouranl.lock is
held). For such purpose, it works as expected without holding
c->journal.lock. Even the front point is changed on other CPU core and
not updated to local core, and current iterating btree node has
identical journal entry local as original fetched fifo front point, it
is still safe. Because after holding mutex b->write_lock (with memory
barrier) this btree node can be found as clean and skipped, the loop
will quite latter when iterate on next node of list c->btree_cache.

Fixes: 91be66e1318f ("bcache: performance improvement for btree_flush_write()")
Reported-by: Guoju Fang <fangguoju@gmail.com>
Reported-by: Shuang Li <psymon@bonuscloud.io>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 80 ++++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index be2a2a2016032..33ddc5269e8dc 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -417,10 +417,14 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 /* Journalling */
 
+#define nr_to_fifo_front(p, front_p, mask)	(((p) - (front_p)) & (mask))
+
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
-	unsigned int i, n;
+	unsigned int i, nr, ref_nr;
+	atomic_t *fifo_front_p, *now_fifo_front_p;
+	size_t mask;
 
 	if (c->journal.btree_flushing)
 		return;
@@ -433,12 +437,50 @@ static void btree_flush_write(struct cache_set *c)
 	c->journal.btree_flushing = true;
 	spin_unlock(&c->journal.flush_write_lock);
 
+	/* get the oldest journal entry and check its refcount */
+	spin_lock(&c->journal.lock);
+	fifo_front_p = &fifo_front(&c->journal.pin);
+	ref_nr = atomic_read(fifo_front_p);
+	if (ref_nr <= 0) {
+		/*
+		 * do nothing if no btree node references
+		 * the oldest journal entry
+		 */
+		spin_unlock(&c->journal.lock);
+		goto out;
+	}
+	spin_unlock(&c->journal.lock);
+
+	mask = c->journal.pin.mask;
+	nr = 0;
 	atomic_long_inc(&c->flush_write);
 	memset(btree_nodes, 0, sizeof(btree_nodes));
-	n = 0;
 
 	mutex_lock(&c->bucket_lock);
 	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
+		/*
+		 * It is safe to get now_fifo_front_p without holding
+		 * c->journal.lock here, because we don't need to know
+		 * the exactly accurate value, just check whether the
+		 * front pointer of c->journal.pin is changed.
+		 */
+		now_fifo_front_p = &fifo_front(&c->journal.pin);
+		/*
+		 * If the oldest journal entry is reclaimed and front
+		 * pointer of c->journal.pin changes, it is unnecessary
+		 * to scan c->btree_cache anymore, just quit the loop and
+		 * flush out what we have already.
+		 */
+		if (now_fifo_front_p != fifo_front_p)
+			break;
+		/*
+		 * quit this loop if all matching btree nodes are
+		 * scanned and record in btree_nodes[] already.
+		 */
+		ref_nr = atomic_read(fifo_front_p);
+		if (nr >= ref_nr)
+			break;
+
 		if (btree_node_journal_flush(b))
 			pr_err("BUG: flush_write bit should not be set here!");
 
@@ -454,17 +496,44 @@ static void btree_flush_write(struct cache_set *c)
 			continue;
 		}
 
+		/*
+		 * Only select the btree node which exactly references
+		 * the oldest journal entry.
+		 *
+		 * If the journal entry pointed by fifo_front_p is
+		 * reclaimed in parallel, don't worry:
+		 * - the list_for_each_xxx loop will quit when checking
+		 *   next now_fifo_front_p.
+		 * - If there are matched nodes recorded in btree_nodes[],
+		 *   they are clean now (this is why and how the oldest
+		 *   journal entry can be reclaimed). These selected nodes
+		 *   will be ignored and skipped in the folowing for-loop.
+		 */
+		if (nr_to_fifo_front(btree_current_write(b)->journal,
+				     fifo_front_p,
+				     mask) != 0) {
+			mutex_unlock(&b->write_lock);
+			continue;
+		}
+
 		set_btree_node_journal_flush(b);
 
 		mutex_unlock(&b->write_lock);
 
-		btree_nodes[n++] = b;
-		if (n == BTREE_FLUSH_NR)
+		btree_nodes[nr++] = b;
+		/*
+		 * To avoid holding c->bucket_lock too long time,
+		 * only scan for BTREE_FLUSH_NR matched btree nodes
+		 * at most. If there are more btree nodes reference
+		 * the oldest journal entry, try to flush them next
+		 * time when btree_flush_write() is called.
+		 */
+		if (nr == BTREE_FLUSH_NR)
 			break;
 	}
 	mutex_unlock(&c->bucket_lock);
 
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < nr; i++) {
 		b = btree_nodes[i];
 		if (!b) {
 			pr_err("BUG: btree_nodes[%d] is NULL", i);
@@ -497,6 +566,7 @@ static void btree_flush_write(struct cache_set *c)
 		mutex_unlock(&b->write_lock);
 	}
 
+out:
 	spin_lock(&c->journal.flush_write_lock);
 	c->journal.btree_flushing = false;
 	spin_unlock(&c->journal.flush_write_lock);
-- 
2.20.1

