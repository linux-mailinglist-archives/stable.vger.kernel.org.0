Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486B039C3FA
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 01:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFDXjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 19:39:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37320 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhFDXjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 19:39:31 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 7715B20B7178; Fri,  4 Jun 2021 16:37:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7715B20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1622849864;
        bh=9AgMOut9eOMhw1jnVJ9dx1pxSUqfCv81iOy00nD3qiU=;
        h=From:To:Cc:Subject:Date:From;
        b=a6n3KyhhijQKNwk7KtIjkSBgGG9V6N95QOk9Bcq61/RdnhQWwWny9O+GJS4nRsEGG
         sQfMO8g5CQ4AOWmBNrJl+v1eaMOGcEH1FJVbiOlhN4NYOBWj6CTUcdqkL3VnUDLnlE
         x5Wq+rxTXepMbxS03BTMLOwP8DomK4a3NVgJhKaw=
From:   longli@linuxonhyperv.com
To:     linux-block@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [Patch v2] block: return the correct bvec when checking for gaps
Date:   Fri,  4 Jun 2021 16:37:19 -0700
Message-Id: <1622849839-5407-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

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
---
Change from v1: add commit details on how data corruption happens

 include/linux/bio.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index a0b4cfdf62a4..6b2f609ccfbf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,9 +44,6 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
 #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
 #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
-#define bio_multiple_segments(bio)				\
-	((bio)->bi_iter.bi_size != bio_iovec(bio).bv_len)
-
 #define bvec_iter_sectors(iter)	((iter).bi_size >> 9)
 #define bvec_iter_end_sector(iter) ((iter).bi_sector + bvec_iter_sectors((iter)))
 
@@ -271,7 +268,7 @@ static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
 
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
-	*bv = bio_iovec(bio);
+	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
 }
 
 static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
@@ -279,10 +276,10 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 	struct bvec_iter iter = bio->bi_iter;
 	int idx;
 
-	if (unlikely(!bio_multiple_segments(bio))) {
-		*bv = bio_iovec(bio);
+	/* this bio has only one bvec */
+	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	if (bv->bv_len == bio->bi_iter.bi_size)
 		return;
-	}
 
 	bio_advance_iter(bio, &iter, iter.bi_size);
 
-- 
2.17.1

