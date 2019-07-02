Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB38D5CB31
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfGBIJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbfGBIJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F03C206A2;
        Tue,  2 Jul 2019 08:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054969;
        bh=3gW9ZjiU8utGDj75DA2lbQz8zKSXQmmL5BoOTTOKORc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWZfNfRjR50VO5zyZpv/nT3uxH2wJurq9xBUgHWjNc88UqRckJP2H2cZ1QQdLEmok
         m6ORLdhWaOcwvRH65kmRiwFka7Q70kZCUuOycicEk2ZoRctofS3MBwGrgjapN8GU11
         3Atg0bOZcdPDO7lM4VfiuGgnjypFx2Xryyn5g+1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/43] block: add a lower-level bio_add_page interface
Date:   Tue,  2 Jul 2019 10:01:46 +0200
Message-Id: <20190702080124.186376743@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0aa69fd32a5f766e997ca8ab4723c5a1146efa8b ]

For the upcoming removal of buffer heads in XFS we need to keep track of
the number of outstanding writeback requests per page.  For this we need
to know if bio_add_page merged a region with the previous bvec or not.
Instead of adding additional arguments this refactors bio_add_page to
be implemented using three lower level helpers which users like XFS can
use directly if they care about the merge decisions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c         | 96 +++++++++++++++++++++++++++++----------------
 include/linux/bio.h |  9 +++++
 2 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d01ab919b313..c1386ce2c014 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -773,7 +773,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 			return 0;
 	}
 
-	if (bio->bi_vcnt >= bio->bi_max_vecs)
+	if (bio_full(bio))
 		return 0;
 
 	/*
@@ -821,52 +821,82 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
- *	bio_add_page	-	attempt to add page to bio
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
+ * __bio_try_merge_page - try appending data to an existing bvec.
+ * @bio: destination bio
+ * @page: page to add
+ * @len: length of the data to add
+ * @off: offset of the data in @page
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
- *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ * Try to add the data at @page + @off to the last bvec of @bio.  This is a
+ * a useful optimisation for file systems with a block size smaller than the
+ * page size.
+ *
+ * Return %true on success or %false on failure.
  */
-int bio_add_page(struct bio *bio, struct page *page,
-		 unsigned int len, unsigned int offset)
+bool __bio_try_merge_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off)
 {
-	struct bio_vec *bv;
-
-	/*
-	 * cloned bio must not modify vec list
-	 */
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
-		return 0;
+		return false;
 
-	/*
-	 * For filesystems with a blocksize smaller than the pagesize
-	 * we will often be called with the same page as last time and
-	 * a consecutive offset.  Optimize this special case.
-	 */
 	if (bio->bi_vcnt > 0) {
-		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page &&
-		    offset == bv->bv_offset + bv->bv_len) {
+		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
 			bv->bv_len += len;
-			goto done;
+			bio->bi_iter.bi_size += len;
+			return true;
 		}
 	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
-	if (bio->bi_vcnt >= bio->bi_max_vecs)
-		return 0;
+/**
+ * __bio_add_page - add page to a bio in a new segment
+ * @bio: destination bio
+ * @page: page to add
+ * @len: length of the data to add
+ * @off: offset of the data in @page
+ *
+ * Add the data at @page + @off to @bio as a new bvec.  The caller must ensure
+ * that @bio has space for another bvec.
+ */
+void __bio_add_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off)
+{
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
-	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bv->bv_page	= page;
-	bv->bv_len	= len;
-	bv->bv_offset	= offset;
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
+	WARN_ON_ONCE(bio_full(bio));
+
+	bv->bv_page = page;
+	bv->bv_offset = off;
+	bv->bv_len = len;
 
-	bio->bi_vcnt++;
-done:
 	bio->bi_iter.bi_size += len;
+	bio->bi_vcnt++;
+}
+EXPORT_SYMBOL_GPL(__bio_add_page);
+
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This will only fail
+ *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
+{
+	if (!__bio_try_merge_page(bio, page, len, offset)) {
+		if (bio_full(bio))
+			return 0;
+		__bio_add_page(bio, page, len, offset);
+	}
 	return len;
 }
 EXPORT_SYMBOL(bio_add_page);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d4b39caf081d..e260f000b9ac 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -123,6 +123,11 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
+static inline bool bio_full(struct bio *bio)
+{
+	return bio->bi_vcnt >= bio->bi_max_vecs;
+}
+
 /*
  * will die
  */
@@ -459,6 +464,10 @@ void bio_chain(struct bio *, struct bio *);
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
+bool __bio_try_merge_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off);
+void __bio_add_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-- 
2.20.1



