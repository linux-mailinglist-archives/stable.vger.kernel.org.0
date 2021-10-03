Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5834201F0
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJCOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhJCOQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DA2561B00;
        Sun,  3 Oct 2021 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270488;
        bh=rfJFW6TIY7bLOhems16VJt66qMKU/AkrCvkKj4qhJe0=;
        h=Subject:To:Cc:From:Date:From;
        b=ZyWbNCG+TAX0VZkrQiyALcohth9Oj/Ks9bi0A4H6mvd3UOLTUpmCQR3i3fE+MNYrU
         YM0rlmKXf0eM56f5KoWjqeZzkghok3RdwIpxZe0GwbBUpLwXiTCmd3zmXjrze4H3EI
         zRQ3onpE8UKJdrpfh6Z87/LYpA4lJDs3Sz6170Lo=
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix PMU probe ordering" failed to apply to 5.14-stable tree
To:     maz@kernel.org, linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 16:14:46 +0200
Message-ID: <1633270486178104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e840f42a49925707fca90e6c7a4095118fdb8c4d Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Sun, 19 Sep 2021 14:09:49 +0100
Subject: [PATCH] KVM: arm64: Fix PMU probe ordering

Russell reported that since 5.13, KVM's probing of the PMU has
started to fail on his HW. As it turns out, there is an implicit
ordering dependency between the architectural PMU probing code and
and KVM's own probing. If, due to probe ordering reasons, KVM probes
before the PMU driver, it will fail to detect the PMU and prevent it
from being advertised to guests as well as the VMM.

Obviously, this is one probing too many, and we should be able to
deal with any ordering.

Add a callback from the PMU code into KVM to advertise the registration
of a host CPU PMU, allowing for any probing order.

Fixes: 5421db1be3b1 ("KVM: arm64: Divorce the perf code from oprofile helpers")
Reported-by: "Russell King (Oracle)" <linux@armlinux.org.uk>
Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/YUYRKVflRtUytzy5@shell.armlinux.org.uk
Cc: stable@vger.kernel.org

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index f9bb3b14130e..c84fe24b2ea1 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -50,9 +50,6 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 
 int kvm_perf_init(void)
 {
-	if (kvm_pmu_probe_pmuver() != ID_AA64DFR0_PMUVER_IMP_DEF && !is_protected_kvm_enabled())
-		static_branch_enable(&kvm_arm_pmu_available);
-
 	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f5065f23b413..2af3c37445e0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -740,7 +740,14 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
-int kvm_pmu_probe_pmuver(void)
+void kvm_host_pmu_init(struct arm_pmu *pmu)
+{
+	if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+	    !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
+		static_branch_enable(&kvm_arm_pmu_available);
+}
+
+static int kvm_pmu_probe_pmuver(void)
 {
 	struct perf_event_attr attr = { };
 	struct perf_event *event;
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 3cbc3baf087f..295cc7952d0e 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -952,6 +952,8 @@ int armpmu_register(struct arm_pmu *pmu)
 		pmu->name, pmu->num_events,
 		has_nmi ? ", using NMIs" : "");
 
+	kvm_host_pmu_init(pmu);
+
 	return 0;
 
 out_destroy:
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 864b9997efb2..90f21898aad8 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -61,7 +61,6 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
-int kvm_pmu_probe_pmuver(void);
 #else
 struct kvm_pmu {
 };
@@ -118,8 +117,6 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return 0;
 }
 
-static inline int kvm_pmu_probe_pmuver(void) { return 0xf; }
-
 #endif
 
 #endif
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 505480217cf1..2512e2f9cd4e 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -163,6 +163,12 @@ int arm_pmu_acpi_probe(armpmu_init_fn init_fn);
 static inline int arm_pmu_acpi_probe(armpmu_init_fn init_fn) { return 0; }
 #endif
 
+#ifdef CONFIG_KVM
+void kvm_host_pmu_init(struct arm_pmu *pmu);
+#else
+#define kvm_host_pmu_init(x)	do { } while(0)
+#endif
+
 /* Internal functions only for core arm_pmu code */
 struct arm_pmu *armpmu_alloc(void);
 struct arm_pmu *armpmu_alloc_atomic(void);

