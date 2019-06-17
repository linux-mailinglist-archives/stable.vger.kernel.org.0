Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB67493C1
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfFQV0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbfFQV0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19D320657;
        Mon, 17 Jun 2019 21:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806776;
        bh=DPX5kHly0Vaj/cPp+9IgSW82tWe8Bf+gstYwWpwl3R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdU2wyB7i1FCAcYtrMRA2B5RUHgSY57DlSQbhHS+zjpb1SCmGhc563l0tPxR0umlm
         jsw7sHRYB9MCFtX1XpmBhZtPtRmRvBQodXRAKnnPsBXkaXvLyu6Ue4CBMv/3hVG8X+
         TRF4zZt5tWSYpnW/pqizyndmLUnWKuQwwV85l3Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/75] KVM: x86/pmu: mask the result of rdpmc according to the width of the counters
Date:   Mon, 17 Jun 2019 23:10:04 +0200
Message-Id: <20190617210754.815585398@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0e6f467ee28ec97f68c7b74e35ec1601bb1368a7 ]

This patch will simplify the changes in the next, by enforcing the
masking of the counters to RDPMC and RDMSR.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c       | 10 +++-------
 arch/x86/kvm/pmu.h       |  3 ++-
 arch/x86/kvm/pmu_amd.c   |  2 +-
 arch/x86/kvm/pmu_intel.c | 13 +++++++++----
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 58ead7db71a3..952aebd0a8a3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -282,20 +282,16 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
 	bool fast_mode = idx & (1u << 31);
 	struct kvm_pmc *pmc;
-	u64 ctr_val;
+	u64 mask = fast_mode ? ~0u : ~0ull;
 
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, idx);
+	pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
-	ctr_val = pmc_read_counter(pmc);
-	if (fast_mode)
-		ctr_val = (u32)ctr_val;
-
-	*data = ctr_val;
+	*data = pmc_read_counter(pmc) & mask;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ba8898e1a854..22dff661145a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -25,7 +25,8 @@ struct kvm_pmu_ops {
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
-	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx);
+	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, unsigned idx,
+					  u64 *mask);
 	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 1495a735b38e..41dff881e0f0 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -186,7 +186,7 @@ static int amd_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 }
 
 /* idx is the ECX register of RDPMC instruction */
-static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx)
+static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *counters;
diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/pmu_intel.c
index 5ab4a364348e..ad7ea81fbfbf 100644
--- a/arch/x86/kvm/pmu_intel.c
+++ b/arch/x86/kvm/pmu_intel.c
@@ -126,7 +126,7 @@ static int intel_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx)
 }
 
 static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
-					    unsigned idx)
+					    unsigned idx, u64 *mask)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
@@ -138,6 +138,7 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
 	if (fixed && idx >= pmu->nr_arch_fixed_counters)
 		return NULL;
 	counters = fixed ? pmu->fixed_counters : pmu->gp_counters;
+	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
 
 	return &counters[idx];
 }
@@ -183,9 +184,13 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 		*data = pmu->global_ovf_ctrl;
 		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
-		    (pmc = get_fixed_pmc(pmu, msr))) {
-			*data = pmc_read_counter(pmc);
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+			u64 val = pmc_read_counter(pmc);
+			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
+			return 0;
+		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+			u64 val = pmc_read_counter(pmc);
+			*data = val & pmu->counter_bitmask[KVM_PMC_FIXED];
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			*data = pmc->eventsel;
-- 
2.20.1



