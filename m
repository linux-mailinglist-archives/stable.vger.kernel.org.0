Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E598F641629
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLCK4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 05:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLCK4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 05:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B16D6150
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 02:56:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EC1B80D3B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 10:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C093C433D6;
        Sat,  3 Dec 2022 10:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670064972;
        bh=I1V8cWmd1WN9QGEs9hOwN2f04SPBUveINEaG/kTput8=;
        h=Subject:To:Cc:From:Date:From;
        b=ve+B29sP5Ss6wzoFJ7pwVMezVrzOQnjzJbgHDgDFGzQPIuGJaVfYgfvPzgwop9NFj
         aCU1n9MvIQEM562j9WcIP00LDcZgsLFdB4HTkwwo5ANwbucMBRXd9la3SRWLtotofQ
         EiHPMvJgxotpUaNclALfuIhgOEfFB3Krvm4ipLFo=
Subject: FAILED: patch "[PATCH] mm: migrate: fix THP's mapcount on isolation" failed to apply to 5.15-stable tree
To:     gshan@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        david@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        zhenyzha@redhat.com, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 11:56:10 +0100
Message-ID: <167006497016598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
89f6c88a6ab4 ("mm: __isolate_lru_page_prepare() in isolate_migratepages_block()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 829ae0f81ce093d674ff2256f66a714753e9ce32 Mon Sep 17 00:00:00 2001
From: Gavin Shan <gshan@redhat.com>
Date: Thu, 24 Nov 2022 17:55:23 +0800
Subject: [PATCH] mm: migrate: fix THP's mapcount on isolation

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

diff --git a/mm/compaction.c b/mm/compaction.c
index c51f7f545afe..1f6da31dd9a5 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -984,29 +984,29 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			goto isolate_fail;
 		}
 
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
 		/*
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

