Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E982D6A5056
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 02:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjB1BA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 20:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB1BAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 20:00:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F75D298C5;
        Mon, 27 Feb 2023 17:00:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BB860F22;
        Tue, 28 Feb 2023 01:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAC0C433EF;
        Tue, 28 Feb 2023 01:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546051;
        bh=yvqQhrDdZcXLpGiZYmTQEkyl0wBKsmaGmR4ctm1ez1Y=;
        h=Date:To:From:Subject:From;
        b=SkNDZGJ8EyfK1AmrfSyVcVABYyfkws+J/wAzC9EqLaODeYsidStetwKq9MswWrYIM
         ORxSsO6lMItpNFZQM/22ZDjxm47qzIHhd5gabuWgM+aIPOyTi+bniV+gAwAD2FMY3r
         h+FSRXoyeM7TpXnvhhVpiUhH3PULEhfF7fVWikyw=
Date:   Mon, 27 Feb 2023 17:00:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, minchan@kernel.org, linmiaohe@huawei.com,
        hughd@google.com, david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hwpoison-convert-ttu_ignore_hwpoison-to-ttu_hwpoison.patch removed from -mm tree
Message-Id: <20230228010051.8EAC0C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-convert-ttu_ignore_hwpoison-to-ttu_hwpoison.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON
Date: Tue, 21 Feb 2023 17:59:05 +0900

After a memory error happens on a clean folio, a process unexpectedly
receives SIGBUS when it accesses the error page.  This SIGBUS killing is
pointless and simply degrades the level of RAS of the system, because the
clean folio can be dropped without any data lost on memory error handling
as we do for a clean pagecache.

When memory_failure() is called on a clean folio, try_to_unmap() is called
twice (one from split_huge_page() and one from hwpoison_user_mappings()). 
The root cause of the issue is that pte conversion to hwpoisoned entry is
now done in the first call of try_to_unmap() because PageHWPoison is
already set at this point, while it's actually expected to be done in the
second call.  This behavior disturbs the error handling operation like
removing pagecache, which results in the malfunction described above.

So convert TTU_IGNORE_HWPOISON into TTU_HWPOISON and set TTU_HWPOISON only
when we really intend to convert pte to hwpoison entry.  This can prevent
other callers of try_to_unmap() from accidentally converting to hwpoison
entries.

Link: https://lkml.kernel.org/r/20230221085905.1465385-1-naoya.horiguchi@linux.dev
Fixes: a42634a6c07d ("readahead: Use a folio in read_pages()")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/rmap.h~mm-hwpoison-convert-ttu_ignore_hwpoison-to-ttu_hwpoison
+++ a/include/linux/rmap.h
@@ -94,7 +94,7 @@ enum ttu_flags {
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
-	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
+	TTU_HWPOISON		= 0x20,	/* do convert pte to hwpoison entry */
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
 					 * do a final flush if necessary */
--- a/mm/memory-failure.c~mm-hwpoison-convert-ttu_ignore_hwpoison-to-ttu_hwpoison
+++ a/mm/memory-failure.c
@@ -1069,7 +1069,7 @@ static int me_pagecache_dirty(struct pag
  * cache and swap cache(ie. page is freshly swapped in). So it could be
  * referenced concurrently by 2 types of PTEs:
  * normal PTEs and swap PTEs. We try to handle them consistently by calling
- * try_to_unmap(TTU_IGNORE_HWPOISON) to convert the normal PTEs to swap PTEs,
+ * try_to_unmap(!TTU_HWPOISON) to convert the normal PTEs to swap PTEs,
  * and then
  *      - clear dirty bit to prevent IO
  *      - remove from LRU
@@ -1486,7 +1486,7 @@ static bool hwpoison_user_mappings(struc
 				  int flags, struct page *hpage)
 {
 	struct folio *folio = page_folio(hpage);
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
@@ -1516,7 +1516,7 @@ static bool hwpoison_user_mappings(struc
 
 	if (PageSwapCache(p)) {
 		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
-		ttu |= TTU_IGNORE_HWPOISON;
+		ttu &= ~TTU_HWPOISON;
 	}
 
 	/*
@@ -1531,7 +1531,7 @@ static bool hwpoison_user_mappings(struc
 		if (page_mkclean(hpage)) {
 			SetPageDirty(hpage);
 		} else {
-			ttu |= TTU_IGNORE_HWPOISON;
+			ttu &= ~TTU_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
 				pfn);
 		}
--- a/mm/rmap.c~mm-hwpoison-convert-ttu_ignore_hwpoison-to-ttu_hwpoison
+++ a/mm/rmap.c
@@ -1602,7 +1602,7 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


