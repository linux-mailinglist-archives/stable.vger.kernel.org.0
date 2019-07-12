Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0EF66E1C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfGLMcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbfGLMcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2E22166E;
        Fri, 12 Jul 2019 12:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934724;
        bh=Ehpl1vJOgxVSnX4bYZNqCygosiLCPAzhduos+K0Cvcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXrz1fTnt1KaEQMh+Q8Hn0NmD0OiJj+r/sOdGvV92qMZ1BMMj7G4zUuYvhtvnqr+3
         kS8VqdwUiqJ2XmdhvCC2o2w3vc4rj1AvQntNLW/jCyKnHvToIHNf6e/9x+8tJvqFW4
         6Td1m8OCjn2PT7kZgKXXKEFuaH38ZYF7ysjmE3Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 11/61] block: fix .bi_size overflow
Date:   Fri, 12 Jul 2019 14:19:24 +0200
Message-Id: <20190712121621.228131224@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 79d08f89bb1b5c2c1ff90d9bb95497ab9e8aa7e0 upstream.

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
Cc: stable@vger.kernel.org
Fixes: 07173c3ec276 ("block: enable multipage bvecs")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bio.c         |   10 +++++-----
 fs/iomap.c          |    2 +-
 fs/xfs/xfs_aops.c   |    2 +-
 include/linux/bio.h |   18 ++++++++++++++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -731,7 +731,7 @@ static int __bio_add_pc_page(struct requ
 		}
 	}
 
-	if (bio_full(bio))
+	if (bio_full(bio, len))
 		return 0;
 
 	if (bio->bi_phys_segments >= queue_max_segments(q))
@@ -807,7 +807,7 @@ void __bio_add_page(struct bio *bio, str
 	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	WARN_ON_ONCE(bio_full(bio));
+	WARN_ON_ONCE(bio_full(bio, len));
 
 	bv->bv_page = page;
 	bv->bv_offset = off;
@@ -834,7 +834,7 @@ int bio_add_page(struct bio *bio, struct
 	bool same_page = false;
 
 	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		if (bio_full(bio))
+		if (bio_full(bio, len))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
 	}
@@ -922,7 +922,7 @@ static int __bio_iov_iter_get_pages(stru
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio)))
+			if (WARN_ON_ONCE(bio_full(bio, len)))
                                 return -EINVAL;
 			__bio_add_page(bio, page, len, offset);
 		}
@@ -966,7 +966,7 @@ int bio_iov_iter_get_pages(struct bio *b
 			ret = __bio_iov_bvec_add_pages(bio, iter);
 		else
 			ret = __bio_iov_iter_get_pages(bio, iter);
-	} while (!ret && iov_iter_count(iter) && !bio_full(bio));
+	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
 	if (iov_iter_bvec_no_ref(iter))
 		bio_set_flag(bio, BIO_NO_PAGE_REF);
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -333,7 +333,7 @@ iomap_readpage_actor(struct inode *inode
 	if (iop)
 		atomic_inc(&iop->read_count);
 
-	if (!ctx->bio || !is_contig || bio_full(ctx->bio)) {
+	if (!ctx->bio || !is_contig || bio_full(ctx->bio, plen)) {
 		gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
 		int nr_vecs = (length + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
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
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -102,9 +102,23 @@ static inline void *bio_data(struct bio
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


