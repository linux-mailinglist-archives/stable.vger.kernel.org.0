Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7FD3FF376
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347146AbhIBSwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 14:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhIBSwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 14:52:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEAE6610A0;
        Thu,  2 Sep 2021 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630608682;
        bh=DUFcY3wv6+PTmRHaA4osbQm/s3jE+4bLTQ6cS73hu18=;
        h=Date:From:To:Subject:From;
        b=Zn2WqW+TGcnDvIIX2ZEKBowkfmhtbedzeMNh2X/z7Be7qYlAHR/60pz23eLWSvUg3
         oFTowVoFEI6Z5BREYupqeFS5z215IxfX63gIEtSYGvB14OWZiIF6gqO9LxfowYCF2u
         XKeNcbRAjeszrmi4+Sh71ThapN3B7Nayfa9dM928=
Date:   Thu, 02 Sep 2021 11:51:21 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
 added to -mm tree
Message-ID: <20210902185121.U-Ew8iXzl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype
has been added to the -mm tree.  Its filename is
     mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: avoid accessing uninitialized pcp page migratetype

If it's not prepared to free unref page, the pcp page migratetype is
unset.  Thus We will get rubbish from get_pcppage_migratetype() and might
list_del &page->lru again after it's already deleted from the list leading
to grumble about data corruption.

Link: https://lkml.kernel.org/r/20210902115447.57050-1-linmiaohe@huawei.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype
+++ a/mm/page_alloc.c
@@ -3445,8 +3445,10 @@ void free_unref_page_list(struct list_he
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_to_pfn(page);
-		if (!free_unref_page_prepare(page, pfn, 0))
+		if (!free_unref_page_prepare(page, pfn, 0)) {
 			list_del(&page->lru);
+			continue;
+		}
 
 		/*
 		 * Free isolated pages directly to the allocator, see
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

