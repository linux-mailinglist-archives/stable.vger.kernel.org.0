Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D149F5CBE7
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfGBICy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfGBICy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A9121479;
        Tue,  2 Jul 2019 08:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054573;
        bh=RaKKqX569LuBgmaHBLPgIetwk+japE1Civy0m2rrXQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRG3rsI1i5DHovFfmjjqp6lNOKAoSrt7Tz8wDfZ/+h3d/TlJMHbDmie33cgQj5Fob
         XS1r10H1rwUwegk09Z91GtvzeZ1qBGoD00BQlv3fpkpJ7r/nPqyFJ/vjbY2/YqkhAp
         O2RAes+ibepIzQSK1Pf44zVz/sKEZm3FHHuPHz4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Ming Lei <ming.lei@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 16/55] mm, swap: fix THP swap out
Date:   Tue,  2 Jul 2019 10:01:24 +0200
Message-Id: <20190702080124.884746006@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

commit 1a5f439c7c02837d943e528d46501564d4226757 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_io.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/page_io.c
+++ b/mm/page_io.c
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


