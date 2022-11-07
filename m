Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4036C61FA63
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiKGQtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiKGQtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:49:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838D2193DE
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20B16611BD
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E680C433B5;
        Mon,  7 Nov 2022 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839758;
        bh=UqG+Sp9YiJOWwTjQHyjSzxbR50iI/CyY7nXSLh9MaC8=;
        h=Subject:To:Cc:From:Date:From;
        b=ekIiEEtEPRikhSCmdxV0I+yqKjCdOUbh46sozpe/c/HasQ2QZfWeb7B2EbJ8R1/8Y
         CFYtEWoYW3Xj4NmpZ+QYxhbMxCxQxirgkeIN0d0MKZF/i34/vMQxwa05CGIH8DKJgf
         NQu+DA3xnKyjOkQfmkXNuPlEgwecuURfsCzdl5zk=
Subject: FAILED: patch "[PATCH] KVM: VMX: Ignore guest CPUID for host userspace writes to" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:49:12 +0100
Message-ID: <1667839752135165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

b333b8ebb85d ("KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL")
18e897d213cb ("KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()")
2f4073e08f4c ("KVM: VMX: Enable Notify VM exit")
938c8745bcf2 ("KVM: x86: Introduce "struct kvm_caps" to track misc caps/settings")
ed2351174e38 ("KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault")
35875316384b ("KVM: x86: Allow userspace to set maximum VCPU id for VM")
e9bf3acb23f0 ("KVM: s390: Add KVM_CAP_S390_PROTECTED_DUMP")
8aba09588d2a ("KVM: s390: Add CPU dump functionality")
0460eb35b443 ("KVM: s390: Add configuration dump functionality")
35d02493dba1 ("KVM: s390: pv: Add query interface")
47e8eec83262 ("Merge tag 'kvmarm-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b333b8ebb85d62469f32b52fa03fd7d1522afc03 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 6 Oct 2022 00:03:10 +0000
Subject: [PATCH] KVM: VMX: Ignore guest CPUID for host userspace writes to
 DEBUGCTL

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

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 981b38355066..63247c57c72c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2021,16 +2021,16 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
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
@@ -2105,7 +2105,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

