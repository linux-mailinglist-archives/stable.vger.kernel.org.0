Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D237A6CAAEC
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjC0QsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjC0QsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:48:22 -0400
Received: from out-47.mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179EF2D50
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 09:48:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679935699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+iw8wDhAWcWckCeuf3blKEQQgijBgnYMqvbb6rr8GQ=;
        b=LJcA/0h2624BqLJ/dmSK4ZRJi0UH9uuHqmUIG08X/AU6s2+TV9/dVEZQG/FCXwhY6XVfND
        9WW1QoDjj5mpTiKNcscT72NczwvDLtW29lpOD3d6VTD+1MxPat2e+0T3/c/M8sMOD9l50/
        pX8C5vUU3cFjblsIhhJ2v0GWT1g8d8w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
Date:   Mon, 27 Mar 2023 16:47:46 +0000
Message-Id: <20230327164747.2466958-4-oliver.upton@linux.dev>
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

There are various bits of VM-scoped data that can only be configured
before the first call to KVM_RUN, such as the hypercall bitmaps and
the PMU. As these fields are protected by the kvm->lock and accessed
while holding vcpu->mutex, this is yet another example of lock
inversion.

Change out the kvm->lock for kvm->arch.config_lock in all of these
instances. Opportunistically simplify the locking mechanics of the
PMU configuration by holding the config_lock for the entirety of
kvm_arm_pmu_v3_set_attr().

Note that this also addresses a couple of bugs. There is an unguarded
read of the PMU version in KVM_ARM_VCPU_PMU_V3_FILTER which could race
with KVM_ARM_VCPU_PMU_V3_SET_PMU. Additionally, until now writes to the
per-vCPU vPMU irq were not serialized VM-wide, meaning concurrent calls
to KVM_ARM_VCPU_PMU_V3_IRQ could lead to a false positive in
pmu_irq_is_valid().

Cc: stable@vger.kernel.org
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c        |  4 ++--
 arch/arm64/kvm/guest.c      |  2 ++
 arch/arm64/kvm/hypercalls.c |  4 ++--
 arch/arm64/kvm/pmu-emul.c   | 23 ++++++-----------------
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1620ec3d95ef..fd8d355aca15 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -624,9 +624,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 07444fa22888..481c79cf22cd 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -957,7 +957,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 		break;
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_set_attr(vcpu, attr);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5da884e11337..fbdbf4257f76 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -377,7 +377,7 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 	if (val & ~fw_reg_features)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
 	    val != *fw_reg_bmap) {
@@ -387,7 +387,7 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 
 	WRITE_ONCE(*fw_reg_bmap, val);
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c243b10f3e15..82991d89c2ea 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -875,7 +875,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	struct arm_pmu *arm_pmu;
 	int ret = -ENXIO;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 	mutex_lock(&arm_pmus_lock);
 
 	list_for_each_entry(entry, &arm_pmus, entry) {
@@ -895,7 +895,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	}
 
 	mutex_unlock(&arm_pmus_lock);
-	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -903,22 +902,20 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	struct kvm *kvm = vcpu->kvm;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
 		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu) {
-			mutex_unlock(&kvm->lock);
+		if (!kvm->arch.arm_pmu)
 			return -ENODEV;
-		}
 	}
-	mutex_unlock(&kvm->lock);
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
@@ -962,19 +959,13 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		mutex_lock(&kvm->lock);
-
-		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
-			mutex_unlock(&kvm->lock);
+		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags))
 			return -EBUSY;
-		}
 
 		if (!kvm->arch.pmu_filter) {
 			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
-			if (!kvm->arch.pmu_filter) {
-				mutex_unlock(&kvm->lock);
+			if (!kvm->arch.pmu_filter)
 				return -ENOMEM;
-			}
 
 			/*
 			 * The default depends on the first applied filter.
@@ -993,8 +984,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		else
 			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
 
-		mutex_unlock(&kvm->lock);
-
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
-- 
2.40.0.348.gf938b09366-goog

