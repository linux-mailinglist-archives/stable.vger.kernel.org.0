Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24E74A448A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380043AbiAaLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:30:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376797AbiAaLZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFE8161267;
        Mon, 31 Jan 2022 11:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41E5C340E8;
        Mon, 31 Jan 2022 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628338;
        bh=kOFAuv7a91kdGZ21ugNybajlFhs3wqROMtBixdqkmEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJadh7zxH0ag6D0Mq52zWDGPpuRJGOQ3bp0gw559rKEcn9pF8929OkBk7j71R0bRs
         jWWWfh8c7Yj4y8LXeD61g2zny0Ls4Uhr22zFqUyLlEYwVchbu9B4LzmS+JaaADbUsS
         DChEs0qph4/O1DYyO3YFsEVh/rIpujpyTxwxDd3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 199/200] KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use
Date:   Mon, 31 Jan 2022 11:57:42 +0100
Message-Id: <20220131105240.221784029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 6cbbaab60ff33f59355492c241318046befd9ffc upstream.

Hyper-V TLFS explicitly forbids VMREAD and VMWRITE instructions when
Enlightened VMCS interface is in use:

"Any VMREAD or VMWRITE instructions while an enlightened VMCS is
active is unsupported and can result in unexpected behavior.""

Windows 11 + WSL2 seems to ignore this, attempts to VMREAD VMCS field
0x4404 ("VM-exit interruption information") are observed. Failing
these attempts with nested_vmx_failInvalid() makes such guests
unbootable.

Microsoft confirms this is a Hyper-V bug and claims that it'll get fixed
eventually but for the time being we need a workaround. (Temporary) allow
VMREAD to get data from the currently loaded Enlightened VMCS.

Note: VMWRITE instructions remain forbidden, it is not clear how to
handle them properly and hopefully won't ever be needed.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220112170134.1904308-6-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/evmcs.h  |   12 ++++++++++
 arch/x86/kvm/vmx/nested.c |   55 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 51 insertions(+), 16 deletions(-)

--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -96,6 +96,18 @@ static __always_inline int evmcs_field_o
 	return evmcs_field->offset;
 }
 
+static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
+				 unsigned long field, u16 offset)
+{
+	/*
+	 * vmcs12_read_any() doesn't care whether the supplied structure
+	 * is 'struct vmcs12' or 'struct hv_enlightened_vmcs' as it takes
+	 * the exact offset of the required field, use it for convenience
+	 * here.
+	 */
+	return vmcs12_read_any((void *)evmcs, field, offset);
+}
+
 #if IS_ENABLED(CONFIG_HYPERV)
 
 static __always_inline int get_evmcs_offset(unsigned long field,
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,6 +7,7 @@
 #include <asm/mmu_context.h>
 
 #include "cpuid.h"
+#include "evmcs.h"
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
@@ -5074,27 +5075,49 @@ static int handle_vmread(struct kvm_vcpu
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	/*
-	 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
-	 * any VMREAD sets the ALU flags for VMfailInvalid.
-	 */
-	if (vmx->nested.current_vmptr == INVALID_GPA ||
-	    (is_guest_mode(vcpu) &&
-	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
-		return nested_vmx_failInvalid(vcpu);
-
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = get_vmcs12_field_offset(field);
-	if (offset < 0)
-		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+		/*
+		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
+		 * any VMREAD sets the ALU flags for VMfailInvalid.
+		 */
+		if (vmx->nested.current_vmptr == INVALID_GPA ||
+		    (is_guest_mode(vcpu) &&
+		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
+			return nested_vmx_failInvalid(vcpu);
+
+		offset = get_vmcs12_field_offset(field);
+		if (offset < 0)
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
+		if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
+			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+
+		/* Read the field, zero-extended to a u64 value */
+		value = vmcs12_read_any(vmcs12, field, offset);
+	} else {
+		/*
+		 * Hyper-V TLFS (as of 6.0b) explicitly states, that while an
+		 * enlightened VMCS is active VMREAD/VMWRITE instructions are
+		 * unsupported. Unfortunately, certain versions of Windows 11
+		 * don't comply with this requirement which is not enforced in
+		 * genuine Hyper-V. Allow VMREAD from an enlightened VMCS as a
+		 * workaround, as misbehaving guests will panic on VM-Fail.
+		 * Note, enlightened VMCS is incompatible with shadow VMCS so
+		 * all VMREADs from L2 should go to L1.
+		 */
+		if (WARN_ON_ONCE(is_guest_mode(vcpu)))
+			return nested_vmx_failInvalid(vcpu);
 
-	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
-		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+		offset = evmcs_field_offset(field, NULL);
+		if (offset < 0)
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
-	/* Read the field, zero-extended to a u64 value */
-	value = vmcs12_read_any(vmcs12, field, offset);
+		/* Read the field, zero-extended to a u64 value */
+		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+	}
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.


