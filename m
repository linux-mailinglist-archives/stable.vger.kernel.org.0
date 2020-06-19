Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CB7200D83
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390372AbgFSO6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbgFSO6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:58:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C87421941;
        Fri, 19 Jun 2020 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578699;
        bh=/4wWnXrjm8IYha4Hfia24J8Mlvmq2Vgs0g5tlJeHsdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCBdUXRzD86dUEXtEPsVx50E1uhi/0PrKMmnhJlklkayh1g47Yv51uBlX7k9wnI27
         pVe0YDajH7msomc1sMiACV5FtLYqa3uXuBIRQq0CDRWDmVT39KjJHdToSsFGaTmWP2
         arx2/s+Lgn8fOG3JkFV1mfIQeOjtRiu0X2eC4E6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 092/267] KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
Date:   Fri, 19 Jun 2020 16:31:17 +0200
Message-Id: <20200619141653.275298996@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
@@ -364,4 +364,6 @@ static inline void kvm_vcpu_put_sysregs(
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+#define kvm_arm_vcpu_loaded(vcpu)	(false)
+
 #endif /* __ARM_KVM_HOST_H__ */
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -537,4 +537,6 @@ void kvm_vcpu_put_sysregs(struct kvm_vcp
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+#define kvm_arm_vcpu_loaded(vcpu)	((vcpu)->arch.sysregs_loaded_on_cpu)
+
 #endif /* __ARM64_KVM_HOST_H__ */
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
@@ -166,7 +186,10 @@ static void prepare_fault32(struct kvm_v
 
 void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 {
+	bool loaded = pre_fault_synchronize(vcpu);
+
 	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
+	post_fault_synchronize(vcpu, loaded);
 }
 
 /*
@@ -179,6 +202,9 @@ static void inject_abt32(struct kvm_vcpu
 	u32 vect_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);
 
 	if (is_pabt) {
 		vect_offset = 12;
@@ -202,6 +228,8 @@ static void inject_abt32(struct kvm_vcpu
 		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
 		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
+
+	post_fault_synchronize(vcpu, loaded);
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)


