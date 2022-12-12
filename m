Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE07649814
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 03:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiLLCwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 21:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiLLCwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 21:52:14 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE601F1
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 18:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1670813533; x=1702349533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UMsb9hYmJRsJJOpw+cm/DZ+dxlKsc+nFP1GRxxj4MVs=;
  b=sULtIWLVHLhftmU3AbIeG/ar1RDM1IJx2aXJuMBs6PQWEKLG8Ov4a8mk
   ObinBwzsOip+yyvGSp+RvAKG1FNHZbW6xgx8+qKzNGPxhqioajSl5yyrK
   j9qpt7b3rXnUVWGHI+jZKmOnIpQYdv1le7fgig8lF6Nav1YVScWTI5Zg6
   Q=;
X-IronPort-AV: E=Sophos;i="5.96,237,1665446400"; 
   d="scan'208";a="160271726"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 02:52:12 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 80BCC81C23;
        Mon, 12 Dec 2022 02:52:09 +0000 (UTC)
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 12 Dec 2022 02:52:08 +0000
Received: from u46989501580c5c.ant.amazon.com (10.43.160.83) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 12 Dec 2022 02:52:06 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <benh@amazon.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Mike Kravetz" <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Samuel Mendoza-Jonas" <samjonas@amazon.com>
Subject: [PATCH 5.4] mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
Date:   Sun, 11 Dec 2022 18:51:48 -0800
Message-ID: <20221212025148.367737-1-samjonas@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.83]
X-ClientProxiedBy: EX13D42UWB002.ant.amazon.com (10.43.161.155) To
 EX19D001UWA002.ant.amazon.com (10.13.138.236)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit fac35ba763ed07ba93154c95ffc0c4a55023707f ]

On some architectures (like ARM64), it can support CONT-PTE/PMD size
hugetlb, which means it can support not only PMD/PUD size hugetlb (2M and
1G), but also CONT-PTE/PMD size(64K and 32M) if a 4K page size specified.

So when looking up a CONT-PTE size hugetlb page by follow_page(), it will
use pte_offset_map_lock() to get the pte entry lock for the CONT-PTE size
hugetlb in follow_page_pte().  However this pte entry lock is incorrect
for the CONT-PTE size hugetlb, since we should use huge_pte_lock() to get
the correct lock, which is mm->page_table_lock.

That means the pte entry of the CONT-PTE size hugetlb under current pte
lock is unstable in follow_page_pte(), we can continue to migrate or
poison the pte entry of the CONT-PTE size hugetlb, which can cause some
potential race issues, even though they are under the 'pte lock'.

For example, suppose thread A is trying to look up a CONT-PTE size hugetlb
page by move_pages() syscall under the lock, however antoher thread B can
migrate the CONT-PTE hugetlb page at the same time, which will cause
thread A to get an incorrect page, if thread A also wants to do page
migration, then data inconsistency error occurs.

Moreover we have the same issue for CONT-PMD size hugetlb in
follow_huge_pmd().

To fix above issues, rename the follow_huge_pmd() as follow_huge_pmd_pte()
to handle PMD and PTE level size hugetlb, which uses huge_pte_lock() to
get the correct pte entry lock to make the pte entry stable.

Mike said:

Support for CONT_PMD/_PTE was added with bb9dd3df8ee9 ("arm64: hugetlb:
refactor find_num_contig()").  Patch series "Support for contiguous pte
hugepages", v4.  However, I do not believe these code paths were
executed until migration support was added with 5480280d3f2d ("arm64/mm:
enable HugeTLB migration for contiguous bit HugeTLB pages") I would go
with 5480280d3f2d for the Fixes: targe.

Link: https://lkml.kernel.org/r/635f43bdd85ac2615a58405da82b4d33c6e5eb05.1662017562.git.baolin.wang@linux.alibaba.com
Fixes: 5480280d3f2d ("arm64/mm: enable HugeTLB migration for contiguous bit HugeTLB pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[5.4: Fixup contextual diffs before pin_user_pages()]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
---
 include/linux/hugetlb.h |  6 +++---
 mm/gup.c                | 13 ++++++++++++-
 mm/hugetlb.c            | 28 ++++++++++++++--------------
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cef70d6e1657..c7507135c2a0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -127,8 +127,8 @@ struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 struct page *follow_huge_pd(struct vm_area_struct *vma,
 			    unsigned long address, hugepd_t hpd,
 			    int flags, int pdshift);
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-				pmd_t *pmd, int flags);
+struct page *follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address,
+				 int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
 				pud_t *pud, int flags);
 struct page *follow_huge_pgd(struct mm_struct *mm, unsigned long address,
@@ -175,7 +175,7 @@ static inline void hugetlb_show_meminfo(void)
 {
 }
 #define follow_huge_pd(vma, addr, hpd, flags, pdshift) NULL
-#define follow_huge_pmd(mm, addr, pmd, flags)	NULL
+#define follow_huge_pmd_pte(vma, addr, flags)	NULL
 #define follow_huge_pud(mm, addr, pud, flags)	NULL
 #define follow_huge_pgd(mm, addr, pgd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
diff --git a/mm/gup.c b/mm/gup.c
index 3ef769529548..98bd5e0a51c8 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -188,6 +188,17 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
 
+	/*
+	 * Considering PTE level hugetlb, like continuous-PTE hugetlb on
+	 * ARM64 architecture.
+	 */
+	if (is_vm_hugetlb_page(vma)) {
+		page = follow_huge_pmd_pte(vma, address, flags);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
+
 retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
@@ -333,7 +344,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2126d78f053d..177dfd03af4e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5157,30 +5157,30 @@ follow_huge_pd(struct vm_area_struct *vma,
 }
 
 struct page * __weak
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int flags)
+follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address, int flags)
 {
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	pte_t pte;
+	pte_t *ptep, pte;
+
 retry:
-	ptl = pmd_lockptr(mm, pmd);
-	spin_lock(ptl);
-	/*
-	 * make sure that the address range covered by this pmd is not
-	 * unmapped from other threads.
-	 */
-	if (!pmd_huge(*pmd))
-		goto out;
-	pte = huge_ptep_get((pte_t *)pmd);
+	ptep = huge_pte_offset(mm, address, huge_page_size(h));
+	if (!ptep)
+		return NULL;
+
+	ptl = huge_pte_lock(h, mm, ptep);
+	pte = huge_ptep_get(ptep);
 	if (pte_present(pte)) {
-		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+		page = pte_page(pte) +
+			((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait(mm, ptep, ptl);
 			goto retry;
 		}
 		/*
-- 
2.25.1

