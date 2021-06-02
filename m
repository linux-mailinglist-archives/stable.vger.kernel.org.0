Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE503982A9
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 09:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFBHIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 03:08:54 -0400
Received: from [110.188.70.11] ([110.188.70.11]:55775 "EHLO spam1.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229753AbhFBHIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 03:08:52 -0400
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam1.hygon.cn with ESMTP id 15273S92001983;
        Wed, 2 Jun 2021 15:03:28 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-FE.hygon.cn with ESMTP id 15273P1T031653;
        Wed, 2 Jun 2021 15:03:25 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from ubuntu1604-2.higon.com (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.10; Wed, 2 Jun
 2021 15:03:25 +0800
From:   Pu Wen <puwen@hygon.cn>
To:     <x86@kernel.org>
CC:     <puwen@hygon.cn>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
        <jroedel@suse.de>, <seanjc@google.com>,
        <dave.hansen@linux.intel.com>, <peterz@infradead.org>,
        <mingo@redhat.com>, <hpa@zytor.com>, <sashal@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2] x86/sev: Check whether SEV or SME is supported first
Date:   Wed, 2 Jun 2021 15:02:07 +0800
Message-ID: <20210602070207.2480-1-puwen@hygon.cn>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam1.hygon.cn 15273S92001983
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first two bits of the CPUID leaf 0x8000001F EAX indicate whether
SEV or SME is supported respectively. It's better to check whether
SEV or SME is actually supported before checking the MSR_AMD64_SEV
to see whether SEV or SME is enabled.

This is both a bare-metal issue and a guest/VM issue. Since the first
generation Hygon Dhyana CPU doesn't support MSR_AMD64_SEV, reading that
MSR results in a #GP - either directly from hardware in the bare-metal
case or via the hypervisor (because the RDMSR is actually intercepted)
in the guest/VM case, resulting in a failed boot. And since this is very
early in the boot phase, rdmsrl_safe()/native_read_msr_safe() can't be
used.

So by checking the CPUID information before attempting the RDMSR, this
goes back to the behavior before the patch identified in the commit
eab696d8e8b9.

Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Pu Wen <puwen@hygon.cn>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
  - Provide more details with improved commit messages.

 arch/x86/mm/mem_encrypt_identity.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index a9639f663d25..470b20208430 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -504,10 +504,6 @@ void __init sme_enable(struct boot_params *bp)
 #define AMD_SME_BIT	BIT(0)
 #define AMD_SEV_BIT	BIT(1)
 
-	/* Check the SEV MSR whether SEV or SME is enabled */
-	sev_status   = __rdmsr(MSR_AMD64_SEV);
-	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
-
 	/*
 	 * Check for the SME/SEV feature:
 	 *   CPUID Fn8000_001F[EAX]
@@ -519,11 +515,16 @@ void __init sme_enable(struct boot_params *bp)
 	eax = 0x8000001f;
 	ecx = 0;
 	native_cpuid(&eax, &ebx, &ecx, &edx);
-	if (!(eax & feature_mask))
+	/* Check whether SEV or SME is supported */
+	if (!(eax & (AMD_SEV_BIT | AMD_SME_BIT)))
 		return;
 
 	me_mask = 1UL << (ebx & 0x3f);
 
+	/* Check the SEV MSR whether SEV or SME is enabled */
+	sev_status   = __rdmsr(MSR_AMD64_SEV);
+	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
+
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
 		/*
-- 
2.23.0

