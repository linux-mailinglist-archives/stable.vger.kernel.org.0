Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBD34800A0
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhL0Prj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43840 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbhL0Ppe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479AB610B1;
        Mon, 27 Dec 2021 15:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A9DC36AEA;
        Mon, 27 Dec 2021 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619933;
        bh=CQpC9OArvoNuOk5bqrt53EJv9bDdHWzi2+L/SCXQuos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI1Zn+3pX4S4XNKyIcrjiY1HCaehOXhSg2BeZFPyULYoPSqwULcwbUYSMxwUh6pOt
         7LerGNZfcMsf2NwwlPU8bcmhroWz9hZQLt9WUFTg1neljwcUzWJx0ht8/o2H2m3DlE
         fcgEDPZc9+ekmnXfuTkWYwhkKZRl7+i/YdkBM29k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 088/128] KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
Date:   Mon, 27 Dec 2021 16:31:03 +0100
Message-Id: <20211227151334.453948167@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit cd0e615c49e5e5d69885af9ac3b4fa7bb3387f58 upstream.

Synthesize a triple fault if L2 guest state is invalid at the time of
VM-Enter, which can happen if L1 modifies SMRAM or if userspace stuffs
guest state via ioctls(), e.g. KVM_SET_SREGS.  KVM should never emulate
invalid guest state, since from L1's perspective, it's architecturally
impossible for L2 to have invalid state while L2 is running in hardware.
E.g. attempts to set CR0 or CR4 to unsupported values will either VM-Exit
or #GP.

Modifying vCPU state via RSM+SMRAM and ioctl() are the only paths that
can trigger this scenario, as nested VM-Enter correctly rejects any
attempt to enter L2 with invalid state.

RSM is a straightforward case as (a) KVM follows AMD's SMRAM layout and
behavior, and (b) Intel's SDM states that loading reserved CR0/CR4 bits
via RSM results in shutdown, i.e. there is precedent for KVM's behavior.
Following AMD's SMRAM layout is important as AMD's layout saves/restores
the descriptor cache information, including CS.RPL and SS.RPL, and also
defines all the fields relevant to invalid guest state as read-only, i.e.
so long as the vCPU had valid state before the SMI, which is guaranteed
for L2, RSM will generate valid state unless SMRAM was modified.  Intel's
layout saves/restores only the selector, which means that scenarios where
the selector and cached RPL don't match, e.g. conforming code segments,
would yield invalid guest state.  Intel CPUs fudge around this issued by
stuffing SS.RPL and CS.RPL on RSM.  Per Intel's SDM on the "Default
Treatment of RSM", paraphrasing for brevity:

  IF internal storage indicates that the [CPU was post-VMXON]
  THEN
     enter VMX operation (root or non-root);
     restore VMX-critical state as defined in Section 34.14.1;
     set to their fixed values any bits in CR0 and CR4 whose values must
     be fixed in VMX operation [unless coming from an unrestricted guest];
     IF RFLAGS.VM = 0 AND (in VMX root operation OR the
        “unrestricted guest” VM-execution control is 0)
     THEN
       CS.RPL := SS.DPL;
       SS.RPL := SS.DPL;
     FI;
     restore current VMCS pointer;
  FI;

Note that Intel CPUs also overwrite the fixed CR0/CR4 bits, whereas KVM
will sythesize TRIPLE_FAULT in this scenario.  KVM's behavior is allowed
as both Intel and AMD define CR0/CR4 SMRAM fields as read-only, i.e. the
only way for CR0 and/or CR4 to have illegal values is if they were
modified by the L1 SMM handler, and Intel's SDM "SMRAM State Save Map"
section states "modifying these registers will result in unpredictable
behavior".

KVM's ioctl() behavior is less straightforward.  Because KVM allows
ioctls() to be executed in any order, rejecting an ioctl() if it would
result in invalid L2 guest state is not an option as KVM cannot know if
a future ioctl() would resolve the invalid state, e.g. KVM_SET_SREGS, or
drop the vCPU out of L2, e.g. KVM_SET_NESTED_STATE.  Ideally, KVM would
reject KVM_RUN if L2 contained invalid guest state, but that carries the
risk of a false positive, e.g. if RSM loaded invalid guest state and KVM
exited to userspace.  Setting a flag/request to detect such a scenario is
undesirable because (a) it's extremely unlikely to add value to KVM as a
whole, and (b) KVM would need to consider ioctl() interactions with such
a flag, e.g. if userspace migrated the vCPU while the flag were set.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211207193006.120997-3-seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5866,18 +5866,14 @@ static int __vmx_handle_exit(struct kvm_
 		vmx_flush_pml_buffer(vcpu);
 
 	/*
-	 * We should never reach this point with a pending nested VM-Enter, and
-	 * more specifically emulation of L2 due to invalid guest state (see
-	 * below) should never happen as that means we incorrectly allowed a
-	 * nested VM-Enter with an invalid vmcs12.
+	 * KVM should never reach this point with a pending nested VM-Enter.
+	 * More specifically, short-circuiting VM-Entry to emulate L2 due to
+	 * invalid guest state should never happen as that means KVM knowingly
+	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
 	 */
 	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
 		return -EIO;
 
-	/* If guest state is invalid, start emulating */
-	if (vmx->emulation_required)
-		return handle_invalid_guest_state(vcpu);
-
 	if (is_guest_mode(vcpu)) {
 		/*
 		 * PML is never enabled when running L2, bail immediately if a
@@ -5899,10 +5895,30 @@ static int __vmx_handle_exit(struct kvm_
 		 */
 		nested_mark_vmcs12_pages_dirty(vcpu);
 
+		/*
+		 * Synthesize a triple fault if L2 state is invalid.  In normal
+		 * operation, nested VM-Enter rejects any attempt to enter L2
+		 * with invalid state.  However, those checks are skipped if
+		 * state is being stuffed via RSM or KVM_SET_NESTED_STATE.  If
+		 * L2 state is invalid, it means either L1 modified SMRAM state
+		 * or userspace provided bad state.  Synthesize TRIPLE_FAULT as
+		 * doing so is architecturally allowed in the RSM case, and is
+		 * the least awful solution for the userspace case without
+		 * risking false positives.
+		 */
+		if (vmx->emulation_required) {
+			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
+			return 1;
+		}
+
 		if (nested_vmx_reflect_vmexit(vcpu))
 			return 1;
 	}
 
+	/* If guest state is invalid, start emulating.  L2 is handled above. */
+	if (vmx->emulation_required)
+		return handle_invalid_guest_state(vcpu);
+
 	if (exit_reason.failed_vmentry) {
 		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;


