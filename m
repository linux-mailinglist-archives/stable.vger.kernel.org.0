Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653F63C5073
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbhGLHc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345239AbhGLH3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29CE161874;
        Mon, 12 Jul 2021 07:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074775;
        bh=edKrVGmtiLVtj8iw48kFwlqYYfAz+bZy2sTnQGqvPUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSqz9e8fo7WA5vR8ec+hACBMtZU5DEBtq2V2CUwYa3lk7xAFcK0EAGvCwGfqKs/px
         wz5lp3WGVEsWfXGRxsuenybp5UGPukYLPjoYmQlgVsvdaN977jnA8P3Qz/krosHb6O
         qdhbzsD9h2D89lZBO+xHzwK8zR7dqrRZxbHqfGWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Long Li <longli@microsoft.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.12 693/700] block: return the correct bvec when checking for gaps
Date:   Mon, 12 Jul 2021 08:12:56 +0200
Message-Id: <20210712061049.664586571@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit c9c9762d4d44dcb1b2ba90cfb4122dc11ceebf31 upstream.

After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
have multiple pages. But bio_will_gap() still assumes one page bvec while
checking for merging. If the pages in the bvec go across the
seg_boundary_mask, this check for merging can potentially succeed if only
the 1st page is tested, and can fail if all the pages are tested.

Later, when SCSI builds the SG list the same check for merging is done in
__blk_segment_map_sg_merge() with all the pages in the bvec tested. This
time the check may fail if the pages in bvec go across the
seg_boundary_mask (but tested okay in bio_will_gap() earlier, so those
BIOs were merged). If this check fails, we end up with a broken SG list
for drivers assuming the SG list not having offsets in intermediate pages.
This results in incorrect pages written to the disk.

Fix this by returning the multi-page bvec when testing gaps for merging.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 07173c3ec276 ("block: enable multipage bvecs")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/1623094445-22332-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bio.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,9 +44,6 @@ static inline unsigned int bio_max_segs(
 #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
 #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
-#define bio_multiple_segments(bio)				\
-	((bio)->bi_iter.bi_size != bio_iovec(bio).bv_len)
-
 #define bvec_iter_sectors(iter)	((iter).bi_size >> 9)
 #define bvec_iter_end_sector(iter) ((iter).bi_sector + bvec_iter_sectors((iter)))
 
@@ -271,7 +268,7 @@ static inline void bio_clear_flag(struct
 
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
-	*bv = bio_iovec(bio);
+	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
 }
 
 static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
@@ -279,10 +276,9 @@ static inline void bio_get_last_bvec(str
 	struct bvec_iter iter = bio->bi_iter;
 	int idx;
 
-	if (unlikely(!bio_multiple_segments(bio))) {
-		*bv = bio_iovec(bio);
-		return;
-	}
+	bio_get_first_bvec(bio, bv);
+	if (bv->bv_len == bio->bi_iter.bi_size)
+		return;		/* this bio only has a single bvec */
 
 	bio_advance_iter(bio, &iter, iter.bi_size);
 


