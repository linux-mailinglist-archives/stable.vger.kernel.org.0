Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CA66CAAEA
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjC0QsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjC0QsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:48:19 -0400
Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205342718
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 09:48:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679935694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ku7MLRrGk2IuWgrE9Ls5EOdNSh07/5BuFg79404kMZo=;
        b=nq2w46zEBGq3jEV8bnLZV6oL63uQxBGikgd+apKVHsJL44WIOSIAY/774/7UmSMI+PTWTm
        xXUAOb9+oKE2Im3sf49ZeV+8QuHpo/L5hXxABrE9rWejB3zOcAU5CGj8PpoygpEWd8i2Uk
        vYaI1RljmKhE+WOCeHcHzbYbpfdQkt4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
Date:   Mon, 27 Mar 2023 16:47:44 +0000
Message-Id: <20230327164747.2466958-2-oliver.upton@linux.dev>
In-Reply-To: <20230327164747.2466958-1-oliver.upton@linux.dev>
References: <20230327164747.2466958-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM/arm64 had the lock ordering backwards on vcpu->mutex and kvm->lock
from the very beginning. One such example is the way vCPU resets are
handled: the kvm->lock is acquired while handling a guest CPU_ON PSCI
call.

Add a dedicated lock to serialize writes to kvm_vcpu_arch::{mp_state,
reset_state}. Promote all accessors of mp_state to {READ,WRITE}_ONCE()
as readers do not acquire the mp_state_lock. While at it, plug yet
another race by taking the mp_state_lock in the KVM_SET_MP_STATE ioctl
handler.

As changes to MP state are now guarded with a dedicated lock, drop the
kvm->lock acquisition from the PSCI CPU_ON path. Similarly, move the
reader of reset_state outside of the kvm->lock and instead protect it
with the mp_state_lock. Note that writes to reset_state::reset have been
demoted to regular stores as both readers and writers acquire the
mp_state_lock.

While the kvm->lock inversion still exists in kvm_reset_vcpu(), at least
now PSCI CPU_ON no longer depends on it for serializing vCPU reset.

Cc: stable@vger.kernel.org
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 31 ++++++++++++++++++++++---------
 arch/arm64/kvm/psci.c             | 28 ++++++++++++++++------------
 arch/arm64/kvm/reset.c            |  9 +++++----
 4 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..917586237a4d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -522,6 +522,7 @@ struct kvm_vcpu_arch {
 
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
+	spinlock_t mp_state_lock;
 
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..647798da8c41 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -326,6 +326,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int err;
 
+	spin_lock_init(&vcpu->arch.mp_state_lock);
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -443,34 +445,41 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
+static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_arm_vcpu_power_off(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_STOPPED;
 }
 
 static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_SUSPENDED);
 	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
 static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	*mp_state = vcpu->arch.mp_state;
+	*mp_state = READ_ONCE(vcpu->arch.mp_state);
 
 	return 0;
 }
@@ -480,12 +489,14 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.mp_state = *mp_state;
+		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:
-		kvm_arm_vcpu_power_off(vcpu);
+		__kvm_arm_vcpu_power_off(vcpu);
 		break;
 	case KVM_MP_STATE_SUSPENDED:
 		kvm_arm_vcpu_suspend(vcpu);
@@ -494,6 +505,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		ret = -EINVAL;
 	}
 
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	return ret;
 }
 
@@ -1213,7 +1226,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
 	else
-		vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 7fbc4c1b9df0..5767e6baa61a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -62,6 +62,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
+	int ret = PSCI_RET_SUCCESS;
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
@@ -76,11 +77,15 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
+
+	spin_lock(&vcpu->arch.mp_state_lock);
 	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
-			return PSCI_RET_ALREADY_ON;
+			ret = PSCI_RET_ALREADY_ON;
 		else
-			return PSCI_RET_INVALID_PARAMS;
+			ret = PSCI_RET_INVALID_PARAMS;
+
+		goto out_unlock;
 	}
 
 	reset_state = &vcpu->arch.reset_state;
@@ -96,7 +101,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	reset_state->r0 = smccc_get_arg3(source_vcpu);
 
-	WRITE_ONCE(reset_state->reset, true);
+	reset_state->reset = true;
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
 
 	/*
@@ -108,7 +113,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 
-	return PSCI_RET_SUCCESS;
+out_unlock:
+	spin_unlock(&vcpu->arch.mp_state_lock);
+	return ret;
 }
 
 static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
@@ -168,8 +175,11 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		spin_lock(&tmp->arch.mp_state_lock);
+		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
+		spin_unlock(&tmp->arch.mp_state_lock);
+	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
@@ -229,7 +239,6 @@ static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32
 
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
 	u32 psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 	int ret = 1;
@@ -254,9 +263,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
 	case PSCI_0_2_FN64_CPU_ON:
-		mutex_lock(&kvm->lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	case PSCI_0_2_FN_AFFINITY_INFO:
 		kvm_psci_narrow_to_32bit(vcpu);
@@ -395,7 +402,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
 	u32 psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 
@@ -405,9 +411,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-		mutex_lock(&kvm->lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	default:
 		val = PSCI_RET_NOT_SUPPORTED;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 49a3257dec46..9e023546bde0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -264,15 +264,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->kvm->lock);
 	ret = kvm_set_vm_width(vcpu);
-	if (!ret) {
-		reset_state = vcpu->arch.reset_state;
-		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
-	}
 	mutex_unlock(&vcpu->kvm->lock);
 
 	if (ret)
 		return ret;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+	reset_state = vcpu->arch.reset_state;
+	vcpu->arch.reset_state.reset = false;
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
-- 
2.40.0.348.gf938b09366-goog

