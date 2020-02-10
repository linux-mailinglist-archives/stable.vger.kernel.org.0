Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2565C1578E8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgBJNLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgBJMjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E9821739;
        Mon, 10 Feb 2020 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338343;
        bh=4mGwWxzEYh40tjmh+lT3PHS0E4bny4D4na8h31TGSHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOXyqoNo4Hyt2iob3HQHMHLOuqBSTRqg1MIm8RyYWaiy0jv9bjdu2Pj4IwIi+eF5O
         Hb+11q0GpTDCinni/xAa71q4zs9C1aMRzXjYHAKv2KyVSutACasqRDdnxDl5ojPDMq
         mqlHR8cH/gPze2z2FPXtdSi45siHBNmG4jB/aQvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 296/309] KVM: x86: use CPUID to locate host page table reserved bits
Date:   Mon, 10 Feb 2020 04:34:12 -0800
Message-Id: <20200210122435.244391679@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 7adacf5eb2d2048045d9fd8fdab861fd9e7e2e96 ]

The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
available, it is simplest and works even if memory is not encrypted.

Cc: stable@vger.kernel.org
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3644ac215567b..d05c10651398f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -538,16 +538,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
-	 * in CPU detection code, but MKTME treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
-	 * we should still return physical address bits reported by CPUID.
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_TME) ||
-	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
-		return boot_cpu_data.x86_phys_bits;
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
 
-	return cpuid_eax(0x80000008) & 0xff;
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
 }
 
 static void kvm_mmu_reset_all_pte_masks(void)
-- 
2.20.1



