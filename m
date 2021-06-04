Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77039BDEE
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 19:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFDREi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDREh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 13:04:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4D3C061767;
        Fri,  4 Jun 2021 10:02:51 -0700 (PDT)
Date:   Fri, 04 Jun 2021 17:02:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622826169;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9M/O8z/gE/UJe1hlJepOyyETr4yp+Qwwjpm8dhZ+Xo=;
        b=rIQividxvZTtQiiN+YPqTYPffmJfjuyTeTgrf/hkCbQNsHQ5zFI0s4wUsFa9Mg+y/eZ6AB
        p0R5PTKbU5+qLmmHTvg0eWtM11ThdC3+2Dck/qxKNs72hEymhUVOOcuJon4f9WANCL2Ok7
        ucQLrbSfWCY+qWbJCt9o/oy3nkGpPeJATHOOb6xvihPiwIQFIz2KdERD7yzm7VEndYrq9f
        vynjIKiMIsnG1lwT8LLg6FVsmrZxLnlcdEjv/Np4uXIERseHOAw3Llcn5FkmfaxhvyB3LR
        PTsnNYZ+RkncZcGzFR1WacyQK/bwJOCse2V5Kt208LZO6Ui0j6z/vgKJHTF1Cw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622826169;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9M/O8z/gE/UJe1hlJepOyyETr4yp+Qwwjpm8dhZ+Xo=;
        b=xw24C5s8ZCBh5PsUG7RBnOJgT4JTTs+yG7z7xOnTcBFWVe1x3W6dSeX1cvwPYlDQTzKywi
        tiQ4DCe3+1dXE3Cw==
From:   "tip-bot2 for Pu Wen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev: Check SME/SEV support in CPUID first
Cc:     Pu Wen <puwen@hygon.cn>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210602070207.2480-1-puwen@hygon.cn>
References: <20210602070207.2480-1-puwen@hygon.cn>
MIME-Version: 1.0
Message-ID: <162282616862.29796.7534384335141540012.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     009767dbf42ac0dbe3cf48c1ee224f6b778aa85a
Gitweb:        https://git.kernel.org/tip/009767dbf42ac0dbe3cf48c1ee224f6b778aa85a
Author:        Pu Wen <puwen@hygon.cn>
AuthorDate:    Wed, 02 Jun 2021 15:02:07 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 04 Jun 2021 18:39:09 +02:00

x86/sev: Check SME/SEV support in CPUID first

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
---
 arch/x86/mm/mem_encrypt_identity.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index a9639f6..470b202 100644
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
