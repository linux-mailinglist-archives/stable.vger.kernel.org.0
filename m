Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4950D5C59F
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfGAWXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 18:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfGAWXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 18:23:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A7020B7C;
        Mon,  1 Jul 2019 22:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562019803;
        bh=O598iM2HcgszPBtH+mZAgbh9IOql2LNGTuowFBIlw70=;
        h=Date:From:To:Subject:From;
        b=BU2Sh3VclxJipL6981r+//Jtjge58zhp2xNFBGUDXjAMhwS5GcJcXOYySZJSL5/PB
         PkgjSXf7O2AoFZfCj0DK66WU3nZw4+DqPEcIa49Gmk8NCgE/zHCWh2/zhKX4nvfeAB
         A48bgWwvujcV2g8GHGAyH+CFvTifA9Shxye+kAEA=
Date:   Mon, 01 Jul 2019 15:23:22 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, daniel.m.jordan@oracle.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, minchan@kernel.org,
        ming.lei@redhat.com, mm-commits@vger.kernel.org, riel@redhat.com,
        stable@vger.kernel.org, ying.huang@intel.com
Subject:  [merged] mm-swap-fix-thp-swap-out.patch removed from -mm
 tree
Message-ID: <20190701222322.xaZkXw9R4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, swap: fix THP swap out
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-thp-swap-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch
mm-swap-simplify-total_swapcache_pages-with-get_swap_device.patch
mm-swap-simplify-total_swapcache_pages-with-get_swap_device-fix.patch
mm-fix-race-between-swapoff-and-mincore.patch

