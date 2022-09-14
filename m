Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9992D5B9097
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 00:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiINWqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 18:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiINWqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 18:46:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC8E49B64;
        Wed, 14 Sep 2022 15:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E473B81CEC;
        Wed, 14 Sep 2022 22:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6906C433C1;
        Wed, 14 Sep 2022 22:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195596;
        bh=bD5ruwgJxvlbGRkNa20Zold49Biv1UOXXwJ2vSeRDCI=;
        h=Date:To:From:Subject:From;
        b=pUaDbUkFmpuyMrUN5/00dxFIhd+GOueg4iUIMZWTpWd0cesBKlz14aO3g3VrvfCyf
         zQz2rCGim5YlO1MrBbcCFXKrYiMyVVKBZaFrcAmLwbpkvQQodP5IakWw4cAPcjybSy
         LuhoteQTncx+IbmUk5587dNLe9r3YL4y/9FhHlNo=
Date:   Wed, 14 Sep 2022 15:46:35 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        opendmb@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-fix-isolate_single_pageblock-isolation-behavior.patch added to mm-hotfixes-unstable branch
Message-Id: <20220914224635.E6906C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix isolate_single_pageblock() isolation behavior
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_isolation-fix-isolate_single_pageblock-isolation-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-fix-isolate_single_pageblock-isolation-behavior.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_isolation: fix isolate_single_pageblock() isolation behavior
Date: Tue, 13 Sep 2022 22:39:13 -0400

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
---

 mm/page_isolation.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-fix-isolate_single_pageblock-isolation-behavior
+++ a/mm/page_isolation.c
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
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-fix-isolate_single_pageblock-isolation-behavior.patch

