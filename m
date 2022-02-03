Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35E44A9080
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 23:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355698AbiBCWMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 17:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiBCWM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 17:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAA8C061714;
        Thu,  3 Feb 2022 14:12:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C76EB835E2;
        Thu,  3 Feb 2022 22:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C8C340E8;
        Thu,  3 Feb 2022 22:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926346;
        bh=revw8UU7WFNKrOaFkz6WeTO23/dbXftr0dSdennufEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nsH11JP3yUbjj2MS/VR9+/Dq9JnXhVensr12oyT0HBBQDSJlQRFFcwcYNLD5wQUR3
         ZPPo2yeT3VvLOa+lzwyRTsjjDVdeYbgQHp0MzwRRSZVqdSFmsOkl1FifJGRgPNIHlE
         oMVWanLVkSnb2E9aesTO468MS19Iy4YrEWdw3KTs=
Date:   Thu, 3 Feb 2022 14:12:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, david@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for
 migration entry
Message-Id: <20220203141226.d510a9fe3fb1f55fc75926e5@linux-foundation.org>
In-Reply-To: <20220203182641.824731-1-shy828301@gmail.com>
References: <20220203182641.824731-1-shy828301@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  3 Feb 2022 10:26:41 -0800 Yang Shi <shy828301@gmail.com> wrote:

> v4: * s/Treated/Treat per David
>     * Collected acked-by tag from David
> v3: * Fixed the fix tag, the one used by v2 was not accurate
>     * Added comment about the risk calling page_mapcount() per David
>     * Fix pagemap
> v2: * Added proper fix tag per Jann Horn
>     * Rebased to the latest linus's tree

The v2->v4 delta shows changes which aren't described above?

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry-v4
+++ a/fs/proc/task_mmu.c
@@ -469,9 +469,12 @@ static void smaps_account(struct mem_siz
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
 	 *
-	 * Treated regular migration entries as mapcount == 1 without reading
-	 * mapcount since calling page_mapcount() for migration entries is
-	 * racy against THP splitting.
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the page lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.  It is not safe to
+	 * call page_mapcount() even with PTL held if the page is not mapped,
+	 * especially for migration entries.  Treat regular migration entries
+	 * as mapcount == 1.
 	 */
 	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
@@ -1393,6 +1396,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1414,13 +1418,14 @@ static pagemap_entry_t pte_to_pagemap_en
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
+		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1436,6 +1441,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+	bool migration = false;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
@@ -1476,11 +1482,12 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
-		if (page && page_mapcount(page) == 1)
+		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
_

