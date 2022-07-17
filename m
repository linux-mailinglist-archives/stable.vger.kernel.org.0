Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E002577450
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 06:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiGQEiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiGQEiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 00:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33DA222AA;
        Sat, 16 Jul 2022 21:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43C1D60FB7;
        Sun, 17 Jul 2022 04:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F71C3411E;
        Sun, 17 Jul 2022 04:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032677;
        bh=w7nmCRFqx2yBAH87L43ECJb9YZ7WwX0Ml8KLEeNmzBg=;
        h=Date:To:From:Subject:From;
        b=LONSerodxHeTpfxS6Oq8gaFdvNz9kbHVx+TRyRuE/BD01Bd9k0gAcuAFZAYSECJsZ
         5nGXk4ricP+GbOaGTrRVTXwjwKFjMUaQjoB+n+wvccHqBMxjb5sjAk3J5qHIwGFQqs
         S2/0LZ3Nff8c2fY6r6gy2OTqN6J+RMMY8zca/UYk=
Date:   Sat, 16 Jul 2022 21:37:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, stable@vger.kernel.org,
        jhubbard@nvidia.com, jgg@ziepe.ca, jack@suse.cz,
        dan.j.williams@intel.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-missing-wake-up-event-for-fsdax-pages.patch removed from -mm tree
Message-Id: <20220717043757.98F71C3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: fix missing wake-up event for FSDAX pages
has been removed from the -mm tree.  Its filename was
     mm-fix-missing-wake-up-event-for-fsdax-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: fix missing wake-up event for FSDAX pages
Date: Tue, 5 Jul 2022 20:35:32 +0800

FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
1, then the page is freed.  The FSDAX pages can be pinned through GUP,
then they will be unpinned via unpin_user_page() using a folio variant
to put the page, however, folio variants did not consider this special
case, the result will be to miss a wakeup event (like the user of
__fuse_dax_break_layouts()).  This results in a task being permanently
stuck in TASK_INTERRUPTIBLE state.

Since FSDAX pages are only possibly obtained by GUP users, so fix GUP
instead of folio_put() to lower overhead.

Link: https://lkml.kernel.org/r/20220705123532.283-1-songmuchun@bytedance.com
Fixes: d8ddc099c6b3 ("mm/gup: Add gup_put_folio()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 +++++++++-----
 mm/gup.c           |    6 ++++--
 mm/memremap.c      |    6 +++---
 3 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-fix-missing-wake-up-event-for-fsdax-pages
+++ a/include/linux/mm.h
@@ -1130,23 +1130,27 @@ static inline bool is_zone_movable_page(
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page(struct page *page);
-static inline bool put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs);
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	return __put_devmap_managed_page(page);
+	return __put_devmap_managed_page_refs(page, refs);
 }
-
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page(struct page *page)
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	return false;
 }
 #endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	return put_devmap_managed_page_refs(page, 1);
+}
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
--- a/mm/gup.c~mm-fix-missing-wake-up-event-for-fsdax-pages
+++ a/mm/gup.c
@@ -87,7 +87,8 @@ retry:
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		folio_put_refs(folio, refs);
+		if (!put_devmap_managed_page_refs(&folio->page, refs))
+			folio_put_refs(folio, refs);
 		goto retry;
 	}
 
@@ -176,7 +177,8 @@ static void gup_put_folio(struct folio *
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	folio_put_refs(folio, refs);
+	if (!put_devmap_managed_page_refs(&folio->page, refs))
+		folio_put_refs(folio, refs);
 }
 
 /**
--- a/mm/memremap.c~mm-fix-missing-wake-up-event-for-fsdax-pages
+++ a/mm/memremap.c
@@ -499,7 +499,7 @@ void free_zone_device_page(struct page *
 }
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
@@ -509,9 +509,9 @@ bool __put_devmap_managed_page(struct pa
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_dec_return(page) == 1)
+	if (page_ref_sub_return(page, refs) == 1)
 		wake_up_var(&page->_refcount);
 	return true;
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
+EXPORT_SYMBOL(__put_devmap_managed_page_refs);
 #endif /* CONFIG_FS_DAX */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

