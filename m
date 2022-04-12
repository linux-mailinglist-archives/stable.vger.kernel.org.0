Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8574FD193
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242990AbiDLG7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351568AbiDLGx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF4D18B2F;
        Mon, 11 Apr 2022 23:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F2E60A77;
        Tue, 12 Apr 2022 06:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8C7C385A1;
        Tue, 12 Apr 2022 06:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745788;
        bh=fCbT5cPgi0qm1bVKA02uFEpXHPIrJ6j2CCR1fbxdDpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onnyFflClAhPmMco+RE9NQbw0Nn8k3ezX2gjxoTB4jWUoUw1V54/wvZShoBdrPbL3
         EhcOBq9wCb/VwoMiO80BO82j+qqbvQ6aKcQUxMF7feMvyrjNlCivpGlexNSjkIggD4
         Cq4IJWNQVLByvInEV0SXFWpHjwJ512Z/g1ybTy1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/277] KVM: x86/pmu: Use different raw event masks for AMD and Intel
Date:   Tue, 12 Apr 2022 08:26:54 +0200
Message-Id: <20220412062942.362373311@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 95b065bf5c431c06c68056a03a5853b660640ecc ]

The third nybble of AMD's event select overlaps with Intel's IN_TX and
IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
platforms that support TSX.

Declare a raw_event_mask in the kvm_pmu structure, initialize it in
the vendor-specific pmu_refresh() functions, and use that mask for
PERF_TYPE_RAW configurations in reprogram_gp_counter().

Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220308012452.3468611-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/pmu.c              | 3 ++-
 arch/x86/kvm/svm/pmu.c          | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01759199d723..d9bb5cdb5db2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 raw_event_mask;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f256f01056bd..44a5ab91a99d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -178,6 +178,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -217,7 +218,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+		config = eventsel & pmu->raw_event_mask;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 06f8034f62e4..369164368819 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -283,6 +283,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
+	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6427d95de01c..db1b88445acb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -478,6 +478,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
-- 
2.35.1



