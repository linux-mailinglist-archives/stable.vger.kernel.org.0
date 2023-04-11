Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA5F6DD889
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDKLAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDKLAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614F43AAA
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90D062168
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C2EC4339B;
        Tue, 11 Apr 2023 11:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210843;
        bh=yC+RXPGdw8mTcmAhYzMg4i5jPFCGw65ZWk4jHRPi4zs=;
        h=Subject:To:Cc:From:Date:From;
        b=yrG+Iox4VUvDD7Fi4kiTKGhRiaXv5s8uMIE+TQDB+SHK+c/238o1OtuglEpfktZ4J
         SmhXZQzI/Zk4B7nhqP6IcjiboC6STNAn7+x7L/pfNZfloU2nwisMqEkbkKqxouM/kg
         pib2EkJp866SFTXcZFMdqq2wnodRfMnzB+Whk10A=
Subject: FAILED: patch "[PATCH] KVM: x86: Clear "has_error_code", not "error_code", for RM" failed to apply to 5.4-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:00:36 +0200
Message-ID: <2023041136-spoiling-scoured-c3b4@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 6c41468c7c12d74843bb414fc00307ea8a6318c3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041136-spoiling-scoured-c3b4@gregkh' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

6c41468c7c12 ("KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection")
d4963e319f1f ("KVM: x86: Make kvm_queued_exception a properly named, visible struct")
6ad75c5c99f7 ("KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception")
5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
8d178f460772 ("KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like")
eba9799b5a6e ("KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS")
a61d7c5432ac ("KVM: x86: Trace re-injected exceptions")
6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
3741aec4c38f ("KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported")
cd9e6da8048c ("KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"")
00f08d99dd7d ("KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02")
9bd1f0efa859 ("KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault")
c3634d25fbee ("KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry")
1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
db663af4a001 ("kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense")
b9f3973ab3a8 ("KVM: x86: nSVM: implement nested VMLOAD/VMSAVE")
23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
e27bc0440ebd ("KVM: x86: Rename kvm_x86_ops pointers to align w/ preferred vendor names")
068f7ea61895 ("KVM: SVM: improve split between svm_prepare_guest_switch and sev_es_prepare_guest_switch")
e1779c2714c3 ("KVM: x86: nSVM: fix potential NULL derefernce on nested migration")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c41468c7c12d74843bb414fc00307ea8a6318c3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 22 Mar 2023 07:32:59 -0700
Subject: [PATCH] KVM: x86: Clear "has_error_code", not "error_code", for RM
 exception injection

When injecting an exception into a vCPU in Real Mode, suppress the error
code by clearing the flag that tracks whether the error code is valid, not
by clearing the error code itself.  The "typo" was introduced by recent
fix for SVM's funky Paged Real Mode.

Opportunistically hoist the logic above the tracepoint so that the trace
is coherent with respect to what is actually injected (this was also the
behavior prior to the buggy commit).

Fixes: b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230322143300.2209476-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45017576ad5e..7d6f98b7635f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9908,13 +9908,20 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Suppress the error code if the vCPU is in Real Mode, as Real Mode
+	 * exceptions don't report error codes.  The presence of an error code
+	 * is carried with the exception and only stripped when the exception
+	 * is injected as intercepted #PF VM-Exits for AMD's Paged Real Mode do
+	 * report an error code despite the CPU being in Real Mode.
+	 */
+	vcpu->arch.exception.has_error_code &= is_protmode(vcpu);
+
 	trace_kvm_inj_exception(vcpu->arch.exception.vector,
 				vcpu->arch.exception.has_error_code,
 				vcpu->arch.exception.error_code,
 				vcpu->arch.exception.injected);
 
-	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_inject_exception)(vcpu);
 }
 

