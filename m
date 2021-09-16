Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1940E546
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbhIPRKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245625AbhIPRHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 122C6613A1;
        Thu, 16 Sep 2021 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810156;
        bh=Re8N8cbG+/CTzg5RsonkIH5v2vVp0qmoaUiyiinyl9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCCNfTA4ZPUTCPrd4KS5CVQsvvoO0nSIfFRw7j2q5vuGw23fJD1IqMteHR2uZP+Gb
         AllsYb9y18VJkfcBm/YwOl/g80qtZ8fEV+un2riYOxAqX6hYqyiRvkRJHOLG8yshuV
         XcoPTBHwsQNh+Pstz1UuMtYozAAV+M0XK6Q0Ph7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Jade Alglave <jade.alglave@arm.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 038/432] arm64: mm: Fix TLBI vs ASID rollover
Date:   Thu, 16 Sep 2021 17:56:27 +0200
Message-Id: <20210916155812.113949758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 5e10f9887ed85d4f59266d5c60dd09be96b5dbd4 upstream.

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
Cc: Marc Zyngier <maz@kernel.org>
Cc: Jade Alglave <jade.alglave@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210806113109.2475-2-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mmu.h      |   29 +++++++++++++++++++++++++----
 arch/arm64/include/asm/tlbflush.h |   11 ++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

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
@@ -256,9 +257,10 @@ static inline void flush_tlb_mm(struct m
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
@@ -283,9 +285,7 @@ static inline void __flush_tlb_range(str
 {
 	int num = 0;
 	int scale = 0;
-	unsigned long asid = ASID(vma->vm_mm);
-	unsigned long addr;
-	unsigned long pages;
+	unsigned long asid, addr, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -305,6 +305,7 @@ static inline void __flush_tlb_range(str
 	}
 
 	dsb(ishst);
+	asid = ASID(vma->vm_mm);
 
 	/*
 	 * When the CPU does not support TLB range operations, flush the TLB


