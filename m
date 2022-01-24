Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CCA49A385
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365504AbiAXXvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53938 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573435AbiAXVo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59005B81233;
        Mon, 24 Jan 2022 21:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AABFC340E4;
        Mon, 24 Jan 2022 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060693;
        bh=0m840cvT6xgkDwj13KN7JfbNhkL66SG8ih2oD6QU2Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkK4MrL60YvQ/ebZz/jNMVsSg+e2lD3cX76tNJtv6Hfhs4+8C78sF1ISGury/i4pm
         zoBmG1sky5sUULgcB2jc9YE0l6oLrfo5N+Mo+6hbb9RsWqnwGyQhnSYUMqYWWdFFaF
         mmngd6Cs8qoGllv4m5zJJg/GBxejvGQ6tzqMGVvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 1032/1039] KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
Date:   Mon, 24 Jan 2022 19:47:01 +0100
Message-Id: <20220124184159.980048786@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   54 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,14 +125,21 @@ static void kvm_update_kvm_cpuid_base(st
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
@@ -147,11 +154,12 @@ void kvm_update_pv_runtime(struct kvm_vc
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
@@ -162,33 +170,38 @@ void kvm_update_cpuid_runtime(struct kvm
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
@@ -276,21 +289,22 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struc
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
-    int r;
+	int r;
+
+	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
-    r = kvm_check_cpuid(e2, nent);
-    if (r)
-        return r;
+	r = kvm_check_cpuid(e2, nent);
+	if (r)
+		return r;
 
-    kvfree(vcpu->arch.cpuid_entries);
-    vcpu->arch.cpuid_entries = e2;
-    vcpu->arch.cpuid_nent = nent;
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
 
-    kvm_update_kvm_cpuid_base(vcpu);
-    kvm_update_cpuid_runtime(vcpu);
-    kvm_vcpu_after_set_cpuid(vcpu);
+	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 
-    return 0;
+	return 0;
 }
 
 /* when an old userspace process fills a new kernel module */


