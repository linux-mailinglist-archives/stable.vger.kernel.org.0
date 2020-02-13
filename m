Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CBB15B85A
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgBMENO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:13:14 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40239 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729440AbgBMENO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:13:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BE4D21F34;
        Wed, 12 Feb 2020 23:13:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=554X9g
        3uwvUphRKnhJ+ZDY2FC0H/f2QBgjRZSfWfRXE=; b=kspPRB65RdPqo+VNM1jI4i
        6TGM4wzzxovnjR9r/1D6AaPJmMvXHKjEdPcn9s1EyY1psOM+qRKmB3xmJhnB2SaB
        W12YwieGxU2tdiGG7wNFltDh9595jBZNqsEqTiDSrE4Wi5hZpLUgHXezxf8uiMBH
        Qag+D3Yhhbbfs/oAXbX51TE6C2+uFu/98nkYVxw1k6ASsirkyE1rALCIZ6dzLpNO
        FBhrQEqsXjCcTB6Dr7UCi7JldPDe/7xhmtYrLipwFfaTZVppzMMbbdE22SdaRcfo
        khn7xSU0zOG3TThN0UvY9ht8uvnbbDb1MWabOgeB4IcgFXmbq1k9uG35kGQP1Ejw
        ==
X-ME-Sender: <xms:2MxEXvxFeoIUOK9AG-IdYXXyH-jt8aQOKbPgLPgTQ87NIjS3McjHJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrfeejrdeljedrudelgeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2MxEXn-i7wP_TIrR-W3mcahlgUK67Bf70nYP-TnGq8tTZeefZR-dDw>
    <xmx:2MxEXngezy8Pt_uiMPNPRPXrbqPk43Sse6QaQ9hCqear0YFlS4rf-w>
    <xmx:2MxEXuEofelD3ixra1XdaDYxhihlHXROPbuBI4MHbm-gY2Iy7P-haA>
    <xmx:2cxEXg3kKEajJMULZLSy2B-NEpl-A7_porXDMrlwotA7RnMM5XeqfQ>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB495328005A;
        Wed, 12 Feb 2020 23:13:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly" failed to apply to 4.19-stable tree
To:     suzuki.poulose@arm.com, ardb@kernel.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:13:11 -0800
Message-ID: <15815671911912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7559950aef1ab8792c50797c6c5c7c5150a02460 Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Mon, 13 Jan 2020 23:30:20 +0000
Subject: [PATCH] arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly

We set the compat_elf_hwcap bits unconditionally on arm64 to
include the VFP and NEON support. However, the FP/SIMD unit
is optional on Arm v8 and thus could be missing. We already
handle this properly in the kernel, but still advertise to
the COMPAT applications that the VFP is available. Fix this
to make sure we only advertise when we really have them.

Fixes: 82e0191a1aa11abf ("arm64: Support systems without FP/ASIMD")
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2fc9f18e2d2d..c008164b0848 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -32,9 +32,7 @@ static unsigned long elf_hwcap __read_mostly;
 #define COMPAT_ELF_HWCAP_DEFAULT	\
 				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
-				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
-				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
-				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
+				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_IDIV|\
 				 COMPAT_HWCAP_LPAE)
 unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
 unsigned int compat_elf_hwcap2 __read_mostly;
@@ -1597,6 +1595,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.match_list = list,						\
 	}
 
+#define HWCAP_CAP_MATCH(match, cap_type, cap)					\
+	{									\
+		__HWCAP_CAP(#cap, cap_type, cap)				\
+		.matches = match,						\
+	}
+
 #ifdef CONFIG_ARM64_PTR_AUTH
 static const struct arm64_cpu_capabilities ptr_auth_hwcap_addr_matches[] = {
 	{
@@ -1670,8 +1674,35 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	{},
 };
 
+#ifdef CONFIG_COMPAT
+static bool compat_has_neon(const struct arm64_cpu_capabilities *cap, int scope)
+{
+	/*
+	 * Check that all of MVFR1_EL1.{SIMDSP, SIMDInt, SIMDLS} are available,
+	 * in line with that of arm32 as in vfp_init(). We make sure that the
+	 * check is future proof, by making sure value is non-zero.
+	 */
+	u32 mvfr1;
+
+	WARN_ON(scope == SCOPE_LOCAL_CPU && preemptible());
+	if (scope == SCOPE_SYSTEM)
+		mvfr1 = read_sanitised_ftr_reg(SYS_MVFR1_EL1);
+	else
+		mvfr1 = read_sysreg_s(SYS_MVFR1_EL1);
+
+	return cpuid_feature_extract_unsigned_field(mvfr1, MVFR1_SIMDSP_SHIFT) &&
+		cpuid_feature_extract_unsigned_field(mvfr1, MVFR1_SIMDINT_SHIFT) &&
+		cpuid_feature_extract_unsigned_field(mvfr1, MVFR1_SIMDLS_SHIFT);
+}
+#endif
+
 static const struct arm64_cpu_capabilities compat_elf_hwcaps[] = {
 #ifdef CONFIG_COMPAT
+	HWCAP_CAP_MATCH(compat_has_neon, CAP_COMPAT_HWCAP, COMPAT_HWCAP_NEON),
+	HWCAP_CAP(SYS_MVFR1_EL1, MVFR1_SIMDFMAC_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP, COMPAT_HWCAP_VFPv4),
+	/* Arm v8 mandates MVFR0.FPDP == {0, 2}. So, piggy back on this for the presence of VFP support */
+	HWCAP_CAP(SYS_MVFR0_EL1, MVFR0_FPDP_SHIFT, FTR_UNSIGNED, 2, CAP_COMPAT_HWCAP, COMPAT_HWCAP_VFP),
+	HWCAP_CAP(SYS_MVFR0_EL1, MVFR0_FPDP_SHIFT, FTR_UNSIGNED, 2, CAP_COMPAT_HWCAP, COMPAT_HWCAP_VFPv3),
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 2, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_PMULL),
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_AES),
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA1),

