Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162B073947
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389223AbfGXTiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389655AbfGXTip (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C02FA214AF;
        Wed, 24 Jul 2019 19:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997125;
        bh=gMosxPRiO7H46AAqnKYGYXV1XV4C1JG52ordBThffJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2J+gmR7dBA7/blHBUaenntZb6uYA/GCxrIdQMpt8ojF0wDylnq99Tw4+yH4k8nfm
         LpjZ/shCI1stDZmYKeypeMgsdQt2bXOfNL4ToDOm+48uQ5nMz1D24vzETWTDlQ1e4H
         k24QXHPhLDC7ibWt/8myEqrNgl2pcKSoLmQyNvrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 328/413] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
Date:   Wed, 24 Jul 2019 21:20:19 +0200
Message-Id: <20190724191759.330135107@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 3b013a2972d5bc344d6eaa8f24fdfe268211e45f upstream.

If L1 does not set VM_ENTRY_LOAD_BNDCFGS, then L1's BNDCFGS value must
be propagated to vmcs02 since KVM always runs with VM_ENTRY_LOAD_BNDCFGS
when MPX is supported.  Because the value effectively comes from vmcs01,
vmcs02 must be updated even if vmcs12 is clean.

Fixes: 62cf9bd8118c4 ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2234,13 +2234,9 @@ static void prepare_vmcs02_full(struct v
 
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
@@ -2283,6 +2279,9 @@ static int prepare_vmcs02(struct kvm_vcp
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
 	}
+	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
+		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the


