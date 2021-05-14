Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58F03808AE
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhENLkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhENLkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 07:40:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6230C061574
        for <stable@vger.kernel.org>; Fri, 14 May 2021 04:38:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k10so12998672ejj.8
        for <stable@vger.kernel.org>; Fri, 14 May 2021 04:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U1u0yE7nQYCdB0eQdInSTsDAtCqXRgbSQLz2EylALdg=;
        b=C91hICZRea3PdFBsYkY3PNP1EOI3dfxdDS2UsWdLnC9UIPex0ZSjYBIuP16VPuwW4p
         EYU4W8NFmbFNI2HbM8bDu9tpSENckpJaTHdn9xdHvc8wjaNyGPxaIX/sdA6BhVhQS/F9
         R6g4zOPtjgV3nxkrgW8GU/FvCQ6FJWPd0lV/JAYUVnSV3DVThUh20aNr7YIgaMaB9BZx
         7VXAXE5hv0xIBAEpykyPU/e6BHnggPA6mTugZcCvpSvrhfIWKrscLvg6o9+DAJXcgYHv
         LM9efZHME7AVOl5gCwMFXx9KEDtw1RCtsggbuLikd4RJ3INWN+EoX4Y6tah3KLWH8X+g
         7GCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U1u0yE7nQYCdB0eQdInSTsDAtCqXRgbSQLz2EylALdg=;
        b=i3MEaFTj2iCZuCNlvhaboqYqpkJdOpa6cMSSjGCli53s0+WzgIOS70DIF/uWc42B/1
         +XWLzyoAs6tIS1qtGHwoaNyk7zA7QOS8RZfSt8WmNEYQpr35+3yarONV2U1y3QGmZf4/
         pFzHkKaaDxtVy3Ska/BPeDNbxpX8Uj7lk3R/FrG++VZaYv95PgWUaET1s+Q1PLfefeFC
         D7NwcB9HxIbaUWvR4W2rf4i0AmHvYBdZBVmuzDnv8lyIgzQaqwioXvXIRvb/t8SwcCIc
         JzdPSNYAv7GHb+eY/vGGId0YhQvfzqMcYQnFPsRnyEi9PJeAiN/tq8nYU4xDdngaktfC
         fm8A==
X-Gm-Message-State: AOAM532MFJKN7P1RMiN/aInZy9xFpTkl/FFWMOoDFINyAZNv8KZwPVEd
        4L/J4NleSq8JRghtepD8Tn3WgLBkZMs8aA==
X-Google-Smtp-Source: ABdhPJzuZA9LOcSk4NjdkvgUkPBf4UZ12ZVYf0DRuS8G8dfdX+mCHRH4dT8FqU+lDy5ABilAV2Y7AA==
X-Received: by 2002:a17:906:82c2:: with SMTP id a2mr48759114ejy.84.1620992335429;
        Fri, 14 May 2021 04:38:55 -0700 (PDT)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4997:ee00:d19d:216d:4ce8:3efe])
        by smtp.gmail.com with ESMTPSA id ga3sm3477948ejb.34.2021.05.14.04.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:38:54 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86/mmu: Remove the defunct update_pte() paging hook
Date:   Fri, 14 May 2021 13:38:53 +0200
Message-Id: <20210514113853.37957-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream

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
(jwang: backport to 5.4 to fix a warning on AMD nested Virtualization)
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
We hit a warning in  WARNING: CPU: 62 PID: 29302 at arch/x86/kvm/mmu.c:2250 nonpaging_update_pte+0x5/0x10 [kvm]
on AMD Opteron(tm) Processor 6386 SE with kernel 5.4.113, it seems nested L2 is running, I notice a similar bug
report on https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1884058.

I did test with kvm-unit-tests on both Intel Broadwell/Skylake, AMD Opteron, no
regression, basic VM tests work fine too on 5.4 kernel.
the commit c5e2184d1544f9e56140791eff1a351bea2e63b9 can be cherry-picked cleanly
to kernel 5.10+.

 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/mmu.c              | 33 ++-------------------------------
 arch/x86/kvm/x86.c              |  1 -
 3 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c52b7073a5ab..4bc476d7fa6c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -391,8 +391,6 @@ struct kvm_mmu {
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
-	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
 	gpa_t root_cr3;
 	union kvm_mmu_role mmu_role;
@@ -944,7 +942,6 @@ struct kvm_arch {
 struct kvm_vm_stat {
 	ulong mmu_shadow_zapped;
 	ulong mmu_pte_write;
-	ulong mmu_pte_updated;
 	ulong mmu_pde_zapped;
 	ulong mmu_flooded;
 	ulong mmu_recycled;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 47c27c6e3842..b9400087141d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2243,13 +2243,6 @@ static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root)
 {
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
@@ -4356,7 +4349,6 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
-	context->update_pte = nonpaging_update_pte;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = true;
@@ -4935,7 +4927,6 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->update_pte = paging64_update_pte;
 	context->shadow_root_level = level;
 	context->direct_map = false;
 }
@@ -4964,7 +4955,6 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->update_pte = paging32_update_pte;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = false;
 }
@@ -5039,7 +5029,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->page_fault = tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
-	context->update_pte = nonpaging_update_pte;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
@@ -5172,7 +5161,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->gva_to_gpa = ept_gva_to_gpa;
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
-	context->update_pte = ept_update_pte;
 	context->root_level = PT64_ROOT_4LEVEL;
 	context->direct_map = false;
 	context->mmu_role.as_u64 = new_role.as_u64;
@@ -5312,19 +5300,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
-static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp, u64 *spte,
-				  const void *new)
-{
-	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
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
@@ -5490,14 +5465,10 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 		local_flush = true;
 		while (npte--) {
-			u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
-
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte);
-			if (gentry &&
-			      !((sp->role.word ^ base_role)
-			      & mmu_base_role_mask.word) && rmap_can_add(vcpu))
-				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
+			if (gentry && sp->role.level != PG_LEVEL_4K)
+				++vcpu->kvm->stat.mmu_pde_zapped;
 			if (need_remote_flush(entry, *spte))
 				remote_flush = true;
 			++spte;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 153659e8f403..b19de7d42b46 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -208,7 +208,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "l1d_flush", VCPU_STAT(l1d_flush) },
 	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
 	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
-	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
 	{ "mmu_pde_zapped", VM_STAT(mmu_pde_zapped) },
 	{ "mmu_flooded", VM_STAT(mmu_flooded) },
 	{ "mmu_recycled", VM_STAT(mmu_recycled) },
-- 
2.25.1

