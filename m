Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA28413F31E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbgAPSkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390374AbgAPRMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F7C24692;
        Thu, 16 Jan 2020 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194722;
        bh=2uKuAs6naMr2zEfcsacto/qs+ruPnyQY/BEKfR1seyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL1K8fCieIrIVrZSikx6BXGs20y81/cjZI9OC9Zghg3h9ieyDa06dlJaQf5UgYk3M
         SnAOxAN5ezI3ht+JRKgN2SRiUaCbfSCpURbhRAXn2cdpXm1I6qEEAjnZ4oFRD6gh/Z
         ZX3jBpt2UBi/WKqcNOzRf9uoWx0sIJJSIN9/xgeE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 557/671] powerpc/mm/mce: Keep irqs disabled during lockless page table walk
Date:   Thu, 16 Jan 2020 12:03:15 -0500
Message-Id: <20200116170509.12787-294-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit d9101bfa6adc831bda8836c4d774820553c14942 ]

__find_linux_mm_pte() returns a page table entry pointer after walking
the page table without holding locks. To make it safe against a THP
split and/or collapse, we disable interrupts around the lockless page
table walk. However we need to keep interrupts disabled as long as we
use the page table entry pointer that is returned.

Fix addr_to_pfn() to do that.

Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Rearrange code slightly and tweak change log wording]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190918145328.28602-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/mce_power.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index 37a110b8e7e1..ecb375040637 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -40,7 +40,7 @@ static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 {
 	pte_t *ptep;
 	unsigned int shift;
-	unsigned long flags;
+	unsigned long pfn, flags;
 	struct mm_struct *mm;
 
 	if (user_mode(regs))
@@ -50,18 +50,22 @@ static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 
 	local_irq_save(flags);
 	ptep = __find_linux_pte(mm->pgd, addr, NULL, &shift);
-	local_irq_restore(flags);
 
-	if (!ptep || pte_special(*ptep))
-		return ULONG_MAX;
+	if (!ptep || pte_special(*ptep)) {
+		pfn = ULONG_MAX;
+		goto out;
+	}
 
-	if (shift > PAGE_SHIFT) {
+	if (shift <= PAGE_SHIFT)
+		pfn = pte_pfn(*ptep);
+	else {
 		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
-
-		return pte_pfn(__pte(pte_val(*ptep) | (addr & rpnmask)));
+		pfn = pte_pfn(__pte(pte_val(*ptep) | (addr & rpnmask)));
 	}
 
-	return pte_pfn(*ptep);
+out:
+	local_irq_restore(flags);
+	return pfn;
 }
 
 /* flush SLBs and reload */
-- 
2.20.1

