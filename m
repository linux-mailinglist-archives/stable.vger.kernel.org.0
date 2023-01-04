Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFAD65D89F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbjADQQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbjADQQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:16:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C7442E2C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:16:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56565B8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFB9C43392;
        Wed,  4 Jan 2023 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848967;
        bh=SnyqLqmv7BeHpxquiDuAgMIxqeZGsC5N0ylfD47dEaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI9/imKpuHaEHQuFv28RR7wEcahpy28gIROZLx/lo1lP7fu6gzUlpVlX0o6eb3UDR
         kKajT80tVUkSpUnRcJg1Gw817OoP33nvQMwgT45PBvFmoVBpK3RI4Bw25V47H/qN8A
         4AHRNuZJD/3gjAIpzESltL4IdU2sNsQOqinjk2ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Li <ercli@ucdavis.edu>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 083/207] KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
Date:   Wed,  4 Jan 2023 17:05:41 +0100
Message-Id: <20230104160514.572721684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 9cc409325ddd776f6fd6293d5ce93ce1248af6e4 upstream.

Inject #GP for if VMXON is attempting with a CR0/CR4 that fails the
generic "is CRx valid" check, but passes the CR4.VMXE check, and do the
generic checks _after_ handling the post-VMXON VM-Fail.

The CR4.VMXE check, and all other #UD cases, are special pre-conditions
that are enforced prior to pivoting on the current VMX mode, i.e. occur
before interception if VMXON is attempted in VMX non-root mode.

All other CR0/CR4 checks generate #GP and effectively have lower priority
than the post-VMXON check.

Per the SDM:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD;
    ELSIF not in VMX operation
        THEN
            IF (CPL > 0) or (in A20M mode) or
            (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);
    ELSIF in VMX non-root operation
        THEN VMexit;
    ELSIF CPL > 0
        THEN #GP(0);
    ELSE VMfail("VMXON executed in VMX root operation");
    FI;

which, if re-written without ELSIF, yields:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD

    IF in VMX non-root operation
        THEN VMexit;

    IF CPL > 0
        THEN #GP(0)

    IF in VMX operation
        THEN VMfail("VMXON executed in VMX root operation");

    IF (in A20M mode) or
       (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);

Note, KVM unconditionally forwards VMXON VM-Exits that occur in L2 to L1,
i.e. there is no need to check the vCPU is not in VMX non-root mode.  Add
a comment to explain why unconditionally forwarding such exits is
functionally correct.

Reported-by: Eric Li <ercli@ucdavis.edu>
Fixes: c7d855c2aff2 ("KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20221006001956.329314-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5100,24 +5100,35 @@ static int handle_vmxon(struct kvm_vcpu
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
-	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
-	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
-	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 * Manually check CR4.VMXE checks, KVM must force CR4.VMXE=1 to enter
+	 * the guest and so cannot rely on hardware to perform the check,
+	 * which has higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON).
 	 *
-	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
-	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
-	 * Mode, but KVM will never take the guest out of those modes.
+	 * Rely on hardware for the other pre-VM-Exit checks, CR0.PE=1, !VM86
+	 * and !COMPATIBILITY modes.  For an unrestricted guest, KVM doesn't
+	 * force any of the relevant guest state.  For a restricted guest, KVM
+	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
+	 * Real Mode, and so there's no need to check CR0.PE manually.
 	 */
-	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
-	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
 	/*
-	 * CPL=0 and all other checks that are lower priority than VM-Exit must
-	 * be checked manually.
+	 * The CPL is checked for "not in VMX operation" and for "in VMX root",
+	 * and has higher priority than the VM-Fail due to being post-VMXON,
+	 * i.e. VMXON #GPs outside of VMX non-root if CPL!=0.  In VMX non-root,
+	 * VMXON causes VM-Exit and KVM unconditionally forwards VMXON VM-Exits
+	 * from L2 to L1, i.e. there's no need to check for the vCPU being in
+	 * VMX non-root.
+	 *
+	 * Forwarding the VM-Exit unconditionally, i.e. without performing the
+	 * #UD checks (see above), is functionally ok because KVM doesn't allow
+	 * L1 to run L2 without CR4.VMXE=0, and because KVM never modifies L2's
+	 * CR0 or CR4, i.e. it's L2's responsibility to emulate #UDs that are
+	 * missed by hardware due to shadowing CR0 and/or CR4.
 	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
@@ -5127,6 +5138,17 @@ static int handle_vmxon(struct kvm_vcpu
 	if (vmx->nested.vmxon)
 		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 
+	/*
+	 * Invalid CR0/CR4 generates #GP.  These checks are performed if and
+	 * only if the vCPU isn't already in VMX operation, i.e. effectively
+	 * have lower priority than the VM-Fail above.
+	 */
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
 		kvm_inject_gp(vcpu, 0);


