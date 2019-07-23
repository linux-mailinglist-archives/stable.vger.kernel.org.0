Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31A77152E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGWJ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:29:24 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54719 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbfGWJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:29:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E87A3503;
        Tue, 23 Jul 2019 05:29:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JedIgD
        PoYDlDj0dvy5/kEPK2RvXpUVkZVHZZVrD0xlc=; b=sGwG7SBF+HaoRkUB++bBAQ
        zONo7vj0K61tjPY9m8vmLLqak08L8OSRH5wInQJ8LlsbsUFICSbhEvXrLbAlPV2U
        Ebw3Qloar21PmkCvitPa3xYf67fR0fsxT+cFggPXBgnojHn5GpRUbb12DiUNoWjK
        nK8qo7/2HH4zwYsKyVid8DHm+zvca492g7F6I7Y0Ree7FVyGoSlrc3XfmAYoEJlS
        WWMo6Ph7GRXqnnPy2Jw1gLMfKxJOVIB116xQHvlCDnpudAtQ9rq94WjmanAYuM+g
        6yLIJYeET3q+chRYswzE+JudWBmRSS9Bxb+gkdA6ruvA34Cyfgdjij2XbwNS6PpA
        ==
X-ME-Sender: <xms:ctM2XdawnDUcKMbBHA_yP1tJX51E41sT7rEUhyflhEW081Yz4U12nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:ctM2XXzEgMbddt8Q8ZZ7i1cb0Hhow8Q3KIeQRkRpgwE9Imt-NUxn8Q>
    <xmx:ctM2XWmm0hQAIL22_kE0_vqz-WoQnVzmKA5_J_aAMYJWjeevK8wLtg>
    <xmx:ctM2XT-gxN-7rWDZa8jTm5rEPxuzdOsV-ZZgFjWH9zEzmFgb4KEdmA>
    <xmx:ctM2XfCM0PE3W-BsOKFWJO3dCaqZRpuQy4Ms-MVS3KiP2ajoxIVl2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06606380084;
        Tue, 23 Jul 2019 05:29:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: fix race in btree_flush_write()" failed to apply to 5.1-stable tree
To:     colyli@suse.de, axboe@kernel.dk, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:29:19 +0200
Message-ID: <156387415937183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50a260e859964002dab162513a10f91ae9d3bcd3 Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Fri, 28 Jun 2019 19:59:58 +0800
Subject: [PATCH] bcache: fix race in btree_flush_write()

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

