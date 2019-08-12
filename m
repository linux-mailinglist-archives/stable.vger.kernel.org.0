Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00C6899C8
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 11:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfHLJXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 05:23:01 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33028 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfHLJXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 05:23:00 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so47552419plo.0
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 02:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D2tlN+71g8bWt9oQlVT6rxO2X/4rsSsVdmtXxR74abA=;
        b=F5CmZV6EuwezAv08fzounW3xIvyloE7TlTR3tVWuYiBzOiJBzQ4hZyORvwevbNCedR
         At8cTrfsKhbqblHowUbN2jF0OWda/Lh5sVSPmkFPPHqUy38Dcdjc3450zFYUTqb3KA6O
         jjvY0jVTDfT7EqeHoOYEnJowTT8eUha4UlZHkLR6hWz65yO1jBCBhpZjKL8gbsJb9RZp
         nQe3zjcON2XlzE22kIOom7j8W8V6P8QOeMvLsTqAiID0wil0VcKuLAXxm6iDYOp7cF0p
         Ijhf+3fzH0vNX0YedSZ48Xp2nUPnI9Z7IqbXJYiD7cDZnspQ1vN+Y/kLr20FI4jW6ujf
         d7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D2tlN+71g8bWt9oQlVT6rxO2X/4rsSsVdmtXxR74abA=;
        b=PYLM4IzLOM+n+p1LUAEdTNg5zzvMjGHRMqRllP1HlIW49QdlrA86pkuJsdi/aLEaHU
         OO9QpgkYZomQBopA2/lVux06TVQrVNXTViv5cKGcvFpyrcmIE98FW9COb6qe0J4nbMJb
         uBr4mgjOi/GD8RLNVOZYq/axhOsboES2QLI+aah9CzRQs5vv2VqpNxuzlJDDmn1H6NOq
         2hXGDuig6+FlLx9jWMtnowC4hthh9vv5CXE6qkVE9iFBpqeg2Rsvo8xssF0B9UoxI04y
         bxyOqH5A8jL22UC/mqV2Vd2ClYgalxrf/g/epL9e7BbJ2IXMARfK5euuTVdWLQDa07nS
         bJtQ==
X-Gm-Message-State: APjAAAVhd1PNPw9ZoQdKiM3sjvR6trUiIGn8Go3qtOfgvZ9bywdVF+C5
        1qCLcs3Z/LgSCoqa7GpIuKBDtw==
X-Google-Smtp-Source: APXvYqyqd0nTPYOnCU40TAZwVXTB79YQa/gqPN4Oo6WYkoB5nyyofR4VfcO9VgyytTcOrayPv8tgEQ==
X-Received: by 2002:a17:902:30d:: with SMTP id 13mr22076112pld.284.1565601779847;
        Mon, 12 Aug 2019 02:22:59 -0700 (PDT)
Received: from santosiv.in.ibm.com ([129.41.84.75])
        by smtp.gmail.com with ESMTPSA id y188sm10543517pfb.115.2019.08.12.02.22.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 02:22:59 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v9 2/7] powerpc/mce: Fix MCE handling for huge pages
Date:   Mon, 12 Aug 2019 14:52:31 +0530
Message-Id: <20190812092236.16648-3-santosh@fossix.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812092236.16648-1-santosh@fossix.org>
References: <20190812092236.16648-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balbir Singh <bsingharora@gmail.com>

The current code would fail on huge pages addresses, since the shift would
be incorrect. Use the correct page shift value returned by
__find_linux_pte() to get the correct physical address. The code is more
generic and can handle both regular and compound pages.

Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")
Signed-off-by: Balbir Singh <bsingharora@gmail.com>
[arbab@linux.ibm.com: Fixup pseries_do_memory_failure()]
Signed-off-by: Reza Arbab <arbab@linux.ibm.com>
Co-developed-by: Santosh Sivaraj <santosh@fossix.org>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # v4.15+
---
 arch/powerpc/include/asm/mce.h       |  2 +-
 arch/powerpc/kernel/mce_power.c      | 55 ++++++++++++++--------------
 arch/powerpc/platforms/pseries/ras.c |  9 ++---
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/mce.h
index a4c6a74ad2fb..f3a6036b6bc0 100644
--- a/arch/powerpc/include/asm/mce.h
+++ b/arch/powerpc/include/asm/mce.h
@@ -209,7 +209,7 @@ extern void release_mce_event(void);
 extern void machine_check_queue_event(void);
 extern void machine_check_print_event_info(struct machine_check_event *evt,
 					   bool user_mode, bool in_guest);
-unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr);
+unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr);
 #ifdef CONFIG_PPC_BOOK3S_64
 void flush_and_reload_slb(void);
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index a814d2dfb5b0..e74816f045f8 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -20,13 +20,14 @@
 #include <asm/exception-64s.h>
 
 /*
- * Convert an address related to an mm to a PFN. NOTE: we are in real
- * mode, we could potentially race with page table updates.
+ * Convert an address related to an mm to a physical address.
+ * NOTE: we are in real mode, we could potentially race with page table updates.
  */
-unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
+unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr)
 {
-	pte_t *ptep;
-	unsigned long flags;
+	pte_t *ptep, pte;
+	unsigned int shift;
+	unsigned long flags, phys_addr;
 	struct mm_struct *mm;
 
 	if (user_mode(regs))
@@ -35,14 +36,21 @@ unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 		mm = &init_mm;
 
 	local_irq_save(flags);
-	if (mm == current->mm)
-		ptep = find_current_mm_pte(mm->pgd, addr, NULL, NULL);
-	else
-		ptep = find_init_mm_pte(addr, NULL);
+	ptep = __find_linux_pte(mm->pgd, addr, NULL, &shift);
 	local_irq_restore(flags);
+
 	if (!ptep || pte_special(*ptep))
 		return ULONG_MAX;
-	return pte_pfn(*ptep);
+
+	pte = *ptep;
+	if (shift > PAGE_SHIFT) {
+		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
+
+		pte = __pte(pte_val(pte) | (addr & rpnmask));
+	}
+	phys_addr = pte_pfn(pte) << PAGE_SHIFT;
+
+	return phys_addr;
 }
 
 /* flush SLBs and reload */
@@ -344,7 +352,7 @@ static const struct mce_derror_table mce_p9_derror_table[] = {
   MCE_INITIATOR_CPU,   MCE_SEV_SEVERE, true },
 { 0, false, 0, 0, 0, 0, 0 } };
 
-static int mce_find_instr_ea_and_pfn(struct pt_regs *regs, uint64_t *addr,
+static int mce_find_instr_ea_and_phys(struct pt_regs *regs, uint64_t *addr,
 					uint64_t *phys_addr)
 {
 	/*
@@ -354,18 +362,16 @@ static int mce_find_instr_ea_and_pfn(struct pt_regs *regs, uint64_t *addr,
 	 * faults
 	 */
 	int instr;
-	unsigned long pfn, instr_addr;
+	unsigned long instr_addr;
 	struct instruction_op op;
 	struct pt_regs tmp = *regs;
 
-	pfn = addr_to_pfn(regs, regs->nip);
-	if (pfn != ULONG_MAX) {
-		instr_addr = (pfn << PAGE_SHIFT) + (regs->nip & ~PAGE_MASK);
+	instr_addr = addr_to_phys(regs, regs->nip) + (regs->nip & ~PAGE_MASK);
+	if (instr_addr != ULONG_MAX) {
 		instr = *(unsigned int *)(instr_addr);
 		if (!analyse_instr(&op, &tmp, instr)) {
-			pfn = addr_to_pfn(regs, op.ea);
 			*addr = op.ea;
-			*phys_addr = (pfn << PAGE_SHIFT);
+			*phys_addr = addr_to_phys(regs, op.ea);
 			return 0;
 		}
 		/*
@@ -440,15 +446,9 @@ static int mce_handle_ierror(struct pt_regs *regs,
 			*addr = regs->nip;
 			if (mce_err->sync_error &&
 				table[i].error_type == MCE_ERROR_TYPE_UE) {
-				unsigned long pfn;
-
-				if (get_paca()->in_mce < MAX_MCE_DEPTH) {
-					pfn = addr_to_pfn(regs, regs->nip);
-					if (pfn != ULONG_MAX) {
-						*phys_addr =
-							(pfn << PAGE_SHIFT);
-					}
-				}
+				if (get_paca()->in_mce < MAX_MCE_DEPTH)
+					*phys_addr = addr_to_phys(regs,
+								 regs->nip);
 			}
 		}
 		return handled;
@@ -541,7 +541,8 @@ static int mce_handle_derror(struct pt_regs *regs,
 			 * kernel/exception-64s.h
 			 */
 			if (get_paca()->in_mce < MAX_MCE_DEPTH)
-				mce_find_instr_ea_and_pfn(regs, addr, phys_addr);
+				mce_find_instr_ea_and_phys(regs, addr,
+							   phys_addr);
 		}
 		found = 1;
 	}
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index f16fdd0f71f7..5743f6353638 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -739,13 +739,10 @@ static void pseries_do_memory_failure(struct pt_regs *regs,
 	if (mce_log->sub_err_type & UE_LOGICAL_ADDR_PROVIDED) {
 		paddr = be64_to_cpu(mce_log->logical_address);
 	} else if (mce_log->sub_err_type & UE_EFFECTIVE_ADDR_PROVIDED) {
-		unsigned long pfn;
-
-		pfn = addr_to_pfn(regs,
-				  be64_to_cpu(mce_log->effective_address));
-		if (pfn == ULONG_MAX)
+		paddr = addr_to_phys(regs,
+				     be64_to_cpu(mce_log->effective_address));
+		if (paddr == ULONG_MAX)
 			return;
-		paddr = pfn << PAGE_SHIFT;
 	} else {
 		return;
 	}
-- 
2.21.0

