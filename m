Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296F0605B31
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiJTJbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 05:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiJTJbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 05:31:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0FD155DBB
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 02:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666258278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P73JFXQ3AWZGy0kFIbXH5/4fwtY8KoEObX2sf4YZ6rg=;
        b=M+s2VQTUPJb84UXona+0WMFF0rI77VGeYoOkxXeA4CwaFdupRH5tCgjygwXueIDEanHgfR
        r0Kk0UBwM8lvsFIsHeR6GGIyIkOCpEvQ1yHhu6+aii3rjj57VednYjhBWsJYphPy1pTWoM
        tccbSTv/CJAlI0rup0GATeL9duexAXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-w3fq1VFrN-yCpp6SElqxpQ-1; Thu, 20 Oct 2022 05:31:15 -0400
X-MC-Unique: w3fq1VFrN-yCpp6SElqxpQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6654085A583;
        Thu, 20 Oct 2022 09:31:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99B2249BB60;
        Thu, 20 Oct 2022 09:31:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86: add kvm_leave_nested
Date:   Thu, 20 Oct 2022 12:30:54 +0300
Message-Id: <20221020093055.224317-4-mlevitsk@redhat.com>
In-Reply-To: <20221020093055.224317-1-mlevitsk@redhat.com>
References: <20221020093055.224317-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Wrap a call to nested_ops->leave_nested into a function.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 ---
 arch/x86/kvm/vmx/nested.c | 3 ---
 arch/x86/kvm/x86.c        | 8 +++++++-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b02a3a1792f194..7354f0035a691d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1146,9 +1146,6 @@ void svm_free_nested(struct vcpu_svm *svm)
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8f67a9c4a28706..a66c5e276ab408 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6440,9 +6440,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de91..d86a8aae1471d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -628,6 +628,12 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
 	ex->payload = payload;
 }
 
+/* Forcibly leave the nested mode in cases like a vCPU reset */
+static void kvm_leave_nested(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.nested_ops->leave_nested(vcpu);
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -5200,7 +5206,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 
-- 
2.26.3

