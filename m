Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F5971629
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbfGWKf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:35:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35227 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:35:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 24503509;
        Tue, 23 Jul 2019 06:35:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QyzFiY
        Ju7pCCa5nvhQK7RdZ5BX3hCgPmapcoDoGDgV8=; b=cSAz6bSQ0bWqjvgYIIzrZ4
        xQRTdUh7BGg7OMbhwyvfnCF4OoSMRNDM5EW/TE1bE/menQZpVzu75Lg8eS5NSA0l
        v7jj3Bth8ernT4z7tr00TxoWIWtdrWSWAb9aS9TYBjzmLX/ekpstrNi5lgnTlaJS
        QJSon1UHTturTkYX+oOl3EAoea77ZEXOXONC9rfawsv8Y8k/abQoP3jh5rRRYq+6
        0vyRZ6h8e7Mr6xtV0qWGNyTgJMK46tsidBqj09OHA9mPCYksQ5paUaBkXPU8vdZ6
        LxyO9kF/3wAo+GLawFV2tgSMPcVWsNBRn7Dv15rgPCVvRu+3he5Q/r94bDlIjBYA
        ==
X-ME-Sender: <xms:DeM2XXfVwprphgzGmOOV-lBHYO3ciyIs61pa027Wi2QhrVPVJ1-4_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:DeM2Xcj7mg3VmqMcayR1fv9C5hQNoZvuUp0qZoZZePP1EK99ivxgkA>
    <xmx:DeM2XXee28n6k5pAuV8w7EvcqfTPIH_tyhJetXL44EEs1xUkh572WQ>
    <xmx:DeM2XUQoOqrPiiJseC0gCwnEjWs3IgYW8qZLcWud5vCVqctLso2zng>
    <xmx:DeM2Xcc38ctCDyzK5Z8-ZXD3DguvXfCBf-GDYw_CbNKGupYO87j7aA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F1A2380075;
        Tue, 23 Jul 2019 06:35:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, liran.alon@oracle.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:32:45 +0200
Message-ID: <1563877965121147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 3b013a2972d5bc344d6eaa8f24fdfe268211e45f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 7 May 2019 09:06:28 -0700
Subject: [PATCH] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from
 vmcs01

If L1 does not set VM_ENTRY_LOAD_BNDCFGS, then L1's BNDCFGS value must
be propagated to vmcs02 since KVM always runs with VM_ENTRY_LOAD_BNDCFGS
when MPX is supported.  Because the value effectively comes from vmcs01,
vmcs02 must be updated even if vmcs12 is clean.

Fixes: 62cf9bd8118c4 ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e82bbca2fe1..c4c0a45245b2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2228,13 +2228,9 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 	set_cr4_guest_host_mask(vmx);
 
-	if (kvm_mpx_supported()) {
-		if (vmx->nested.nested_run_pending &&
-			(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
-			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
-		else
-			vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
-	}
+	if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+		vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 }
 
 /*
@@ -2266,6 +2262,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
 	}
+	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
+		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the

