Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FDE3291B3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhCAUa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237020AbhCAUYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2197F65406;
        Mon,  1 Mar 2021 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621960;
        bh=TiWoGviXOufGdTRqfWOZaR3EhpkUziOf8SsdsMT3Rjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3ZFAJ/RiKgqtvcFCkUdpNO6BaKcz/HRaCs5fVPPviHS46v/r+VsDigaqZZqADmcs
         jTTBPdoRFWA82fhHg7qGZ0XWqor4HhfzaLZ9+kt1XevMc+3fe8LuiU2yWAHnVjcHEv
         6clmUMvX46gEGFi8iX9RjGlik5NT5U4KN2+uciAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 707/775] KVM: nSVM: fix running nested guests when npt=0
Date:   Mon,  1 Mar 2021 17:14:35 +0100
Message-Id: <20210301161236.295663658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit a04aead144fd938c2d9869eb187e5b9ea0009bae upstream.

In case of npt=0 on host, nSVM needs the same .inject_page_fault tweak
as VMX has, to make sure that shadow mmu faults are injected as vmexits.

It is not clear why this is needed at all, but for now keep the same
code as VMX and we'll fix it for both.

Based on a patch by Maxim Levitsky <mlevitsk@redhat.com>.

Fixes: 7c86663b68ba ("KVM: nSVM: inject exceptions via svm_check_nested_events")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -51,6 +51,23 @@ static void nested_svm_inject_npf_exit(s
 	nested_svm_vmexit(svm);
 }
 
+static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+{
+       struct vcpu_svm *svm = to_svm(vcpu);
+       WARN_ON(!is_guest_mode(vcpu));
+
+       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
+	   !svm->nested.nested_run_pending) {
+               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+               svm->vmcb->control.exit_code_hi = 0;
+               svm->vmcb->control.exit_info_1 = fault->error_code;
+               svm->vmcb->control.exit_info_2 = fault->address;
+               nested_svm_vmexit(svm);
+       } else {
+               kvm_inject_page_fault(vcpu, fault);
+       }
+}
+
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -446,6 +463,9 @@ int enter_svm_guest_mode(struct vcpu_svm
 	if (ret)
 		return ret;
 
+	if (!npt_enabled)
+		svm->vcpu.arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
+
 	svm_set_gif(svm, true);
 
 	return 0;


