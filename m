Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74572111DBC
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfLCW4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbfLCW4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3352320865;
        Tue,  3 Dec 2019 22:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413790;
        bh=pPZsBLyPBI1BaG0vlYUUYhpQW3wrjUUIPFUaphUi7xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCPBDKH9lbm14j8Kq4BYQe8ib2Jm1ujlFq/jfgp6sx97FIEHVl7ogIJoDZPu7GVLA
         pEC5GXaOh2ILgXHL+nfTd2jFGlrKnquCPNL3nXFOCqmuQ31isLSTEGD7Xa+81k4u0P
         U81TWKJcfvPTT26FQYV/NxO2DYFAwmuVyfGWCek8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jack Wang <jack.wang.usish@gmail.com>
Subject: [PATCH 4.19 264/321] KVM: nVMX: rename enter_vmx_non_root_mode to nested_vmx_enter_non_root_mode
Date:   Tue,  3 Dec 2019 23:35:30 +0100
Message-Id: <20191203223440.862014163@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit d63907dc7dd11d98c8ffbdaf8311987e5a508744 upstream.

...to be more consistent with the nested VMX nomenclature.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -12680,7 +12680,7 @@ static int check_vmentry_postreqs(struct
  * If exit_qual is NULL, this is being called from state restore (either RSM
  * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
  */
-static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
+static int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -12845,7 +12845,7 @@ static int nested_vmx_run(struct kvm_vcp
 	 */
 
 	vmx->nested.nested_run_pending = 1;
-	ret = enter_vmx_non_root_mode(vcpu, &exit_qual);
+	ret = nested_vmx_enter_non_root_mode(vcpu, &exit_qual);
 	if (ret) {
 		nested_vmx_entry_failure(vcpu, vmcs12, ret, exit_qual);
 		vmx->nested.nested_run_pending = 0;
@@ -12856,7 +12856,7 @@ static int nested_vmx_run(struct kvm_vcp
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
 
 	/*
-	 * Must happen outside of enter_vmx_non_root_mode() as it will
+	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will
 	 * also be used as part of restoring nVMX state for
 	 * snapshot restore (migration).
 	 *
@@ -14089,7 +14089,7 @@ static int vmx_pre_leave_smm(struct kvm_
 
 	if (vmx->nested.smm.guest_mode) {
 		vcpu->arch.hflags &= ~HF_SMM_MASK;
-		ret = enter_vmx_non_root_mode(vcpu, NULL);
+		ret = nested_vmx_enter_non_root_mode(vcpu, NULL);
 		vcpu->arch.hflags |= HF_SMM_MASK;
 		if (ret)
 			return ret;
@@ -14300,7 +14300,7 @@ static int vmx_set_nested_state(struct k
 		return -EINVAL;
 
 	vmx->nested.dirty_vmcs12 = true;
-	ret = enter_vmx_non_root_mode(vcpu, NULL);
+	ret = nested_vmx_enter_non_root_mode(vcpu, NULL);
 	if (ret)
 		return -EINVAL;
 


