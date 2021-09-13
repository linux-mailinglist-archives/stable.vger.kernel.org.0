Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAEC408A2D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbhIMLaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239060AbhIMLaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6539B60F44;
        Mon, 13 Sep 2021 11:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532539;
        bh=4QnIZ3ofKb0mWAOnSTVvGbEwchGLkSGk2b1EyRlsKfQ=;
        h=Subject:To:Cc:From:Date:From;
        b=UNZqx7lhRUYvv/I81BAULb/xELtMjDn478KgVD5lQjie0pvWg/ySua6gN2jKIaDf7
         AZqxAz82xAl8qX7FukJg7Z2LAxSmJD72Io4778PEj2tYRFTxjP8UjqQOMoQdV38FhS
         sEqVA5Df6PoEJh1xirJZQj9riWs3mBW7G05sxxAQ=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Unconditionally clear nested.pi_pending on nested" failed to apply to 4.14-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:28:53 +0200
Message-ID: <16315325332497@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7782bb8d818d8f47c26b22079db10599922787a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Aug 2021 07:45:26 -0700
Subject: [PATCH] KVM: nVMX: Unconditionally clear nested.pi_pending on nested
 VM-Enter

Clear nested.pi_pending on nested VM-Enter even if L2 will run without
posted interrupts enabled.  If nested.pi_pending is left set from a
previous L2, vmx_complete_nested_posted_interrupt() will pick up the
stale flag and exit to userspace with an "internal emulation error" due
the new L2 not having a valid nested.pi_desc.

Arguably, vmx_complete_nested_posted_interrupt() should first check for
posted interrupts being enabled, but it's also completely reasonable that
KVM wouldn't screw up a fundamental flag.  Not to mention that the mere
existence of nested.pi_pending is a long-standing bug as KVM shouldn't
move the posted interrupt out of the IRR until it's actually processed,
e.g. KVM effectively drops an interrupt when it performs a nested VM-Exit
with a "pending" posted interrupt.  Fixing the mess is a future problem.

Prior to vmx_complete_nested_posted_interrupt() interpreting a null PI
descriptor as an error, this was a benign bug as the null PI descriptor
effectively served as a check on PI not being enabled.  Even then, the
new flow did not become problematic until KVM started checking the result
of kvm_check_nested_events().

Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Fixes: 966eefb89657 ("KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't mappable")
Fixes: 47d3530f86c0 ("KVM: x86: Exit to userspace when kvm_check_nested_events fails")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210810144526.2662272-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 264a9f4c9179..bc6327950657 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2187,12 +2187,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
-	if (nested_cpu_has_posted_intr(vmcs12)) {
+	vmx->nested.pi_pending = false;
+	if (nested_cpu_has_posted_intr(vmcs12))
 		vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
-		vmx->nested.pi_pending = false;
-	} else {
+	else
 		exec_control &= ~PIN_BASED_POSTED_INTR;
-	}
 	pin_controls_set(vmx, exec_control);
 
 	/*

