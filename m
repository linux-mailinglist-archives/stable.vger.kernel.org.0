Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D0439750D
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhFAOJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:09:33 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3373 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhFAOJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 10:09:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvYmj2x7Mz65Qn;
        Tue,  1 Jun 2021 22:04:05 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:07:48 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:07:48 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <maz@kernel.org>, <alexandru.elisei@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: [PATCH v2 stable-5.12.y backport 1/2] KVM: arm64: Commit pending PC adjustemnts before returning to userspace
Date:   Tue, 1 Jun 2021 22:07:37 +0800
Message-ID: <20210601140738.2026-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20210601140738.2026-1-yuzenghui@huawei.com>
References: <20210601140738.2026-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
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
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/arm.c               | 11 +++++++++++
 arch/arm64/kvm/hyp/exception.c     |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a8578d650bb6..f362f72bcb50 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -57,6 +57,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			15
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 84b5f79c9eab..c18740a1e541 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -892,6 +892,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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
index 936328207bde..e52582e14087 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -25,6 +25,13 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
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
@@ -112,6 +119,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
-- 
2.19.1

