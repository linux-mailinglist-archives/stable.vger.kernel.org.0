Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1E1F5347
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgFJLeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgFJLeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 07:34:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0252074B;
        Wed, 10 Jun 2020 11:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591788856;
        bh=TrZf3M3cHAQOb0xV50khGwwPsW73cXBhqp8dOirlr8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kz5/b6I8eEptc7qCxkktqA6xHjPypRFgozSjLyGxuMvE0SHEwR5uOnAZN/kGXtrE4
         qIuZfTRZjcp8yp/xv3rlc0uh8XPEvesRzj0amgcXBi1XOPfTuAPuhYbAv1T3/KMGcD
         39T6HHLrUn/1Mc42A6lJGJZtYLqqswR5Ukf/QYPc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiyzm-001lrp-UW; Wed, 10 Jun 2020 12:34:15 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
Date:   Wed, 10 Jun 2020 12:34:03 +0100
Message-Id: <20200610113406.1493170-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610113406.1493170-1-maz@kernel.org>
References: <20200610113406.1493170-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm64/include/asm/kvm_emulate.h |  6 ------
 arch/arm64/kvm/arm.c                 | 18 +++++++++++++++++-
 arch/arm64/kvm/handle_exit.c         | 19 ++-----------------
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a30b4eec7cb4..977843e4d5fb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -112,12 +112,6 @@ static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d6988401c22a..152049c5055d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -337,6 +337,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -370,7 +376,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	vcpu_ptrauth_setup_lazy(vcpu);
+	if (vcpu_has_ptrauth(vcpu)) {
+		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
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
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index eb194696ef62..065251efa2e6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,31 +162,16 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
-- 
2.26.2

