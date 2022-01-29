Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEDC4A3050
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 16:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbiA2PaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 10:30:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344843AbiA2PaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 10:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643470205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bl6hggqWbfuZc99XeLDgodd6K0W1QM3p+SrO1S/zFSQ=;
        b=WNwWNMjVbn4bZa85HWNsmx5KojkjR8Ko5vXnTb2VeNtH/8nGtmgicbOcbJ96X9A1DwR5Cx
        /KxRHee20Ii7/SoewNWgjK+0e45G+TuG8gHcze6ElWNi0Gd4tQsAyGYAI7h62xWIrwpf0l
        +622bugoBz+OL7whcX71fDWpScB1uFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-FzIlnhKEP0GAcK71a9ZxsQ-1; Sat, 29 Jan 2022 10:30:03 -0500
X-MC-Unique: FzIlnhKEP0GAcK71a9ZxsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52AA11006AA9;
        Sat, 29 Jan 2022 15:30:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEE59519A5;
        Sat, 29 Jan 2022 15:29:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 3/3] KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use
Date:   Sat, 29 Jan 2022 16:29:47 +0100
Message-Id: <20220129152947.3136637-4-vkuznets@redhat.com>
In-Reply-To: <20220129152947.3136637-1-vkuznets@redhat.com>
References: <20220129152947.3136637-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h  | 12 +++++++++
 arch/x86/kvm/vmx/nested.c | 55 +++++++++++++++++++++++++++------------
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index bc14e8429c19..6255fa716772 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -96,6 +96,18 @@ static __always_inline int evmcs_field_offset(unsigned long field,
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
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 84cf1d4b3d88..a5d90f012b5d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,6 +7,7 @@
 #include <asm/mmu_context.h>
 
 #include "cpuid.h"
+#include "evmcs.h"
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
@@ -5074,27 +5075,49 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
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
 
-	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
-		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
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
 
-	/* Read the field, zero-extended to a u64 value */
-	value = vmcs12_read_any(vmcs12, field, offset);
+		offset = evmcs_field_offset(field, NULL);
+		if (offset < 0)
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
+		/* Read the field, zero-extended to a u64 value */
+		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+	}
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.
-- 
2.34.1

