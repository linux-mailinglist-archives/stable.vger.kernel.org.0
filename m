Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE72DD1659
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbfJIRYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732155AbfJIRYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:09 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAC9121D71;
        Wed,  9 Oct 2019 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641848;
        bh=5AlLPhD4yO09XfSZ0TEnVnoz8yf0tp9B6US8uShCF+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLNpg9A/SHR3tM5p/tM7wrvACU7rA4bV58ZK7r5xJgH1PJS3o7rM1vX/PHksNG/yc
         4Dy6SNneYdGov+7XV+JLTSoMxV94zLJ/rs9twuoiHBz1omUKBd2EMYZmyEoTFganr7
         fEcyseZ8g6Zy8O9Gk39CyuVoyf6VpmW/DffcGUKo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/26] kvm: vmx: Limit guest PMCs to those supported on the host
Date:   Wed,  9 Oct 2019 13:05:47 -0400
Message-Id: <20191009170558.32517-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit e1fba49cc1e965a3dacd897367ba1e7b340cf0f4 ]

KVM can only virtualize as many PMCs as the host supports.

Limit the number of generic counters and fixed counters to the number
of corresponding counters supported on the host, rather than to
INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.

Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
contiguous MSR indices reserved by Intel for event selectors. Since
the existing code relies on a contiguous range of MSR indices for
event selectors, it can't possibly work for more than 18 general
purpose counters.

Fixes: f5132b01386b5a ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu_intel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/pmu_intel.c
index c3f103e2b08e1..0fd2a511605b5 100644
--- a/arch/x86/kvm/pmu_intel.c
+++ b/arch/x86/kvm/pmu_intel.c
@@ -265,6 +265,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -286,8 +287,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	perf_get_x86_pmu_capability(&x86_pmu);
+
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
-					INTEL_PMC_MAX_GENERIC);
+					 x86_pmu.num_counters_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
@@ -297,7 +300,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	} else {
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
-				INTEL_PMC_MAX_FIXED);
+			      x86_pmu.num_counters_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
-- 
2.20.1

