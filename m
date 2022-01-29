Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2880A4A304F
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 16:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbiA2PaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 10:30:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240665AbiA2PaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 10:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643470202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0+D4Lgsys8t6OVA/NwrJfpAmuhEVAKrxRqT8aJWy7Y=;
        b=SHQI7+iGK5r/qVzAdQBy0lm9vI9GmT8s1RRYFBmhIvspxVPiIMsrOm08/1SxC2V8qQGfri
        tdIW3h5NalROEbeThVZOMIo2crckKSutwDjH7XsBJfS90F+8PCXG90boPZ+HJu5Fzi+sqi
        VV+xbCXZqHt6P+olRtcGs0C/zUCkwA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-sVqLyAdLPOur4nXLdI1iLg-1; Sat, 29 Jan 2022 10:29:58 -0500
X-MC-Unique: sVqLyAdLPOur4nXLdI1iLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66BE281424A;
        Sat, 29 Jan 2022 15:29:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA7A47A426;
        Sat, 29 Jan 2022 15:29:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 2/3] KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
Date:   Sat, 29 Jan 2022 16:29:46 +0100
Message-Id: <20220129152947.3136637-3-vkuznets@redhat.com>
In-Reply-To: <20220129152947.3136637-1-vkuznets@redhat.com>
References: <20220129152947.3136637-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 892a42c10ddb945d3a4dcf07dccdf9cb98b21548 upstream.

In preparation to allowing reads from Enlightened VMCS from
handle_vmread(), implement evmcs_field_offset() to get the correct
read offset. get_evmcs_offset(), which is being used by KVM-on-Hyper-V,
is almost what's needed but a few things need to be adjusted. First,
WARN_ON() is unacceptable for handle_vmread() as any field can (in
theory) be supplied by the guest and not all fields are defined in
eVMCS v1. Second, we need to handle 'holes' in eVMCS (missing fields).
It also sounds like a good idea to WARN_ON() if such fields are ever
accessed by KVM-on-Hyper-V.

Implement dedicated evmcs_field_offset() helper.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220112170134.1904308-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c |  3 +--
 arch/x86/kvm/vmx/evmcs.h | 32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ba6f99f584ac..09fac0ddac8b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -12,8 +12,6 @@
 
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
-#if IS_ENABLED(CONFIG_HYPERV)
-
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
 #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
 		{EVMCS1_OFFSET(name), clean_field}
@@ -296,6 +294,7 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
+#if IS_ENABLED(CONFIG_HYPERV)
 __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 16731d2cf231..bc14e8429c19 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -63,8 +63,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
-#if IS_ENABLED(CONFIG_HYPERV)
-
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
@@ -73,26 +71,44 @@ struct evmcs_field {
 extern const struct evmcs_field vmcs_field_to_evmcs_1[];
 extern const unsigned int nr_evmcs_1_fields;
 
-static __always_inline int get_evmcs_offset(unsigned long field,
-					    u16 *clean_field)
+static __always_inline int evmcs_field_offset(unsigned long field,
+					      u16 *clean_field)
 {
 	unsigned int index = ROL16(field, 6);
 	const struct evmcs_field *evmcs_field;
 
-	if (unlikely(index >= nr_evmcs_1_fields)) {
-		WARN_ONCE(1, "KVM: accessing unsupported EVMCS field %lx\n",
-			  field);
+	if (unlikely(index >= nr_evmcs_1_fields))
 		return -ENOENT;
-	}
 
 	evmcs_field = &vmcs_field_to_evmcs_1[index];
 
+	/*
+	 * Use offset=0 to detect holes in eVMCS. This offset belongs to
+	 * 'revision_id' but this field has no encoding and is supposed to
+	 * be accessed directly.
+	 */
+	if (unlikely(!evmcs_field->offset))
+		return -ENOENT;
+
 	if (clean_field)
 		*clean_field = evmcs_field->clean_field;
 
 	return evmcs_field->offset;
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+
+static __always_inline int get_evmcs_offset(unsigned long field,
+					    u16 *clean_field)
+{
+	int offset = evmcs_field_offset(field, clean_field);
+
+	WARN_ONCE(offset < 0, "KVM: accessing unsupported EVMCS field %lx\n",
+		  field);
+
+	return offset;
+}
+
 static __always_inline void evmcs_write64(unsigned long field, u64 value)
 {
 	u16 clean_field;
-- 
2.34.1

