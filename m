Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D925630CC7B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhBBT5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhBBNt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA7664FA6;
        Tue,  2 Feb 2021 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273352;
        bh=hfO1gJckeNJ5MJjPmbNI9FztksTcpkDKp5MpNDJcyLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WE2fSloHxPrCn8ejWeAALxdUiwgO4e/XOcppGa3pLR3Z0gUOgxKKSuJBbgNAB4/CP
         GWtW+ts/fp+WR4SHHSgcpglPN5dlIKdjUBQbcsumWGC+ef7V/5FTnvJLVqc00URJUw
         0qrqsAn21DlmB7kgqtsXQk7og2vZU86K/wv/KLNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 043/142] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX
Date:   Tue,  2 Feb 2021 14:36:46 +0100
Message-Id: <20210202132959.501506338@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9a78e15802a87de2b08dfd1bd88e855201d2c8fa upstream.

VMX also uses KVM_REQ_GET_NESTED_STATE_PAGES for the Hyper-V eVMCS,
which may need to be loaded outside guest mode.  Therefore we cannot
WARN in that case.

However, that part of nested_get_vmcs12_pages is _not_ needed at
vmentry time.  Split it out of KVM_REQ_GET_NESTED_STATE_PAGES handling,
so that both vmentry and migration (and in the latter case, independent
of is_guest_mode) do the parts that are needed.

Cc: <stable@vger.kernel.org> # 5.10.x: f2c7ef3ba: KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/nested.c |    3 +++
 arch/x86/kvm/vmx/nested.c |   31 +++++++++++++++++++++++++------
 arch/x86/kvm/x86.c        |    4 +---
 3 files changed, 29 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -200,6 +200,9 @@ static bool svm_get_nested_state_pages(s
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (WARN_ON(!is_guest_mode(vcpu)))
+		return true;
+
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3123,13 +3123,9 @@ static int nested_vmx_check_vmentry_hw(s
 	return 0;
 }
 
-static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 {
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_host_map *map;
-	struct page *page;
-	u64 hpa;
 
 	/*
 	 * hv_evmcs may end up being not mapped after migration (when
@@ -3152,6 +3148,17 @@ static bool nested_get_vmcs12_pages(stru
 		}
 	}
 
+	return true;
+}
+
+static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_host_map *map;
+	struct page *page;
+	u64 hpa;
+
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		/*
 		 * Translate L1 physical address to host physical
@@ -3220,6 +3227,18 @@ static bool nested_get_vmcs12_pages(stru
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+
+	return true;
+}
+
+static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	if (!nested_get_evmcs_page(vcpu))
+		return false;
+
+	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
+		return false;
+
 	return true;
 }
 
@@ -6575,7 +6594,7 @@ struct kvm_x86_nested_ops vmx_nested_ops
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
-	.get_nested_state_pages = nested_get_vmcs12_pages,
+	.get_nested_state_pages = vmx_get_nested_state_pages,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8750,9 +8750,7 @@ static int vcpu_enter_guest(struct kvm_v
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
-				;
-			else if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}


