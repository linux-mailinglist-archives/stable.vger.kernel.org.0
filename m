Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655FE396163
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhEaOkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhEaOha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA95E6162D;
        Mon, 31 May 2021 13:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469102;
        bh=CcrXQkY+hw9NOmztT9aGlyDCKhVu5UMIvIdkaGMeoSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paFdpuQqK04MNwIuA+VdFr9xCYg6bBp2lpEaf8/J3CN/MF0jBoj4+3Sjfop2nrHjq
         bnhH1G71QJh6E4uAlKcF7GCIhkmnt3ap1np1g55CEj1CqCuMZXQDOai0JA/PbPq6OE
         TmUf7Nv258eyAdzQHXwdTRzbuZNvaoHo6NXFWnn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 071/296] KVM: arm64: Move __adjust_pc out of line
Date:   Mon, 31 May 2021 15:12:06 +0200
Message-Id: <20210531130706.231037423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit f5e30680616ab09e690b153b7a68ff7dd13e6579 upstream.

In order to make it easy to call __adjust_pc() from the EL1 code
(in the case of nVHE), rename it to __kvm_adjust_pc() and move
it out of line.

No expected functional change.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_asm.h           |    2 ++
 arch/arm64/kvm/hyp/exception.c             |   18 +++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |   18 ------------------
 arch/arm64/kvm/hyp/nvhe/switch.c           |    3 +--
 arch/arm64/kvm/hyp/vhe/switch.c            |    3 +--
 5 files changed, 21 insertions(+), 23 deletions(-)

--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -192,6 +192,8 @@ extern void __kvm_timer_set_cntvoff(u64
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
+extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
+
 extern u64 __vgic_v3_get_gic_config(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -296,7 +296,7 @@ static void enter_exception32(struct kvm
 	*vcpu_pc(vcpu) = vect_offset;
 }
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu)
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_el1_is_32bit(vcpu)) {
 		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
@@ -329,3 +329,19 @@ void kvm_inject_exception(struct kvm_vcp
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
@@ -44,22 +42,6 @@ static inline void __kvm_skip_instr(stru
 }
 
 /*
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
-/*
  * Skip an instruction while host sysregs are live.
  * Assumes host is always 64-bit.
  */
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,7 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
@@ -201,7 +200,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -4,7 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
 #include <linux/arm-smccc.h>
@@ -134,7 +133,7 @@ static int __kvm_vcpu_run_vhe(struct kvm
 	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
-	__adjust_pc(vcpu);
+	__kvm_adjust_pc(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);


