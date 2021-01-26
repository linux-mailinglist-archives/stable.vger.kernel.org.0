Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D21E304C24
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbhAZWBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbhAZVPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 16:15:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A77722B2C;
        Tue, 26 Jan 2021 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611695698;
        bh=LJa+EjZkO8n/sGtn9wsG2+5gf+uriwbCGuXersm6trM=;
        h=Date:From:To:Subject:From;
        b=XUBzEnbmzD97Lz3kOmv5fDAA7y6gkI5oh9B7h8W+pkmxrFAmWellrtVe38bWXJa6x
         B8leTKMe5Z2cRyZnARHSw5mnxAM79oDLGEt4VkPQ7dLslypfvKqdId4yYSn/1dcap0
         PkbAv3RWqQf0mx0YHY4CawR7Cv8fP5e4aeN7tC44=
Date:   Tue, 26 Jan 2021 13:14:57 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  +
 mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch added to -mm
 tree
Message-ID: <20210126211457.EUKDwYVhX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch

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
Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()

The VM_BUG_ON_PAGE avoids the generation of any code, even if that
expression has side-effects when !CONFIG_DEBUG_VM.

Link: https://lkml.kernel.org/r/20210126031009.96266-1-songmuchun@bytedance.com
Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2047,13 +2047,16 @@ retry:
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		int zeroed;
+
 		if ((--needed) < 0)
 			break;
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
+		zeroed = put_page_testzero(page);
+		VM_BUG_ON_PAGE(!zeroed, page);
 		enqueue_huge_page(h, page);
 	}
 free:
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch

