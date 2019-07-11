Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07F5655D2
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfGKLgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:36:01 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35795 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbfGKLgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:36:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3EB9840A;
        Thu, 11 Jul 2019 07:36:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=g22hPD
        lKuuoefN3WmdM6qVbGqekDmCFsZXG9QALv72I=; b=UKm6S9hixrdUdV5nN4e4aZ
        JzDjNBwf2A2eIVsAG586FqHPeDIo2yX6IXHiCgr9eEj29/m6r/hERJiwjL+qFBtK
        QS2FCeuwn0N4H2cOO9NeANbVRuKJXpLMO4+1+i7J/P+nT/8Yh8uBDsTWJpGjgk3N
        aZSFrSXmpJsLdkWqXad7Tprlz4Vhrh4rMNIE7Ir1BOtPQf1+mJi7SlY2cEezRQIb
        fzBiFVs0WcNKZyZJaH/vKlFPWXyb7hIVx05puML+FuBSBYcDY7xZKJk8pnKcX+yN
        OrJdUw8ndqIV1v/aIAfi1XBMiMDbllBBHL/VvHbVz8AxNHtvprAH43VjA9CZT96Q
        ==
X-ME-Sender: <xms:Hh8nXdw4YFFj9oDZ-JodGkVDQyVXnfIyMFw5N58v9qOESI7TYzyZNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Hh8nXc-fWNUv6v2HHRhnUPhiRvojrpD_3Io5RVArV0hUSGgxVnM88A>
    <xmx:Hh8nXS-LnK39dDhcgPkLfVHReNNBa1A78rcaY2Dpy7Ua7PYQUqZMcQ>
    <xmx:Hh8nXbXAVZnHR-CHoLvKaWWT-Aw4ozu3DP3_zUid_ePjCfo4s7eQHQ>
    <xmx:Hx8nXZAZVLnYruMsnznM8zVCuwEakSfQXeunJEygFiBmclahGT7zyA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64C4B380076;
        Thu, 11 Jul 2019 07:35:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: fix .bi_size overflow" failed to apply to 5.1-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, darrick.wong@oracle.com,
        hch@lst.de, liuyd.fnst@cn.fujitsu.com, rong.a.chen@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:35:56 +0200
Message-ID: <156284495617378@kroah.com>
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

From 79d08f89bb1b5c2c1ff90d9bb95497ab9e8aa7e0 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 1 Jul 2019 15:14:46 +0800
Subject: [PATCH] block: fix .bi_size overflow

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

diff --git a/block/bio.c b/block/bio.c
index 933c1e36643b..29cd6cf4da51 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -723,7 +723,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		}
 	}
 
-	if (bio_full(bio))
+	if (bio_full(bio, len))
 		return 0;
 
 	if (bio->bi_vcnt >= queue_max_segments(q))
@@ -797,7 +797,7 @@ void __bio_add_page(struct bio *bio, struct page *page,
 	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	WARN_ON_ONCE(bio_full(bio));
+	WARN_ON_ONCE(bio_full(bio, len));
 
 	bv->bv_page = page;
 	bv->bv_offset = off;
@@ -824,7 +824,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	bool same_page = false;
 
 	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		if (bio_full(bio))
+		if (bio_full(bio, len))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
 	}
@@ -909,7 +909,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio)))
+			if (WARN_ON_ONCE(bio_full(bio, len)))
                                 return -EINVAL;
 			__bio_add_page(bio, page, len, offset);
 		}
@@ -953,7 +953,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			ret = __bio_iov_bvec_add_pages(bio, iter);
 		else
 			ret = __bio_iov_iter_get_pages(bio, iter);
-	} while (!ret && iov_iter_count(iter) && !bio_full(bio));
+	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
 	if (is_bvec)
 		bio_set_flag(bio, BIO_NO_PAGE_REF);
diff --git a/fs/iomap.c b/fs/iomap.c
index 4f94788db43b..7a147aa0c4d9 100644
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
index dc630b05e6e5..3cdb84cdc488 100644
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

