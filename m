Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA5E370C29
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhEBOF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhEBOFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69496613C1;
        Sun,  2 May 2021 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964265;
        bh=ILEpy1J7TlHfivPJPRaTe2nxOeUCInHvx8q4MVLUlIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lae569kzSEdsey4wdplvN+sI6n60H4lz2XSHmKKeE+1wOTQZELT8B4J1WQzCfDJyJ
         a2khabrHpj6TSXdTYWDeFt+aM/TRfeE0U0dSe5BRLteGPYuOavt/jrbtAWCjDHkQbg
         p7R9hx9woQoWOa+8NTJ9WRyJJIcoDBBQxPzYrC29onV24Mc19AvAByxjcYhjZcHj1T
         hOF3KdHWZdxN9XMWhKoZEdBCAEnHBwMSr0xBnXSq7BCF3isPXjnbxHrAQ9eexYhPXB
         ejdmm4qIh3ZASpWDKd9/PVd4OdIuqrgC3TJX7gV4nMdbmbYh+C9Fy5STZRNT5Nl55Q
         HmTXIOm4DKD3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 10/66] x86/sev: Do not require Hypervisor CPUID bit for SEV guests
Date:   Sun,  2 May 2021 10:03:15 -0400
Message-Id: <20210502140411.2719301-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140411.2719301-1-sashal@kernel.org>
References: <20210502140411.2719301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit eab696d8e8b9c9d600be6fad8dd8dfdfaca6ca7c ]

A malicious hypervisor could disable the CPUID intercept for an SEV or
SEV-ES guest and trick it into the no-SEV boot path, where it could
potentially reveal secrets. This is not an issue for SEV-SNP guests,
as the CPUID intercept can't be disabled for those.

Remove the Hypervisor CPUID bit check from the SEV detection code to
protect against this kind of attack and add a Hypervisor bit equals zero
check to the SME detection path to prevent non-encrypted guests from
trying to enable SME.

This handles the following cases:

	1) SEV(-ES) guest where CPUID intercept is disabled. The guest
	   will still see leaf 0x8000001f and the SEV bit. It can
	   retrieve the C-bit and boot normally.

	2) Non-encrypted guests with intercepted CPUID will check
	   the SEV_STATUS MSR and find it 0 and will try to enable SME.
	   This will fail when the guest finds MSR_K8_SYSCFG to be zero,
	   as it is emulated by KVM. But we can't rely on that, as there
	   might be other hypervisors which return this MSR with bit
	   23 set. The Hypervisor bit check will prevent that the guest
	   tries to enable SME in this case.

	3) Non-encrypted guests on SEV capable hosts with CPUID intercept
	   disabled (by a malicious hypervisor) will try to boot into
	   the SME path. This will fail, but it is also not considered
	   a problem because non-encrypted guests have no protection
	   against the hypervisor anyway.

 [ bp: s/non-SEV/non-encrypted/g ]

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20210312123824.306-3-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/mem_encrypt.S |  6 -----
 arch/x86/kernel/sev-es-shared.c        |  6 +----
 arch/x86/mm/mem_encrypt_identity.c     | 35 ++++++++++++++------------
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index aa561795efd1..a6dea4e8a082 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -23,12 +23,6 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	push	%ecx
 	push	%edx
 
-	/* Check if running under a hypervisor */
-	movl	$1, %eax
-	cpuid
-	bt	$31, %ecx		/* Check the hypervisor bit */
-	jnc	.Lno_sev
-
 	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
 	cpuid
 	cmpl	$0x8000001f, %eax	/* See if 0x8000001f is available */
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index cdc04d091242..387b71669818 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -186,7 +186,6 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 	 * make it accessible to the hypervisor.
 	 *
 	 * In particular, check for:
-	 *	- Hypervisor CPUID bit
 	 *	- Availability of CPUID leaf 0x8000001f
 	 *	- SEV CPUID bit.
 	 *
@@ -194,10 +193,7 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
 	 * can't be checked here.
 	 */
 
-	if ((fn == 1 && !(regs->cx & BIT(31))))
-		/* Hypervisor bit */
-		goto fail;
-	else if (fn == 0x80000000 && (regs->ax < 0x8000001f))
+	if (fn == 0x80000000 && (regs->ax < 0x8000001f))
 		/* SEV leaf check */
 		goto fail;
 	else if ((fn == 0x8000001f && !(regs->ax & BIT(1))))
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 6c5eb6f3f14f..a19374d26101 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -503,14 +503,10 @@ void __init sme_enable(struct boot_params *bp)
 
 #define AMD_SME_BIT	BIT(0)
 #define AMD_SEV_BIT	BIT(1)
-	/*
-	 * Set the feature mask (SME or SEV) based on whether we are
-	 * running under a hypervisor.
-	 */
-	eax = 1;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-	feature_mask = (ecx & BIT(31)) ? AMD_SEV_BIT : AMD_SME_BIT;
+
+	/* Check the SEV MSR whether SEV or SME is enabled */
+	sev_status   = __rdmsr(MSR_AMD64_SEV);
+	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
 	/*
 	 * Check for the SME/SEV feature:
@@ -530,19 +526,26 @@ void __init sme_enable(struct boot_params *bp)
 
 	/* Check if memory encryption is enabled */
 	if (feature_mask == AMD_SME_BIT) {
+		/*
+		 * No SME if Hypervisor bit is set. This check is here to
+		 * prevent a guest from trying to enable SME. For running as a
+		 * KVM guest the MSR_K8_SYSCFG will be sufficient, but there
+		 * might be other hypervisors which emulate that MSR as non-zero
+		 * or even pass it through to the guest.
+		 * A malicious hypervisor can still trick a guest into this
+		 * path, but there is no way to protect against that.
+		 */
+		eax = 1;
+		ecx = 0;
+		native_cpuid(&eax, &ebx, &ecx, &edx);
+		if (ecx & BIT(31))
+			return;
+
 		/* For SME, check the SYSCFG MSR */
 		msr = __rdmsr(MSR_K8_SYSCFG);
 		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
 			return;
 	} else {
-		/* For SEV, check the SEV MSR */
-		msr = __rdmsr(MSR_AMD64_SEV);
-		if (!(msr & MSR_AMD64_SEV_ENABLED))
-			return;
-
-		/* Save SEV_STATUS to avoid reading MSR again */
-		sev_status = msr;
-
 		/* SEV state cannot be controlled by a command line option */
 		sme_me_mask = me_mask;
 		sev_enabled = true;
-- 
2.30.2

