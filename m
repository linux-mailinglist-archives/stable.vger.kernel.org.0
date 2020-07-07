Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A2B217101
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgGGPXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbgGGPXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9925D207CD;
        Tue,  7 Jul 2020 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135392;
        bh=9pXmzSl7d/iEQlige2ZLUJK8cExAJXI8Zl9oQfRY6Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uagEk+4XaLrcxntFdNzGywJIsd6mmcoax5bAn6p32qfVFLaMTbRNZDiA+UAsbkxqX
         hm+21zgTyv662k2mUWTqJGKCiUF57ShbeFzhf/mQupLlubiTSjRj81veq13RIfqFHz
         Ee39pTUYPBUYjmkW70LKrtdR35ipKoGe7dGx5u9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 022/112] powerpc/kvm/book3s: Add helper to walk partition scoped linux page table.
Date:   Tue,  7 Jul 2020 17:16:27 +0200
Message-Id: <20200707145802.045273198@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 4b99412ed6972cc77c1f16009e1d00323fcef9ab ]

The locking rules for walking partition scoped table is different from process
scoped table. Hence add a helper for secondary linux page table walk and also
add check whether we are holding the right locks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200505071729.54912-10-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 13 +++++++++++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c   | 12 ++++++------
 arch/powerpc/kvm/book3s_hv_nested.c      |  2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 04b2b927bb5ae..2c2635967d6e0 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -14,6 +14,7 @@
 #include <asm/book3s/64/mmu-hash.h>
 #include <asm/cpu_has_feature.h>
 #include <asm/ppc-opcode.h>
+#include <asm/pte-walk.h>
 
 #ifdef CONFIG_PPC_PSERIES
 static inline bool kvmhv_on_pseries(void)
@@ -634,6 +635,18 @@ extern void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
 				unsigned long gpa, unsigned long hpa,
 				unsigned long nbytes);
 
+static inline pte_t *find_kvm_secondary_pte(struct kvm *kvm, unsigned long ea,
+					    unsigned *hshift)
+{
+	pte_t *pte;
+
+	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
+		"%s called with kvm mmu_lock not held \n", __func__);
+	pte = __find_linux_pte(kvm->arch.pgtable, ea, NULL, hshift);
+
+	return pte;
+}
+
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 
 #endif /* __ASM_KVM_BOOK3S_64_H__ */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bc6c1aa3d0e92..e9b3622405b1d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -993,11 +993,11 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		return 0;
 	}
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 				 kvm->arch.lpid);
-	return 0;				
+	return 0;
 }
 
 /* Called with kvm->mmu_lock held */
@@ -1013,7 +1013,7 @@ int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ref;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep)) {
 		old = kvmppc_radix_update_pte(kvm, ptep, _PAGE_ACCESSED, 0,
 					      gpa, shift);
@@ -1040,7 +1040,7 @@ int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ref;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep))
 		ref = 1;
 	return ref;
@@ -1060,7 +1060,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ret;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_dirty(*ptep)) {
 		ret = 1;
 		if (shift)
@@ -1121,7 +1121,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	gpa = memslot->base_gfn << PAGE_SHIFT;
 	spin_lock(&kvm->mmu_lock);
 	for (n = memslot->npages; n; --n) {
-		ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+		ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 		if (ptep && pte_present(*ptep))
 			kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 					 kvm->arch.lpid);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index dc97e5be76f61..7f1fc5db13eab 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1362,7 +1362,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_run *run,
 	/* See if can find translation in our partition scoped tables for L1 */
 	pte = __pte(0);
 	spin_lock(&kvm->mmu_lock);
-	pte_p = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	pte_p = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (!shift)
 		shift = PAGE_SHIFT;
 	if (pte_p)
-- 
2.25.1



