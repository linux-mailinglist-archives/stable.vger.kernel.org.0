Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD4353F08
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhDEJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238546AbhDEJIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3164061398;
        Mon,  5 Apr 2021 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613718;
        bh=EFlZX130TRgZWvw5J0PA2eaRxZjNLbQbMdSnzDH8e04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvdS8Iw+D+kVll48GjjdBLarBQtwVYQgckVMTigyqX+GYMt2RGgYWyq/KcqmNYlMG
         DcF3xMVjEKQwUPsg5OiNaT2qero7JQhF51Y6XswcSlQrqZHNSuXTCRdcYAiPewkk3N
         AycX1+Sb8eJvJyNz46ntGE+78G6PDlrvbu3kyTpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Wilhelm <fwilhelm@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 065/126] KVM: SVM: load control fields from VMCB12 before checking them
Date:   Mon,  5 Apr 2021 10:53:47 +0200
Message-Id: <20210405085033.210655053@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit a58d9166a756a0f4a6618e4f593232593d6df134 upstream.

Avoid races between check and use of the nested VMCB controls.  This
for example ensures that the VMRUN intercept is always reflected to the
nested hypervisor, instead of being processed by the host.  Without this
patch, it is possible to end up with svm->nested.hsave pointing to
the MSR permission bitmap for nested guests.

This bug is CVE-2021-29657.

Reported-by: Felix Wilhelm <fwilhelm@google.com>
Cc: stable@vger.kernel.org
Fixes: 2fcf4876ada ("KVM: nSVM: implement on demand allocation of the nested state")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -246,7 +246,7 @@ static bool nested_vmcb_check_controls(s
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_check_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool vmcb12_lma;
@@ -271,7 +271,7 @@ static bool nested_vmcb_checks(struct vc
 	if (kvm_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb12->control);
+	return true;
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -454,7 +454,6 @@ int enter_svm_guest_mode(struct vcpu_svm
 	int ret;
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
-	load_nested_vmcb_control(svm, &vmcb12->control);
 	nested_prepare_vmcb_save(svm, vmcb12);
 	nested_prepare_vmcb_control(svm);
 
@@ -501,7 +500,10 @@ int nested_svm_vmrun(struct vcpu_svm *sv
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(svm, vmcb12)) {
+	load_nested_vmcb_control(svm, &vmcb12->control);
+
+	if (!nested_vmcb_check_save(svm, vmcb12) ||
+	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;


