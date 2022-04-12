Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9F04FD8FD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiDLHva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357101AbiDLHjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323B7BE11;
        Tue, 12 Apr 2022 00:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B04316103A;
        Tue, 12 Apr 2022 07:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FFBC385A1;
        Tue, 12 Apr 2022 07:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747521;
        bh=6BkhvsDQaPwwUOomzHYlSBCe/6+7AFRdPB1xOKiYIbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYIR2jwHtNb/rw5L+vtIKuLevVWs79abhx5Zm6bxBiVABlVSt5J/vKXCMcuSpcEnE
         055QSjwW5iKwPmJd64lR0hNIPSFxWrnkxw55LwTaAsAC3Z3EJk4irFhUuaHr7Xtg+V
         xl0Kf9YFK0+Sjp5quAsRjiKoUCTz7rkZC1FA//vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 068/343] KVM: arm64: Do not change the PMU event filter after a VCPU has run
Date:   Tue, 12 Apr 2022 08:28:06 +0200
Message-Id: <20220412062953.066116719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 5177fe91e4cf78a659aada2c9cf712db4d788481 ]

Userspace can specify which events a guest is allowed to use with the
KVM_ARM_VCPU_PMU_V3_FILTER attribute. The list of allowed events can be
identified by a guest from reading the PMCEID{0,1}_EL0 registers.

Changing the PMU event filter after a VCPU has run can cause reads of the
registers performed before the filter is changed to return different values
than reads performed with the new event filter in place. The architecture
defines the two registers as read-only, and this behaviour contradicts
that.

Keep track when the first VCPU has run and deny changes to the PMU event
filter to prevent this from happening.

Signed-off-by: Marc Zyngier <maz@kernel.org>
[ Alexandru E: Added commit message, updated ioctl documentation ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127161759.53553-2-alexandru.elisei@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.rst |  2 +-
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/arm.c                    |  4 +++
 arch/arm64/kvm/pmu-emul.c               | 33 +++++++++++++++----------
 4 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60a29972d3f1..d063aaee5bb7 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -70,7 +70,7 @@ irqchip.
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
 	 	  configured as required prior to calling this attribute
-	 -EBUSY   PMUv3 already initialized
+	 -EBUSY   PMUv3 already initialized or a VCPU has already run
 	 -EINVAL  Invalid filter range
 	 =======  ======================================================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 031e3a2537fc..8234626a945a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,7 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+	bool ran_once;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4dca6ffd03d4..85a2a75f4498 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -634,6 +634,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
+	mutex_lock(&kvm->lock);
+	kvm->arch.ran_once = true;
+	mutex_unlock(&kvm->lock);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fbcfd4ec6f92..bc771bc1a041 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -924,6 +924,8 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
+	struct kvm *kvm = vcpu->kvm;
+
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
@@ -941,7 +943,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		int __user *uaddr = (int __user *)(long)attr->addr;
 		int irq;
 
-		if (!irqchip_in_kernel(vcpu->kvm))
+		if (!irqchip_in_kernel(kvm))
 			return -EINVAL;
 
 		if (get_user(irq, uaddr))
@@ -951,7 +953,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
 			return -EINVAL;
 
-		if (!pmu_irq_is_valid(vcpu->kvm, irq))
+		if (!pmu_irq_is_valid(kvm, irq))
 			return -EINVAL;
 
 		if (kvm_arm_pmu_irq_initialized(vcpu))
@@ -966,7 +968,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+		nr_events = kvm_pmu_event_mask(kvm) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
@@ -978,12 +980,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&kvm->lock);
+
+		if (kvm->arch.ran_once) {
+			mutex_unlock(&kvm->lock);
+			return -EBUSY;
+		}
 
-		if (!vcpu->kvm->arch.pmu_filter) {
-			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
-			if (!vcpu->kvm->arch.pmu_filter) {
-				mutex_unlock(&vcpu->kvm->lock);
+		if (!kvm->arch.pmu_filter) {
+			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
+			if (!kvm->arch.pmu_filter) {
+				mutex_unlock(&kvm->lock);
 				return -ENOMEM;
 			}
 
@@ -994,17 +1001,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 			 * events, the default is to allow.
 			 */
 			if (filter.action == KVM_PMU_EVENT_ALLOW)
-				bitmap_zero(vcpu->kvm->arch.pmu_filter, nr_events);
+				bitmap_zero(kvm->arch.pmu_filter, nr_events);
 			else
-				bitmap_fill(vcpu->kvm->arch.pmu_filter, nr_events);
+				bitmap_fill(kvm->arch.pmu_filter, nr_events);
 		}
 
 		if (filter.action == KVM_PMU_EVENT_ALLOW)
-			bitmap_set(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+			bitmap_set(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
 		else
-			bitmap_clear(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
 
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&kvm->lock);
 
 		return 0;
 	}
-- 
2.35.1



