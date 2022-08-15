Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C645F59512F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiHPEw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiHPEvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B747A19F4BF;
        Mon, 15 Aug 2022 13:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E106103F;
        Mon, 15 Aug 2022 20:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4226C433C1;
        Mon, 15 Aug 2022 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596525;
        bh=65v5R84eOGAgGCGuIaLe2DkBsygBijgD/MYNP/um+EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHbNEX2++Ig07j4Y0RvjCESs3rj0pC6Mqwx3NPjHfYdudy2yNASCte3DdBfdpgNGU
         6FU5tYDOWlWotKRRJCnHzgnro5mS2TTndeEZWZTWGDNU+RjRGwrazfQkEWIOhZq5SS
         nCyuWmUgmto+7nbJphWRrFAmLUUj6BCPk6EgluY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1107/1157] KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL
Date:   Mon, 15 Aug 2022 20:07:43 +0200
Message-Id: <20220815180524.564356605@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b663f0b5f3d665c261256d1f76e98f077c6e56af ]

Add a helper to check of the guest PMU has PERF_GLOBAL_CTRL, which is
unintuitive _and_ diverges from Intel's architecturally defined behavior.
Even worse, KVM currently implements the check using two different (but
equivalent) checks, _and_ there has been at least one attempt to add a
_third_ flavor.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220722224409.1336532-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/pmu_intel.c |  4 ++--
 arch/x86/kvm/vmx/vmx.h       | 12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8faac421171f..a9280ebf78f5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -98,7 +98,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (pmu->version < 2)
+	if (!intel_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
@@ -215,7 +215,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		ret = pmu->version > 1;
+		return intel_pmu_has_perf_global_ctrl(pmu);
 		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1e7f9453894b..93aa1f3ea01e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -92,6 +92,18 @@ union vmx_exit_reason {
 	u32 full;
 };
 
+static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
+{
+	/*
+	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
+	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
+	 * greater than zero.  However, KVM only exposes and emulates the MSR
+	 * to/for the guest if the guest PMU supports at least "Architectural
+	 * Performance Monitoring Version 2".
+	 */
+	return pmu->version > 1;
+}
+
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
-- 
2.35.1



