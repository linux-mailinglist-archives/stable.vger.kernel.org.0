Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906AE4A449F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350847AbiAaLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376519AbiAaLZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB0861310;
        Mon, 31 Jan 2022 11:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEB5C340E8;
        Mon, 31 Jan 2022 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628331;
        bh=i9mSXskbJPYxio2loBDl5juLFgVWZimkJbikOWCTuj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCDODNMRasbmKihTZ2MdtPc9Yd6LIwyJSGRLov5h9KKG7jD1PVqa4O1LwqbXAoi4i
         0yUdS3IdTXPjUvXdoPKDZzsZ9nK6b2Rc2h/GdILwt4RHv4S5tTKhJqTedz9CkE04PZ
         hDTm+/r8tQLz0dwtJn7OdK2ZmXXcJ8Q6W77celiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 197/200] KVM: nVMX: Rename vmcs_to_field_offset{,_table}
Date:   Mon, 31 Jan 2022 11:57:40 +0100
Message-Id: <20220131105240.157986155@linuxfoundation.org>
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

commit 2423a4c0d17418eca1ba1e3f48684cb2ab7523d5 upstream.

vmcs_to_field_offset{,_table} may sound misleading as VMCS is an opaque
blob which is not supposed to be accessed directly. In fact,
vmcs_to_field_offset{,_table} are related to KVM defined VMCS12 structure.

Rename vmcs_field_to_offset() to get_vmcs12_field_offset() for clarity.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220112170134.1904308-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    6 +++---
 arch/x86/kvm/vmx/vmcs12.c |    4 ++--
 arch/x86/kvm/vmx/vmcs12.h |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5086,7 +5086,7 @@ static int handle_vmread(struct kvm_vcpu
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = vmcs_field_to_offset(field);
+	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
@@ -5189,7 +5189,7 @@ static int handle_vmwrite(struct kvm_vcp
 
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = vmcs_field_to_offset(field);
+	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
@@ -6435,7 +6435,7 @@ static u64 nested_vmx_calc_vmcs_enum_msr
 	max_idx = 0;
 	for (i = 0; i < nr_vmcs12_fields; i++) {
 		/* The vmcs12 table is very, very sparsely populated. */
-		if (!vmcs_field_to_offset_table[i])
+		if (!vmcs12_field_offsets[i])
 			continue;
 
 		idx = vmcs_field_index(VMCS12_IDX_TO_ENC(i));
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -8,7 +8,7 @@
 	FIELD(number, name),						\
 	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
 
-const unsigned short vmcs_field_to_offset_table[] = {
+const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
 	FIELD(POSTED_INTR_NV, posted_intr_nv),
 	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
@@ -151,4 +151,4 @@ const unsigned short vmcs_field_to_offse
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
 };
-const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
+const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -361,10 +361,10 @@ static inline void vmx_check_vmcs12_offs
 	CHECK_OFFSET(guest_pml_index, 996);
 }
 
-extern const unsigned short vmcs_field_to_offset_table[];
+extern const unsigned short vmcs12_field_offsets[];
 extern const unsigned int nr_vmcs12_fields;
 
-static inline short vmcs_field_to_offset(unsigned long field)
+static inline short get_vmcs12_field_offset(unsigned long field)
 {
 	unsigned short offset;
 	unsigned int index;
@@ -377,7 +377,7 @@ static inline short vmcs_field_to_offset
 		return -ENOENT;
 
 	index = array_index_nospec(index, nr_vmcs12_fields);
-	offset = vmcs_field_to_offset_table[index];
+	offset = vmcs12_field_offsets[index];
 	if (offset == 0)
 		return -ENOENT;
 	return offset;


