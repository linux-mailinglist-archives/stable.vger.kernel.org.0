Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1066000E7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJPPsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiJPPr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:47:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6551E33841
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DADCCCE0E11
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E26C433D6;
        Sun, 16 Oct 2022 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935275;
        bh=UtLYMgQWQjOBEpQdalkgs+JRkRU43EOvF8ScqlbEO6w=;
        h=Subject:To:Cc:From:Date:From;
        b=q81NzM0T4rALwSkRqjxF/mrJU/EMNyPq6f0JIN9G3aoa9KZY4tSSA5TFWZCY8trhG
         MN1auO3E4dJYJPZKz3nVA444bZpIdhu1+Z++xvvUpF2i3phlpYsKhwBOE0U5W/dy0E
         3T5QxytwkONA7FXo3JzWaZu6Slf6o5juPwxPXgQQ=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Make an event request when pending an MTF nested" failed to apply to 5.10-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:48:29 +0200
Message-ID: <166593530932141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2ea89c7f7f7b ("KVM: nVMX: Make an event request when pending an MTF nested VM-Exit")
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

From 2ea89c7f7f7b192e32d1842dafc2e972cd14329b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Sep 2022 00:31:51 +0000
Subject: [PATCH] KVM: nVMX: Make an event request when pending an MTF nested
 VM-Exit

Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
through inject_pending_event() and thus vmx_check_nested_events() prior
to re-entering the guest.

MTF currently works by virtue of KVM's hack that calls
kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
be removed in the near future.  Until that call is removed, the patch
introduces no real functional change.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220921003201.1441511-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 85318d803f4f..3a080051a4ec 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6632,6 +6632,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto error_guest_mode;
 
+	if (vmx->nested.mtf_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return 0;
 
 error_guest_mode:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94c314dc2393..9dba04b6b019 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1665,10 +1665,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	    (!vcpu->arch.exception.pending ||
 	     vcpu->arch.exception.vector == DB_VECTOR) &&
 	    (!vcpu->arch.exception_vmexit.pending ||
-	     vcpu->arch.exception_vmexit.vector == DB_VECTOR))
+	     vcpu->arch.exception_vmexit.vector == DB_VECTOR)) {
 		vmx->nested.mtf_pending = true;
-	else
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	} else {
 		vmx->nested.mtf_pending = false;
+	}
 }
 
 static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)

