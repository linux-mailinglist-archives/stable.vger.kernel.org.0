Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2139AE20
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 00:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhFCWgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 18:36:23 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45084 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFCWgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 18:36:23 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id D156720B7178; Thu,  3 Jun 2021 15:34:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D156720B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1622759677;
        bh=ioJUhKY3qUUCcIYsL/pASNHo0JgYm1RtNDDEZtn4LcE=;
        h=From:To:Cc:Subject:Date:From;
        b=Smx2IERIahuvzgohQwukrweRT+oaysrzB8dtE7ka8qlaOK1DpSAB1V13t7CLt/fZO
         zwdcD0tAaKrUkgMrG7b+B8Hxrxq0QBEa28kHaaRoFCYyI285rVcqHjMBj3gFcoEohx
         bWT61YpXadv5i3bxTtuRE6xn3RNTmRSZJirVSuh8=
From:   longli@linuxonhyperv.com
To:     linux-block@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] block: return the correct bvec when checking for gaps
Date:   Thu,  3 Jun 2021 15:34:31 -0700
Message-Id: <1622759671-14059-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
have multiple pages. But bio_will_gap() still assumes one page bvec while
checking for merging. This causes data corruption on drivers relying on
the correct merging on virt_boundary_mask.

Fix this by returning the multi-page bvec for testing gaps for merging.

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

