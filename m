Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD69259507B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiHPEmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiHPElI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72353AE;
        Mon, 15 Aug 2022 13:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5226B60EE9;
        Mon, 15 Aug 2022 20:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2888BC433C1;
        Mon, 15 Aug 2022 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595542;
        bh=3TJo0b7k0R9QFW1dV3wjTaCrOGfOoO6YsoFPu/EfN0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghCCEjLcAxFmHtTPos2gb4YgDPBgTLa9dvyOnpvRUIfT1xlGxyf8CoqcCWF4NIjtR
         UlkXB28/IlVmau59YObHAq0ArV4v/HiqCQ+9pDMonBCUl4mvKoGC9eapgx1hGZPRrO
         cHjm5OMzd0EYp6dO5mzD2luPZZkcpW4fFqunoC1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Howells <dhowells@redhat.com>,
        Huang Ying <ying.huang@intel.com>,
        kernel test robot <lkp@intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0766/1157] mm/migration: fix potential pte_unmap on an not mapped pte
Date:   Mon, 15 Aug 2022 20:02:02 +0200
Message-Id: <20220815180510.133372771@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit ad1ac596e8a8c4b06715dfbd89853eb73c9886b2 ]

__migration_entry_wait and migration_entry_wait_on_locked assume pte is
always mapped from caller.  But this is not the case when it's called from
migration_entry_wait_huge and follow_huge_pmd.  Add a hugetlbfs variant
that calls hugetlb_migration_entry_wait(ptep == NULL) to fix this issue.

Link: https://lkml.kernel.org/r/20220530113016.16663-5-linmiaohe@huawei.com
Fixes: 30dad30922cc ("mm: migration: add migrate_entry_wait_huge()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swapops.h | 12 ++++++++----
 mm/hugetlb.c            |  4 ++--
 mm/migrate.c            | 23 +++++++++++++++++++----
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index f24775b41880..bb7afd03a324 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -244,8 +244,10 @@ extern void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 					spinlock_t *ptl);
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte);
+#ifdef CONFIG_HUGETLB_PAGE
+extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
+extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
+#endif
 #else
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -271,8 +273,10 @@ static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
-static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte) { }
+#ifdef CONFIG_HUGETLB_PAGE
+static inline void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
+#endif
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b7f007399be2..474bfbe9929e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5707,7 +5707,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		 */
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
+			migration_entry_wait_huge(vma, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
@@ -6933,7 +6933,7 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait_huge((pte_t *)pmd, ptl);
 			goto retry;
 		}
 		/*
diff --git a/mm/migrate.c b/mm/migrate.c
index 29b9faed4136..a480f54016b3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -315,13 +315,28 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	__migration_entry_wait(mm, ptep, ptl);
 }
 
-void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte)
+#ifdef CONFIG_HUGETLB_PAGE
+void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl)
 {
-	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), mm, pte);
-	__migration_entry_wait(mm, pte, ptl);
+	pte_t pte;
+
+	spin_lock(ptl);
+	pte = huge_ptep_get(ptep);
+
+	if (unlikely(!is_hugetlb_entry_migration(pte)))
+		spin_unlock(ptl);
+	else
+		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
 }
 
+void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
+{
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
+
+	__migration_entry_wait_huge(pte, ptl);
+}
+#endif
+
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
-- 
2.35.1



