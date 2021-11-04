Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0308B445B0A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 21:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhKDU0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 16:26:39 -0400
Received: from verein.lst.de ([213.95.11.211]:36591 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhKDU0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 16:26:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CD1A6732D; Thu,  4 Nov 2021 21:23:58 +0100 (CET)
Date:   Thu, 4 Nov 2021 21:23:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Message-ID: <20211104202358.GA4264@lst.de>
References: <20211103151041.70516-1-colyli@suse.de> <20211103154644.GA30686@lst.de> <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de> <20211103161955.GA394@lst.de> <9e23e103-40ff-963f-739f-730da4d5fe3f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e23e103-40ff-963f-739f-730da4d5fe3f@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ok, because it takes the offset away we're not aligned any more.
I think the right fix is to fix this properly and stop poking into
the bio internals.  The patch below has surived and xfstests quick
run on two bcache devices:

---
From 3bf1068e2dc6a75442513e8f9f64055740c0b507 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 4 Nov 2021 10:40:37 +0100
Subject: bcache: lift bvec mapping into bch_bio_alloc_pages

Use the proper block APIs to add pages to the bio and remove the need
for the extra call to bch_bio_map and the open coded data copy for the
write case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/btree.c     | 31 ++++++++------------------
 drivers/md/bcache/debug.c     |  4 +---
 drivers/md/bcache/movinggc.c  |  7 +++---
 drivers/md/bcache/request.c   |  5 ++---
 drivers/md/bcache/util.c      | 41 +++++++++++++++++++++++------------
 drivers/md/bcache/util.h      |  2 +-
 drivers/md/bcache/writeback.c |  7 +++---
 7 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 93b67b8d31c3d..c435b8f2bca04 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -339,6 +339,7 @@ static void do_btree_node_write(struct btree *b)
 {
 	struct closure *cl = &b->io;
 	struct bset *i = btree_bset_last(b);
+	size_t size;
 	BKEY_PADDED(key) k;
 
 	i->version	= BCACHE_BSET_VERSION;
@@ -349,9 +350,7 @@ static void do_btree_node_write(struct btree *b)
 
 	b->bio->bi_end_io	= btree_node_write_endio;
 	b->bio->bi_private	= cl;
-	b->bio->bi_iter.bi_size	= roundup(set_bytes(i), block_bytes(b->c->cache));
 	b->bio->bi_opf		= REQ_OP_WRITE | REQ_META | REQ_FUA;
-	bch_bio_map(b->bio, i);
 
 	/*
 	 * If we're appending to a leaf node, we don't technically need FUA -
@@ -372,32 +371,20 @@ static void do_btree_node_write(struct btree *b)
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
 		       bset_sector_offset(&b->keys, i));
 
-	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
-		struct bio_vec *bv;
-		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
-		struct bvec_iter_all iter_all;
-
-		bio_for_each_segment_all(bv, b->bio, iter_all) {
-			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
-			addr += PAGE_SIZE;
-		}
-
-		bch_submit_bbio(b->bio, b->c, &k.key, 0);
-
-		continue_at(cl, btree_node_write_done, NULL);
-	} else {
-		/*
-		 * No problem for multipage bvec since the bio is
-		 * just allocated
-		 */
-		b->bio->bi_vcnt = 0;
+	size = roundup(set_bytes(i), block_bytes(b->c->cache));
+	if (bch_bio_alloc_pages(b->bio, i, size,
+			__GFP_NOWARN | GFP_NOWAIT) < 0) {
+		b->bio->bi_iter.bi_size	= size;
 		bch_bio_map(b->bio, i);
-
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
 
 		closure_sync(cl);
 		continue_at_nobarrier(cl, __btree_node_write_done, NULL);
+		return;
 	}
+
+	bch_submit_bbio(b->bio, b->c, &k.key, 0);
+	continue_at(cl, btree_node_write_done, NULL);
 }
 
 void __bch_btree_node_write(struct btree *b, struct closure *parent)
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 6230dfdd9286e..ef8ec8090d579 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -117,10 +117,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	bio_set_dev(check, bio->bi_bdev);
 	check->bi_opf = REQ_OP_READ;
 	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
-	check->bi_iter.bi_size = bio->bi_iter.bi_size;
 
-	bch_bio_map(check, NULL);
-	if (bch_bio_alloc_pages(check, GFP_NOIO))
+	if (bch_bio_alloc_pages(check, NULL, bio->bi_iter.bi_size, GFP_NOIO))
 		goto out_put;
 
 	submit_bio_wait(check);
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index b9c3d27ec093a..7d94e2ec562a4 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -84,9 +84,7 @@ static void moving_init(struct moving_io *io)
 	bio_get(bio);
 	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
-	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
 	bio->bi_private		= &io->cl;
-	bch_bio_map(bio, NULL);
 }
 
 static void write_moving(struct closure *cl)
