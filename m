Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C844F38F
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhKMORc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235743AbhKMORc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:17:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 800286108E;
        Sat, 13 Nov 2021 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636812880;
        bh=miqmCarj1u2rbFpDBKUnQnFGzCsfI9tlwbJw/jMxhwI=;
        h=Subject:To:Cc:From:Date:From;
        b=m40npEqXkiFWKkqIFKhnR2up3Dspn7Ykjaqsf4mNn1nPCHhrTKOmD6Ef+2VNNNls1
         q6qw9jRuisE+tz7AGyAkxWa5IPKbRNZyhcga7VKYMO4R+9/3rzWgtgeBnh6O5HG6NN
         dV9SgIJyYXMtw+tYNA/hUTGjUJUmkxXRWYz2oO0Y=
Subject: FAILED: patch "[PATCH] KVM: VMX: Unregister posted interrupt wakeup handler on" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:14:22 +0100
Message-ID: <1636812862153167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec5a4919fa7b7d8c7a2af1c7e799b1fe4be84343 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Oct 2021 17:11:05 -0700
Subject: [PATCH] KVM: VMX: Unregister posted interrupt wakeup handler on
 hardware unsetup

Unregister KVM's posted interrupt wakeup handler during unsetup so that a
spurious interrupt that arrives after kvm_intel.ko is unloaded doesn't
call into freed memory.

Fixes: bf9f6ac8d749 ("KVM: Update Posted-Interrupts Descriptor when vCPU is blocked")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009001107.3936588-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f677e72d864..c11688f64e80 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7555,6 +7555,8 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
+	kvm_set_posted_intr_wakeup_handler(NULL);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7885,8 +7887,6 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-
 	kvm_mce_cap_supported |= MCG_LMCE_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
@@ -7910,6 +7910,9 @@ static __init int hardware_setup(void)
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
+
+	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+
 	return r;
 }
 

