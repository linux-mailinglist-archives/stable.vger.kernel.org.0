Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0AB38306B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbhEQO1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235769AbhEQOY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C35D614A7;
        Mon, 17 May 2021 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260793;
        bh=GNwBJ1IifUPNQMGwtGA1GJIgXh02A9OEqHHKjzCSbXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2jjR6Vq+zgYQaKgqD62boUsIR3ieo/2TaoTDy6qAZ9mwiq9xucHqVFs2UVy/DyPy
         Ozj1PjRcABFBNQfZpjZPJcY394fJZdN75vJOkCdbfqF6jcr9Zk49R8VxP+xKjp6A/L
         /LleXmbPfAdBGuuRc+pG6xJb79h47i3YLbD4amKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhang <yu.c.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 006/329] KVM: x86/mmu: Remove the defunct update_pte() paging hook
Date:   Mon, 17 May 2021 15:58:37 +0200
Message-Id: <20210517140302.248628949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream.

Remove the update_pte() shadow paging logic, which was obsoleted by
commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
removed.  As pointed out by Yu, KVM never write protects leaf page
tables for the purposes of shadow paging, and instead marks their
associated shadow page as unsync so that the guest can write PTEs at
will.

The update_pte() path, which predates the unsync logic, optimizes COW
scenarios by refreshing leaf SPTEs when they are written, as opposed to
zapping the SPTE, restarting the guest, and installing the new SPTE on
the subsequent fault.  Since KVM no longer write-protects leaf page
tables, update_pte() is unreachable and can be dropped.

Reported-by: Yu Zhang <yu.c.zhang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210115004051.4099250-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    3 --
 arch/x86/kvm/mmu/mmu.c          |   49 +---------------------------------------
 arch/x86/kvm/x86.c              |    1 
 3 files changed, 2 insertions(+), 51 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -358,8 +358,6 @@ struct kvm_mmu {
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
-	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
@@ -1035,7 +1033,6 @@ struct kvm_arch {
 struct kvm_vm_stat {
 	ulong mmu_shadow_zapped;
 	ulong mmu_pte_write;
-	ulong mmu_pte_updated;
 	ulong mmu_pde_zapped;
 	ulong mmu_flooded;
 	ulong mmu_recycled;
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1723,13 +1723,6 @@ static int nonpaging_sync_page(struct kv
 	return 0;
 }
 
-static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
-				 struct kvm_mmu_page *sp, u64 *spte,
-				 const void *pte)
-{
-	WARN_ON(1);
-}
-
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
@@ -3833,7 +3826,6 @@ static void nonpaging_init_context(struc
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->update_pte = nonpaging_update_pte;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = true;
@@ -4415,7 +4407,6 @@ static void paging64_init_context_common
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->update_pte = paging64_update_pte;
 	context->shadow_root_level = level;
 	context->direct_map = false;
 }
@@ -4444,7 +4435,6 @@ static void paging32_init_context(struct
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->update_pte = paging32_update_pte;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = false;
 }
@@ -4526,7 +4516,6 @@ static void init_kvm_tdp_mmu(struct kvm_
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->update_pte = nonpaging_update_pte;
 	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
@@ -4703,7 +4692,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_
 	context->gva_to_gpa = ept_gva_to_gpa;
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
-	context->update_pte = ept_update_pte;
 	context->root_level = level;
 	context->direct_map = false;
 	context->mmu_role.as_u64 = new_role.as_u64;
@@ -4851,19 +4839,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
-static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp, u64 *spte,
-				  const void *new)
-{
-	if (sp->role.level != PG_LEVEL_4K) {
-		++vcpu->kvm->stat.mmu_pde_zapped;
-		return;
-        }
-
-	++vcpu->kvm->stat.mmu_pte_updated;
-	vcpu->arch.mmu->update_pte(vcpu, sp, spte, new);
-}
-
 static bool need_remote_flush(u64 old, u64 new)
 {
 	if (!is_shadow_present_pte(old))
@@ -4979,22 +4954,6 @@ static u64 *get_written_sptes(struct kvm
 	return spte;
 }
 
-/*
- * Ignore various flags when determining if a SPTE can be immediately
- * overwritten for the current MMU.
- *  - level: explicitly checked in mmu_pte_write_new_pte(), and will never
- *    match the current MMU role, as MMU's level tracks the root level.
- *  - access: updated based on the new guest PTE
- *  - quadrant: handled by get_written_sptes()
- *  - invalid: always false (loop only walks valid shadow pages)
- */
-static const union kvm_mmu_page_role role_ign = {
-	.level = 0xf,
-	.access = 0x7,
-	.quadrant = 0x3,
-	.invalid = 0x1,
-};
-
 static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
@@ -5045,14 +5004,10 @@ static void kvm_mmu_pte_write(struct kvm
 
 		local_flush = true;
 		while (npte--) {
-			u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
-
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
-			if (gentry &&
-			    !((sp->role.word ^ base_role) & ~role_ign.word) &&
-			    rmap_can_add(vcpu))
-				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
+			if (gentry && sp->role.level != PG_LEVEL_4K)
+				++vcpu->kvm->stat.mmu_pde_zapped;
 			if (need_remote_flush(entry, *spte))
 				remote_flush = true;
 			++spte;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -234,7 +234,6 @@ struct kvm_stats_debugfs_item debugfs_en
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
-	VM_STAT("mmu_pte_updated", mmu_pte_updated),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
 	VM_STAT("mmu_flooded", mmu_flooded),
 	VM_STAT("mmu_recycled", mmu_recycled),


