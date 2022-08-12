Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A14591309
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiHLPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiHLPdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 11:33:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCA88284C
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 08:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 981DDCE259B
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8948FC433C1;
        Fri, 12 Aug 2022 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660318395;
        bh=SJXL+Vf0NkaTDQlbXWfqnCOUjykuleLHCOWh3qHxU6E=;
        h=Subject:To:Cc:From:Date:From;
        b=NaO/530x5GgDk5UyhWvRoMM9aQpkw6ABoqkLJtNQrR53bI/jR60Spg/1BYhE7qWD0
         M0MlIbZ7BttyGAap7qlTB0vjGh6MjJRLzNN23a6LLtiltB39Ubzg+9fUNdBvqsxaxN
         EEYonGBgFE2gCpvaeQmaXB/s3VdOx0Z1XAo7wk58=
Subject: FAILED: patch "[PATCH] KVM: VMX: Add helper to check if the guest PMU has" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 17:32:52 +0200
Message-ID: <1660318372145153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b663f0b5f3d665c261256d1f76e98f077c6e56af Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 22 Jul 2022 22:44:07 +0000
Subject: [PATCH] KVM: VMX: Add helper to check if the guest PMU has
 PERF_GLOBAL_CTRL

Add a helper to check of the guest PMU has PERF_GLOBAL_CTRL, which is
unintuitive _and_ diverges from Intel's architecturally defined behavior.
Even worse, KVM currently implements the check using two different (but
equivalent) checks, _and_ there has been at least one attempt to add a
_third_ flavor.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220722224409.1336532-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6e355c5d2f40..78f2800fd850 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -111,7 +111,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (pmu->version < 2)
+	if (!intel_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
@@ -207,7 +207,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		ret = pmu->version > 1;
+		return intel_pmu_has_perf_global_ctrl(pmu);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 286c88e285ea..2a0b94e0fda7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -91,6 +91,18 @@ union vmx_exit_reason {
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
 

