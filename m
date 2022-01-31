Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138964A45AF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbiAaLqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347966AbiAaLkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0ABC02B74F;
        Mon, 31 Jan 2022 03:25:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2052612DE;
        Mon, 31 Jan 2022 11:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73843C340E8;
        Mon, 31 Jan 2022 11:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628335;
        bh=2xzL8Ftr/S5iP2Y9dkrb08xfKDdPckbKShVNwmsT17k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSyzHouFV+UG0fbYiCSmUH+Y28mSd/g4k68U1De/6U4yCButZVNNM1Z9QG2TizWbM
         cmXcWuh/NYmjAlNdJZP2MpThZv4UoPJMWXtP9JYjyv45GNEBLRyuMosQG/gm/r2+aQ
         y/BPzNzgu78XNTDl5vmveue+3Z6Jm5F9kAFBjBYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 198/200] KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
Date:   Mon, 31 Jan 2022 11:57:41 +0100
Message-Id: <20220131105240.190536836@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/evmcs.c |    3 +--
 arch/x86/kvm/vmx/evmcs.h |   32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -12,8 +12,6 @@
 
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
-#if IS_ENABLED(CONFIG_HYPERV)
-
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
 #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
 		{EVMCS1_OFFSET(name), clean_field}
@@ -296,6 +294,7 @@ const struct evmcs_field vmcs_field_to_e
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
+#if IS_ENABLED(CONFIG_HYPERV)
 __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
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


