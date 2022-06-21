Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EF05537E7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353026AbiFUQfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 12:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiFUQfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 12:35:08 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061E2610F
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 09:35:07 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id q4so9064410qvq.8
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 09:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7o7lxnUCtyY119FDb7ETl2LEK0niL9adrYh+6j8vRDM=;
        b=kyJxHPRDRM4uC53ozGfsfin6nlkRVWf5iBAST55XTe5GqMzSYeAtXTzkEB3W5lCZ+I
         Ul3DcLUejVmM+3w+IxStaPE5aWy+QlFbcpBFklHccuDJb6LRPxeGqyUZS2vtk6AIlr6r
         w9ObLwQkCaz8eg3bty13bZY4pii8qYCSJ81HS3XxYew6lXjdntecu7TySiIb4U/6XVAo
         YQ6oEVdWJpOtZMGILrDmDap7ZX6tOUEhpawi/hRt1K5Bevtl1eHgdsoi1J9q7yIQ4Dea
         5BsNnV1Z9Av8qBq4ZsJXOO45sdlCO4Qghmt4mCrseHgPp2wHVisyuAsIubEU/UvnsiSJ
         v/Cg==
X-Gm-Message-State: AJIora/aoNutO1BYAeiD4FAQ7WB2jIfZ5DNf40lGSC5otbnn3Xo6rC24
        TAA2iQaoxusXJBEkgsY6BaKx
X-Google-Smtp-Source: AGRyM1vb5epLM31RsTODGVjfqmrGoNVubXn0wSp23W4x2r0NPOZ/e265VHIpuY+3dMMPz16j405rgw==
X-Received: by 2002:a05:6214:2309:b0:46e:5fb9:a33 with SMTP id gc9-20020a056214230900b0046e5fb90a33mr23883039qvb.28.1655829306287;
        Tue, 21 Jun 2022 09:35:06 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a444800b006a6f68c8a87sm15162267qkp.126.2022.06.21.09.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:35:05 -0700 (PDT)
Date:   Tue, 21 Jun 2022 12:35:04 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Mike Snitzer <snitzer@kernel.org>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
        regressions@lists.linux.dev
Subject: [5.4.y PATCH v2] dm: remove special-casing of bio-based immutable
 singleton target on NVMe
Message-ID: <YrHzOGO5fOSFwqdJ@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com>
 <YrBdsTDrreF3H82o@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrBdsTDrreF3H82o@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.

There is no benefit to DM special-casing NVMe. Remove all code used to
establish DM_TYPE_NVME_BIO_BASED.

Also, remove 3 'struct mapped_device *md' variables in __map_bio() which
masked the same variable that is available within __map_bio()'s scope.

Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c         | 32 +--------------
 drivers/md/dm.c               | 73 ++++-------------------------------
 include/linux/device-mapper.h |  1 -
 3 files changed, 9 insertions(+), 97 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 06b382304d92..81bc36a43b32 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -872,8 +872,7 @@ EXPORT_SYMBOL(dm_consume_args);
 static bool __table_type_bio_based(enum dm_queue_mode table_type)
 {
 	return (table_type == DM_TYPE_BIO_BASED ||
-		table_type == DM_TYPE_DAX_BIO_BASED ||
-		table_type == DM_TYPE_NVME_BIO_BASED);
+		table_type == DM_TYPE_DAX_BIO_BASED);
 }
 
 static bool __table_type_request_based(enum dm_queue_mode table_type)
@@ -929,8 +928,6 @@ bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
-
 static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
@@ -960,7 +957,6 @@ static int dm_table_determine_type(struct dm_table *t)
 			goto verify_bio_based;
 		}
 		BUG_ON(t->type == DM_TYPE_DAX_BIO_BASED);
-		BUG_ON(t->type == DM_TYPE_NVME_BIO_BASED);
 		goto verify_rq_based;
 	}
 
@@ -999,15 +995,6 @@ static int dm_table_determine_type(struct dm_table *t)
 		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
 		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
 			t->type = DM_TYPE_DAX_BIO_BASED;
-		} else {
-			/* Check if upgrading to NVMe bio-based is valid or required */
-			tgt = dm_table_get_immutable_target(t);
-			if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-				goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
-			} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-			}
 		}
 		return 0;
 	}
@@ -1024,8 +1011,7 @@ static int dm_table_determine_type(struct dm_table *t)
 	 * (e.g. request completion process for partial completion.)
 	 */
 	if (t->num_targets > 1) {
-		DMERR("%s DM doesn't support multiple targets",
-		      t->type == DM_TYPE_NVME_BIO_BASED ? "nvme bio-based" : "request-based");
+		DMERR("request-based DM doesn't support multiple targets");
 		return -EINVAL;
 	}
 
