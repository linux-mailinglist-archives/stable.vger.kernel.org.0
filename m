Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E987461FA62
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiKGQtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiKGQtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:49:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBB126C0
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54AEACE1167
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147E0C433B5;
        Mon,  7 Nov 2022 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839755;
        bh=ZX0J9JO1aeZFFm5XdtSBS1/1TBgr+90l4UAW0hIOQiY=;
        h=Subject:To:Cc:From:Date:From;
        b=swKWKo+RFRl3UqFqnKmYp9YkPPI9ENwH99YWWINPm/N6mQlNdx6AAMjMrVGWZpKmJ
         9f9brJntMQVS/8gFqdoRfF5PX1U7S8Zp/s0CIujAxeXR26ae+S8jIfxObzvXEPbvFG
         QHWDao6UvtDxJdKXcXDSxvlTJAO6E3CW5c4XYbaw=
Subject: FAILED: patch "[PATCH] KVM: VMX: Fold vmx_supported_debugctl() into" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:49:06 +0100
Message-ID: <1667839746104229@kroah.com>
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

From 18e897d213cb152c786abab14919196bd9dc3a9f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 6 Oct 2022 00:03:09 +0000
Subject: [PATCH] KVM: VMX: Fold vmx_supported_debugctl() into
 vcpu_supported_debugctl()

Fold vmx_supported_debugctl() into vcpu_supported_debugctl(), its only
caller.  Setting bits only to clear them a few instructions later is
rather silly, and splitting the logic makes things seem more complicated
than they actually are.

Opportunistically drop DEBUGCTLMSR_LBR_MASK now that there's a single
reference to the pair of bits.  The extra layer of indirection provides
no meaningful value and makes it unnecessarily tedious to understand
what KVM is doing.

No functional change.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221006000314.73240-4-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3bd7a8970618..07254314f3dd 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -24,8 +24,6 @@ extern int __read_mostly pt_mode;
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
-#define DEBUGCTLMSR_LBR_MASK		(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
-
 struct nested_vmx_msrs {
 	/*
 	 * We only store the "true" versions of the VMX capability MSRs. We
@@ -421,19 +419,6 @@ static inline u64 vmx_get_perf_capabilities(void)
 	return perf_cap;
 }
 
-static inline u64 vmx_supported_debugctl(void)
-{
-	u64 debugctl = 0;
-
-	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
-		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
-
-	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
-		debugctl |= DEBUGCTLMSR_LBR_MASK;
-
-	return debugctl;
-}
-
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65f092e4a81b..981b38355066 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2023,13 +2023,15 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 
 static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 {
-	u64 debugctl = vmx_supported_debugctl();
+	u64 debugctl = 0;
 
-	if (!intel_pmu_lbr_is_enabled(vcpu))
-		debugctl &= ~DEBUGCTLMSR_LBR_MASK;
+	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
-		debugctl &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
+	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
+	    intel_pmu_lbr_is_enabled(vcpu))
+		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
 	return debugctl;
 }

