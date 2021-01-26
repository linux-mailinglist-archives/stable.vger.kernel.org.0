Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F029F3033D0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbhAZFFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732272AbhAZBfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 20:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611624841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aoPNVJItjntzvSmEbIkhipMW6l3+xUofRDwTaAUWaf0=;
        b=OOksBQERAjwdUvvS5mzM911L7TrglQOagwJHUMcd/sqKc2I3vQQADWtoLs5wD5YQgAO5yY
        UwaHQRbpN0E/nlC16KxF22Fsnw9vm0dsCsrTY+1Lc0YOHXTj+PTcPHpA4omr0rpa9ObaFc
        V8UAXJ1feNr70dTi7V5hIRf29BCIy8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-2R8Fn7WwMwG4HhUGCCL5yA-1; Mon, 25 Jan 2021 19:43:08 -0500
X-MC-Unique: 2R8Fn7WwMwG4HhUGCCL5yA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E498C28A;
        Tue, 26 Jan 2021 00:43:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 246E35D9DB;
        Tue, 26 Jan 2021 00:43:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX
Date:   Mon, 25 Jan 2021 19:43:06 -0500
Message-Id: <20210126004306.1442975-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kvm/svm/nested.c |  3 +++
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++------
 arch/x86/kvm/x86.c        |  4 +---
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cb4c6ee10029..7a605ad8254d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -200,6 +200,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (WARN_ON(!is_guest_mode(vcpu)))
+		return true;
+
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 776688f9d101..f2b9bfb58206 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3124,13 +3124,9 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
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
@@ -3153,6 +3149,17 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
@@ -3221,6 +3228,18 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
 
@@ -6605,7 +6624,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
-	.get_nested_state_pages = nested_get_vmcs12_pages,
+	.get_nested_state_pages = vmx_get_nested_state_pages,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f64e8b97605..76bce832cade 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8806,9 +8806,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
-				;
-			else if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}
-- 
2.26.2

