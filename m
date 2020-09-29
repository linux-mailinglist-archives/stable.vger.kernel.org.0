Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B620127CA51
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgI2MSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgI2LgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03ACD23A69;
        Tue, 29 Sep 2020 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379097;
        bh=TwUQv1EQxadIrvE+XResavrS6lTYVCHYXyvyB+aqY1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+u5sb9wmH0NMYlxUVBaGHEDLuUuwLXK4u2jEoNz7afKGnR1Q1OvDtRr9t34FvV2h
         JotbjEqRuSP1+ItZ0liiZhfhsPNjwstKZmjXp8kLX1pK6C/FyUt8yalcbQdSRArpEk
         +Azq6eV5YpMGbhzYCWAL4uYsexK9gCOdFnSMsZ3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia He <justin.he@arm.com>,
        Yibo Cai <Yibo.Cai@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/388] mm: fix double page fault on arm64 if PTE_AF is cleared
Date:   Tue, 29 Sep 2020 12:55:44 +0200
Message-Id: <20200929110011.122564748@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia He <justin.he@arm.com>

[ Upstream commit 83d116c53058d505ddef051e90ab27f57015b025 ]

When we tested pmdk unit test [1] vmmalloc_fork TEST3 on arm64 guest, there
will be a double page fault in __copy_from_user_inatomic of cow_user_page.

To reproduce the bug, the cmd is as follows after you deployed everything:
make -C src/test/vmmalloc_fork/ TEST_TIME=60m check

Below call trace is from arm64 do_page_fault for debugging purpose:
[  110.016195] Call trace:
[  110.016826]  do_page_fault+0x5a4/0x690
[  110.017812]  do_mem_abort+0x50/0xb0
[  110.018726]  el1_da+0x20/0xc4
[  110.019492]  __arch_copy_from_user+0x180/0x280
[  110.020646]  do_wp_page+0xb0/0x860
[  110.021517]  __handle_mm_fault+0x994/0x1338
[  110.022606]  handle_mm_fault+0xe8/0x180
[  110.023584]  do_page_fault+0x240/0x690
[  110.024535]  do_mem_abort+0x50/0xb0
[  110.025423]  el0_da+0x20/0x24

The pte info before __copy_from_user_inatomic is (PTE_AF is cleared):
[ffff9b007000] pgd=000000023d4f8003, pud=000000023da9b003,
               pmd=000000023d4b3003, pte=360000298607bd3

As told by Catalin: "On arm64 without hardware Access Flag, copying from
user will fail because the pte is old and cannot be marked young. So we
always end up with zeroed page after fork() + CoW for pfn mappings. we
don't always have a hardware-managed access flag on arm64."

This patch fixes it by calling pte_mkyoung. Also, the parameter is
changed because vmf should be passed to cow_user_page()

Add a WARN_ON_ONCE when __copy_from_user_inatomic() returns error
in case there can be some obscure use-case (by Kirill).

[1] https://github.com/pmem/pmdk/tree/master/src/test/vmmalloc_fork

Signed-off-by: Jia He <justin.he@arm.com>
Reported-by: Yibo Cai <Yibo.Cai@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 104 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 89 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index cb7c940cf800c..9ea917e28ef4e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -118,6 +118,18 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
+#ifndef arch_faults_on_old_pte
+static inline bool arch_faults_on_old_pte(void)
+{
+	/*
+	 * Those arches which don't have hw access flag feature need to
+	 * implement their own helper. By default, "true" means pagefault
+	 * will be hit on old pte.
+	 */
+	return true;
+}
+#endif
+
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
@@ -2145,32 +2157,82 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 	return same;
 }
 
-static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
+static inline bool cow_user_page(struct page *dst, struct page *src,
+				 struct vm_fault *vmf)
 {
+	bool ret;
+	void *kaddr;
+	void __user *uaddr;
+	bool force_mkyoung;
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr = vmf->address;
+
 	debug_dma_assert_idle(src);
 
+	if (likely(src)) {
+		copy_user_highpage(dst, src, addr, vma);
+		return true;
+	}
+
 	/*
 	 * If the source page was a PFN mapping, we don't have
 	 * a "struct page" for it. We do a best-effort copy by
 	 * just copying from the original user address. If that
 	 * fails, we just zero-fill it. Live with it.
 	 */
-	if (unlikely(!src)) {
-		void *kaddr = kmap_atomic(dst);
-		void __user *uaddr = (void __user *)(va & PAGE_MASK);
+	kaddr = kmap_atomic(dst);
+	uaddr = (void __user *)(addr & PAGE_MASK);
+
+	/*
+	 * On architectures with software "accessed" bits, we would
+	 * take a double page fault, so mark it accessed here.
+	 */
+	force_mkyoung = arch_faults_on_old_pte() && !pte_young(vmf->orig_pte);
+	if (force_mkyoung) {
+		pte_t entry;
+
+		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+			/*
+			 * Other thread has already handled the fault
+			 * and we don't need to do anything. If it's
+			 * not the case, the fault will be triggered
+			 * again on the same address.
+			 */
+			ret = false;
+			goto pte_unlock;
+		}
 
+		entry = pte_mkyoung(vmf->orig_pte);
+		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
+			update_mmu_cache(vma, addr, vmf->pte);
+	}
+
+	/*
+	 * This really shouldn't fail, because the page is there
+	 * in the page tables. But it might just be unreadable,
+	 * in which case we just give up and fill the result with
+	 * zeroes.
+	 */
+	if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
 		/*
-		 * This really shouldn't fail, because the page is there
-		 * in the page tables. But it might just be unreadable,
-		 * in which case we just give up and fill the result with
-		 * zeroes.
+		 * Give a warn in case there can be some obscure
+		 * use-case
 		 */
-		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
-			clear_page(kaddr);
-		kunmap_atomic(kaddr);
-		flush_dcache_page(dst);
-	} else
-		copy_user_highpage(dst, src, va, vma);
+		WARN_ON_ONCE(1);
+		clear_page(kaddr);
+	}
+
+	ret = true;
+
+pte_unlock:
+	if (force_mkyoung)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	kunmap_atomic(kaddr);
+	flush_dcache_page(dst);
+
+	return ret;
 }
 
 static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
@@ -2342,7 +2404,19 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 				vmf->address);
 		if (!new_page)
 			goto oom;
-		cow_user_page(new_page, old_page, vmf->address, vma);
+
+		if (!cow_user_page(new_page, old_page, vmf)) {
+			/*
+			 * COW failed, if the fault was solved by other,
+			 * it's fine. If not, userspace would re-fault on
+			 * the same address and we will handle the fault
+			 * from the second attempt.
+			 */
+			put_page(new_page);
+			if (old_page)
+				put_page(old_page);
+			return 0;
+		}
 	}
 
 	if (mem_cgroup_try_charge_delay(new_page, mm, GFP_KERNEL, &memcg, false))
-- 
2.25.1



