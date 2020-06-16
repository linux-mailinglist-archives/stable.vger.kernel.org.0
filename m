Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB601FB36E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 16:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgFPOFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 10:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728919AbgFPOFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 10:05:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2802067B;
        Tue, 16 Jun 2020 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592316336;
        bh=jZo2nR1dDUbxVyrFA8QfcalnzASQCamn6xsUyThuHgI=;
        h=From:To:Cc:Subject:Date:From;
        b=OpNLPgqB6NYza0xygD1NJAUuomUYAAoojHVi3AicrafB/QLk2plERuLyf8YXv57W3
         RzFgVfgg8NS52pgCi6LZBamRWbaCSW5lD4S9vahARXnEcTda0+lhyzjulFqjFWyUvJ
         MuSwVbtYbsMLEEYlXQrjDmGWXkVxFgU2TsEOKWcs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jlCDW-003REm-AU; Tue, 16 Jun 2020 15:05:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH stable-4.19] KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
Date:   Tue, 16 Jun 2020 15:05:18 +0100
Message-Id: <20200616140518.2216674-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream

On a VHE system, the EL1 state is left in the CPU most of the time,
and only syncronized back to memory when vcpu_put() is called (most
of the time on preemption).

Which means that when injecting an exception, we'd better have a way
to either:
(1) write directly to the EL1 sysregs
(2) synchronize the state back to memory, and do the changes there

For an AArch64, we already do (1), so we are safe. Unfortunately,
doing the same thing for AArch32 would be pretty invasive. Instead,
we can easily implement (2) by calling the put/load architectural
backends, and keep preemption disabled. We can then reload the
state back into EL1.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 virt/kvm/arm/aarch32.c            | 28 ++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d0d0227fc70d..c9128bb187f9 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -364,4 +364,6 @@ static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+#define kvm_arm_vcpu_loaded(vcpu)	(false)
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 367b2e0b6d76..3c2f270f3b50 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -535,4 +535,6 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+#define kvm_arm_vcpu_loaded(vcpu)	((vcpu)->arch.sysregs_loaded_on_cpu)
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 18d6d5124397..92c9ad6c0182 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -44,6 +44,26 @@ static const u8 return_offsets[8][2] = {
 	[7] = { 4, 4 },		/* FIQ, unused */
 };
 
+static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (kvm_arm_vcpu_loaded(vcpu)) {
+		kvm_arch_vcpu_put(vcpu);
+		return true;
+	}
+
+	preempt_enable();
+	return false;
+}
+
+static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
+{
+	if (loaded) {
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		preempt_enable();
+	}
+}
+
 /*
  * When an exception is taken, most CPSR fields are left unchanged in the
  * handler. However, some are explicitly overridden (e.g. M[4:0]).
@@ -166,7 +186,10 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 
 void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 {
+	bool loaded = pre_fault_synchronize(vcpu);
+
 	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
+	post_fault_synchronize(vcpu, loaded);
 }
 
 /*
@@ -179,6 +202,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	u32 vect_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);
 
 	if (is_pabt) {
 		vect_offset = 12;
@@ -202,6 +228,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
 		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
+
+	post_fault_synchronize(vcpu, loaded);
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)
-- 
2.27.0

