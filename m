Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512DE582CA8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiG0Qtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240604AbiG0Qsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935B52E66;
        Wed, 27 Jul 2022 09:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1FBA61A04;
        Wed, 27 Jul 2022 16:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC09EC433C1;
        Wed, 27 Jul 2022 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939556;
        bh=FeCdmP6du55VKIjZLjCHLYaOC6HIqbWya7cDxcsTO5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVxtON02CPgKXoutbeO9lssP9mqXNjhAtVrbIf+exd3rDKTM0bdlIsYq7WQMJTJcb
         iBYpJMbVAh4X6w+kW/wA3a0XV3+uBrhvk2ALQMWL4VriFjPA771tI6hneynQUR8UEu
         n0HrtKkFWE2zDhG+CmVt7/wtM/ALjko4x8mY4RG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 007/105] block: split bio_kmalloc from bio_alloc_bioset
Date:   Wed, 27 Jul 2022 18:09:53 +0200
Message-Id: <20220727161012.364032637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 3175199ab0ac8c874ec25c6bf169f74888917435 upstream.

bio_kmalloc shares almost no logic with the bio_set based fast path
in bio_alloc_bioset.  Split it into an entirely separate implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Acked-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c         |  174 ++++++++++++++++++++++++++--------------------------
 include/linux/bio.h |    6 -
 2 files changed, 90 insertions(+), 90 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -405,122 +405,101 @@ static void punt_bios_to_rescuer(struct
  * @nr_iovecs:	number of iovecs to pre-allocate
  * @bs:		the bio_set to allocate from.
  *
- * Description:
- *   If @bs is NULL, uses kmalloc() to allocate the bio; else the allocation is
- *   backed by the @bs's mempool.
- *
- *   When @bs is not NULL, if %__GFP_DIRECT_RECLAIM is set then bio_alloc will
- *   always be able to allocate a bio. This is due to the mempool guarantees.
- *   To make this work, callers must never allocate more than 1 bio at a time
- *   from this pool. Callers that need to allocate more than 1 bio must always
- *   submit the previously allocated bio for IO before attempting to allocate
- *   a new one. Failure to do so can cause deadlocks under memory pressure.
- *
- *   Note that when running under submit_bio_noacct() (i.e. any block
- *   driver), bios are not submitted until after you return - see the code in
- *   submit_bio_noacct() that converts recursion into iteration, to prevent
- *   stack overflows.
- *
- *   This would normally mean allocating multiple bios under
- *   submit_bio_noacct() would be susceptible to deadlocks, but we have
- *   deadlock avoidance code that resubmits any blocked bios from a rescuer
- *   thread.
- *
- *   However, we do not guarantee forward progress for allocations from other
- *   mempools. Doing multiple allocations from the same mempool under
- *   submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
- *   for per bio allocations.
+ * Allocate a bio from the mempools in @bs.
  *
- *   RETURNS:
- *   Pointer to new bio on success, NULL on failure.
+ * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
+ * allocate a bio.  This is due to the mempool guarantees.  To make this work,
+ * callers must never allocate more than 1 bio at a time from the general pool.
+ * Callers that need to allocate more than 1 bio must always submit the
+ * previously allocated bio for IO before attempting to allocate a new one.
+ * Failure to do so can cause deadlocks under memory pressure.
+ *
+ * Note that when running under submit_bio_noacct() (i.e. any block driver),
+ * bios are not submitted until after you return - see the code in
+ * submit_bio_noacct() that converts recursion into iteration, to prevent
+ * stack overflows.
+ *
+ * This would normally mean allocating multiple bios under submit_bio_noacct()
+ * would be susceptible to deadlocks, but we have
+ * deadlock avoidance code that resubmits any blocked bios from a rescuer
+ * thread.
+ *
+ * However, we do not guarantee forward progress for allocations from other
+ * mempools. Doing multiple allocations from the same mempool under
+ * submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
+ * for per bio allocations.
+ *
+ * Returns: Pointer to new bio on success, NULL on failure.
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
 			     struct bio_set *bs)
 {
 	gfp_t saved_gfp = gfp_mask;
-	unsigned front_pad;
-	unsigned inline_vecs;
-	struct bio_vec *bvl = NULL;
 	struct bio *bio;
 	void *p;
 
-	if (!bs) {
-		if (nr_iovecs > UIO_MAXIOV)
-			return NULL;
-
-		p = kmalloc(struct_size(bio, bi_inline_vecs, nr_iovecs), gfp_mask);
-		front_pad = 0;
-		inline_vecs = nr_iovecs;
-	} else {
-		/* should not use nobvec bioset for nr_iovecs > 0 */
-		if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) &&
-				 nr_iovecs > 0))
-			return NULL;
-		/*
-		 * submit_bio_noacct() converts recursion to iteration; this
-		 * means if we're running beneath it, any bios we allocate and
-		 * submit will not be submitted (and thus freed) until after we
-		 * return.
-		 *
-		 * This exposes us to a potential deadlock if we allocate
-		 * multiple bios from the same bio_set() while running
-		 * underneath submit_bio_noacct(). If we were to allocate
-		 * multiple bios (say a stacking block driver that was splitting
-		 * bios), we would deadlock if we exhausted the mempool's
-		 * reserve.
-		 *
-		 * We solve this, and guarantee forward progress, with a rescuer
-		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
-		 * bios we would be blocking to the rescuer workqueue before
-		 * we retry with the original gfp_flags.
-		 */
-
-		if (current->bio_list &&
-		    (!bio_list_empty(&current->bio_list[0]) ||
-		     !bio_list_empty(&current->bio_list[1])) &&
-		    bs->rescue_workqueue)
-			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+	/* should not use nobvec bioset for nr_iovecs > 0 */
+	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_iovecs > 0))
+		return NULL;
 
