Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5EF17816C
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbgCCSCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388192AbgCCSCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4075220866;
        Tue,  3 Mar 2020 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258540;
        bh=qjzHJ7RyXbk68kqkDHkrRTeM8Wey8C0wgzXF/aGFSeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVTXD9ux069sZP4A4SaxVvcGIrF4+OXGoYzOn7lruVEe3WgDj3Lylxk9FOb7U2bkh
         OGMs+Tjq/lpHkoCOQcU0V34EsbRZj7qFTyqCcM826Sn2glnWj8BCaCW6tIl5a4NKyj
         KnkS0LC7M3AwCYB/OR2ejh/3qGWOZiTydG8XIc3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 70/87] KVM: SVM: Override default MMIO mask if memory encryption is enabled
Date:   Tue,  3 Mar 2020 18:44:01 +0100
Message-Id: <20200303174356.572899901@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
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
@@ -1298,6 +1298,47 @@ static void shrink_ple_window(struct kvm
 				    control->pause_filter_count, old);
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
@@ -1352,6 +1393,8 @@ static __init int svm_hardware_setup(voi
 		}
 	}
 
+	svm_adjust_mmio_mask();
+
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)


