Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D624551A7B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244942AbiFTNGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244094AbiFTNEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057DE13CCB;
        Mon, 20 Jun 2022 05:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 542AFCE1386;
        Mon, 20 Jun 2022 12:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3292FC3411C;
        Mon, 20 Jun 2022 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729993;
        bh=zKDGnQNZ3Lcx01ngixrSGF90RNivdIWvffi8qbGBins=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvJdd455yw7tMD0HR4B++j6+3USh9lXBTtaIrQGj+XgeQ1QdxOM1HKWn9UzDu6Tl4
         dQcUtE4sU/GaDGPIizRQd6A4JoBjRu78s9mYqQkhjZxTXUyA0eeFkJIJ3a0l/31PSE
         dylJ58GPLoruubDKcmtzZO/Q/JYOzz/LoxCOITZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.18 140/141] dm: fix bio_set allocation
Date:   Mon, 20 Jun 2022 14:51:18 +0200
Message-Id: <20220620124733.697765253@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 29dec90a0f1d961b93f34f910e9319d8cb23edbd upstream.

The use of bioset_init_from_src mean that the pre-allocated pools weren't
used for anything except parameter passing, and the integrity pool
creation got completely lost for the actual live mapped_device.  Fix that
by assigning the actual preallocated dm_md_mempools to the mapped_device
and using that for I/O instead of creating new mempools.

Fixes: 2a2a4c510b76 ("dm: use bioset_init_from_src() to copy bio_set")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h  |   11 +++++-
 drivers/md/dm-rq.c    |    2 -
 drivers/md/dm-table.c |   11 ------
 drivers/md/dm.c       |   83 ++++++++++++++------------------------------------
 drivers/md/dm.h       |    2 -
 5 files changed, 34 insertions(+), 75 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -32,6 +32,14 @@ struct dm_kobject_holder {
  * access their members!
  */
 
+/*
+ * For mempools pre-allocation at the table loading time.
+ */
+struct dm_md_mempools {
+	struct bio_set bs;
+	struct bio_set io_bs;
+};
+
 struct mapped_device {
 	struct mutex suspend_lock;
 
@@ -109,8 +117,7 @@ struct mapped_device {
 	/*
 	 * io objects are allocated from here.
 	 */
-	struct bio_set io_bs;
-	struct bio_set bs;
+	struct dm_md_mempools *mempools;
 
 	/* kobject and completion */
 	struct dm_kobject_holder kobj_holder;
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -319,7 +319,7 @@ static int setup_clone(struct request *c
 {
 	int r;
 
-	r = blk_rq_prep_clone(clone, rq, &tio->md->bs, gfp_mask,
+	r = blk_rq_prep_clone(clone, rq, &tio->md->mempools->bs, gfp_mask,
 			      dm_rq_bio_constructor, tio);
 	if (r)
 		return r;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1030,17 +1030,6 @@ static int dm_table_alloc_md_mempools(st
 	return 0;
 }
 
-void dm_table_free_md_mempools(struct dm_table *t)
-{
-	dm_free_md_mempools(t->mempools);
-	t->mempools = NULL;
-}
-
-struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t)
-{
-	return t->mempools;
-}
-
 static int setup_indexes(struct dm_table *t)
 {
 	int i;
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -131,14 +131,6 @@ static int get_swap_bios(void)
 	return latch;
 }
 
-/*
- * For mempools pre-allocation at the table loading time.
- */
-struct dm_md_mempools {
-	struct bio_set bs;
-	struct bio_set io_bs;
-};
-
 struct table_device {
 	struct list_head list;
 	refcount_t count;
@@ -573,7 +565,7 @@ static struct dm_io *alloc_io(struct map
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->io_bs);
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->mempools->io_bs);
 
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
@@ -615,7 +607,7 @@ static struct bio *alloc_tio(struct clon
 		clone = &tio->clone;
 	} else {
 		clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio,
-					gfp_mask, &ci->io->md->bs);
+					gfp_mask, &ci->io->md->mempools->bs);
 		if (!clone)
 			return NULL;
 
@@ -1775,8 +1767,7 @@ static void cleanup_mapped_device(struct
 {
 	if (md->wq)
 		destroy_workqueue(md->wq);
-	bioset_exit(&md->bs);
-	bioset_exit(&md->io_bs);
+	dm_free_md_mempools(md->mempools);
 
 	if (md->dax_dev) {
 		dax_remove_host(md->disk);
@@ -1948,48 +1939,6 @@ static void free_dev(struct mapped_devic
 	kvfree(md);
 }
 
-static int __bind_mempools(struct mapped_device *md, struct dm_table *t)
-{
-	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
-	int ret = 0;
-
-	if (dm_table_bio_based(t)) {
-		/*
-		 * The md may already have mempools that need changing.
-		 * If so, reload bioset because front_pad may have changed
-		 * because a different table was loaded.
-		 */
-		bioset_exit(&md->bs);
-		bioset_exit(&md->io_bs);
-
-	} else if (bioset_initialized(&md->bs)) {
-		/*
-		 * There's no need to reload with request-based dm
-		 * because the size of front_pad doesn't change.
-		 * Note for future: If you are to reload bioset,
-		 * prep-ed requests in the queue may refer
-		 * to bio from the old bioset, so you must walk
-		 * through the queue to unprep.
-		 */
-		goto out;
-	}
-
-	BUG_ON(!p ||
-	       bioset_initialized(&md->bs) ||
-	       bioset_initialized(&md->io_bs));
-
-	ret = bioset_init_from_src(&md->bs, &p->bs);
-	if (ret)
-		goto out;
-	ret = bioset_init_from_src(&md->io_bs, &p->io_bs);
-	if (ret)
-		bioset_exit(&md->bs);
-out:
-	/* mempool bind completed, no longer need any mempools in the table */
-	dm_table_free_md_mempools(t);
-	return ret;
-}
-
 /*
  * Bind a table to the device.
  */
@@ -2043,12 +1992,28 @@ static struct dm_table *__bind(struct ma
 		 * immutable singletons - used to optimize dm_mq_queue_rq.
 		 */
 		md->immutable_target = dm_table_get_immutable_target(t);
-	}
 
-	ret = __bind_mempools(md, t);
-	if (ret) {
-		old_map = ERR_PTR(ret);
-		goto out;
+		/*
+		 * There is no need to reload with request-based dm because the
+		 * size of front_pad doesn't change.
+		 *
+		 * Note for future: If you are to reload bioset, prep-ed
+		 * requests in the queue may refer to bio from the old bioset,
+		 * so you must walk through the queue to unprep.
+		 */
+		if (!md->mempools) {
+			md->mempools = t->mempools;
+			t->mempools = NULL;
+		}
+	} else {
+		/*
+		 * The md may already have mempools that need changing.
+		 * If so, reload bioset because front_pad may have changed
+		 * because a different table was loaded.
+		 */
+		dm_free_md_mempools(md->mempools);
+		md->mempools = t->mempools;
+		t->mempools = NULL;
 	}
 
 	ret = dm_table_set_restrictions(t, md->queue, limits);
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -71,8 +71,6 @@ struct dm_target *dm_table_get_immutable
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-void dm_table_free_md_mempools(struct dm_table *t);
-struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);


