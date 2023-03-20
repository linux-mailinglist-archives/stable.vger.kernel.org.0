Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9BE6C19B1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjCTPgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjCTPg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCA11E5E0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E98615B2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2132C433EF;
        Mon, 20 Mar 2023 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326099;
        bh=1T6WtcvQ1lTuToTui+h3IWyhaagwhESl8MD7v0qj89Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA2PpPCm/CocCeBg2G//82KzeuXecJzruCZLH2UpHUOnzAX9YUiqi0FaBh1IGeLNR
         UxsLvOSJY5L0Fe5A12mO/oDmjLJ9X4IjBBjkTJE04r+W3bwFawYEuIr7Ma9lLyRHuf
         wHjDBUZTC2YXDGw3W/eBvr7uZXxHz3aUEkxV1uhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong Li <zong.li@sifive.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 159/211] Revert "riscv: mm: notify remote harts about mmu cache updates"
Date:   Mon, 20 Mar 2023 15:54:54 +0100
Message-Id: <20230320145520.098439889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

commit e921050022f1f12d5029d1487a7dfc46cde15523 upstream.

This reverts the remaining bits of commit 4bd1d80efb5a ("riscv: mm:
notify remote harts harts about mmu cache updates").

According to bug reports, suggested approach to fix stale TLB entries
is not sufficient. It needs to be replaced by a more robust solution.

Fixes: 4bd1d80efb5a ("riscv: mm: notify remote harts about mmu cache updates")
Reported-by: Zong Li <zong.li@sifive.com>
Reported-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Cc: stable@vger.kernel.org
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230226150137.1919750-2-geomatsi@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/mmu.h      |    2 --
 arch/riscv/include/asm/tlbflush.h |   18 ------------------
 arch/riscv/mm/context.c           |   10 ----------
 arch/riscv/mm/tlbflush.c          |   28 +++++++++++++++++-----------
 4 files changed, 17 insertions(+), 41 deletions(-)

--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,8 +19,6 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
-	/* A local tlb flush is needed before user execution can resume. */
-	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,24 +22,6 @@ static inline void local_flush_tlb_page(
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
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
-
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,16 +196,6 @@ switch_mm_fast:
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
-#ifdef CONFIG_SMP
-	else {
-		cpumask_t *mask = &mm->context.tlb_stale_mask;
-
-		if (cpumask_test_cpu(cpu, mask)) {
-			cpumask_clear_cpu(cpu, mask);
-			local_flush_tlb_all_asid(cntx & asid_mask);
-		}
-	}
-#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,7 +5,23 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-#include <asm/tlbflush.h>
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
 
 void flush_tlb_all(void)
 {
@@ -15,7 +31,6 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
-	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	unsigned int cpuid;
 	bool broadcast;
@@ -29,15 +44,6 @@ static void __sbi_tlb_flush_range(struct
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
-		/*
-		 * TLB will be immediately flushed on harts concurrently
-		 * executing this MM context. TLB flush on other harts
-		 * is deferred until this MM context migrates there.
-		 */
-		cpumask_setall(pmask);
-		cpumask_clear_cpu(cpuid, pmask);
-		cpumask_andnot(pmask, pmask, cmask);
-
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {


