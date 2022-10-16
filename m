Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56956000E4
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPPrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJPPrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:47:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A8D38699
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 559C4CE0E02
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7708FC433D7;
        Sun, 16 Oct 2022 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935260;
        bh=f+HGSM9mWzNMv485EqN+ce1PygsYQuEc+2qLlXGg4cc=;
        h=Subject:To:Cc:From:Date:From;
        b=z3AACW1R1yWZfmKAkUpghJgR9r4yMm7SZebcQTZxkSh4EREk4pJJEpPGcF9paq1/8
         s+pYjE9i4wdUsNt9yIqfH82TUheVpD+hSa7h5IVX8nZEVrkIpW6PIz9PsKlPTd76oo
         y58agYOnFKPwbpF1an27IWZYABbqEI3VO7/jvfMw=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Make an event request when pending an MTF nested" failed to apply to 6.0-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:48:27 +0200
Message-ID: <16659353074972@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
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

