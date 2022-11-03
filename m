Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE95C617F1C
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiKCOPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiKCOPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E04111834
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94fXNJlMtb+F/0JTvy69iWSeE6FRHdWRb8tmVfQpuZA=;
        b=FMytOsxtkBC7pVDTN0p8dtSADhozEzokwm1s/1dOpICF6i+KPJi/2dGL1OJ0cdK7KGsVBZ
        HLqUTCa8SXSkXDNaXeyLIrFKTzkJPFZIWJUgoUxGDNVpRWsGrIchkDoy1g/UhwGERt69SG
        HeAmAbWDgwgrHHbBhCpAV+/lYQ2h0rY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-EnmTDWMaOJ2pOzA6ZiKQVg-1; Thu, 03 Nov 2022 10:14:09 -0400
X-MC-Unique: EnmTDWMaOJ2pOzA6ZiKQVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECC8085A583;
        Thu,  3 Nov 2022 14:14:07 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4900D40C6EC3;
        Thu,  3 Nov 2022 14:14:04 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/9] KVM: x86: add kvm_leave_nested
Date:   Thu,  3 Nov 2022 16:13:45 +0200
Message-Id: <20221103141351.50662-4-mlevitsk@redhat.com>
In-Reply-To: <20221103141351.50662-1-mlevitsk@redhat.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

