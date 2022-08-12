Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D547591263
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 16:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiHLOlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 10:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiHLOlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 10:41:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A5E98C89
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 07:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBB98CE2574
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CF0C433D6;
        Fri, 12 Aug 2022 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660315278;
        bh=KN9RDcI3akAmp7w6lDuAmRdckSUvk6zSSRnd9jJfwkc=;
        h=Subject:To:Cc:From:Date:From;
        b=ivcevQ3sgCW0MdOOKZms6ju0BtfndVGcKQZarjl1stdfthv1hkwCz2HKLyiR8nn/P
         t7qlC1Z8/kfpl6CutagVG1NHp2NkuEFCvxQ51QFEwDaG/Y/WgWOIy92HGshi0JimQW
         MY2XlCrhZUcFDm+H9D8Syhz4/hMgIu16z53seEeo=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff" failed to apply to 5.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 16:41:15 +0200
Message-ID: <1660315275123213@kroah.com>
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4496a6f9b45e8cd83343ad86a3984d614e22cf54 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 22 Jul 2022 22:44:08 +0000
Subject: [PATCH] KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff
 it exists

Attempt to load PERF_GLOBAL_CTRL during nested VM-Enter/VM-Exit if and
only if the MSR exists (according to the guest vCPU model).  KVM has very
misguided handling of VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL and
attempts to force the nVMX MSR settings to match the vPMU model, i.e. to
hide/expose the control based on whether or not the MSR exists from the
guest's perspective.

KVM's modifications fail to handle the scenario where the vPMU is hidden
from the guest _after_ being exposed to the guest, e.g. by userspace
doing multiple KVM_SET_CPUID2 calls, which is allowed if done before any
KVM_RUN.  nested_vmx_pmu_refresh() is called if and only if there's a
recognized vPMU, i.e. KVM will leave the bits in the allow state and then
ultimately reject the MSR load and WARN.

KVM should not force the VMX MSRs in the first place.  KVM taking control
of the MSRs was a misguided attempt at mimicking what commit 5f76f6f5ff96
("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled",
2018-10-01) did for MPX.  However, the MPX commit was a workaround for
another KVM bug and not something that should be imitated (and it should
never been done in the first place).

In other words, KVM's ABI _should_ be that userspace has full control
over the MSRs, at which point triggering the WARN that loading the MSR
must not fail is trivial.

The intent of the WARN is still valid; KVM has consistency checks to
ensure that vmcs12->{guest,host}_ia32_perf_global_ctrl is valid.  The
problem is that '0' must be considered a valid value at all times, and so
the simple/obvious solution is to just not actually load the MSR when it
does not exist.  It is userspace's responsibility to provide a sane vCPU
model, i.e. KVM is well within its ABI and Intel's VMX architecture to
skip the loads if the MSR does not exist.

Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220722224409.1336532-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c1c85fd75d42..819cfd926954 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2623,6 +2623,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
@@ -4333,7 +4334,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 

