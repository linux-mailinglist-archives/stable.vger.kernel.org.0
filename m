Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C11965D945
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbjADQW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239796AbjADQWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDD11C107
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B17B61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE533C433D2;
        Wed,  4 Jan 2023 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849358;
        bh=PMpMR5JSznT+4xtw8NubllbAt3S06TaPv2TpR67ZZmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr71/FB43SJa1ZkQThMKX5M5tSnh3DjP3sw8QUEvY1TTUiq6q4IOuuZKDC+CT43CZ
         RznFYnKG+zp2zNODKTqV6mBGMK3Z1A2mbTGZtZih1jrEmtLAbQcJKiJL+IJizYohfR
         vz1ETnisHXanF9GvaxDhRoROS9A2fAdpDV/dCnjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 108/177] riscv: mm: notify remote harts about mmu cache updates
Date:   Wed,  4 Jan 2023 17:06:39 +0100
Message-Id: <20230104160510.915662417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

commit 4bd1d80efb5af640f99157f39b50fb11326ce641 upstream.

Current implementation of update_mmu_cache function performs local TLB
flush. It does not take into account ASID information. Besides, it does
not take into account other harts currently running the same mm context
or possible migration of the running context to other harts. Meanwhile
TLB flush is not performed for every context switch if ASID support
is enabled.

Patch [1] proposed to add ASID support to update_mmu_cache to avoid
flushing local TLB entirely. This patch takes into account other
harts currently running the same mm context as well as possible
migration of this context to other harts.

For this purpose the approach from flush_icache_mm is reused. Remote
harts currently running the same mm context are informed via SBI calls
that they need to flush their local TLBs. All the other harts are marked
as needing a deferred TLB flush when this mm context runs on them.

[1] https://lore.kernel.org/linux-riscv/20220821013926.8968-1-tjytimi@163.com/

Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Fixes: 65d4b9c53017 ("RISC-V: Implement ASID allocator")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-riscv/20220829205219.283543-1-geomatsi@gmail.com/#t
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/mmu.h      |    2 ++
 arch/riscv/include/asm/pgtable.h  |    2 +-
 arch/riscv/include/asm/tlbflush.h |   18 ++++++++++++++++++
 arch/riscv/mm/context.c           |   10 ++++++++++
 arch/riscv/mm/tlbflush.c          |   28 +++++++++++-----------------
 5 files changed, 42 insertions(+), 18 deletions(-)

--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,6 +19,8 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
+	/* A local tlb flush is needed before user execution can resume. */
+	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,7 +415,7 @@ static inline void update_mmu_cache(stru
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	local_flush_tlb_page(address);
+	flush_tlb_page(vma, address);
 }
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,6 +22,24 @@ static inline void local_flush_tlb_page(
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
+
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,6 +196,16 @@ switch_mm_fast:
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
+#ifdef CONFIG_SMP
+	else {
+		cpumask_t *mask = &mm->context.tlb_stale_mask;
+
+		if (cpumask_test_cpu(cpu, mask)) {
+			cpumask_clear_cpu(cpu, mask);
+			local_flush_tlb_all_asid(cntx & asid_mask);
+		}
+	}
+#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,23 +5,7 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
+#include <asm/tlbflush.h>
 
 void flush_tlb_all(void)
 {
@@ -31,6 +15,7 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
+	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	unsigned int cpuid;
 	bool broadcast;
@@ -44,6 +29,15 @@ static void __sbi_tlb_flush_range(struct
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
+		/*
+		 * TLB will be immediately flushed on harts concurrently
+		 * executing this MM context. TLB flush on other harts
+		 * is deferred until this MM context migrates there.
+		 */
+		cpumask_setall(pmask);
+		cpumask_clear_cpu(cpuid, pmask);
+		cpumask_andnot(pmask, pmask, cmask);
+
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {


