Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C171D2467
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388991AbfJJIot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389002AbfJJIor (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A19321D56;
        Thu, 10 Oct 2019 08:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697086;
        bh=Khvry8g2ty+4zxEaUKkGQndvX0HO1gOPvybZEd4V0Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg28OQCIWdIK2TzDWeOlk2J4Eh/RQReMNbSProTcv+SYKwQFV10E2+w2m3lIGZC5M
         mRrSmFV2mre0F3DyB1WNQ9m+qL4cZRrNp9OFgHTpmTXW9yloZwMpeUkfE5sr810J1L
         q1k5Rmfvxb2XEeOuXwbIq3/bh6RRiAQTEvr0sJSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 014/114] powerpc/mce: Fix MCE handling for huge pages
Date:   Thu, 10 Oct 2019 10:35:21 +0200
Message-Id: <20191010083550.594991638@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balbir Singh <bsingharora@gmail.com>

commit 99ead78afd1128bfcebe7f88f3b102fb2da09aee upstream.

The current code would fail on huge pages addresses, since the shift would
be incorrect. Use the correct page shift value returned by
__find_linux_pte() to get the correct physical address. The code is more
generic and can handle both regular and compound pages.

Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")
Signed-off-by: Balbir Singh <bsingharora@gmail.com>
[arbab@linux.ibm.com: Fixup pseries_do_memory_failure()]
Signed-off-by: Reza Arbab <arbab@linux.ibm.com>
Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190820081352.8641-3-santosh@fossix.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/mce_power.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -39,6 +39,7 @@
 static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 {
 	pte_t *ptep;
+	unsigned int shift;
 	unsigned long flags;
 	struct mm_struct *mm;
 
@@ -48,13 +49,18 @@ static unsigned long addr_to_pfn(struct
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
+
+	if (shift > PAGE_SHIFT) {
+		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
+
+		return pte_pfn(__pte(pte_val(*ptep) | (addr & rpnmask)));
+	}
+
 	return pte_pfn(*ptep);
 }
 
@@ -339,7 +345,7 @@ static const struct mce_derror_table mce
   MCE_INITIATOR_CPU,   MCE_SEV_ERROR_SYNC, },
 { 0, false, 0, 0, 0, 0 } };
 
-static int mce_find_instr_ea_and_pfn(struct pt_regs *regs, uint64_t *addr,
+static int mce_find_instr_ea_and_phys(struct pt_regs *regs, uint64_t *addr,
 					uint64_t *phys_addr)
 {
 	/*
@@ -530,7 +536,8 @@ static int mce_handle_derror(struct pt_r
 			 * kernel/exception-64s.h
 			 */
 			if (get_paca()->in_mce < MAX_MCE_DEPTH)
-				mce_find_instr_ea_and_pfn(regs, addr, phys_addr);
+				mce_find_instr_ea_and_phys(regs, addr,
+							   phys_addr);
 		}
 		found = 1;
 	}


