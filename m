Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E434B594284
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiHOVvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349987AbiHOVt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE37BD14D;
        Mon, 15 Aug 2022 12:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 012C8B81128;
        Mon, 15 Aug 2022 19:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C72EC433C1;
        Mon, 15 Aug 2022 19:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591929;
        bh=dq9WWjAYZEhXKKCWmOnvVPXflF8GkTuFqLiM/zsxIcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKzWzkJyd8KE7wDaFO2c2whRZdWPYHju6LzFlOOZPN7Nz704uhjnRc1cmuDqDQGKn
         tiMsI4LEiSFnim7RV4VG7BzRYSkYMTgtwknPJ/egx8HfT3WdASjEqwI30bKA9UG6te
         DgYrPZZMzFU4ttK+nE5CUJ+716pHpL2GEMj8jVLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0032/1157] KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits
Date:   Mon, 15 Aug 2022 19:49:48 +0200
Message-Id: <20220815180440.717962967@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit c33f6f2228fe8517e38941a508e9f905f99ecba9 upstream.

Split the common x86 parts of kvm_is_valid_cr4(), i.e. the reserved bits
checks, into a separate helper, __kvm_is_valid_cr4(), and export only the
inner helper to vendor code in order to prevent nested VMX from calling
back into vmx_is_valid_cr4() via kvm_is_valid_cr4().

On SVM, this is a nop as SVM doesn't place any additional restrictions on
CR4.

On VMX, this is also currently a nop, but only because nested VMX is
missing checks on reserved CR4 bits for nested VM-Enter.  That bug will
be fixed in a future patch, and could simply use kvm_is_valid_cr4() as-is,
but nVMX has _another_ bug where VMXON emulation doesn't enforce VMX's
restrictions on CR0/CR4.  The cleanest and most intuitive way to fix the
VMXON bug is to use nested_host_cr{0,4}_valid().  If the CR4 variant
routes through kvm_is_valid_cr4(), using nested_host_cr4_valid() won't do
the right thing for the VMXON case as vmx_is_valid_cr4() enforces VMX's
restrictions if and only if the vCPU is post-VMXON.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 ++-
 arch/x86/kvm/vmx/vmx.c    |    4 ++--
 arch/x86/kvm/x86.c        |   12 +++++++++---
 arch/x86/kvm/x86.h        |    2 +-
 4 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -320,7 +320,8 @@ static bool __nested_vmcb_check_save(str
 			return false;
 	}
 
-	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
+	/* Note, SVM doesn't have any additional restrictions on CR4. */
+	if (CC(!__kvm_is_valid_cr4(vcpu, save->cr4)))
 		return false;
 
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3230,8 +3230,8 @@ static bool vmx_is_valid_cr4(struct kvm_
 {
 	/*
 	 * We operate under the default treatment of SMM, so VMX cannot be
-	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
-	 * handled by kvm_is_valid_cr4().
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all,
+	 * i.e. is a reserved bit, is handled by common x86 code.
 	 */
 	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
 		return false;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1094,7 +1094,7 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
-bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
 		return false;
@@ -1102,9 +1102,15 @@ bool kvm_is_valid_cr4(struct kvm_vcpu *v
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return false;
 
-	return static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
+	return true;
+}
+EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
+
+static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return __kvm_is_valid_cr4(vcpu, cr4) &&
+	       static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
 }
-EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -407,7 +407,7 @@ static inline void kvm_machine_check(voi
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);


