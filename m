Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CE348C8B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 10:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhCYJQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 05:16:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14875 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCYJPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 05:15:33 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F5fXj3tkmz9sn1;
        Thu, 25 Mar 2021 17:13:25 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.26.249) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 17:15:19 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
CC:     <maz@kernel.org>, <pbonzini@redhat.com>, <linuxarm@huawei.com>
Subject: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility
Date:   Thu, 25 Mar 2021 09:14:24 +0000
Message-ID: <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
References: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.26.249]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 9739f6ef053f104a997165701c6e15582c4307ee upstream.

It looks like we have broken firmware out there that wrongly advertises
a GICv2 compatibility interface, despite the CPUs not being able to deal
with it.

To work around this, check that the CPU initialising KVM is actually able
to switch to MMIO instead of system registers, and use that as a
precondition to enable GICv2 compatibility in KVM.

Note that the detection happens on a single CPU. If the firmware is
lying *and* that the CPUs are asymetric, all hope is lost anyway.

Cc: stable@vger.kernel.org #5.10
Reported-by: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Message-Id: <20210305185254.3730990-8-maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 35 +++++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 54ce4048d7d1..098b96c121e3 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -406,11 +406,42 @@ void __vgic_v3_init_lrs(void)
 /*
  * Return the GIC CPU configuration:
  * - [31:0]  ICH_VTR_EL2
- * - [63:32] RES0
+ * - [62:32] RES0
+ * - [63]    MMIO (GICv2) capable
  */
 u64 __vgic_v3_get_gic_config(void)
 {
-	return read_gicreg(ICH_VTR_EL2);
+	u64 val, sre = read_gicreg(ICC_SRE_EL1);
+	unsigned long flags = 0;
+
+	/*
+	 * To check whether we have a MMIO-based (GICv2 compatible)
+	 * CPU interface, we need to disable the system register
+	 * view. To do that safely, we have to prevent any interrupt
+	 * from firing (which would be deadly).
+	 *
+	 * Note that this only makes sense on VHE, as interrupts are
+	 * already masked for nVHE as part of the exception entry to
+	 * EL2.
+	 */
+	if (has_vhe())
+		flags = local_daif_save();
+
+	write_gicreg(0, ICC_SRE_EL1);
+	isb();
+
+	val = read_gicreg(ICC_SRE_EL1);
+
+	write_gicreg(sre, ICC_SRE_EL1);
+	isb();
+
+	if (has_vhe())
+		local_daif_restore(flags);
+
+	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
+	val |= read_gicreg(ICH_VTR_EL2);
+
+	return val;
 }
 
 u64 __vgic_v3_read_vmcr(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 8e7bf3151057..6a4bced0851d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -584,8 +584,10 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	bool has_v2;
 	int ret;
 
+	has_v2 = ich_vtr_el2 >> 63;
 	ich_vtr_el2 = (u32)ich_vtr_el2;
 
 	/*
@@ -605,13 +607,15 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 			 gicv4_enable ? "en" : "dis");
 	}
 
+	kvm_vgic_global_state.vcpu_base = 0;
+
 	if (!info->vcpu.start) {
 		kvm_info("GICv3: no GICV resource entry\n");
-		kvm_vgic_global_state.vcpu_base = 0;
+	} else if (!has_v2) {
+		pr_warn(FW_BUG "CPU interface incapable of MMIO access\n");
 	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)info->vcpu.start);
-		kvm_vgic_global_state.vcpu_base = 0;
 	} else {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
-- 
2.17.1

