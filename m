Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1820B1482F1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404413AbgAXLcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404379AbgAXLcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0CA720704;
        Fri, 24 Jan 2020 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865528;
        bh=e6LrhppPSWmwo4SwTVxa11bvIPM7NUDheCDYZfySAfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZeJSPOtUiJP6FqWhT9aJ3VHlg2Q+W3vfivnmmbhV5Vq43hCtTFGlbinnsiWX6Rpv
         JQXezkHd87lLLUKEB3vFQ7B7cp7EPCHLsA/Haq1f6Re2m2UjzPZqJhC0xMEJhLVC9d
         SLg/67Z5XgnN+cteSwyKd5QuoBAGWwox0M2VEbuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 570/639] powerpc/mm/mce: Keep irqs disabled during lockless page table walk
Date:   Fri, 24 Jan 2020 10:32:20 +0100
Message-Id: <20200124093200.766629221@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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
index 37a110b8e7e17..ecb3750406378 100644
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



