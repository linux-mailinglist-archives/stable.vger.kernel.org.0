Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B6061705
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfGGToh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57214 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727543AbfGGTiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:07 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006gq-8F; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005ah-Sd; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tang Junhui" <tang.junhui.linux@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>, "Coly Li" <colyli@suse.de>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.315631401@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 055/129] bcache: treat stale && dirty keys as bad keys
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Junhui <tang.junhui.linux@gmail.com>

commit 58ac323084ebf44f8470eeb8b82660f9d0ee3689 upstream.

Stale && dirty keys can be produced in the follow way:
After writeback in write_dirty_finish(), dirty keys k1 will
replace by clean keys k2
==>ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
==>btree_insert_fn(struct btree_op *b_op, struct btree *b)
==>static int bch_btree_insert_node(struct btree *b,
       struct btree_op *op,
       struct keylist *insert_keys,
       atomic_t *journal_ref,
Then two steps:
A) update k1 to k2 in btree node memory;
   bch_btree_insert_keys(b, op, insert_keys, replace_key)
B) Write the bset(contains k2) to cache disk by a 30s delay work
   bch_btree_leaf_dirty(b, journal_ref).
But before the 30s delay work write the bset to cache device,
these things happened:
A) GC works, and reclaim the bucket k2 point to;
B) Allocator works, and invalidate the bucket k2 point to,
   and increase the gen of the bucket, and place it into free_inc
   fifo;
C) Until now, the 30s delay work still does not finish work,
   so in the disk, the key still is k1, it is dirty and stale
   (its gen is smaller than the gen of the bucket). and then the
   machine power off suddenly happens;
D) When the machine power on again, after the btree reconstruction,
   the stale dirty key appear.

In bch_extent_bad(), when expensive_debug_checks is off, it would
treat the dirty key as good even it is stale keys, and it would
cause bellow probelms:
A) In read_dirty() it would cause machine crash:
   BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
B) It could be worse when reads hits stale dirty keys, it would
   read old incorrect data.

This patch tolerate the existence of these stale && dirty keys,
and treat them as bad key in bch_extent_bad().

(Coly Li: fix indent which was modified by sender's email client)

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/extents.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -530,6 +530,7 @@ static bool bch_extent_bad(struct btree_
 	struct btree *b = container_of(bk, struct btree, keys);
 	struct bucket *g;
 	unsigned i, stale;
+	char buf[80];
 
 	if (!KEY_PTRS(k) ||
 	    bch_extent_invalid(bk, k))
@@ -539,20 +540,20 @@ static bool bch_extent_bad(struct btree_
 		if (!ptr_available(b->c, k, i))
 			return true;
 
-	if (!expensive_debug_checks(b->c) && KEY_DIRTY(k))
-		return false;
-
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		g = PTR_BUCKET(b->c, k, i);
 		stale = ptr_stale(b->c, k, i);
 
+		if (stale && KEY_DIRTY(k)) {
+			bch_extent_to_text(buf, sizeof(buf), k);
+			pr_info("stale dirty pointer, stale %u, key: %s",
+				stale, buf);
+		}
+
 		btree_bug_on(stale > 96, b,
 			     "key too stale: %i, need_gc %u",
 			     stale, b->c->need_gc);
 
-		btree_bug_on(stale && KEY_DIRTY(k) && KEY_SIZE(k),
-			     b, "stale dirty pointer");
-
 		if (stale)
 			return true;
 

