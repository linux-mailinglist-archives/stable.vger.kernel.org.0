Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15C333BC6F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhCOOZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234108AbhCOOYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA8E865024;
        Mon, 15 Mar 2021 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818280;
        bh=hXuywi2/KtpvsSr9giYi/NjdPXs8OexkSH38sBvLajU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaR1PcdMShSh3DOhGve9zq1/mG/dQIJOzjCh+A1P5qW89euTZNO7NPTsrYwcOqMPZ
         HYM4qMRXA9sA5FnrURLEgddpfMupKNojjGQqsdIMfzUvW/JwPPh8tlJ3SDoZYj4Q1d
         f1EWYRgLvI71tohLn5sJdeMoTSIfnbYIcQh/Givw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.11 294/306] KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
Date:   Mon, 15 Mar 2021 15:24:19 +0100
Message-Id: <20210315135517.632401595@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Marc Zyngier <maz@kernel.org>

commit 01dc9262ff5797b675c32c0c6bc682777d23de05 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h   |    4 ++--
 arch/arm64/kvm/arm.c               |    7 ++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    6 +++---
 arch/arm64/kvm/hyp/nvhe/tlb.c      |    3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c       |    3 ++-
 5 files changed, 15 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -47,7 +47,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	5
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
 #define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
 #define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
@@ -183,10 +183,10 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
 extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -385,11 +385,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
+		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -46,11 +46,11 @@ static void handle___kvm_tlb_flush_vmid(
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
-static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
+static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
 
-	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 
 static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
@@ -115,7 +115,7 @@ static const hcall_t *host_hcall[] = {
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
-	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
+	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__kvm_enable_ssbs),
 	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -123,7 +123,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -131,6 +131,7 @@ void __kvm_tlb_flush_local_vmid(struct k
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -127,7 +127,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -135,6 +135,7 @@ void __kvm_tlb_flush_local_vmid(struct k
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 


