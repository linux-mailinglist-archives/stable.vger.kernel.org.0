Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7AC498066
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiAXNFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:05:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241581AbiAXNFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643029541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zf7vHRniRoPq6qM5QG33wE6VsCHfcA9ljDhs++LxBdc=;
        b=RVkf1V6nVkmbz6yWwR39pnnBfLXBIYDagIvnIbyDtTQ/TbQQXqfTaEdYVQnEdgoMOH3SXf
        9x3DZjkfmx75q5xreyqvMjmiYRh71qOREm1xTMq++aNOIQ0PfOdbDATPuRhPvt3vIurjyu
        KdHRwOhnr68l3ESaH7T4oAkLZtWbzFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-k7ii2OVnP6--D9OQLASBhg-1; Mon, 24 Jan 2022 08:05:40 -0500
X-MC-Unique: k7ii2OVnP6--D9OQLASBhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AE9A814404;
        Mon, 24 Jan 2022 13:05:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DE7A7D4A4;
        Mon, 24 Jan 2022 13:05:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 1/4] KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
Date:   Mon, 24 Jan 2022 14:05:31 +0100
Message-Id: <20220124130534.2645955-2-vkuznets@redhat.com>
In-Reply-To: <20220124130534.2645955-1-vkuznets@redhat.com>
References: <20220124130534.2645955-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ee3a5f9e3d9bf94159f3cc80da542fbe83502dd8 upstream.

kvm_update_cpuid_runtime() mangles CPUID data coming from userspace
VMM after updating 'vcpu->arch.cpuid_entries', this makes it
impossible to compare an update with what was previously
supplied. Introduce __kvm_update_cpuid_runtime() version which can be
used to tweak the input before it goes to 'vcpu->arch.cpuid_entries'
so the upcoming update check can compare tweaked data.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220117150542.2176196-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 54 ++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..c4d4c350afbe 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,14 +125,21 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 	}
 }
 
-static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
+					      struct kvm_cpuid_entry2 *entries, int nent)
 {
 	u32 base = vcpu->arch.kvm_cpuid_base;
 
 	if (!base)
 		return NULL;
 
-	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
+	return cpuid_entry2_find(entries, nent, base | KVM_CPUID_FEATURES, 0);
+}
+
+static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+{
+	return __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
+					     vcpu->arch.cpuid_nent);
 }
 
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
@@ -147,11 +154,12 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = cpuid_entry2_find(entries, nent, 1, 0);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -162,33 +170,38 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+	best = cpuid_entry2_find(entries, nent, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_kvm_cpuid_features(vcpu);
+	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+		best = cpuid_entry2_find(entries, nent, 0x1, 0);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+{
+	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+}
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -276,21 +289,22 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
-    int r;
+	int r;
 
-    r = kvm_check_cpuid(e2, nent);
-    if (r)
-        return r;
+	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
-    kvfree(vcpu->arch.cpuid_entries);
-    vcpu->arch.cpuid_entries = e2;
-    vcpu->arch.cpuid_nent = nent;
+	r = kvm_check_cpuid(e2, nent);
+	if (r)
+		return r;
 
-    kvm_update_kvm_cpuid_base(vcpu);
-    kvm_update_cpuid_runtime(vcpu);
-    kvm_vcpu_after_set_cpuid(vcpu);
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
 
-    return 0;
+	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
+
+	return 0;
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.34.1

