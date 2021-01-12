Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8832F276F
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 05:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbhALE6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 23:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387526AbhALE6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 23:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E9A922B30;
        Tue, 12 Jan 2021 04:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610427441;
        bh=ltMwMcomie2T+wg+k9FYFqLiFg1eEc8cfer63wJLypw=;
        h=Date:From:To:Subject:From;
        b=kb64S0LIKr8AC7oFUysZ8zpduk86CoBy7I1M1an7OADCnKFc/1dKPYnZhDjlU8S0B
         B8aE7kJyZXxxW+It0/Xv29o0+9X8h4+D8r4oY4vj1NOJ0bV8sJXWfV94v9hjsDnJao
         xJd0HtsbCR0cVUYDpB2xdegJzbNtxnZv+/4Q0e7U=
Date:   Mon, 11 Jan 2021 20:57:20 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject:  +
 mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch added to -mm
 tree
Message-ID: <20210112045720.laKfzIZ7r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

The page_huge_active() can be called from scan_movable_pages() which
do not hold a reference count to the HugeTLB page. So when we call
page_huge_active() from scan_movable_pages(), the HugeTLB page can
be freed parallel. Then we will trigger a BUG_ON which is in the
page_huge_active() when CONFIG_DEBUG_VM is enabled. Just remove the
VM_BUG_ON_PAGE.

Link: https://lkml.kernel.org/r/20210110124017.86750-7-songmuchun@bytedance.com
Fixes: 7e1f049efb86 ("mm: hugetlb: cleanup using paeg_huge_active()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active
+++ a/mm/hugetlb.c
@@ -1361,8 +1361,7 @@ struct hstate *size_to_hstate(unsigned l
  */
 bool page_huge_active(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return PageHead(page) && PagePrivate(&page[1]);
+	return PageHeadHuge(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch

