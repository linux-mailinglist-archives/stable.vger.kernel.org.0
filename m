Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39F3A0388
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhFHTSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234614AbhFHTQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D1AA61954;
        Tue,  8 Jun 2021 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178247;
        bh=IWzbsvazQ/Rv68RMwi2/R6ZolNNYvus/0NQQowmYP0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov9A4YTH0s/hNXeu8t2KQyZ84wP7Z1MVmLiLWo7+mjEh9TZXqCVWoiClUiIs3+j10
         Ly2bvxJM3B0ozm8bXXdWFyQCOWsrDdQs+CjU2QmhBCgtMlNBbR9D2QwskC1lD7MPU5
         4gsEoUNORArg0XVDQEpc0d1DeNkL6XkT736/8VbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pu Wen <puwen@hygon.cn>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5.12 132/161] x86/sev: Check SME/SEV support in CPUID first
Date:   Tue,  8 Jun 2021 20:27:42 +0200
Message-Id: <20210608175949.910197372@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Wen <puwen@hygon.cn>

commit 009767dbf42ac0dbe3cf48c1ee224f6b778aa85a upstream.

The first two bits of the CPUID leaf 0x8000001F EAX indicate whether SEV
or SME is supported, respectively. It's better to check whether SEV or
SME is actually supported before accessing the MSR_AMD64_SEV to check
whether SEV or SME is enabled.

This is both a bare-metal issue and a guest/VM issue. Since the first
generation Hygon Dhyana CPU doesn't support the MSR_AMD64_SEV, reading that
MSR results in a #GP - either directly from hardware in the bare-metal
case or via the hypervisor (because the RDMSR is actually intercepted)
in the guest/VM case, resulting in a failed boot. And since this is very
early in the boot phase, rdmsrl_safe()/native_read_msr_safe() can't be
used.

So check the CPUID bits first, before accessing the MSR.

 [ tlendacky: Expand and improve commit message. ]
 [ bp: Massage commit message. ]

Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
Signed-off-by: Pu Wen <puwen@hygon.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org> # v5.10+
Link: https://lkml.kernel.org/r/20210602070207.2480-1-puwen@hygon.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt_identity.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -504,10 +504,6 @@ void __init sme_enable(struct boot_param
 #define AMD_SME_BIT	BIT(0)
 #define AMD_SEV_BIT	BIT(1)
 
-	/* Check the SEV MSR whether SEV or SME is enabled */
-	sev_status   = __rdmsr(MSR_AMD64_SEV);
-	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
-
 	/*
 	 * Check for the SME/SEV feature:
 	 *   CPUID Fn8000_001F[EAX]
@@ -519,11 +515,16 @@ void __init sme_enable(struct boot_param
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


