Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A193F3837C4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbhEQPq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344621AbhEQPpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49CA61D2D;
        Mon, 17 May 2021 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262616;
        bh=gPM2Sf+ZxIJ0EELORApxwtu0yTWvElr6wAHAMxFYO9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7ikC3s2d2V8lvOXxk7I1TzjVwXPgA7aPeMpbT2BWCEwhn8oT31sI5WiDlhW58JLX
         pEGZdfjemKcpKBsOHMJPNje36QNHkpWQ4lzrqSB/EsbjFe1ttT3rX8RxeZwXJyXEcS
         rC4pxR7Du79AuQAVi7fYfyeBH8cV13VuTCngbT1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 300/329] KVM: nVMX: Always make an attempt to map eVMCS after migration
Date:   Mon, 17 May 2021 16:03:31 +0200
Message-Id: <20210517140312.246819970@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit f5c7e8425f18fdb9bdb7d13340651d7876890329 upstream.

When enlightened VMCS is in use and nested state is migrated with
vmx_get_nested_state()/vmx_set_nested_state() KVM can't map evmcs
page right away: evmcs gpa is not 'struct kvm_vmx_nested_state_hdr'
and we can't read it from VP assist page because userspace may decide
to restore HV_X64_MSR_VP_ASSIST_PAGE after restoring nested state
(and QEMU, for example, does exactly that). To make sure eVMCS is
mapped /vmx_set_nested_state() raises KVM_REQ_GET_NESTED_STATE_PAGES
request.

Commit f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
on nested vmexit") added KVM_REQ_GET_NESTED_STATE_PAGES clearing to
nested_vmx_vmexit() to make sure MSR permission bitmap is not switched
when an immediate exit from L2 to L1 happens right after migration (caused
by a pending event, for example). Unfortunately, in the exact same
situation we still need to have eVMCS mapped so
nested_sync_vmcs12_to_shadow() reflects changes in VMCS12 to eVMCS.

As a band-aid, restore nested_get_evmcs_page() when clearing
KVM_REQ_GET_NESTED_STATE_PAGES in nested_vmx_vmexit(). The 'fix' is far
from being ideal as we can't easily propagate possible failures and even if
we could, this is most likely already too late to do so. The whole
'KVM_REQ_GET_NESTED_STATE_PAGES' idea for mapping eVMCS after migration
seems to be fragile as we diverge too much from the 'native' path when
vmptr loading happens on vmx_set_nested_state().

Fixes: f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210503150854.1144255-2-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3140,15 +3140,8 @@ static bool nested_get_evmcs_page(struct
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
 
 		if (evmptrld_status == EVMPTRLD_VMFAIL ||
-		    evmptrld_status == EVMPTRLD_ERROR) {
-			pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
-					     __func__);
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-				KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+		    evmptrld_status == EVMPTRLD_ERROR)
 			return false;
-		}
 	}
 
 	return true;
@@ -3236,8 +3229,16 @@ static bool nested_get_vmcs12_pages(stru
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-	if (!nested_get_evmcs_page(vcpu))
+	if (!nested_get_evmcs_page(vcpu)) {
+		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
+				     __func__);
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+
 		return false;
+	}
 
 	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
 		return false;
@@ -4467,7 +4468,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+		/*
+		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
+		 * Enlightened VMCS after migration and we still need to
+		 * do that when something is forcing L2->L1 exit prior to
+		 * the first L2 run.
+		 */
+		(void)nested_get_evmcs_page(vcpu);
+	}
 
 	/* Service the TLB flush request for L2 before switching to L1. */
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))


