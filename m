Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C1D5A4CB
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfF1THT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1THT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:07:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD85208E3;
        Fri, 28 Jun 2019 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748839;
        bh=kC6KtOMoCKomqvOsgRoDYnc+bRVyfMvaBNQSBfjyBSA=;
        h=Date:From:To:Subject:From;
        b=qonnQlOtgurh4Ijv4Ekdrq8G4divInhBzO7+ybRroxR0RAh8ELsf0+0WuUCN4o/CB
         T1SJFJ0hIv067Ul5DywUa0ZIfCej0OSlpOuG3sza4rmI5lgJVzUstPOIoxbsKPitgv
         p9NqZIPMrR5KN2DMXt173LUZeaCbBkS/NV/Z4G/I=
Date:   Fri, 28 Jun 2019 12:07:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, minchan@kernel.org, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, riel@redhat.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 14/15] mm, swap: fix THP swap out
Message-ID: <20190628190718.4lquOEXtk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: fix THP swap out

0-Day test system reported some OOM regressions for several THP
(Transparent Huge Page) swap test cases.  These regressions are bisected
to 6861428921b5 ("block: always define BIO_MAX_PAGES as 256").  In the
commit, BIO_MAX_PAGES is set to 256 even when THP swap is enabled.  So the
bio_alloc(gfp_flags, 512) in get_swap_bio() may fail when swapping out
THP.  That causes the OOM.

As in the patch description of 6861428921b5 ("block: always define
BIO_MAX_PAGES as 256"), THP swap should use multi-page bvec to write THP
to swap space.  So the issue is fixed via doing that in get_swap_bio().

BTW: I remember I have checked the THP swap code when 6861428921b5
("block: always define BIO_MAX_PAGES as 256") was merged, and thought the
THP swap code needn't to be changed.  But apparently, I was wrong.  I
should have done this at that time.

Link: http://lkml.kernel.org/r/20190624075515.31040-1-ying.huang@intel.com
Fixes: 6861428921b5 ("block: always define BIO_MAX_PAGES as 256")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-swap-fix-thp-swap-out
+++ a/mm/page_io.c
@@ -29,10 +29,9 @@
 static struct bio *get_swap_bio(gfp_t gfp_flags,
 				struct page *page, bio_end_io_t end_io)
 {
-	int i, nr = hpage_nr_pages(page);
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_flags, nr);
+	bio = bio_alloc(gfp_flags, 1);
 	if (bio) {
 		struct block_device *bdev;
 
@@ -41,9 +40,7 @@ static struct bio *get_swap_bio(gfp_t gf
 		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
-		for (i = 0; i < nr; i++)
-			bio_add_page(bio, page + i, PAGE_SIZE, 0);
-		VM_BUG_ON(bio->bi_iter.bi_size != PAGE_SIZE * nr);
+		bio_add_page(bio, page, PAGE_SIZE * hpage_nr_pages(page), 0);
 	}
 	return bio;
 }
_
