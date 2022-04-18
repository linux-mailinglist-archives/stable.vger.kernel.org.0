Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE5505043
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiDRMXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbiDRMWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:22:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923601CB28;
        Mon, 18 Apr 2022 05:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0303560F37;
        Mon, 18 Apr 2022 12:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97A4C385A7;
        Mon, 18 Apr 2022 12:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284294;
        bh=Tw1PzyLZ5Vo3JmM4ucjbj28v6t/GDkoYGnUxHCrh9CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKXW82w982qBELUvVDprtxctOEKtID34lo5tGdzKssrCcWPD7M639ptFae9Be5Cv+
         0zD0pY9bt314C616L1eaC+9hfTBHkz9GdAMYmolrQrHgIs8exEF214BrMd0glO11Uz
         id+CTiO9u2/MLsC7T72zLv4SNb3ZyxIegSQ27a6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 066/219] KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
Date:   Mon, 18 Apr 2022 14:10:35 +0200
Message-Id: <20220418121207.515916525@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

[ Upstream commit 26bf74bd9f6ff0f1545b4f0c92a37c232d076014 ]

KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
the guest needs to be configured with all 32bit or 64bit vCPUs, and
a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
EL1_32BIT bit is valid (already set up). Values in those bits are set at
the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
configuration for the vCPU.

Check vcpu's register width against those new bits at the vcpu's
KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220329031924.619453-2-reijiw@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 27 ++++++++----
 arch/arm64/include/asm/kvm_host.h    | 10 +++++
 arch/arm64/kvm/reset.c               | 65 +++++++++++++++++++---------
 3 files changed, 74 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..7496deab025a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+#if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
 }
+#else
+static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
+			       &kvm->arch.flags));
+
+	return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
+}
+#endif
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
@@ -72,15 +84,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TVM;
 	}
 
-	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
+	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
+	else
+		/*
+		 * TID3: trap feature register accesses that we virtualise.
+		 * For now this is conditional, since no AArch32 feature regs
+		 * are currently virtualised.
+		 */
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2619fda42ca2..b5ae92f77c61 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -127,6 +127,16 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
 	/* At least one vCPU has ran in the VM */
 #define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
+	/*
+	 * The following two bits are used to indicate the guest's EL1
+	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
+	 * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
+	 * Otherwise, the guest's EL1 register width has not yet been
+	 * determined yet.
+	 */
+#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
+#define KVM_ARCH_FLAG_EL1_32BIT				4
+
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..6c70c6f61c70 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -181,27 +181,51 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+/**
+ * kvm_set_vm_width() - set the register width for the guest
+ * @vcpu: Pointer to the vcpu being configured
+ *
+ * Set both KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
+ * in the VM flags based on the vcpu's requested register width, the HW
+ * capabilities and other options (such as MTE).
+ * When REG_WIDTH_CONFIGURED is already set, the vcpu settings must be
+ * consistent with the value of the FLAG_EL1_32BIT bit in the flags.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *tmp;
+	struct kvm *kvm = vcpu->kvm;
 	bool is32bit;
-	unsigned long i;
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+
+	lockdep_assert_held(&kvm->lock);
+
+	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
+		/*
+		 * The guest's register width is already configured.
+		 * Make sure that the vcpu is consistent with it.
+		 */
+		if (is32bit == test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags))
+			return 0;
+
+		return -EINVAL;
+	}
+
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
-		return false;
+		return -EINVAL;
 
 	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(vcpu->kvm) && is32bit)
-		return false;
+	if (kvm_has_mte(kvm) && is32bit)
+		return -EINVAL;
 
-	/* Check that the vcpus are either all 32bit or all 64bit */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
-			return false;
-	}
+	if (is32bit)
+		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
 
-	return true;
+	set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
+
+	return 0;
 }
 
 /**
@@ -230,10 +254,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	u32 pstate;
 
 	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	ret = kvm_set_vm_width(vcpu);
+	if (!ret) {
+		reset_state = vcpu->arch.reset_state;
+		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	}
 	mutex_unlock(&vcpu->kvm->lock);
 
+	if (ret)
+		return ret;
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -260,14 +290,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (!vcpu_allowed_register_width(vcpu)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	switch (vcpu->arch.target) {
 	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		if (vcpu_el1_is_32bit(vcpu)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.35.1