+	/*
+	 * submit_bio_noacct() converts recursion to iteration; this means if
+	 * we're running beneath it, any bios we allocate and submit will not be
+	 * submitted (and thus freed) until after we return.
+	 *
+	 * This exposes us to a potential deadlock if we allocate multiple bios
+	 * from the same bio_set() while running underneath submit_bio_noacct().
+	 * If we were to allocate multiple bios (say a stacking block driver
+	 * that was splitting bios), we would deadlock if we exhausted the
+	 * mempool's reserve.
+	 *
+	 * We solve this, and guarantee forward progress, with a rescuer
+	 * workqueue per bio_set. If we go to allocate and there are bios on
+	 * current->bio_list, we first try the allocation without
+	 * __GFP_DIRECT_RECLAIM; if that fails, we punt those bios we would be
+	 * blocking to the rescuer workqueue before we retry with the original
+	 * gfp_flags.
+	 */
+	if (current->bio_list &&
+	    (!bio_list_empty(&current->bio_list[0]) ||
+	     !bio_list_empty(&current->bio_list[1])) &&
+	    bs->rescue_workqueue)
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	p = mempool_alloc(&bs->bio_pool, gfp_mask);
+	if (!p && gfp_mask != saved_gfp) {
+		punt_bios_to_rescuer(bs);
+		gfp_mask = saved_gfp;
 		p = mempool_alloc(&bs->bio_pool, gfp_mask);
-		if (!p && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			p = mempool_alloc(&bs->bio_pool, gfp_mask);
-		}
-
-		front_pad = bs->front_pad;
-		inline_vecs = BIO_INLINE_VECS;
 	}
-
 	if (unlikely(!p))
 		return NULL;
 
-	bio = p + front_pad;
-	bio_init(bio, NULL, 0);
-
-	if (nr_iovecs > inline_vecs) {
+	bio = p + bs->front_pad;
+	if (nr_iovecs > BIO_INLINE_VECS) {
 		unsigned long idx = 0;
+		struct bio_vec *bvl = NULL;
 
 		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
 		if (!bvl && gfp_mask != saved_gfp) {
 			punt_bios_to_rescuer(bs);
 			gfp_mask = saved_gfp;
-			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
+			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx,
+					 &bs->bvec_pool);
 		}
 
 		if (unlikely(!bvl))
 			goto err_free;
 
 		bio->bi_flags |= idx << BVEC_POOL_OFFSET;
+		bio_init(bio, bvl, bvec_nr_vecs(idx));
 	} else if (nr_iovecs) {
-		bvl = bio->bi_inline_vecs;
+		bio_init(bio, bio->bi_inline_vecs, BIO_INLINE_VECS);
+	} else {
+		bio_init(bio, NULL, 0);
 	}
 
 	bio->bi_pool = bs;
-	bio->bi_max_vecs = nr_iovecs;
-	bio->bi_io_vec = bvl;
 	return bio;
 
 err_free:
@@ -529,6 +508,31 @@ err_free:
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
+/**
+ * bio_kmalloc - kmalloc a bio for I/O
+ * @gfp_mask:   the GFP_* mask given to the slab allocator
+ * @nr_iovecs:	number of iovecs to pre-allocate
+ *
+ * Use kmalloc to allocate and initialize a bio.
+ *
+ * Returns: Pointer to new bio on success, NULL on failure.
+ */
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+{
+	struct bio *bio;
+
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
+	bio = kmalloc(struct_size(bio, bi_inline_vecs, nr_iovecs), gfp_mask);
+	if (unlikely(!bio))
+		return NULL;
+	bio_init(bio, nr_iovecs ? bio->bi_inline_vecs : NULL, nr_iovecs);
+	bio->bi_pool = NULL;
+	return bio;
+}
+EXPORT_SYMBOL(bio_kmalloc);
+
 void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
 {
 	unsigned long flags;
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -390,6 +390,7 @@ extern int biovec_init_pool(mempool_t *p
 extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 
 extern struct bio *bio_alloc_bioset(gfp_t, unsigned int, struct bio_set *);
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 extern void bio_put(struct bio *);
 
 extern void __bio_clone_fast(struct bio *, struct bio *);
@@ -402,11 +403,6 @@ static inline struct bio *bio_alloc(gfp_
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, &fs_bio_set);
 }
 
-static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
-{
-	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
-}
-
 extern blk_qc_t submit_bio(struct bio *);
 
 extern void bio_endio(struct bio *);