@@ -97,6 +95,8 @@ static void write_moving(struct closure *cl)
 	if (!op->status) {
 		moving_init(io);
 
+		io->bio.bio.bi_iter.bi_size = KEY_SIZE(&io->w->key) << 9;
+		bch_bio_map(&io->bio.bio, NULL);
 		io->bio.bio.bi_iter.bi_sector = KEY_START(&io->w->key);
 		op->write_prio		= 1;
 		op->bio			= &io->bio.bio;
@@ -163,7 +163,8 @@ static void read_moving(struct cache_set *c)
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		bio->bi_end_io	= read_moving_endio;
 
-		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
+		if (bch_bio_alloc_pages(bio, NULL, KEY_SIZE(&io->w->key) << 9,
+				GFP_KERNEL))
 			goto err;
 
 		trace_bcache_gc_copy(&w->key);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c13..faa89410c7470 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -921,13 +921,12 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 
 	cache_bio->bi_iter.bi_sector	= miss->bi_iter.bi_sector;
 	bio_copy_dev(cache_bio, miss);
-	cache_bio->bi_iter.bi_size	= s->insert_bio_sectors << 9;
 
 	cache_bio->bi_end_io	= backing_request_endio;
 	cache_bio->bi_private	= &s->cl;
 
-	bch_bio_map(cache_bio, NULL);
-	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO))
+	if (bch_bio_alloc_pages(cache_bio, NULL, s->insert_bio_sectors << 9,
+			__GFP_NOWARN | GFP_NOIO))
 		goto out_put;
 
 	s->cache_miss	= miss;
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index ae380bc3992e3..cf627e7eadc10 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -258,6 +258,8 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
 /**
  * bch_bio_alloc_pages - allocates a single page for each bvec in a bio
  * @bio: bio to allocate pages for
+ * @data: if non-NULL copy data from here into the newly allocate pages
+ * @size: size to allocate
  * @gfp_mask: flags for allocation
  *
  * Allocates pages up to @bio->bi_vcnt.
@@ -265,23 +267,34 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
  * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
  * freed.
  */
-int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
+int bch_bio_alloc_pages(struct bio *bio, void *data, size_t size, gfp_t gfp)
 {
-	int i;
-	struct bio_vec *bv;
+	struct bvec_iter iter;
+	struct bio_vec bv;
 
-	/*
-	 * This is called on freshly new bio, so it is safe to access the
-	 * bvec table directly.
-	 */
-	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++, i++) {
-		bv->bv_page = alloc_page(gfp_mask);
-		if (!bv->bv_page) {
-			while (--bv >= bio->bi_io_vec)
-				__free_page(bv->bv_page);
-			return -ENOMEM;
-		}
+	BUG_ON(bio->bi_vcnt);
+
+	while (size) {
+		struct page *page = alloc_page(gfp);
+		unsigned int offset = offset_in_page(page);
+		size_t len = min(size, PAGE_SIZE - offset);
+
+		if (!page)
+			goto unwind;
+		if (data)
+			memcpy_to_page(page, offset, data, len);
+		if (bio_add_page(bio, page, offset, len) != len)
+			goto unwind;
+
+		size -= len;
+		data += len;
 	}
 
 	return 0;
+
+unwind:
+	bio_for_each_segment(bv, bio, iter)
+		__free_page(bv.bv_page);
+	bio->bi_vcnt = 0;
+	return -ENOMEM;
 }
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 6f3cb7c921303..131d5e874231f 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -557,6 +557,6 @@ static inline unsigned int fract_exp_two(unsigned int x,
 }
 
 void bch_bio_map(struct bio *bio, void *base);
-int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask);
+int bch_bio_alloc_pages(struct bio *bio, void *data, size_t size, gfp_t gfp);
 
 #endif /* _BCACHE_UTIL_H */
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c7560f66dca88..a153e3a1b3b87 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -297,9 +297,7 @@ static void dirty_init(struct keybuf_key *w)
 	if (!io->dc->writeback_percent)
 		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
-	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
 	bio->bi_private		= w;
-	bch_bio_map(bio, NULL);
 }
 
 static void dirty_io_destructor(struct closure *cl)
@@ -395,6 +393,8 @@ static void write_dirty(struct closure *cl)
 	 */
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
+		io->bio.bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
+		bch_bio_map(&io->bio, NULL);
 		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
@@ -513,7 +513,8 @@ static void read_dirty(struct cached_dev *dc)
 			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
 			io->bio.bi_end_io	= read_dirty_endio;
 
-			if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
+			if (bch_bio_alloc_pages(&io->bio, NULL,
+					KEY_SIZE(&w->key) << 9, GFP_KERNEL))
 				goto err_free;
 
 			trace_bcache_writeback(&w->key);
-- 
2.30.2

