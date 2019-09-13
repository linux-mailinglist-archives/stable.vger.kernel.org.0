Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02BDB1F06
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbfIMNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389062AbfIMNPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:02 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7AD206BB;
        Fri, 13 Sep 2019 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380501;
        bh=regKA2GOvohh5LfW7rgzUKVkS60LhH0+sDOxmpKCkQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMZrqiRK3Vwg2M67yaVbwlU3tLqCwPEBuaIiVmttkWQU3WV5jXkYUYrbWugldRMPD
         sjVKioWoFkwpKrYdr05N+F3Y/1rX8MPKpTqDSB1naIJe1+wVSaCZAi9RXN+Ti2PNPw
         8QsoJwJYKp2QNYD2FNzJ/tkB59A8eRwHWre0aFbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/190] bcache: treat stale && dirty keys as bad keys
Date:   Fri, 13 Sep 2019 14:05:41 +0100
Message-Id: <20190913130606.430130776@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58ac323084ebf44f8470eeb8b82660f9d0ee3689 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/extents.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 9560043666999..886710043025f 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -538,6 +538,7 @@ static bool bch_extent_bad(struct btree_keys *bk, const struct bkey *k)
 {
 	struct btree *b = container_of(bk, struct btree, keys);
 	unsigned int i, stale;
+	char buf[80];
 
 	if (!KEY_PTRS(k) ||
 	    bch_extent_invalid(bk, k))
@@ -547,19 +548,19 @@ static bool bch_extent_bad(struct btree_keys *bk, const struct bkey *k)
 		if (!ptr_available(b->c, k, i))
 			return true;
 
-	if (!expensive_debug_checks(b->c) && KEY_DIRTY(k))
-		return false;
-
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		stale = ptr_stale(b->c, k, i);
 
+		if (stale && KEY_DIRTY(k)) {
+			bch_extent_to_text(buf, sizeof(buf), k);
+			pr_info("stale dirty pointer, stale %u, key: %s",
+				stale, buf);
+		}
+
 		btree_bug_on(stale > BUCKET_GC_GEN_MAX, b,
 			     "key too stale: %i, need_gc %u",
 			     stale, b->c->need_gc);
 
-		btree_bug_on(stale && KEY_DIRTY(k) && KEY_SIZE(k),
-			     b, "stale dirty pointer");
-
 		if (stale)
 			return true;
 
-- 
2.20.1



