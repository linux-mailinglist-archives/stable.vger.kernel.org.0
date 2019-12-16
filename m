Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9592121363
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfLPSBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfLPSBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4ED2082E;
        Mon, 16 Dec 2019 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519274;
        bh=hMofN0NT6+q/44pwAvowqFqatmJHb0HQ5fp/bMI9BHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkU9+DlxYWj/WdmTqLKyW+wGl5sZxBE8ovOIxBfSAoVtCp7wRew4aOA4bcCHJDgnO
         F96bQq5kiU1n+ahstWh+9MJhdS5GNVHrFaJJSGVs7RpQ5f/IM84FhSsG2D/YyVvN0w
         m7CVoSoFIvNbgzIpOK4NvhLdJXKo7i+HEa6j/I3E=
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
Subject: [PATCH 4.14 266/267] mm, thp, proc: report THP eligibility for each vma
Date:   Mon, 16 Dec 2019 18:49:52 +0100
Message-Id: <20191216174917.431398199@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 346a9dd5a9f9a0306e988401d4d726ef1b668057 ]

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
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/huge_mm.h            | 13 ++++++++++++-
 mm/huge_memory.c                   | 12 +++++++++++-
 mm/memory.c                        |  4 ++--
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 4cee34ce496e6..9795b61d83cfe 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -423,6 +423,7 @@ SwapPss:               0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:                0 kB
+THPeligible:           0
 VmFlags: rd ex mr mw me dw
 
 the first of these lines shows the same information as is displayed for the
@@ -460,6 +461,8 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
 "SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
+"THPeligible" indicates whether the mapping is eligible for THP pages - 1 if
+true, 0 otherwise.
 
 "VmFlags" field deserves a separate description. This member represents the kernel
 flags associated with the particular virtual memory area in two letter encoded
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 309d24118f9a0..7541f56251456 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -860,6 +860,9 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 			   (unsigned long)(mss->swap_pss >> (10 + PSS_SHIFT)),
 			   (unsigned long)(mss->pss_locked >> (10 + PSS_SHIFT)));
 
+	if (!rollup_mode)
+		seq_printf(m, "THPeligible:    %d\n", transparent_hugepage_enabled(vma));
+
 	if (!rollup_mode) {
 		arch_show_smap(m, vma);
 		show_smap_vma_flags(m, vma);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bfa38da4c261f..3dbf3b0ac38c3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -92,7 +92,11 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
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
@@ -116,6 +120,8 @@ static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 	return false;
 }
 
+bool transparent_hugepage_enabled(struct vm_area_struct *vma);
+
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
@@ -256,6 +262,11 @@ static inline bool thp_migration_supported(void)
 
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
index 1adc2e6c50f9c..34cd798d46f41 100644
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
@@ -1280,7 +1290,7 @@ int do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 	get_page(page);
 	spin_unlock(vmf->ptl);
 alloc:
-	if (transparent_hugepage_enabled(vma) &&
+	if (__transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow()) {
 		huge_gfp = alloc_hugepage_direct_gfpmask(vma);
 		new_page = alloc_hugepage_vma(huge_gfp, vma, haddr, HPAGE_PMD_ORDER);
diff --git a/mm/memory.c b/mm/memory.c
index e9bce27bc18c3..24963eee4fb03 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4054,7 +4054,7 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	vmf.pud = pud_alloc(mm, p4d, address);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
-	if (pud_none(*vmf.pud) && transparent_hugepage_enabled(vma)) {
+	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -4080,7 +4080,7 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
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



