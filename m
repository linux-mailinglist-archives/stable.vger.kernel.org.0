Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548C51780B9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbgCCR62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732966AbgCCR61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3EC3206D5;
        Tue,  3 Mar 2020 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258306;
        bh=sTSTycuNnPO+ZMgJZjwp6l2Nl3IVSmSVhf+e/Jh3vCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYoIM2l+oKfW8FfF8TJPy5ohyjbS86E01fI7cDIj6Ku5UEmqCea+kXKwG/yR5L6B5
         nvdVIyJFp5odf8xm5YzlbyIqOCzqB8JqvOIUVM0QW/Ohy5lqdwRo0COrc11NRt+Lpr
         reIoCY0vwy1WkqcMHwkazst/wGGXM7neA/2vV8Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
Subject: [PATCH 5.4 151/152] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
Date:   Tue,  3 Mar 2020 18:44:09 +0100
Message-Id: <20200303174319.988650385@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit dd2d6042b7f4a5440705b4ffc6c4c2dba81a43b7 upstream.

According to the SDM, a VMWRITE in VMX non-root operation with an
invalid VMCS-link pointer results in VMfailInvalid before the validity
of the VMCS field in the secondary source operand is checked.

For consistency, modify both handle_vmwrite and handle_vmread, even
though there was no problem with the latter.

Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   59 +++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4609,32 +4609,28 @@ static int handle_vmread(struct kvm_vcpu
 {
 	unsigned long field;
 	u64 field_value;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	int len;
 	gva_t gva = 0;
-	struct vmcs12 *vmcs12;
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
 	struct x86_exception e;
 	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (to_vmx(vcpu)->nested.current_vmptr == -1ull)
+	/*
+	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * any VMREAD sets the ALU flags for VMfailInvalid.
+	 */
+	if (vmx->nested.current_vmptr == -1ull ||
+	    (is_guest_mode(vcpu) &&
+	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (!is_guest_mode(vcpu))
-		vmcs12 = get_vmcs12(vcpu);
-	else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
-
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
@@ -4713,13 +4709,20 @@ static int handle_vmwrite(struct kvm_vcp
 	 */
 	u64 field_value = 0;
 	struct x86_exception e;
-	struct vmcs12 *vmcs12;
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
 	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (vmx->nested.current_vmptr == -1ull)
+	/*
+	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * any VMWRITE sets the ALU flags for VMfailInvalid.
+	 */
+	if (vmx->nested.current_vmptr == -1ull ||
+	    (is_guest_mode(vcpu) &&
+	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
 	if (vmx_instruction_info & (1u << 10))
@@ -4747,24 +4750,12 @@ static int handle_vmwrite(struct kvm_vcp
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu)) {
-		vmcs12 = get_vmcs12(vcpu);
-
-		/*
-		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
-		 * vmcs12, else we may crush a field or consume a stale value.
-		 */
-		if (!is_shadow_field_rw(field))
-			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
+	/*
+	 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+	 * vmcs12, else we may crush a field or consume a stale value.
+	 */
+	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
+		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)


