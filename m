Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273BD664A42
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbjAJSbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbjAJSas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C9F2189
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66ECBCE18E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1ABC433EF;
        Tue, 10 Jan 2023 18:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375152;
        bh=vq1hLRbfBe5Zm1RWvzGNGvQGbBfT9Sm2KN97pI4VIfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiO2B84MGSF3NTsFnL0l8l+FawkXY333yHRdInTw+PWnQjrWjeSq7CRnrQ+u7F+Th
         AyWGx0iO937KCV/GLqitrpaQMzMSB/DQeIWUcbOftwAR1gwH0ZdHay4ilec/1bVpFJ
         4EKr2DINf1EuG+6kWg7WDBgb50ndtievZ7PB49Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Li <ercli@ucdavis.edu>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 094/290] KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
Date:   Tue, 10 Jan 2023 19:03:06 +0100
Message-Id: <20230110180034.864395677@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
@@ -4970,24 +4970,35 @@ static int handle_vmon(struct kvm_vcpu *
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
@@ -4997,6 +5008,17 @@ static int handle_vmon(struct kvm_vcpu *
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


