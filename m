Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E140463D57E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiK3MXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiK3MWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:22:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F2615706
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3620A61B91
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4787FC433D6;
        Wed, 30 Nov 2022 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810973;
        bh=OOTuHw63T1XDE9HKcD+JSR81qTEJ/75JSeh0/FiFEiE=;
        h=Subject:To:Cc:From:Date:From;
        b=PEU+CLEt69Hil3qNlqNHCMsiU3qUjVTEzQY1UyJQo/6nu+FAb5bqbkYezSQ0O8b1W
         dc5qKb9+n6uqG/bP7ssrC6ZG8jCHfWUJNovCWWx7+KODmGG9A80kLPNuBq9rXFDBnC
         Qu+SGb8k1lZt+RK+iX80ZRkIwePajNuBANRaJVjw=
Subject: FAILED: patch "[PATCH] KVM: x86: add kvm_leave_nested" failed to apply to 4.9-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:22:37 +0100
Message-ID: <1669810957166125@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f9697df25143 ("KVM: x86: add kvm_leave_nested")
7709aba8f716 ("KVM: x86: Morph pending exceptions to pending VM-Exits at queue time")
28360f887068 ("KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential VM-Exit")
6c593b5276e6 ("KVM: x86: Hoist nested event checks above event injection logic")
72c14e00bdc4 ("KVM: x86: Formalize blocking of nested pending exceptions")
d4963e319f1f ("KVM: x86: Make kvm_queued_exception a properly named, visible struct")
593a5c2e3c12 ("KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit")
5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
b9d44f9091ac ("KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag")
8d178f460772 ("KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like")
eba9799b5a6e ("KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS")
2d61391270a3 ("KVM: x86: Differentiate Soft vs. Hard IRQs vs. reinjected in tracepoint")
a61d7c5432ac ("KVM: x86: Trace re-injected exceptions")
6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
3741aec4c38f ("KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported")
cd9e6da8048c ("KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"")
00f08d99dd7d ("KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02")
b699da3dc279 ("Merge tag 'kvm-riscv-5.19-1' of https://github.com/kvm-riscv/linux into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9697df251438b0798780900e8b43bdb12a56d64 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:45 +0200
Subject: [PATCH] KVM: x86: add kvm_leave_nested

add kvm_leave_nested which wraps a call to nested_ops->leave_nested
into a function.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b02a3a1792f1..7354f0035a69 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1146,9 +1146,6 @@ void svm_free_nested(struct vcpu_svm *svm)
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..f7333b9cdfbc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6440,9 +6440,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ecea83f0da49..ff5be7189237 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -628,6 +628,12 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
 	ex->payload = payload;
 }
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -5195,7 +5201,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 

