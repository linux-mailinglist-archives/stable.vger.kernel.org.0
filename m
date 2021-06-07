Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D031739E786
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 21:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhFGTgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 15:36:00 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57162 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhFGTgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 15:36:00 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id A309520B83D0; Mon,  7 Jun 2021 12:34:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A309520B83D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1623094448;
        bh=VpnHUDEF9AccYFVvo2kPdN3Gw49CLQLaBsY8vvbjUiE=;
        h=From:To:Cc:Subject:Date:From;
        b=h5kY0IfDu/+yWnaNaPR06Olpy3SnlNiBe8Z3xnHkElkxK+AeXv96uQkybYBy/evCq
         t41YBxDCKP353h1RxPB+wBWMrQo+Hdz22+nPGX1OIoNqgPM+lovPm+dbdxAR+2PPFc
         rUor92gL2HyqnyW4b0CTQnBCRP0F0/YiDp2d5gVM=
From:   longli@linuxonhyperv.com
To:     linux-block@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [Patch v3] block: return the correct bvec when checking for gaps
Date:   Mon,  7 Jun 2021 12:34:05 -0700
Message-Id: <1623094445-22332-1-git-send-email-longli@linuxonhyperv.com>
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
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
Changes
v2: added commit details on how data corruption happens
v3: reorganized the code/comments in bio_get_last_bvec

 include/linux/bio.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index a0b4cfdf62a4..d2b98efb5cc5 100644
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
@@ -279,10 +276,9 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
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
 
-- 
2.17.1

