Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06CA468AD1
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhLEMjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:39:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32828 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:39:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C2860FD2
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277C4C341C8;
        Sun,  5 Dec 2021 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638707774;
        bh=4yRq94ERCyFZ6dw4dVcP4t9v85qcARo8omK47RKSfFE=;
        h=Subject:To:Cc:From:Date:From;
        b=tGFXIhdglgZvRPtRqn0M6J00QiwQoXDMpiq8LQo6AueDk45C+q1Vbz9e8T/KHccpK
         LNVdxEyuRBEt+g+vPgoEZRSJ4dZ60TLNYAD/iNC1RIdlN496hOK6DLmNPuf7QpAOi7
         eHNBXRYJPdio3GMuqrBxUhL8sQ9MSFeKHXhv+c00=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with" failed to apply to 5.4-stable tree
To:     seanjc@google.com, jiangshanlai+lkml@gmail.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:36:02 +0100
Message-ID: <1638707762239103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 712494de96f35f3e146b36b752c2afe0fdc0f0cc Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Nov 2021 01:49:44 +0000
Subject: [PATCH] KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with
 new vpid12

Fully emulate a guest TLB flush on nested VM-Enter which changes vpid12,
i.e. L2's VPID, instead of simply doing INVVPID to flush real hardware's
TLB entries for vpid02.  From L1's perspective, changing L2's VPID is
effectively a TLB flush unless "hardware" has previously cached entries
for the new vpid12.  Because KVM tracks only a single vpid12, KVM doesn't
know if the new vpid12 has been used in the past and so must treat it as
a brand new, never been used VPID, i.e. must assume that the new vpid12
represents a TLB flush from L1's perspective.

For example, if L1 and L2 share a CR3, the first VM-Enter to L2 (with a
VPID) is effectively a TLB flush as hardware/KVM has never seen vpid12
and thus can't have cached entries in the TLB for vpid12.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211125014944.536398-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8e55aaef33ee..64f2828035c2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1162,29 +1162,26 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	WARN_ON(!enable_vpid);
 
 	/*
-	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
-	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
-	 * a VPID for L2, flush the current context as the effective ASID is
-	 * common to both L1 and L2.
-	 *
-	 * Defer the flush so that it runs after vmcs02.EPTP has been set by
-	 * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
-	 * redundant flushes further down the nested pipeline.
-	 *
-	 * If a TLB flush isn't required due to any of the above, and vpid12 is
-	 * changing then the new "virtual" VPID (vpid12) will reuse the same
-	 * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
-	 * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
-	 * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
-	 * guest-physical mappings, so there is no need to sync the nEPT MMU.
+	 * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
+	 * emulate a guest TLB flush as KVM does not track vpid12 history nor
+	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
+	 * that the new vpid12 has never been used and thus represents a new
+	 * guest ASID that cannot have entries in the TLB.
 	 */
-	if (!nested_has_guest_tlb_tag(vcpu)) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-	} else if (is_vmenter &&
-		   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
+	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-		vpid_sync_context(nested_get_vpid02(vcpu));
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
 	}
+
+	/*
+	 * If VPID is enabled, used by vmc12, and vpid12 is not changing but
+	 * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
+	 * KVM was unable to allocate a VPID for L2, flush the current context
+	 * as the effective ASID is common to both L1 and L2.
+	 */
+	if (!nested_has_guest_tlb_tag(vcpu))
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)

