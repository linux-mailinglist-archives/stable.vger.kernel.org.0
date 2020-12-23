Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7702E1476
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgLWCjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgLWCXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33F422D73;
        Wed, 23 Dec 2020 02:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690209;
        bh=ttibY4CYcqWLEZB+Pd0wkF+oOxlfdb/3kj1G3780xgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov4Iv4jLvlNd7czZpNZ9r+g8W+B/Rof3wzOfdykQtfQnZxtlhwBwrU9bkR9gNd0w1
         CyngoOjJPLxMHuubj4HNqpy4uli6btIWzcOXNfRuNidMeigtbNqE2dJswyib23duN+
         CyLLCscsga+UB7knOvRkVIxAK7/G2ZfJKiMjk3dCdAy8SvN9g9Q22LlZ6Ejh5+7BiC
         YaFabf8EmR38eOQF7+PBFO3AUr+ac1JqWxOtxVGldWM+Emr439FYMwr3ubXzhqvePY
         /GWdOidJcLsVr0sQv+ad4MIIL1H3JRqHTvtFjKYChsNuCuwCgocMlcD/k4PpROWYx6
         sdR0qidPX+Obg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 29/66] MIPS: kvm: Use vm_get_page_prot to get protection bits
Date:   Tue, 22 Dec 2020 21:22:15 -0500
Message-Id: <20201223022253.2793452-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index ee64db0327933..0e3ad8c0d346a 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -1108,6 +1108,7 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
 {
 	kvm_pfn_t pfn;
 	pte_t *ptep;
+	pgprot_t prot;
 
 	ptep = kvm_trap_emul_pte_for_gva(vcpu, badvaddr);
 	if (!ptep) {
@@ -1117,7 +1118,8 @@ int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
 
 	pfn = PFN_DOWN(virt_to_phys(vcpu->arch.kseg0_commpage));
 	/* Also set valid and dirty, so refill handler doesn't have to */
-	*ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, PAGE_SHARED)));
+	prot = vm_get_page_prot(VM_READ|VM_WRITE|VM_SHARED);
+	*ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, prot)));
 
 	/* Invalidate this entry in the TLB, guest kernel ASID only */
 	kvm_mips_host_tlb_inv(vcpu, badvaddr, false, true);
-- 
2.27.0

