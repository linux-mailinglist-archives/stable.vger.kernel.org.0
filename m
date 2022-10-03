Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF935F2943
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJCHQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJCHQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC4D46215;
        Mon,  3 Oct 2022 00:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC7660F9B;
        Mon,  3 Oct 2022 07:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE65C433D6;
        Mon,  3 Oct 2022 07:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781213;
        bh=CFV5xLWV3169vW5q/lnpNP60a9I5FfoMfHFZB/0Ieto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZooN/h3+SV+2Cu71ynqw97zc8Ba6JPE3DjOPfGXe6fq/eRMMQBrbUu0aVt1NSWxsT
         j2la+3p+zFIZfZ83VZxYWgR8phDaH0/NO8QPJv4r9B389a4p7nVZl8oPWK2xWPy1CV
         8LSRa67hRxRNSi8pz6UFg/5YuBz7xqofPCI33mTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Doug Berger <opendmb@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 038/101] mm/page_isolation: fix isolate_single_pageblock() isolation behavior
Date:   Mon,  3 Oct 2022 09:10:34 +0200
Message-Id: <20221003070725.418906323@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

commit 80e2b584f3abfc31c3fe5573007f0d1d10810fde upstream.

set_migratetype_isolate() does not allow isolating MIGRATE_CMA pageblocks
unless it is used for CMA allocation.  isolate_single_pageblock() did not
have the same behavior when it is used together with
set_migratetype_isolate() in start_isolate_page_range().  This allows
alloc_contig_range() with migratetype other than MIGRATE_CMA, like
MIGRATE_MOVABLE (used by alloc_contig_pages()), to isolate first and last
pageblock but fail the rest.  The failure leads to changing migratetype of
the first and last pageblock to MIGRATE_MOVABLE from MIGRATE_CMA,
corrupting the CMA region.  This can happen during gigantic page
allocations.

Like Doug said here:
https://lore.kernel.org/linux-mm/a3363a52-883b-dcd1-b77f-f2bb378d6f2d@gmail.com/T/#u,
for gigantic page allocations, the user would notice no difference,
since the allocation on CMA region will fail as well as it did before.
But it might hurt the performance of device drivers that use CMA, since
CMA region size decreases.

Fix it by passing migratetype into isolate_single_pageblock(), so that
set_migratetype_isolate() used by isolate_single_pageblock() will prevent
the isolation happening.

Link: https://lkml.kernel.org/r/20220914023913.1855924-1-zi.yan@sent.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Doug Berger <opendmb@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_isolation.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -288,6 +288,7 @@ __first_valid_page(unsigned long pfn, un
  * @isolate_before:	isolate the pageblock before the boundary_pfn
  * @skip_isolation:	the flag to skip the pageblock isolation in second
  *			isolate_single_pageblock()
+ * @migratetype:	migrate type to set in error recovery.
  *
  * Free and in-use pages can be as big as MAX_ORDER-1 and contain more than one
  * pageblock. When not all pageblocks within a page are isolated at the same
@@ -302,9 +303,9 @@ __first_valid_page(unsigned long pfn, un
  * the in-use page then splitting the free page.
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
-			gfp_t gfp_flags, bool isolate_before, bool skip_isolation)
+			gfp_t gfp_flags, bool isolate_before, bool skip_isolation,
+			int migratetype)
 {
-	unsigned char saved_mt;
 	unsigned long start_pfn;
 	unsigned long isolate_pageblock;
 	unsigned long pfn;
@@ -328,13 +329,13 @@ static int isolate_single_pageblock(unsi
 	start_pfn  = max(ALIGN_DOWN(isolate_pageblock, MAX_ORDER_NR_PAGES),
 				      zone->zone_start_pfn);
 
-	saved_mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
+	if (skip_isolation) {
+		int mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
 
-	if (skip_isolation)
-		VM_BUG_ON(!is_migrate_isolate(saved_mt));
-	else {
-		ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt, flags,
-				isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
+		VM_BUG_ON(!is_migrate_isolate(mt));
+	} else {
+		ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype,
+				flags, isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
 
 		if (ret)
 			return ret;
@@ -475,7 +476,7 @@ static int isolate_single_pageblock(unsi
 failed:
 	/* restore the original migratetype */
 	if (!skip_isolation)
-		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt);
+		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype);
 	return -EBUSY;
 }
 
@@ -537,7 +538,8 @@ int start_isolate_page_range(unsigned lo
 	bool skip_isolation = false;
 
 	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock */
-	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false, skip_isolation);
+	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false,
+			skip_isolation, migratetype);
 	if (ret)
 		return ret;
 
@@ -545,7 +547,8 @@ int start_isolate_page_range(unsigned lo
 		skip_isolation = true;
 
 	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
-	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true, skip_isolation);
+	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true,
+			skip_isolation, migratetype);
 	if (ret) {
 		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
 		return ret;


