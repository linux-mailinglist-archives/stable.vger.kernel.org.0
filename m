Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65795594A34
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244334AbiHOX2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344421AbiHOX0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680F88051D;
        Mon, 15 Aug 2022 13:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1698AB80EAB;
        Mon, 15 Aug 2022 20:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E4EC433D6;
        Mon, 15 Aug 2022 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594005;
        bh=BxxQGjGKz5O0tnAGdtnCyKK1ppGvz7kj0lavPH7jdEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzC6kd5icMBraJ47qteRWd7q5uZSZeXAwK6zkGjX/qS22eJLvWlfO7Fu4BggxMtK9
         EB1Je50px1k8HukTtfyNjU3tbSHh06OrLXIHWsaObDWIKI3QRieBgiQF1lP/09zuX5
         4vQLHIEzMnv2WEBdEk71upVeD2Y6lTsdrzFMMWaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1041/1095] KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff it exists
Date:   Mon, 15 Aug 2022 20:07:20 +0200
Message-Id: <20220815180512.159575135@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 4496a6f9b45e8cd83343ad86a3984d614e22cf54 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aa287302f991..5c62e552082a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2621,6 +2621,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
@@ -4346,7 +4347,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
-- 
2.35.1



