Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAEE3E299C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbhHFLbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 07:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239694AbhHFLbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 07:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8259961058;
        Fri,  6 Aug 2021 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628249483;
        bh=mo5wDPhEHYGqKKM336AjWzR67zEBISf0qmWTSG4w3FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOW8954Np0TRki2NQdRgjPDxmAZzhqGNSxZXmycNwYPxzXwddUObeqilT03yvpj1T
         lKefspovDCqksqUaPtilAvlMfADzP/44EdArMZh7ECFvLrJdui1+jOMdCKfZVZy4qD
         fxXQK/7nzgDNYuxMmDTEi39066TBaVNpzhmWG2mqrfUhE5WcS3LzMs0ns82bs4CJ7q
         BI44cpMQf3KErVQMPnx5QaeTh1mDPqNCKPI6CfsCBZBH/KpQWQk+cWi7JPm2ulIGkN
         PDEUuFFHlIG9o1SujCaSVINBHOXjmEU6A1AapxAY5tf+Kn6eNSnM9PBiq5aqERLJCs
         +e3F+WCTV8qFQ==
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Jade Alglave <jade.alglave@arm.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] arm64: mm: Fix TLBI vs ASID rollover
Date:   Fri,  6 Aug 2021 12:31:04 +0100
Message-Id: <20210806113109.2475-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806113109.2475-1-will@kernel.org>
References: <20210806113109.2475-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When switching to an 'mm_struct' for the first time following an ASID
rollover, a new ASID may be allocated and assigned to 'mm->context.id'.
This reassignment can happen concurrently with other operations on the
mm, such as unmapping pages and subsequently issuing TLB invalidation.

Consequently, we need to ensure that (a) accesses to 'mm->context.id'
are atomic and (b) all page-table updates made prior to a TLBI using the
old ASID are guaranteed to be visible to CPUs running with the new ASID.

This was found by inspection after reviewing the VMID changes from
Shameer but it looks like a real (yet hard to hit) bug.

Cc: <stable@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Jade Alglave <jade.alglave@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/mmu.h      | 29 +++++++++++++++++++++++++----
 arch/arm64/include/asm/tlbflush.h | 11 ++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 75beffe2ee8a..e9c30859f80c 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -27,11 +27,32 @@ typedef struct {
 } mm_context_t;
 
 /*
- * This macro is only used by the TLBI and low-level switch_mm() code,
- * neither of which can race with an ASID change. We therefore don't
- * need to reload the counter using atomic64_read().
+ * We use atomic64_read() here because the ASID for an 'mm_struct' can
+ * be reallocated when scheduling one of its threads following a
+ * rollover event (see new_context() and flush_context()). In this case,
+ * a concurrent TLBI (e.g. via try_to_unmap_one() and ptep_clear_flush())
+ * may use a stale ASID. This is fine in principle as the new ASID is
+ * guaranteed to be clean in the TLB, but the TLBI routines have to take
+ * care to handle the following race:
+ *
+ *    CPU 0                    CPU 1                          CPU 2
+ *
+ *    // ptep_clear_flush(mm)
+ *    xchg_relaxed(pte, 0)
+ *    DSB ISHST
+ *    old = ASID(mm)
+ *         |                                                  <rollover>
+ *         |                   new = new_context(mm)
+ *         \-----------------> atomic_set(mm->context.id, new)
+ *                             cpu_switch_mm(mm)
+ *                             // Hardware walk of pte using new ASID
+ *    TLBI(old)
+ *
+ * In this scenario, the barrier on CPU 0 and the dependency on CPU 1
+ * ensure that the page-table walker on CPU 1 *must* see the invalid PTE
+ * written by CPU 0.
  */
-#define ASID(mm)	((mm)->context.id.counter & 0xffff)
+#define ASID(mm)	(atomic64_read(&(mm)->context.id) & 0xffff)
 
 static inline bool arm64_kernel_unmapped_at_el0(void)
 {
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index cc3f5a33ff9c..36f02892e1df 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -245,9 +245,10 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long asid = __TLBI_VADDR(0, ASID(mm));
+	unsigned long asid;
 
 	dsb(ishst);
+	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
 	dsb(ish);
@@ -256,9 +257,10 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 static inline void flush_tlb_page_nosync(struct vm_area_struct *vma,
 					 unsigned long uaddr)
 {
-	unsigned long addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
+	unsigned long addr;
 
 	dsb(ishst);
+	addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
 	__tlbi(vale1is, addr);
 	__tlbi_user(vale1is, addr);
 }
@@ -283,9 +285,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 {
 	int num = 0;
 	int scale = 0;
-	unsigned long asid = ASID(vma->vm_mm);
-	unsigned long addr;
-	unsigned long pages;
+	unsigned long asid, addr, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -305,6 +305,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	}
 
 	dsb(ishst);
+	asid = ASID(vma->vm_mm);
 
 	/*
 	 * When the CPU does not support TLB range operations, flush the TLB
-- 
2.32.0.605.g8dce9f2422-goog

