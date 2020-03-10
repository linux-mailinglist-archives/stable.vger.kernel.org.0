Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6665F17FAF3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgCJNJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgCJNJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BFD32468D;
        Tue, 10 Mar 2020 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845776;
        bh=QHH9ZDp6/gEjEOe3GhgF4+iH08VXpuPOLoiGZqInhJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16EMCJNyly4Mu4zdzQk0HqomH0kV71FPZWQgnXzH+7LGA9YLuSXopr6fmaTIozG8x
         DXyeSCsU98aX9QAG39hAS9XUgm1KGV8XD2PS9Tbl1egSzjcgo7pjAfMIIb4h3fANJ4
         winY+srCJEGG9hUoLFYxmsxAPptB15Lqw0+1VEbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 057/126] KVM: SVM: Override default MMIO mask if memory encryption is enabled
Date:   Tue, 10 Mar 2020 13:41:18 +0100
Message-Id: <20200310124207.819562318@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 52918ed5fcf05d97d257f4131e19479da18f5d16 upstream.

The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
faults when a guest performs MMIO. The AMD memory encryption support uses
a CPUID function to define the encryption bit position. Given this, it is
possible that these bits can conflict.

Use svm_hardware_setup() to override the MMIO mask if memory encryption
support is enabled. Various checks are performed to ensure that the mask
is properly defined and rsvd_bits() is used to generate the new mask (as
was done prior to the change that necessitated this patch).

Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1088,6 +1088,47 @@ static int avic_ga_log_notifier(u32 ga_t
 	return 0;
 }
 
+/*
+ * The default MMIO mask is a single bit (excluding the present bit),
+ * which could conflict with the memory encryption bit. Check for
+ * memory encryption support and override the default MMIO mask if
+ * memory encryption is enabled.
+ */
+static __init void svm_adjust_mmio_mask(void)
+{
+	unsigned int enc_bit, mask_bit;
+	u64 msr, mask;
+
+	/* If there is no memory encryption support, use existing mask */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return;
+
+	/* If memory encryption is not enabled, use existing mask */
+	rdmsrl(MSR_K8_SYSCFG, msr);
+	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		return;
+
+	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	mask_bit = boot_cpu_data.x86_phys_bits;
+
+	/* Increment the mask bit if it is the same as the encryption bit */
+	if (enc_bit == mask_bit)
+		mask_bit++;
+
+	/*
+	 * If the mask bit location is below 52, then some bits above the
+	 * physical addressing limit will always be reserved, so use the
+	 * rsvd_bits() function to generate the mask. This mask, along with
+	 * the present bit, will be used to generate a page fault with
+	 * PFER.RSV = 1.
+	 *
+	 * If the mask bit location is 52 (or above), then clear the mask.
+	 */
+	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
+
+	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1123,6 +1164,8 @@ static __init int svm_hardware_setup(voi
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
+	svm_adjust_mmio_mask();
+
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)


