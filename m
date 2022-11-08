Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88106215CE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbiKHOPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKHOPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2668B59847
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6135B81B05
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39605C433C1;
        Tue,  8 Nov 2022 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916931;
        bh=fJOCNKvRcfEZBKf66GhhFB41losisquyfGEodIJOzoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu8rPUYtMrxqGO+PO2VKodl+JxRUrDfeWTq49rDmY8TY77GsJvIDV3u77GqHrXvtI
         0xaeVRnQbOLqt8wwDijhE//cRV7e1L89pe6BgNBa5Nsz6nXnst7obW5qdmgTAVNV1H
         K0L5nlopPzY4NQQAe2Z/NGgP63nsDJrBf1yHa6NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 177/197] KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL
Date:   Tue,  8 Nov 2022 14:40:15 +0100
Message-Id: <20221108133402.970524920@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit b333b8ebb85d62469f32b52fa03fd7d1522afc03 upstream.

Ignore guest CPUID for host userspace writes to the DEBUGCTL MSR, KVM's
ABI is that setting CPUID vs. state can be done in any order, i.e. KVM
allows userspace to stuff MSRs prior to setting the guest's CPUID that
makes the new MSR "legal".

Keep the vmx_get_perf_capabilities() check for guest writes, even though
it's technically unnecessary since the vCPU's PERF_CAPABILITIES is
consulted when refreshing LBR support.  A future patch will clean up
vmx_get_perf_capabilities() to avoid the RDMSR on every call, at which
point the paranoia will incur no meaningful overhead.

Note, prior to vmx_get_perf_capabilities() checking that the host fully
supports LBRs via x86_perf_get_lbr(), KVM effectively relied on
intel_pmu_lbr_is_enabled() to guard against host userspace enabling LBRs
on platforms without full support.

Fixes: c646236344e9 ("KVM: vmx/pmu: Add PMU_CAP_LBR_FMT check when guest LBR is enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221006000314.73240-5-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2016,16 +2016,16 @@ static u64 nested_vmx_truncate_sysenter_
 	return (unsigned long)data;
 }
 
-static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
+static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
 	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
 	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
-	    intel_pmu_lbr_is_enabled(vcpu))
+	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
 	return debugctl;
@@ -2100,7 +2100,9 @@ static int vmx_set_msr(struct kvm_vcpu *
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid = data & ~vcpu_supported_debugctl(vcpu);
+		u64 invalid;
+
+		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
 		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
 			if (report_ignored_msrs)
 				vcpu_unimpl(vcpu, "%s: BTF|LBR in IA32_DEBUGCTLMSR 0x%llx, nop\n",


