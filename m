Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63B3A03D3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhFHTWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238002AbhFHTS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3553613DC;
        Tue,  8 Jun 2021 18:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178312;
        bh=MZRgdcwTak35JCmwkrToVUJ54ErTgwQqssS1fik8Kik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzD9KSFytkZ5JgwegBt9Ry45tRIviKh5INS1UDjqktmnx3pbdMZRdL5MqHHwdFvJs
         KVScOWa/nwXu1RpksNd+cmS1eHRm+HF0nqn5sgQd/EEokkykf2ICBF/wbOo43TgrkZ
         n3DEQloYC/6rY8WJ/l8gIPynFcMOaM/Pxw5i+iTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 154/161] KVM: arm64: Commit pending PC adjustemnts before returning to userspace
Date:   Tue,  8 Jun 2021 20:28:04 +0200
Message-Id: <20210608175950.654918120@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 26778aaa134a9aefdf5dbaad904054d7be9d656d upstream.

KVM currently updates PC (and the corresponding exception state)
using a two phase approach: first by setting a set of flags,
then by converting these flags into a state update when the vcpu
is about to enter the guest.

However, this creates a disconnect with userspace if the vcpu thread
returns there with any exception/PC flag set. In this case, the exposed
context is wrong, as userspace doesn't have access to these flags
(they aren't architectural). It also means that these flags are
preserved across a reset, which isn't expected.

To solve this problem, force an explicit synchronisation of the
exception state on vcpu exit to userspace. As an optimisation
for nVHE systems, only perform this when there is something pending.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11
[yuz: stable-5.12.y backport: allocate a new number (15) for
 __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc to keep the host_hcall array
 tightly packed]
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h   |    1 +
 arch/arm64/kvm/arm.c               |   11 +++++++++++
 arch/arm64/kvm/hyp/exception.c     |    4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    8 ++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -57,6 +57,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			15
 
 #ifndef __ASSEMBLY__
 
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -892,6 +892,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_deactivate(vcpu);
 
+	/*
+	 * In the unlikely event that we are returning to userspace
+	 * with pending exceptions or PC adjustment, commit these
+	 * adjustments in order to give userspace a consistent view of
+	 * the vcpu state. Note that this relies on __kvm_adjust_pc()
+	 * being preempt-safe on VHE.
+	 */
+	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
+					 KVM_ARM64_INCREMENT_PC)))
+		kvm_call_hyp(__kvm_adjust_pc, vcpu);
+
 	vcpu_put(vcpu);
 	return ret;
 }
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -331,8 +331,8 @@ static void kvm_inject_exception(struct
 }
 
 /*
- * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg) or exception injection.
+ * Adjust the guest PC (and potentially exception state) depending on
+ * flags provided by the emulation code.
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -25,6 +25,13 @@ static void handle___kvm_vcpu_run(struct
 	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
 }
 
+static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+
+	__kvm_adjust_pc(kern_hyp_va(vcpu));
+}
+
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
 {
 	__kvm_flush_vm_context();
@@ -112,6 +119,7 @@ typedef void (*hcall_t)(struct kvm_cpu_c
 
 static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),


