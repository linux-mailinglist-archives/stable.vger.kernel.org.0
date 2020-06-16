Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFBB1FB86A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgFPP4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732800AbgFPPz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8ECC208D5;
        Tue, 16 Jun 2020 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322958;
        bh=sBp50xgtSXUBc3XAEiLd22g9LgGhg066+1c0iNI/n2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cco7KpE9NcXZgoPGfuVE56pxIPEQ4Do4ygMXzb+AQPyOuGuoK/22f1TWOiCtN7nts
         tc5y5jfPogTfOCOvfl116nKtPqgY4OpHD+h/EXo6ndoBzPu84W/aj20t0zL8bfKbnE
         LGOE7Ak8hQZG21lNvz8yEU6ny8rzga3UpevP6yNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.6 161/161] KVM: arm64: Save the hosts PtrAuth keys in non-preemptible context
Date:   Tue, 16 Jun 2020 17:35:51 +0200
Message-Id: <20200616153114.048785126@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit ef3e40a7ea8dbe2abd0a345032cd7d5023b9684f upstream.

When using the PtrAuth feature in a guest, we need to save the host's
keys before allowing the guest to program them. For that, we dump
them in a per-CPU data structure (the so called host context).

But both call sites that do this are in preemptible context,
which may end up in disaster should the vcpu thread get preempted
before reentering the guest.

Instead, save the keys eagerly on each vcpu_load(). This has an
increased overhead, but is at least safe.

Cc: stable@vger.kernel.org
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/include/asm/kvm_emulate.h   |    3 ++-
 arch/arm64/include/asm/kvm_emulate.h |    6 ------
 arch/arm64/kvm/handle_exit.c         |   19 ++-----------------
 virt/kvm/arm/arm.c                   |   22 +++++++++++++++++++++-
 4 files changed, 25 insertions(+), 25 deletions(-)

--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -367,6 +367,7 @@ static inline unsigned long vcpu_data_ho
 	}
 }
 
-static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
+static inline bool vcpu_has_ptrauth(struct kvm_vcpu *vcpu) { return false; }
+static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu) { }
 
 #endif /* __ARM_KVM_EMULATE_H__ */
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -111,12 +111,6 @@ static inline void vcpu_ptrauth_disable(
 	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
 }
 
-static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
-{
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_disable(vcpu);
-}
-
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,31 +162,16 @@ static int handle_sve(struct kvm_vcpu *v
 	return 1;
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
-
 /*
  * Handle the guest trying to use a ptrauth instruction, or trying to access a
  * ptrauth register.
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *ctxt;
-
-	if (vcpu_has_ptrauth(vcpu)) {
+	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_enable(vcpu);
-		ctxt = vcpu->arch.host_cpu_context;
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
-	} else {
+	else
 		kvm_inject_undefined(vcpu);
-	}
 }
 
 /*
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -332,6 +332,16 @@ void kvm_arch_vcpu_unblocking(struct kvm
 	preempt_enable();
 }
 
+#ifdef CONFIG_ARM64
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+#else
+#define  __ptrauth_save_key(regs, key)	do { } while (0)
+#endif
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -365,7 +375,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	vcpu_ptrauth_setup_lazy(vcpu);
+	if (vcpu_has_ptrauth(vcpu)) {
+		struct kvm_cpu_context __maybe_unused *ctxt = vcpu->arch.host_cpu_context;
+
+		__ptrauth_save_key(ctxt->sys_regs, APIA);
+		__ptrauth_save_key(ctxt->sys_regs, APIB);
+		__ptrauth_save_key(ctxt->sys_regs, APDA);
+		__ptrauth_save_key(ctxt->sys_regs, APDB);
+		__ptrauth_save_key(ctxt->sys_regs, APGA);
+
+		vcpu_ptrauth_disable(vcpu);
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)


