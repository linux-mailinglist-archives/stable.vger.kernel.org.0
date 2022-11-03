Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F30617EA0
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiKCN7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 09:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiKCN7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 09:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E5715A01
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667483876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94fXNJlMtb+F/0JTvy69iWSeE6FRHdWRb8tmVfQpuZA=;
        b=hWLdBWdxtXkijbB9ZwWgdbe2woCJi17xJltKQ3aJ/ASn36KqlHeJi0+MeiYOHfcexK65MD
        Au8XYrPQvnS0SzHkaw6yTLfhPzF+LBotMGikmPx0WC3fWUlZeGu++dlu6Oaj39w40IRwAj
        7nsqBGfkMPXoiegftbAweahqbTwxnGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-hIm7tAVWNzu-RCY0-B8plw-1; Thu, 03 Nov 2022 09:57:53 -0400
X-MC-Unique: hIm7tAVWNzu-RCY0-B8plw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB7E21C14345;
        Thu,  3 Nov 2022 13:57:52 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76BD940C83AD;
        Thu,  3 Nov 2022 13:57:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3/9] KVM: x86: add kvm_leave_nested
Date:   Thu,  3 Nov 2022 15:57:30 +0200
Message-Id: <20221103135736.42295-4-mlevitsk@redhat.com>
In-Reply-To: <20221103135736.42295-1-mlevitsk@redhat.com>
References: <20221103135736.42295-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

add kvm_leave_nested which wraps a call to nested_ops->leave_nested
into a function.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 ---
 arch/x86/kvm/vmx/nested.c | 3 ---
 arch/x86/kvm/x86.c        | 8 +++++++-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b74da40c1fc40c..bcc4f6620f8aec 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1147,9 +1147,6 @@ void svm_free_nested(struct vcpu_svm *svm)
 	svm->nested.initialized = false;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a08..1ebe141a0a015f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6441,9 +6441,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-/*
- * Forcibly leave nested mode in order to be able to reset the VCPU later on.
- */
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd9eb13e2ed7fc..316ab1d5317f92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -627,6 +627,12 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
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
@@ -5193,7 +5199,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
 #ifdef CONFIG_KVM_SMM
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
-			kvm_x86_ops.nested_ops->leave_nested(vcpu);
+			kvm_leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
 		}
 
-- 
2.34.3

