Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A347288E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240305AbhLMKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46136 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbhLMJ4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3830CE0E85;
        Mon, 13 Dec 2021 09:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DA1C34601;
        Mon, 13 Dec 2021 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389404;
        bh=q6kYNjuRyZxJiwplzh8MYrHB3szUhr1KWHr4N1NdtXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwOFaJRHfhz9ZMsHBRbbh5kGdtq9C5ZCLlDsXYs8UZa9ZoPfDxKukGFLIPMwAydqp
         6zLwDgOezLMr4yi8zfeqdbVyCSxm7eSibzprqWHpkSVvVsJJMVFfUhs92dPqzWoZDc
         PdP2bYuFnetgCWPjLlAbIT4PspzMPQUH5xl6DQoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 087/171] selftests: KVM: avoid failures due to reserved HyperTransport region
Date:   Mon, 13 Dec 2021 10:30:02 +0100
Message-Id: <20211213092947.985461518@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit c8cc43c1eae2910ac96daa4216e0fb3391ad0504 upstream.

AMD proceessors define an address range that is reserved by HyperTransport
and causes a failure if used for guest physical addresses.  Avoid
selftests failures by reserving those guest physical addresses; the
rules are:

- On parts with <40 bits, its fully hidden from software.

- Before Fam17h, it was always 12G just below 1T, even if there was more
RAM above this location.  In this case we just not use any RAM above 1T.

- On Fam17h and later, it is variable based on SME, and is either just
below 2^48 (no encryption) or 2^43 (encryption).

Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210805105423.412878-1-pbonzini@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |    9 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |    2 
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   68 +++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -69,6 +69,15 @@ enum vm_guest_mode {
 
 #endif
 
+#if defined(__x86_64__)
+unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
+#else
+static inline unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
+{
+	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+}
+#endif
+
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
 #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
 
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -307,7 +307,7 @@ struct kvm_vm *vm_create(enum vm_guest_m
 		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
 
 	/* Limit physical addresses to PA-bits. */
-	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+	vm->max_gfn = vm_compute_max_gfn(vm);
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1433,3 +1433,71 @@ struct kvm_cpuid2 *vcpu_get_supported_hv
 
 	return cpuid;
 }
+
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
+
+static inline unsigned x86_family(unsigned int eax)
+{
+        unsigned int x86;
+
+        x86 = (eax >> 8) & 0xf;
+
+        if (x86 == 0xf)
+                x86 += (eax >> 20) & 0xff;
+
+        return x86;
+}
+
+unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
+{
+	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
+	unsigned long ht_gfn, max_gfn, max_pfn;
+	uint32_t eax, ebx, ecx, edx, max_ext_leaf;
+
+	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
+
+	/* Avoid reserved HyperTransport region on AMD processors.  */
+	eax = ecx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	if (ebx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx ||
+	    ecx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx ||
+	    edx != X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
+		return max_gfn;
+
+	/* On parts with <40 physical address bits, the area is fully hidden */
+	if (vm->pa_bits < 40)
+		return max_gfn;
+
+	/* Before family 17h, the HyperTransport area is just below 1T.  */
+	ht_gfn = (1 << 28) - num_ht_pages;
+	eax = 1;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	if (x86_family(eax) < 0x17)
+		goto done;
+
+	/*
+	 * Otherwise it's at the top of the physical address space, possibly
+	 * reduced due to SME by bits 11:6 of CPUID[0x8000001f].EBX.  Use
+	 * the old conservative value if MAXPHYADDR is not enumerated.
+	 */
+	eax = 0x80000000;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	max_ext_leaf = eax;
+	if (max_ext_leaf < 0x80000008)
+		goto done;
+
+	eax = 0x80000008;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	max_pfn = (1ULL << ((eax & 0xff) - vm->page_shift)) - 1;
+	if (max_ext_leaf >= 0x8000001f) {
+		eax = 0x8000001f;
+		cpuid(&eax, &ebx, &ecx, &edx);
+		max_pfn >>= (ebx >> 6) & 0x3f;
+	}
+
+	ht_gfn = max_pfn - num_ht_pages;
+done:
+	return min(max_gfn, ht_gfn - 1);
+}


