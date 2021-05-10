Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3809377FCC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEJJun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhEJJun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 05:50:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B6F461449;
        Mon, 10 May 2021 09:49:35 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg2Xd-000LFh-RT; Mon, 10 May 2021 10:49:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before returning to userspace
Date:   Mon, 10 May 2021 10:49:15 +0100
Message-Id: <20210510094915.1909484-3-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510094915.1909484-1-maz@kernel.org>
References: <20210510094915.1909484-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM currently updates PC (and the corresponding exception state)
using a two phase approach: first by setting a set of flags,
then by converting these flags into a state update when the vcpu
is about to enter the guest.

However, this creates a disconnect with userspace if the vcpu thread
returns there with any exception/PC flag set. In this case, the exposed
context is wrong, as userpsace doesn't have access to these flags
(they aren't architectural). It also means that these flags are
preserved across a reset, which isn't expected.

To solve this problem, force an explicit synchronisation of the
exception state on vcpu exit to userspace. As an optimisation
for nVHE systems, only perform this when there is something pending.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/arm.c               | 10 ++++++++++
 arch/arm64/kvm/hyp/exception.c     |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d5b11037401d..5e9b33cbac51 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cb39c0803a4..d62a7041ebd1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
+	/*
+	 * In the unlikely event that we are returning to userspace
+	 * with pending exceptions or PC adjustment, commit these
+	 * adjustments in order to give userspace a consistent view of
+	 * the vcpu state.
+	 */
+	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
+					 KVM_ARM64_EXCEPT_MASK)))
+		kvm_call_hyp(__kvm_adjust_pc, vcpu);
+
 	vcpu_put(vcpu);
 	return ret;
 }
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0812a496725f..11541b94b328 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -331,8 +331,8 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg) or exception injection.
+ * Adjust the guest PC (and potentially exception state) depending on
+ * flags provided by the emulation code.
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f36420a80474..1632f001f4ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -28,6 +28,13 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
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
@@ -170,6 +177,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
-- 
2.29.2

