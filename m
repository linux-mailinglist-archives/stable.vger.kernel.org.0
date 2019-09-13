Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E2B2012
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfIMNPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbfIMNPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:21 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C334C206A5;
        Fri, 13 Sep 2019 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380519;
        bh=Dt/SmXv7L/dLtW5+1RfHqJi7TyMKcJSyRZIGEnRlLFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPcY008c7iwMRyu5q8nu8f+/ILnf9Dg34nZi0sWU2ZzOTJm+4yinkzP9j6Qy9NW0L
         f+NzoNmybDT76VDMjUgCjDo9NFbVDDG6tt4vtVuK6Fnk15ZhQrMYzkW2kN8hAE7xcY
         tiHX4ecBRvitycHSqSW3Bd4LMhXeqSxpEQpXLYpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/190] powerpc/pkeys: Fix handling of pkey state across fork()
Date:   Fri, 13 Sep 2019 14:05:27 +0100
Message-Id: <20190913130605.367739894@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2cd4bd192ee94848695c1c052d87913260e10f36 ]

Protection key tracking information is not copied over to the
mm_struct of the child during fork(). This can cause the child to
erroneously allocate keys that were already allocated. Any allocated
execute-only key is lost aswell.

Add code; called by dup_mmap(), to copy the pkey state from parent to
child explicitly.

This problem was originally found by Dave Hansen on x86, which turns
out to be a problem on powerpc aswell.

Fixes: cf43d3b26452 ("powerpc: Enable pkey subsystem")
Cc: stable@vger.kernel.org # v4.16+
Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmu_context.h | 15 +++++++++------
 arch/powerpc/mm/pkeys.c                | 10 ++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index b694d6af11508..ae953958c0f33 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -217,12 +217,6 @@ static inline void enter_lazy_tlb(struct mm_struct *mm,
 #endif
 }
 
-static inline int arch_dup_mmap(struct mm_struct *oldmm,
-				struct mm_struct *mm)
-{
-	return 0;
-}
-
 #ifndef CONFIG_PPC_BOOK3S_64
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
@@ -247,6 +241,7 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 #ifdef CONFIG_PPC_MEM_KEYS
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign);
+void arch_dup_pkeys(struct mm_struct *oldmm, struct mm_struct *mm);
 #else /* CONFIG_PPC_MEM_KEYS */
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
@@ -259,6 +254,7 @@ static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 #define thread_pkey_regs_save(thread)
 #define thread_pkey_regs_restore(new_thread, old_thread)
 #define thread_pkey_regs_init(thread)
+#define arch_dup_pkeys(oldmm, mm)
 
 static inline u64 pte_to_hpte_pkey_bits(u64 pteflags)
 {
@@ -267,5 +263,12 @@ static inline u64 pte_to_hpte_pkey_bits(u64 pteflags)
 
 #endif /* CONFIG_PPC_MEM_KEYS */
 
+static inline int arch_dup_mmap(struct mm_struct *oldmm,
+				struct mm_struct *mm)
+{
+	arch_dup_pkeys(oldmm, mm);
+	return 0;
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
diff --git a/arch/powerpc/mm/pkeys.c b/arch/powerpc/mm/pkeys.c
index b271b283c785e..25a8dd9cd71db 100644
--- a/arch/powerpc/mm/pkeys.c
+++ b/arch/powerpc/mm/pkeys.c
@@ -414,3 +414,13 @@ bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 
 	return pkey_access_permitted(vma_pkey(vma), write, execute);
 }
+
+void arch_dup_pkeys(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	if (static_branch_likely(&pkey_disabled))
+		return;
+
+	/* Duplicate the oldmm pkey state in mm: */
+	mm_pkey_allocation_map(mm) = mm_pkey_allocation_map(oldmm);
+	mm->context.execute_only_pkey = oldmm->context.execute_only_pkey;
+}
-- 
2.20.1