@@ -1714,20 +1700,6 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
-					sector_t start, sector_t len, void *data)
-{
-	char b[BDEVNAME_SIZE];
-
-	/* For now, NVMe devices are the only devices of this class */
-	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
-}
-
-static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
-{
-	return !dm_table_any_dev_attr(t, device_is_partial_completion, NULL);
-}
-
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
 					 sector_t start, sector_t len, void *data)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 37b8bb4d80f0..77e28f77c59f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1000,7 +1000,7 @@ static void clone_endio(struct bio *bio)
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
+	if (unlikely(error == BLK_STS_TARGET)) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
 		    !bio->bi_disk->queue->limits.max_discard_sectors)
 			disable_discard(md);
@@ -1325,7 +1325,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	sector = clone->bi_iter.bi_sector;
 
 	if (unlikely(swap_bios_limit(ti, clone))) {
-		struct mapped_device *md = io->md;
 		int latch = get_swap_bios();
 		if (unlikely(latch != md->swap_bios))
 			__set_swap_bios_limit(md, latch);
@@ -1340,24 +1339,17 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone->bi_disk->queue, clone,
 				      bio_dev(io->orig_bio), sector);
-		if (md->type == DM_TYPE_NVME_BIO_BASED)
-			ret = direct_make_request(clone);
-		else
-			ret = generic_make_request(clone);
+		ret = generic_make_request(clone);
 		break;
 	case DM_MAPIO_KILL:
-		if (unlikely(swap_bios_limit(ti, clone))) {
-			struct mapped_device *md = io->md;
+		if (unlikely(swap_bios_limit(ti, clone)))
 			up(&md->swap_bios_semaphore);
-		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
-		if (unlikely(swap_bios_limit(ti, clone))) {
-			struct mapped_device *md = io->md;
+		if (unlikely(swap_bios_limit(ti, clone)))
 			up(&md->swap_bios_semaphore);
-		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
@@ -1732,51 +1724,6 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 	return ret;
 }
 
-/*
- * Optimized variant of __split_and_process_bio that leverages the
- * fact that targets that use it do _not_ have a need to split bios.
- */
-static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
-			      struct bio *bio, struct dm_target *ti)
-{
-	struct clone_info ci;
-	blk_qc_t ret = BLK_QC_T_NONE;
-	int error = 0;
-
-	init_clone_info(&ci, md, map, bio);
-
-	if (bio->bi_opf & REQ_PREFLUSH) {
-		struct bio flush_bio;
-
-		/*
-		 * Use an on-stack bio for this, it's safe since we don't
-		 * need to reference it after submit. It's just used as
-		 * the basis for the clone(s).
-		 */
-		bio_init(&flush_bio, NULL, 0);
-		flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
-		ci.bio = &flush_bio;
-		ci.sector_count = 0;
-		error = __send_empty_flush(&ci);
-		bio_uninit(ci.bio);
-		/* dec_pending submits any data associated with flush */
-	} else {
-		struct dm_target_io *tio;
-
-		ci.bio = bio;
-		ci.sector_count = bio_sectors(bio);
-		if (__process_abnormal_io(&ci, ti, &error))
-			goto out;
-
-		tio = alloc_tio(&ci, ti, 0, GFP_NOIO);
-		ret = __clone_and_map_simple_bio(&ci, tio, NULL);
-	}
-out:
-	/* drop the extra reference count */
-	dec_pending(ci.io, errno_to_blk_status(error));
-	return ret;
-}
-
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
@@ -1807,8 +1754,6 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 		/* regular IO is split by __split_and_process_bio */
 	}
 
-	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
-		return __process_bio(md, map, bio, ti);
 	return __split_and_process_bio(md, map, bio);
 }
 
@@ -2200,12 +2145,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (request_based)
 		dm_stop_queue(q);
 
-	if (request_based || md->type == DM_TYPE_NVME_BIO_BASED) {
+	if (request_based) {
 		/*
-		 * Leverage the fact that request-based DM targets and
-		 * NVMe bio based targets are immutable singletons
-		 * - used to optimize both dm_request_fn and dm_mq_queue_rq;
-		 *   and __process_bio.
+		 * Leverage the fact that request-based DM targets are
+		 * immutable singletons - used to optimize dm_mq_queue_rq.
 		 */
 		md->immutable_target = dm_table_get_immutable_target(t);
 	}
@@ -2334,7 +2277,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_congested_fn(md);
 		break;
 	case DM_TYPE_NONE:
@@ -3070,7 +3012,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-	case DM_TYPE_NVME_BIO_BASED:
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a53d7d2c2d95..60631f3abddb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -28,7 +28,6 @@ enum dm_queue_mode {
 	DM_TYPE_BIO_BASED	 = 1,
 	DM_TYPE_REQUEST_BASED	 = 2,
 	DM_TYPE_DAX_BIO_BASED	 = 3,
-	DM_TYPE_NVME_BIO_BASED	 = 4,
 };
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
-- 
2.30.0

