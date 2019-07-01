Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB25B59F
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 09:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfGAHPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 03:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfGAHPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 03:15:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89BA3308A9BE;
        Mon,  1 Jul 2019 07:15:11 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7CC1001B2E;
        Mon,  1 Jul 2019 07:14:53 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH V2] block: fix .bi_size overflow
Date:   Mon,  1 Jul 2019 15:14:46 +0800
Message-Id: <20190701071446.22028-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 01 Jul 2019 07:15:11 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
bytes.

Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
include very limited pages, and usually at most 256, so the fs bio
size won't be bigger than 1M bytes most of times.

Since we support multi-page bvec, in theory one fs bio really can
be added > 1M pages, especially in case of hugepage, or big writeback
with too many dirty pages. Then there is chance in which .bi_size
is overflowed.

Fixes this issue by using bio_full() to check if the added segment may
overflow .bi_size.

Cc: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Fixes: 07173c3ec276 ("block: enable multipage bvecs")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 10 +++++-----
 fs/iomap.c          |  2 +-
 fs/xfs/xfs_aops.c   |  2 +-
 include/linux/bio.h | 18 ++++++++++++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ce797d73bb43..67bba12d273b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -731,7 +731,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		}
 	}
 
-	if (bio_full(bio))
+	if (bio_full(bio, len))
 		return 0;
 
 	if (bio->bi_phys_segments >= queue_max_segments(q))
@@ -807,7 +807,7 @@ void __bio_add_page(struct bio *bio, struct page *page,
 	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	WARN_ON_ONCE(bio_full(bio));
+	WARN_ON_ONCE(bio_full(bio, len));
 
 	bv->bv_page = page;
 	bv->bv_offset = off;
@@ -834,7 +834,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	bool same_page = false;
 
 	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		if (bio_full(bio))
+		if (bio_full(bio, len))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
 	}
@@ -922,7 +922,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio)))
+			if (WARN_ON_ONCE(bio_full(bio, len)))
                                 return -EINVAL;
 			__bio_add_page(bio, page, len, offset);
 		}
@@ -966,7 +966,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			ret = __bio_iov_bvec_add_pages(bio, iter);
 		else
 			ret = __bio_iov_iter_get_pages(bio, iter);
-	} while (!ret && iov_iter_count(iter) && !bio_full(bio));
+	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
 	if (iov_iter_bvec_no_ref(iter))
 		bio_set_flag(bio, BIO_NO_PAGE_REF);
diff --git a/fs/iomap.c b/fs/iomap.c
index 12654c2e78f8..da961fca3180 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -333,7 +333,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	if (iop)
 		atomic_inc(&iop->read_count);
 
-	if (!ctx->bio || !is_contig || bio_full(ctx->bio)) {
+	if (!ctx->bio || !is_contig || bio_full(ctx->bio, plen)) {
 		gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
 		int nr_vecs = (length + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8da5e6637771..11f703d4a605 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -782,7 +782,7 @@ xfs_add_to_ioend(
 		atomic_inc(&iop->write_count);
 
 	if (!merged) {
-		if (bio_full(wpc->ioend->io_bio))
+		if (bio_full(wpc->ioend->io_bio, len))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
 		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f87abaa898f0..e36b8fc1b1c3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -102,9 +102,23 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
-static inline bool bio_full(struct bio *bio)
+/**
+ * bio_full - check if the bio is full
+ * @bio:	bio to check
+ * @len:	length of one segment to be added
+ *
+ * Return true if @bio is full and one segment with @len bytes can't be
+ * added to the bio, otherwise return false
+ */
+static inline bool bio_full(struct bio *bio, unsigned len)
 {
-	return bio->bi_vcnt >= bio->bi_max_vecs;
+	if (bio->bi_vcnt >= bio->bi_max_vecs)
+		return true;
+
+	if (bio->bi_iter.bi_size > UINT_MAX - len)
+		return true;
+
+	return false;
 }
 
 static inline bool bio_next_segment(const struct bio *bio,
-- 
2.20.1

