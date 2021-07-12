Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF43C5095
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344652AbhGLHdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344398AbhGLH3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2085F613FE;
        Mon, 12 Jul 2021 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074701;
        bh=w+lsq1po2qmzpXFUwkCsK5BMD08VL/y+rhzzVFHsNPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xfzt/glKCh2SkRxa4o/tbEe2io78nvcHCwVagMNhZSJLY5SlIgquY9r2D21UhN4/g
         K3hDSE7zWTa8SoKaC3jL5bXCS8Dd1NIit7LZo1bXyxT8RQRnNt4BGPsEmnRU27CebG
         0mQisNEmHQFfKPWD/yuzYx3+drTGnJFFBG3FC4/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Yang Shi <shy828301@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Rik van Riel <riel@surriel.com>,
        Song Liu <songliubraving@fb.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Zi Yan <ziy@nvidia.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 666/700] mm/huge_memory.c: add missing read-only THP checking in transparent_hugepage_enabled()
Date:   Mon, 12 Jul 2021 08:12:29 +0200
Message-Id: <20210712061046.753609399@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit e6be37b2e7bddfe0c76585ee7c7eee5acc8efeab ]

Since commit 99cb0dbd47a1 ("mm,thp: add read-only THP support for
(non-shmem) FS"), read-only THP file mapping is supported.  But it forgot
to add checking for it in transparent_hugepage_enabled().  To fix it, we
add checking for read-only THP file mapping and also introduce helper
transhuge_vma_enabled() to check whether thp is enabled for specified vma
to reduce duplicated code.  We rename transparent_hugepage_enabled to
transparent_hugepage_active to make the code easier to follow as suggested
by David Hildenbrand.

[linmiaohe@huawei.com: define transhuge_vma_enabled next to transhuge_vma_suitable]
  Link: https://lkml.kernel.org/r/20210514093007.4117906-1-linmiaohe@huawei.com

Link: https://lkml.kernel.org/r/20210511134857.1581273-4-linmiaohe@huawei.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c      |  2 +-
 include/linux/huge_mm.h | 57 +++++++++++++++++++++++++----------------
 mm/huge_memory.c        | 11 +++++++-
 mm/khugepaged.c         |  4 +--
 mm/shmem.c              |  3 +--
 5 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e862cab69583..a3f27ccec742 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -829,7 +829,7 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %d\n",
-		   transparent_hugepage_enabled(vma));
+		   transparent_hugepage_active(vma));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2a7c58ea5ca9..e72787731a5b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -118,9 +118,34 @@ extern struct kobj_attribute shmem_enabled_attr;
 
 extern unsigned long transparent_hugepage_flags;
 
+static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
+		unsigned long haddr)
+{
+	/* Don't have to check pgoff for anonymous vma */
+	if (!vma_is_anonymous(vma)) {
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
+			return false;
+	}
+
+	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
+		return false;
+	return true;
+}
+
+static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
+					  unsigned long vm_flags)
+{
+	/* Explicitly disabled through madvise. */
+	if ((vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+		return false;
+	return true;
+}
+
 /*
  * to be used on vmas which are known to support THP.
- * Use transparent_hugepage_enabled otherwise
+ * Use transparent_hugepage_active otherwise
  */
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -131,15 +156,12 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
 		return false;
 
-	if (vma->vm_flags & VM_NOHUGEPAGE)
+	if (!transhuge_vma_enabled(vma, vma->vm_flags))
 		return false;
 
 	if (vma_is_temporary_stack(vma))
 		return false;
 
-	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
 
@@ -153,22 +175,7 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 	return false;
 }
 
-bool transparent_hugepage_enabled(struct vm_area_struct *vma);
-
-static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
-{
-	/* Don't have to check pgoff for anonymous vma */
-	if (!vma_is_anonymous(vma)) {
-		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR))
-			return false;
-	}
-
-	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
-		return false;
-	return true;
-}
+bool transparent_hugepage_active(struct vm_area_struct *vma);
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
@@ -355,7 +362,7 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+static inline bool transparent_hugepage_active(struct vm_area_struct *vma)
 {
 	return false;
 }
@@ -366,6 +373,12 @@ static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
+					  unsigned long vm_flags)
+{
+	return false;
+}
+
 static inline void prep_transhuge_page(struct page *page) {}
 
 static inline bool is_transparent_hugepage(struct page *page)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44c455dbbd63..3120b6952f0d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -63,7 +63,14 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(struct vm_area_struct *vma)
+{
+	return transhuge_vma_enabled(vma, vma->vm_flags) && vma->vm_file &&
+	       !inode_is_open_for_write(vma->vm_file->f_inode) &&
+	       (vma->vm_flags & VM_EXEC);
+}
+
+bool transparent_hugepage_active(struct vm_area_struct *vma)
 {
 	/* The addr is used to check if the vma size fits */
 	unsigned long addr = (vma->vm_end & HPAGE_PMD_MASK) - HPAGE_PMD_SIZE;
@@ -74,6 +81,8 @@ bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 		return __transparent_hugepage_enabled(vma);
 	if (vma_is_shmem(vma))
 		return shmem_huge_enabled(vma);
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
+		return file_thp_enabled(vma);
 
 	return false;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2680d5ffee7f..1259efcd94ca 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -442,9 +442,7 @@ static inline int khugepaged_test_exit(struct mm_struct *mm)
 static bool hugepage_vma_check(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
 {
-	/* Explicitly disabled through madvise. */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
 	/* Enabled via shmem mount options or sysfs settings. */
diff --git a/mm/shmem.c b/mm/shmem.c
index 1a03744240e7..3c39116fd071 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4037,8 +4037,7 @@ bool shmem_huge_enabled(struct vm_area_struct *vma)
 	loff_t i_size;
 	pgoff_t off;
 
-	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (!transhuge_vma_enabled(vma, vma->vm_flags))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_FORCE)
 		return true;
-- 
2.30.2



