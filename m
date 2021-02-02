Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B568830CC85
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbhBBT6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232743AbhBBNtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B7564F9F;
        Tue,  2 Feb 2021 13:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273338;
        bh=u+gyNyBEIWNgsF7KN7HrrHtIDyzveKBd0m/L8JWUnsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcrd/FOblA4V3ezWlMiBHwV7Mbca3xGN1ZJ17+TK6aO9nLkYGK0vAOQQjsKPKcHfm
         dd8A/GcDne/sLgA8vRMM32vBr6HUtL3o1FnFREDrATuMD7q2zPHp8TIzYmpzGqbAk4
         TXPpeXFeWms7ohAAEpd5jkm2PPSz6JJ1SqH57xBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 042/142] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit
Date:   Tue,  2 Feb 2021 14:36:45 +0100
Message-Id: <20210202132959.459866638@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit f2c7ef3ba9556d62a7e2bb23b563c6510007d55c upstream.

It is possible to exit the nested guest mode, entered by
svm_set_nested_state prior to first vm entry to it (e.g due to pending event)
if the nested run was not pending during the migration.

In this case we must not switch to the nested msr permission bitmap.
Also add a warning to catch similar cases in the future.

Fixes: a7d5c7ce41ac1 ("KVM: nSVM: delay MSR permission processing to first nested VM run")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210107093854.882483-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/nested.c |    3 +++
 arch/x86/kvm/vmx/nested.c |    2 ++
 arch/x86/kvm/x86.c        |    4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -199,6 +199,7 @@ static bool nested_svm_vmrun_msrpm(struc
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
@@ -595,6 +596,8 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+
 	/* in case we halted in L2 */
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4416,6 +4416,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
 	/* Service the TLB flush request for L2 before switching to L1. */
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8750,7 +8750,9 @@ static int vcpu_enter_guest(struct kvm_v
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+			if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
+				;
+			else if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}


