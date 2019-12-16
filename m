Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0520121770
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfLPSHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730107AbfLPSHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0228C206EC;
        Mon, 16 Dec 2019 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519630;
        bh=7fN3UWlUWd1PaCvXO9WAUWYgyiwJjuvQGOX1wXdhKWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoPorr7CO6aKQAFm2BzZ2bmFRoN1MNAHCXcrCGJPVKn7cKKm2XURk6/P7a0in20J5
         Sj/ZObz7c6Opk64l2lgL6ePtf7LSVvqMB5zyyKUWMbi0i/NGamZnsbnryC1SVVougt
         tazSmFbMeCv1l5HQy3LRo1Tq7dz1gg7/B75uBPDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        David Rientjes <rientjes@google.com>, Jan Kara <jack@suse.cz>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paul Oppenheimer <bepvte@gmail.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/140] mm, thp, proc: report THP eligibility for each vma
Date:   Mon, 16 Dec 2019 18:50:06 +0100
Message-Id: <20191216174829.672011364@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 7635d9cbe8327e131a1d3d8517dc186c2796ce2e ]

Userspace falls short when trying to find out whether a specific memory
range is eligible for THP.  There are usecases that would like to know
that
http://lkml.kernel.org/r/alpine.DEB.2.21.1809251248450.50347@chino.kir.corp.google.com
: This is used to identify heap mappings that should be able to fault thp
: but do not, and they normally point to a low-on-memory or fragmentation
: issue.

The only way to deduce this now is to query for hg resp.  nh flags and
confronting the state with the global setting.  Except that there is also
PR_SET_THP_DISABLE that might change the picture.  So the final logic is
not trivial.  Moreover the eligibility of the vma depends on the type of
VMA as well.  In the past we have supported only anononymous memory VMAs
but things have changed and shmem based vmas are supported as well these
days and the query logic gets even more complicated because the
eligibility depends on the mount option and another global configuration
knob.

Simplify the current state and report the THP eligibility in
/proc/<pid>/smaps for each existing vma.  Reuse
transparent_hugepage_enabled for this purpose.  The original
implementation of this function assumes that the caller knows that the vma
itself is supported for THP so make the core checks into
__transparent_hugepage_enabled and use it for existing callers.
__show_smap just use the new transparent_hugepage_enabled which also
checks the vma support status (please note that this one has to be out of
line due to include dependency issues).

[mhocko@kernel.org: fix oops with NULL ->f_mapping]
  Link: http://lkml.kernel.org/r/20181224185106.GC16738@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/20181211143641.3503-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Oppenheimer <bepvte@gmail.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/proc.txt |  3 +++
 fs/proc/task_mmu.c                 |  2 ++
 include/linux/huge_mm.h            | 13 ++++++++++++-
 mm/huge_memory.c                   | 12 +++++++++++-
 mm/memory.c                        |  4 ++--
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 06ac6dda9b345..0d0ecc7df2600 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -425,6 +425,7 @@ SwapPss:               0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:                0 kB
+THPeligible:           0
 VmFlags: rd ex mr mw me dw
 
 the first of these lines shows the same information as is displayed for the
@@ -462,6 +463,8 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
 "SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
+"THPeligible" indicates whether the mapping is eligible for THP pages - 1 if
+true, 0 otherwise.
 
 "VmFlags" field deserves a separate description. This member represents the kernel
 flags associated with the particular virtual memory area in two letter encoded
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 71aba44c4fa6d..efa6273c00067 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -800,6 +800,8 @@ static int show_smap(struct seq_file *m, void *v)
 
 	__show_smap(m, &mss);
 
+	seq_printf(m, "THPeligible:    %d\n", transparent_hugepage_enabled(vma));
+
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
 	show_smap_vma_flags(m, vma);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 77227224ca880..e375f2249f520 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -91,7 +91,11 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 extern unsigned long transparent_hugepage_flags;
 
-static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+/*
+ * to be used on vmas which are known to support THP.
+ * Use transparent_hugepage_enabled otherwise
+ */
+static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_NOHUGEPAGE)
 		return false;
@@ -115,6 +119,8 @@ static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 	return false;
 }
 
+bool transparent_hugepage_enabled(struct vm_area_struct *vma);
+
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
@@ -255,6 +261,11 @@ static inline bool thp_migration_supported(void)
 
 #define hpage_nr_pages(x) 1
 
+static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 09ce8528bbdd9..5a1771bd5d04d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -63,6 +63,16 @@ static struct shrinker deferred_split_shrinker;
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 
+bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return __transparent_hugepage_enabled(vma);
+	if (vma_is_shmem(vma) && shmem_huge_enabled(vma))
+		return __transparent_hugepage_enabled(vma);
+
+	return false;
+}
+
 static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
@@ -1329,7 +1339,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 	get_page(page);
 	spin_unlock(vmf->ptl);
 alloc:
-	if (transparent_hugepage_enabled(vma) &&
+	if (__transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow()) {
 		huge_gfp = alloc_hugepage_direct_gfpmask(vma);
 		new_page = alloc_hugepage_vma(huge_gfp, vma, haddr, HPAGE_PMD_ORDER);
diff --git a/mm/memory.c b/mm/memory.c
index fb5655b518c99..bbf0cc4066c84 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4106,7 +4106,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vmf.pud = pud_alloc(mm, p4d, address);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
-	if (pud_none(*vmf.pud) && transparent_hugepage_enabled(vma)) {
+	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -4132,7 +4132,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
-	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
+	if (pmd_none(*vmf.pmd) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
-- 
2.20.1



