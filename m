Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBAC63E3AE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiK3Wvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiK3Wvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87248DBDD;
        Wed, 30 Nov 2022 14:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764CC61E24;
        Wed, 30 Nov 2022 22:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB7C433D6;
        Wed, 30 Nov 2022 22:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848704;
        bh=C6yc2I/Z5dK+xg99xOiBxsZOa4EKllMzkLpwAR48VU0=;
        h=Date:To:From:Subject:From;
        b=0y93BRA1miXPt0E1rPxSB9MTYYyxITK38n5lzfbxj+lkusgsYvCrWn3Zr5EPYmZSN
         mz3P1fOD76tsogwQHz1uICXUX1XS4nhAqIRs7Y0P3LzlGzAnC9gnN6AzhMVFRRo+7M
         Mkel7ph5fOTNXbKt2XoUeVrPNWmPoqGfkO1Z8umY=
Date:   Wed, 30 Nov 2022 14:51:44 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, zhenyzha@redhat.com,
        willy@infradead.org, william.kucharski@oracle.com,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        gshan@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-thps-mapcount-on-isolation.patch removed from -mm tree
Message-Id: <20221130225144.CADB7C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: fix THP's mapcount on isolation
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-thps-mapcount-on-isolation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm: migrate: fix THP's mapcount on isolation
Date: Thu, 24 Nov 2022 17:55:23 +0800

The issue is reported when removing memory through virtio_mem device.  The
transparent huge page, experienced copy-on-write fault, is wrongly
regarded as pinned.  The transparent huge page is escaped from being
isolated in isolate_migratepages_block().  The transparent huge page can't
be migrated and the corresponding memory block can't be put into offline
state.

Fix it by replacing page_mapcount() with total_mapcount().  With this, the
transparent huge page can be isolated and migrated, and the memory block
can be put into offline state.  Besides, The page's refcount is increased
a bit earlier to avoid the page is released when the check is executed.

Link: https://lkml.kernel.org/r/20221124095523.31061-1-gshan@redhat.com
Fixes: 1da2f328fa64 ("mm,thp,compaction,cma: allow THP migration for CMA allocations")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Tested-by: Zhenyu Zhang <zhenyzha@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>	[5.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/compaction.c~mm-migrate-fix-thps-mapcount-on-isolation
+++ a/mm/compaction.c
@@ -985,28 +985,28 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
+		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
 		mapping = page_mapping(page);
-		if (!mapping && page_count(page) > page_mapcount(page))
-			goto isolate_fail;
+		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+			goto isolate_fail_put;
 
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
 		 */
 		if (!(cc->gfp_mask & __GFP_FS) && mapping)
-			goto isolate_fail;
-
-		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		if (unlikely(!get_page_unless_zero(page)))
-			goto isolate_fail;
+			goto isolate_fail_put;
 
 		/* Only take pages on LRU: a check now makes later tests safe */
 		if (!PageLRU(page))
_

Patches currently in -mm which might be from gshan@redhat.com are


