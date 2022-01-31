Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C694A4359
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359409AbiAaLVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377310AbiAaLR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6D81B82A5C;
        Mon, 31 Jan 2022 11:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD3DC340EE;
        Mon, 31 Jan 2022 11:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627877;
        bh=3PhrSa9o0GNXbS7Lmn2NAFstnx7nk83jQUk7CopRbo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOzfMaYzVDdp8ZiyHI6BegYZAsh/bCwVYtWtp4ejEB66ngz1G9T82rhTYJmAIUuFa
         eX5YlLOpYd+qcDOwtm/DqyH/mHX96VpYN/g3EzsXPjBe1ubrxyaXoxox7DH0mRyled
         kFfm1xURAlN+jlLexpoxahQDalYrJRW9uV3dx8OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 052/200] KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to __kvm_update_cpuid_runtime()
Date:   Mon, 31 Jan 2022 11:55:15 +0100
Message-Id: <20220131105235.324283439@linuxfoundation.org>
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

commit 5c89be1dd5cfb697614bc13626ba3bd0781aa160 upstream.

Full equality check of CPUID data on update (kvm_cpuid_check_equal()) may
fail for SGX enabled CPUs as CPUID.(EAX=0x12,ECX=1) is currently being
mangled in kvm_vcpu_after_set_cpuid(). Move it to
__kvm_update_cpuid_runtime() and split off cpuid_get_supported_xcr0()
helper  as 'vcpu->arch.guest_supported_xcr0' update needs (logically)
to stay in kvm_vcpu_after_set_cpuid().

Cc: stable@vger.kernel.org
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220124103606.2630588-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   54 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -176,10 +176,26 @@ void kvm_update_pv_runtime(struct kvm_vc
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
+/*
+ * Calculate guest's supported XCR0 taking into account guest CPUID data and
+ * supported_xcr0 (comprised of host configuration and KVM_SUPPORTED_XCR0).
+ */
+static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	if (!best)
+		return 0;
+
+	return (best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+}
+
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
+	u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
 
 	best = cpuid_entry2_find(entries, nent, 1, 0);
 	if (best) {
@@ -218,6 +234,21 @@ static void __kvm_update_cpuid_runtime(s
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
+
+	/*
+	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
+	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
+	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
+	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
+	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
+	 * '1' even on CPUs that don't support XSAVE.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x12, 0x1);
+	if (best) {
+		best->ecx &= guest_supported_xcr0 & 0xffffffff;
+		best->edx &= guest_supported_xcr0 >> 32;
+		best->ecx |= XFEATURE_MASK_FPSSE;
+	}
 }
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
@@ -241,27 +272,8 @@ static void kvm_vcpu_after_set_cpuid(str
 		kvm_apic_set_version(vcpu);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
-		vcpu->arch.guest_supported_xcr0 = 0;
-	else
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
-
-	/*
-	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
-	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
-	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
-	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
-	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
-	 * '1' even on CPUs that don't support XSAVE.
-	 */
-	best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
-	if (best) {
-		best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
-		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
-		best->ecx |= XFEATURE_MASK_FPSSE;
-	}
+	vcpu->arch.guest_supported_xcr0 =
+		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
 	kvm_update_pv_runtime(vcpu);
 


