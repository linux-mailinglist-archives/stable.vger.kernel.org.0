Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229544FDAEA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356114AbiDLHeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352344AbiDLH2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:28:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189674F452;
        Tue, 12 Apr 2022 00:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3740B81B50;
        Tue, 12 Apr 2022 07:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB5DC385A6;
        Tue, 12 Apr 2022 07:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747286;
        bh=2QzFLpKuDfKD58gEd49LRz6JCO86eIm3Yu/3IGO+lDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYc3/AHNnYNW7dDTYK71cURAqdz+cAVDghi4qsac88+vjciEtTKLR8/qPesMyDEsn
         yismtYqYsY742C2KD3TKK/E3IFspvozc5Y2AU3YO+8FdxO4EvmKbkuBFPZA9/z45T9
         VFBD6HYG+ZIr8gTZm9yNdFv70PEnr2Wuj7FkbTQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 009/343] KVM: x86/pmu: Fix and isolate TSX-specific performance event logic
Date:   Tue, 12 Apr 2022 08:27:07 +0200
Message-Id: <20220412062951.373345079@linuxfoundation.org>
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

From: Like Xu <likexu@tencent.com>

[ Upstream commit e644896f5106aa3f6d7e8c7adf2e4dc0fce53555 ]

HSW_IN_TX* bits are used in generic code which are not supported on
AMD. Worse, these bits overlap with AMD EventSelect[11:8] and hence
using HSW_IN_TX* bits unconditionally in generic code is resulting in
unintentional pmu behavior on AMD. For example, if EventSelect[11:8]
is 0x2, pmc_reprogram_counter() wrongly assumes that
HSW_IN_TX_CHECKPOINTED is set and thus forces sampling period to be 0.

Also per the SDM, both bits 32 and 33 "may only be set if the processor
supports HLE or RTM" and for "IN_TXCP (bit 33): this bit may only be set
for IA32_PERFEVTSEL2."

Opportunistically eliminate code redundancy, because if the HSW_IN_TX*
bit is set in pmc->eventsel, it is already set in attr.config.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reported-by: Jim Mattson <jmattson@google.com>
Fixes: 103af0a98788 ("perf, kvm: Support the in_tx/in_tx_cp modifiers in KVM arch perfmon emulation v5")
Co-developed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20220309084257.88931-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c           | 15 +++++----------
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 902b6d700215..eca39f56c231 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -96,8 +96,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
-				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool exclude_kernel, bool intr)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -116,16 +115,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
-	if (in_tx)
-		attr.config |= HSW_IN_TX;
-	if (in_tx_cp) {
+	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
+	    guest_cpuid_is_intel(pmc->vcpu)) {
 		/*
 		 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
 		 * period. Just clear the sample period so at least
 		 * allocating the counter doesn't fail.
 		 */
 		attr.sample_period = 0;
-		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -233,9 +230,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	pmc_reprogram_counter(pmc, type, config,
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
+			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
@@ -271,7 +266,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+			      pmi);
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8ba12294a7c5..5fa3870b8988 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -389,6 +389,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 reserved_bits;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -443,7 +444,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
 				return 0;
-			if (!(data & pmu->reserved_bits)) {
+			reserved_bits = pmu->reserved_bits;
+			if ((pmc->idx == 2) &&
+			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
+				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
+			if (!(data & reserved_bits)) {
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
@@ -534,8 +539,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
-	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
-		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM))) {
+		pmu->reserved_bits ^= HSW_IN_TX;
+		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+	}
 
 	bitmap_set(pmu->all_valid_pmc_idx,
 		0, pmu->nr_arch_gp_counters);
-- 
2.35.1



