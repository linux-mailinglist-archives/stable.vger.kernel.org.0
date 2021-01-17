Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF02F9539
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 21:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbhAQUpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 15:45:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbhAQUpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 15:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5C921D7A;
        Sun, 17 Jan 2021 20:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610916264;
        bh=RvRi6BxgL0VcjiBKDY7T7BePcQ2BnG/wqDj5EfkNWuU=;
        h=Date:From:To:Subject:From;
        b=ugEKK9T0wEoB6KBTQPuatmZvUflLvwDZOLWdPOq4LGFXbEPCiVfcBXDEv7fXwtvww
         Na3RjkvPetSgGuSgjW3ctZs3EqVEn5kC5p5tb2OtmlwPDBXq3TQPXt4CuP8qZkCPHi
         CQOxFe6NwMelfeq1Ye/1ETGLBazgFG61cAeLh5FQ=
Date:   Sun, 17 Jan 2021 12:44:22 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject:  [to-be-updated]
 mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch removed
 from -mm tree
Message-ID: <20210117204422._bfXz1QN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page

If a new hugetlb page is allocated during fallocate it will not be marked
as active (set_page_huge_active) which will result in a later
isolate_huge_page failure when the page migration code would like to move
that page.  Such a failure would be unexpected and wrong.

Only export set_page_huge_active, just leave clear_page_huge_active
as static. Because there are no external users.

Link: https://lkml.kernel.org/r/20210110124017.86750-3-songmuchun@bytedance.com
Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    3 ++-
 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/fs/hugetlbfs/inode.c
@@ -735,9 +735,10 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
+		set_page_huge_active(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
-		 * page_put due to reference from alloc_huge_page()
+		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
 		put_page(page);
--- a/include/linux/hugetlb.h~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/include/linux/hugetlb.h
@@ -770,6 +770,8 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
+void set_page_huge_active(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/mm/hugetlb.c
@@ -1349,7 +1349,7 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-static void set_page_huge_active(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

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

