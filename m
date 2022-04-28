Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18555138DD
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbiD1Pq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349520AbiD1PqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9372B821A;
        Thu, 28 Apr 2022 08:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A5262010;
        Thu, 28 Apr 2022 15:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF52C385AE;
        Thu, 28 Apr 2022 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160581;
        bh=uBhpMoiEbz/kzy6AX3rpsSw0CWwU7xwTlMeypxaO5Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxkkCEAAWJoTphppzHibkcxUM81IURKMlKh3LYBQkIr+Mn7JeWIL+fLC08TLib+HZ
         LpQt9ptXPtjFwKApX6HukTOWXquSUqV0D0eeIeZjbfamW2wITFjq7c7HMGdyVYYdNh
         VzvPyu8kGK2CowpYFCOXtfvUY5cI32P2pEYfLQhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Aaron Lu <aaron.lu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 07/14] mm/page_alloc: fetch the correct pcp buddy during bulk free
Date:   Thu, 28 Apr 2022 17:42:15 +0200
Message-Id: <20220428154222.1230793-7-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3124; i=gregkh@linuxfoundation.org; h=from:subject; bh=tCOXBoUo5NxQepLUpCqvv6otafb9oNj1S1MmG8sm4mw=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8efZNz48WD91FnTyqYi+YEL07d4rHs3UYJaV+966H5 Bxde6YhlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICJpK5gmB/04G/zEu+3uUs9PzIJPS 1qfW3X/othnpriz49rzNUUXN+GcV88sNXiuaHaLwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit ca7b59b1de72450b3e696bada3506a519ac5455c upstream.

Patch series "Follow-up on high-order PCP caching", v2.

Commit 44042b449872 ("mm/page_alloc: allow high-order pages to be stored
on the per-cpu lists") was primarily aimed at reducing the cost of SLUB
cache refills of high-order pages in two ways.  Firstly, zone lock
acquisitions was reduced and secondly, there were fewer buddy list
modifications.  This is a follow-up series fixing some issues that
became apparant after merging.

Patch 1 is a functional fix.  It's harmless but inefficient.

Patches 2-5 reduce the overhead of bulk freeing of PCP pages.  While the
overhead is small, it's cumulative and noticable when truncating large
files.  The changelog for patch 4 includes results of a microbench that
deletes large sparse files with data in page cache.  Sparse files were
used to eliminate filesystem overhead.

Patch 6 addresses issues with high-order PCP pages being stored on PCP
lists for too long.  Pages freed on a CPU potentially may not be quickly
reused and in some cases this can increase cache miss rates.  Details
are included in the changelog.

This patch (of 6):

free_pcppages_bulk() prefetches buddies about to be freed but the order
must also be passed in as PCP lists store multiple orders.

Link: https://lkml.kernel.org/r/20220217002227.5739-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20220217002227.5739-2-mgorman@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e6f211dcf82e..b2ef0e75fd29 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1432,10 +1432,10 @@ static bool bulkfree_pcp_prepare(struct page *page)
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline void prefetch_buddy(struct page *page)
+static inline void prefetch_buddy(struct page *page, unsigned int order)
 {
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long buddy_pfn = __find_buddy_pfn(pfn, 0);
+	unsigned long buddy_pfn = __find_buddy_pfn(pfn, order);
 	struct page *buddy = page + (buddy_pfn - pfn);
 
 	prefetch(buddy);
@@ -1512,7 +1512,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			 * prefetch buddy for the first pcp->batch nr of pages.
 			 */
 			if (prefetch_nr) {
-				prefetch_buddy(page);
+				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
 		} while (count > 0 && --batch_free && !list_empty(list));
-- 
2.36.0

