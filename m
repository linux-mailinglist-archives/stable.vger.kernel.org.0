Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E2D1FB6E6
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgFPPlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbgFPPlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1FD9207C4;
        Tue, 16 Jun 2020 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322095;
        bh=QE52FG2xOUXV33Cg5XUI/t3yU+pakCPIncMqd6LhEz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUM98tTfisAxlRSuj9kTprkRM3XML6EpJB+HYyuuCibRzw8NZFACQddfJ3W/b2n8g
         gE+zIBTC1VeSNxu84jloEopo7yG8tMFfMlq+Ahlu2KF9N/KiBJTtTcTS25JT7WN2HU
         i0rVVujDyucAZmZ4RIMpU5gQsvWZH+sbOeSre+94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 133/134] KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
Date:   Tue, 16 Jun 2020 17:35:17 +0200
Message-Id: <20200616153107.157813635@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/kvm_host.h   |    2 ++
 arch/arm64/include/asm/kvm_host.h |    2 ++
 virt/kvm/arm/aarch32.c            |   28 ++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -421,4 +421,6 @@ static inline bool kvm_arm_vcpu_is_final
 	return true;
 }
 
+#define kvm_arm_vcpu_loaded(vcpu)	(false)
+
 #endif /* __ARM_KVM_HOST_H__ */
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -679,4 +679,6 @@ bool kvm_arm_vcpu_is_finalized(struct kv
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
+#define kvm_arm_vcpu_loaded(vcpu)	((vcpu)->arch.sysregs_loaded_on_cpu)
+
 #endif /* __ARM64_KVM_HOST_H__ */
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -33,6 +33,26 @@ static const u8 return_offsets[8][2] = {
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
@@ -155,7 +175,10 @@ static void prepare_fault32(struct kvm_v
 
 void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 {
+	bool loaded = pre_fault_synchronize(vcpu);
+
 	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
+	post_fault_synchronize(vcpu, loaded);
 }
 
 /*
@@ -168,6 +191,9 @@ static void inject_abt32(struct kvm_vcpu
 	u32 vect_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);
 
 	if (is_pabt) {
 		vect_offset = 12;
@@ -191,6 +217,8 @@ static void inject_abt32(struct kvm_vcpu
 		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
 		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
+
+	post_fault_synchronize(vcpu, loaded);
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)


