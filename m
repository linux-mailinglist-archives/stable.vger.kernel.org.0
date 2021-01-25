Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB0E3028B9
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbhAYRWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 12:22:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730981AbhAYRWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 12:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611595250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fLkc6jBByIwZj+y5K87dwsdh1F4jKYYT1Ucr0DYgAHo=;
        b=jBe0BXwmZBHCNzfkNXdgQOfvaVyC0xcS5od5vsCrK5BBa3zo4X/dxx4iSX7OV2iySqTqGr
        +sVSDQNG37U8blBPDsV/pgHbf3zm1OYjtyPsCIPa7mQYvKONSZEGv/yRdpJx0c+hPec3mM
        u7BVLGGd27GfDeinFf0COqjZfjw0DNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-BsjjSMAxOdS1oRXxbwGosw-1; Mon, 25 Jan 2021 12:20:46 -0500
X-MC-Unique: BsjjSMAxOdS1oRXxbwGosw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B643559;
        Mon, 25 Jan 2021 17:20:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 663E55D9DB;
        Mon, 25 Jan 2021 17:20:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX
Date:   Mon, 25 Jan 2021 12:20:44 -0500
Message-Id: <20210125172044.1360661-1-pbonzini@redhat.com>
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
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c        |  4 +---
 3 files changed, 30 insertions(+), 9 deletions(-)

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
index 0fbb46990dfc..20ab40a2ac34 100644
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
@@ -3152,6 +3148,19 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			return false;
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
+	if (!nested_get_evmcs_page(vcpu))
+		return false;
 
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		/*
@@ -3224,6 +3233,17 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	if (!nested_get_evmcs_page(vcpu))
+		return false;
+
+	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
+		return false;
+
+	return true;
+}
+
 static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
@@ -6602,7 +6622,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
-	.get_nested_state_pages = nested_get_vmcs12_pages,
+	.get_nested_state_pages = vmx_get_nested_state_pages,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..b910aa74ee05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8802,9 +8802,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
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

