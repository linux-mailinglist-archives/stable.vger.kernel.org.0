Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6563C2E1579
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgLWCWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgLWCWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF8F32256F;
        Wed, 23 Dec 2020 02:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690105;
        bh=0cjWunkOrS5N82H+bVlL4sE7+9kDOA3T9tRz41FU7J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsW50qKIcv+WpkcKz6GuaSXwzr3WyPdQm2MpIXKkirZLIKgdzk4QUtd+4O9z8XCXy
         IqV9L0FUGqbIpfDG0TZQRabuBF9CNeavLUisbR24DqIqpZfKvgDZ6LTedtvjyK/H4R
         hhcrrL3wLJvVF/5evY4UyP9TYyxs3oLc31J3Dx5MBlvZnwndPX9+UH2AXfFBEX61Rs
         vfcJJkK2xRwGk8y6bx1IVsuquNMCZNCvv1rxFzZezWijy4jpHMgMS9NtrZRp1drpKp
         7Kwrjr+DpJPBoV59/+GEQXbBJwTGrZapJsady3YUvcFr/srUyI/09zC7kGMMYM+DzF
         hQ6iNZPlvPxHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 34/87] MIPS: kvm: Use vm_get_page_prot to get protection bits
Date:   Tue, 22 Dec 2020 21:20:10 -0500
Message-Id: <20201223022103.2792705-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 411406a8c758d9ad6f908fab3a6cf1d3d89e1d08 ]

MIPS protection bits are setup during runtime so using defines like
PAGE_SHARED ignores this runtime changes. Using vm_get_page_prot
to get correct page protection fixes this.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 098a7afd4d384..5631d6aee1a70 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -1099,6 +1099,7 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
 {
 	kvm_pfn_t pfn;
 	pte_t *ptep;
+	pgprot_t prot;
 
 	ptep = kvm_trap_emul_pte_for_gva(vcpu, badvaddr);
 	if (!ptep) {
@@ -1108,7 +1109,8 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
 
 	pfn = PFN_DOWN(virt_to_phys(vcpu->arch.kseg0_commpage));
 	/* Also set valid and dirty, so refill handler doesn't have to */
-	*ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, PAGE_SHARED)));
+	prot = vm_get_page_prot(VM_READ|VM_WRITE|VM_SHARED);
+	*ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, prot)));
 
 	/* Invalidate this entry in the TLB, guest kernel ASID only */
 	kvm_mips_host_tlb_inv(vcpu, badvaddr, false, true);
-- 
2.27.0

