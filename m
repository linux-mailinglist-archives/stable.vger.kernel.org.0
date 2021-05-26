Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987D63911B1
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhEZIAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 04:00:01 -0400
Received: from [110.188.70.11] ([110.188.70.11]:51051 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S231993AbhEZIAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 04:00:00 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2021 03:59:59 EDT
Received: from spam2.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam2.hygon.cn with ESMTP id 14Q7RSgW019266;
        Wed, 26 May 2021 15:27:28 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam2.hygon.cn with ESMTP id 14Q7PRq7019119;
        Wed, 26 May 2021 15:25:27 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-DB.hygon.cn with ESMTP id 14Q7PLjd075433;
        Wed, 26 May 2021 15:25:22 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from ubuntu1604-2.higon.com (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Wed, 26 May
 2021 15:25:22 +0800
From:   Pu Wen <puwen@hygon.cn>
To:     <x86@kernel.org>
CC:     <puwen@hygon.cn>, <joro@8bytes.org>, <thomas.lendacky@amd.com>,
        <dave.hansen@linux.intel.com>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@suse.de>,
        <hpa@zytor.com>, <jroedel@suse.de>, <sashal@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] x86/sev: Check whether SEV or SME is supported first
Date:   Wed, 26 May 2021 15:24:24 +0800
Message-ID: <20210526072424.22453-1-puwen@hygon.cn>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam2.hygon.cn 14Q7RSgW019266
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first two bits of the CPUID leaf 0x8000001F EAX indicate whether
SEV or SME is supported respectively. It's better to check whether
SEV or SME is supported before checking the SEV MSR(0xc0010131) to
see whether SEV or SME is enabled.

This also avoid the MSR reading failure on the first generation Hygon
Dhyana CPU which does not support SEV or SME.

Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Pu Wen <puwen@hygon.cn>
---
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

