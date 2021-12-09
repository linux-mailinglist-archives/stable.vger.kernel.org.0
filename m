Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E955D46F6DF
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhLIWeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232449AbhLIWeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 17:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639089046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t+kB11hh+VnOtImVW4ebeHRG4lBJpxm4ZYPg2Y8mUU0=;
        b=QSKvlt/1pQaKyfbicHx29venllH82rLw0023wePzctS54VzjUTaNW0aky7sqQqv1LN21mr
        wu16qpAJ8aHkMb2dvbAmCNMi1T6dEPsrAnTvSCNDvB+xIcEdxPSoVgWtXvKcmyRVAbxDis
        JZDplfu/EZW/RZWisZxX0yYde4zxcB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-YwwddUEVPfe8NVlPUGPhxw-1; Thu, 09 Dec 2021 17:30:43 -0500
X-MC-Unique: YwwddUEVPfe8NVlPUGPhxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CFFD100CE91;
        Thu,  9 Dec 2021 22:30:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CE255DF37;
        Thu,  9 Dec 2021 22:30:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v3] selftests: KVM: avoid failures due to reserved HyperTransport region
Date:   Thu,  9 Dec 2021 17:30:40 -0500
Message-Id: <20211209223040.304355-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  9 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 69 +++++++++++++++++++
 3 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 6a1a37f30494..da2b702da71a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -71,6 +71,15 @@ enum vm_guest_mode {
 
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
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8f2e0bb1ef96..daf6fdb217a7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -302,7 +302,7 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
 
 	/* Limit physical addresses to PA-bits. */
-	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+	vm->max_gfn = vm_compute_max_gfn(vm);
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 82c39db91369..5e587d81dec3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1431,3 +1431,72 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 
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
+	 * Otherwise it's at the top of the physical address
+	 * space, possibly reduced due to SME by bits 11:6 of
+	 * CPUID[0x8000001f].EBX.  Use the old conservative
+	 * value if MAXPHYADDR is not enumerated.
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
-- 
2.31.1

