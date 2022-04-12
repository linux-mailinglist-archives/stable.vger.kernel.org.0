Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34D34FD880
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356072AbiDLHeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355657AbiDLH1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061494EDE3;
        Tue, 12 Apr 2022 00:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9D61616B2;
        Tue, 12 Apr 2022 07:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECFCC385A1;
        Tue, 12 Apr 2022 07:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747278;
        bh=Izilb6B/7THa28ox0iEsc8os9I9I2KEyl0YBu3Tqam0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIqqSlxcUwhcIuZpQ6fgToA/RU77+hWgn5DIgiRz4H58g8gHNq8S+ZzCKJK+iNskh
         khU2/0Iu/nqi7iSpBgLzJG3gxQ9OTRiJWqhZ5oHVkY+PI43uDRWGw+Ur88ayOWemgq
         ZYAHBHHxdvuEc1dmWRBTVlvoZ5HC3bhAQdOV5Ibk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 006/343] KVM: x86/pmu: Use different raw event masks for AMD and Intel
Date:   Tue, 12 Apr 2022 08:27:04 +0200
Message-Id: <20220412062951.286087957@linuxfoundation.org>
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
index ec9830d2aabf..17b4e1808b8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -509,6 +509,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 raw_event_mask;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..902b6d700215 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -185,6 +185,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -221,7 +222,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+		config = eventsel & pmu->raw_event_mask;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5aa45f13b16d..7cc664b4472a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -284,6 +284,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
+	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..8ba12294a7c5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -485,6 +485,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !enable_pmu)
-- 
2.35.1



