Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4C377FCA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEJJun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 05:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhEJJun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 05:50:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A47461042;
        Mon, 10 May 2021 09:49:35 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg2Xd-000LFh-BX; Mon, 10 May 2021 10:49:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Move __adjust_pc out of line
Date:   Mon, 10 May 2021 10:49:14 +0100
Message-Id: <20210510094915.1909484-2-maz@kernel.org>
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

In order to make it easy to call __adjust_pc() from the EL1 code
(in the case of nVHE), rename it to __kvm_adjust_pc() and move
it out of line.

No expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11
---
 arch/arm64/include/asm/kvm_asm.h           |  2 ++
 arch/arm64/kvm/hyp/exception.c             | 18 +++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ------------------
 arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index cf8df032b9c3..d5b11037401d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -201,6 +201,8 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
+extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
+
 extern u64 __vgic_v3_get_gic_config(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 73629094f903..0812a496725f 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -296,7 +296,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	*vcpu_pc(vcpu) = vect_offset;
 }
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu)
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_el1_is_32bit(vcpu)) {
 		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
@@ -329,3 +329,19 @@ void kvm_inject_exception(struct kvm_vcpu *vcpu)
 		}
 	}
 }
+
+/*
+ * Adjust the guest PC on entry, depending on flags provided by EL1
+ * for the purpose of emulation (MMIO, sysreg) or exception injection.
+ */
+void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
+		kvm_inject_exception(vcpu);
+		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+				      KVM_ARM64_EXCEPT_MASK);
+	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
+		kvm_skip_instr(vcpu);
+		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
+	}
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 61716359035d..4fdfeabefeb4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,8 +13,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu);
-
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -43,22 +41,6 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 }
 
-/*
- * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg) or exception injection.
- */
-static inline void __adjust_pc(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
-		kvm_inject_exception(vcpu);
-		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
-				      KVM_ARM64_EXCEPT_MASK);
-	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
-		kvm_skip_instr(vcpu);
-		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
-	}
-}
-
 /*
  * Skip an instruction while host sysregs are live.
  * Assumes host is always 64-bit.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index e9f6ea704d07..b8ac123c3419 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -201,7 +201,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7b8f7db5c1ed..3eafed0431f5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -132,7 +132,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
-- 
2.29.2

