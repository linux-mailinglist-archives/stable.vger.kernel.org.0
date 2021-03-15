Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405D533B984
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhCOOGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233410AbhCOOBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5178F64DAD;
        Mon, 15 Mar 2021 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816874;
        bh=gOIejV+/bBiUcgMjnZ/TDR9kYFEXWqR+mNLQGCWAF98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1DECGyckVcKlXdEsjXkgV4nvm8Aoxz80U22mSiC2VDtknRyC7DfT2H6jQM8XWciG
         DrqFjebQClQk0FNcTxb+33c/W7t/vTRazBuxNmyc3kso2RtxhsBDyYw9I1eZRTGGth
         sAYmOheuxXLOMTHIGs1o6BnZs3INtFfeQHrb/fzI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 164/168] KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
Date:   Mon, 15 Mar 2021 14:56:36 +0100
Message-Id: <20210315135555.752583848@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Marc Zyngier <maz@kernel.org>

Commit 01dc9262ff5797b675c32c0c6bc682777d23de05 upstream.

It recently became apparent that the ARMv8 architecture has interesting
rules regarding attributes being used when fetching instructions
if the MMU is off at Stage-1.

In this situation, the CPU is allowed to fetch from the PoC and
allocate into the I-cache (unless the memory is mapped with
the XN attribute at Stage-2).

If we transpose this to vcpus sharing a single physical CPU,
it is possible for a vcpu running with its MMU off to influence
another vcpu running with its MMU on, as the latter is expected to
fetch from the PoU (and self-patching code doesn't flush below that
level).

In order to solve this, reuse the vcpu-private TLB invalidation
code to apply the same policy to the I-cache, nuking it every time
the vcpu runs on a physical CPU that ran another vcpu of the same
VM in the past.

This involve renaming __kvm_tlb_flush_local_vmid() to
__kvm_flush_cpu_context(), and inserting a local i-cache invalidation
there.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210303164505.68492-1-maz@kernel.org
[maz: added 32bit ARM support]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/kvm_asm.h   |    2 +-
 arch/arm/kvm/hyp/tlb.c           |    3 ++-
 arch/arm64/include/asm/kvm_asm.h |    2 +-
 arch/arm64/kvm/hyp/tlb.c         |    3 ++-
 virt/kvm/arm/arm.c               |    8 +++++++-
 5 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -56,7 +56,7 @@ extern char __kvm_hyp_init_end[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_flush_cpu_context(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -45,7 +45,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa
 	__kvm_tlb_flush_vmid(kvm);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_flush_cpu_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 
@@ -54,6 +54,7 @@ void __hyp_text __kvm_tlb_flush_local_vm
 	isb();
 
 	write_sysreg(0, TLBIALL);
+	write_sysreg(0, ICIALLU);
 	dsb(nsh);
 	isb();
 
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,7 +60,7 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_flush_cpu_context(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -182,7 +182,7 @@ void __hyp_text __kvm_tlb_flush_vmid(str
 	__tlb_switch_to_host(kvm, &cxt);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_flush_cpu_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 	struct tlb_inv_context cxt;
@@ -191,6 +191,7 @@ void __hyp_text __kvm_tlb_flush_local_vm
 	__tlb_switch_to_guest(kvm, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -373,11 +373,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	cpu_data = this_cpu_ptr(&kvm_host_data);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
+         * We might get preempted before the vCPU actually runs, but
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
+		kvm_call_hyp(__kvm_flush_cpu_context, vcpu);
 		*last_ran = vcpu->vcpu_id;
 	}
 


