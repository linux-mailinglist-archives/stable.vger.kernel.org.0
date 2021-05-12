Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB83637CB3B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242496AbhELQe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241551AbhELQ1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB2361DEF;
        Wed, 12 May 2021 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834846;
        bh=RCuR4nnNefH+xIKMwYwrNbxoReMnhNvr8OFZzqtyzJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpx7kl62BAVTVwduKR5rxsKtybSCxLp4Z507MtHTWsdFtRgRwgQIcEe/dIrxBo6Bf
         lLjqoJ4LpWBZYkvJDRTsE+StwWvdI3tlcB5f4Wf9zn7SmVhG/sZNdkI1U/XH1rxwUN
         30dhzNu2sIUMHgW8kj04SD5fOCkTZM+Fj04l/jSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 106/677] KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with 64-bit
Date:   Wed, 12 May 2021 16:42:32 +0200
Message-Id: <20210512144840.747468345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 04d45551a1eefbea42655da52f56e846c0af721a upstream.

Allocate the so called pae_root page on-demand, along with the lm_root
page, when shadowing 32-bit NPT with 64-bit NPT, i.e. when running a
32-bit L1.  KVM currently only allocates the page when NPT is disabled,
or when L0 is 32-bit (using PAE paging).

Note, there is an existing memory leak involving the MMU roots, as KVM
fails to free the PAE roots on failure.  This will be addressed in a
future commit.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Fixes: b6b80c78af83 ("KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT")
Cc: stable@vger.kernel.org
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3193,14 +3193,14 @@ void kvm_mmu_free_roots(struct kvm_vcpu
 		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
-		} else {
+		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
 					mmu_free_root_page(kvm,
 							   &mmu->pae_root[i],
 							   &invalid_list);
-			mmu->root_hpa = INVALID_PAGE;
 		}
+		mmu->root_hpa = INVALID_PAGE;
 		mmu->root_pgd = 0;
 	}
 
@@ -3312,9 +3312,23 @@ static int mmu_alloc_shadow_roots(struct
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK;
-	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
+		/*
+		 * Allocate the page for the PDPTEs when shadowing 32-bit NPT
+		 * with 64-bit only when needed.  Unlike 32-bit NPT, it doesn't
+		 * need to be in low mem.  See also lm_root below.
+		 */
+		if (!vcpu->arch.mmu->pae_root) {
+			WARN_ON_ONCE(!tdp_enabled);
+
+			vcpu->arch.mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+			if (!vcpu->arch.mmu->pae_root)
+				return -ENOMEM;
+		}
+	}
+
 	for (i = 0; i < 4; ++i) {
 		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
@@ -3337,21 +3351,19 @@ static int mmu_alloc_shadow_roots(struct
 	vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 
 	/*
-	 * If we shadow a 32 bit page table with a long mode page
-	 * table we enter this path.
+	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
+	 * tables are allocated and initialized at MMU creation as there is no
+	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
+	 * on demand, as running a 32-bit L1 VMM is very rare.  The PDP is
+	 * handled above (to share logic with PAE), deal with the PML4 here.
 	 */
 	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		if (vcpu->arch.mmu->lm_root == NULL) {
-			/*
-			 * The additional page necessary for this is only
-			 * allocated on demand.
-			 */
-
 			u64 *lm_root;
 
 			lm_root = (void*)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-			if (lm_root == NULL)
-				return 1;
+			if (!lm_root)
+				return -ENOMEM;
 
 			lm_root[0] = __pa(vcpu->arch.mmu->pae_root) | pm_mask;
 
@@ -5240,9 +5252,11 @@ static int __kvm_mmu_create(struct kvm_v
 	 * while the PDP table is a per-vCPU construct that's allocated at MMU
 	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
 	 * x86_64.  Therefore we need to allocate the PDP table in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
-	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
-	 * skip allocating the PDP table.
+	 * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
+	 * generally doesn't use PAE paging and can skip allocating the PDP
+	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
+	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
+	 * KVM; that horror is handled on-demand by mmu_alloc_shadow_roots().
 	 */
 	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;


