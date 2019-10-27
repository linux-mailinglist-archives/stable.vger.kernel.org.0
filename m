Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352FEE6946
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfJ0VIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbfJ0VIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:41 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47EF42064A;
        Sun, 27 Oct 2019 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210519;
        bh=XAtUwWtLhsBaYmpiDMWm4JPHxyarlQg8VLV/zLpyYp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVrJ0O5rRoBLaxavw50cCblyj5iaYOGe7Oh9WY6f3/nIFLgaqxaS5Ca0w6a8xDkjt
         byL1avQRT5IyXQoQ+PPT521yrXLfhgyOS3y7wV91FJwxgHb9701Jm9koKGhbQSDuJe
         boXVPgIa2nK3emIpv3QduGKx47ElMTl1ugEVd22E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 042/119] arm64: Expose Arm v8.4 features
Date:   Sun, 27 Oct 2019 22:00:19 +0100
Message-Id: <20191027203315.902578426@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 7206dc93a58fb76421c4411eefa3c003337bcb2d ]

Expose the new features introduced by Arm v8.4 extensions to
Arm v8-A profile.

These include :

 1) Data indpendent timing of instructions. (DIT, exposed as HWCAP_DIT)
 2) Unaligned atomic instructions and Single-copy atomicity of loads
    and stores. (AT, expose as HWCAP_USCAT)
 3) LDAPR and STLR instructions with immediate offsets (extension to
    LRCPC, exposed as HWCAP_ILRCPC)
 4) Flag manipulation instructions (TS, exposed as HWCAP_FLAGM).

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ardb: fix up context for missing SVE]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.txt |   10 ++++++++++
 arch/arm64/include/asm/sysreg.h               |    3 +++
 arch/arm64/include/uapi/asm/hwcap.h           |    4 ++++
 arch/arm64/kernel/cpufeature.c                |    7 +++++++
 arch/arm64/kernel/cpuinfo.c                   |    4 ++++
 5 files changed, 28 insertions(+)

--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,6 +110,7 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
+     | TS                           | [55-52] |    y    |
      |--------------------------------------------------|
      | FHM                          | [51-48] |    y    |
      |--------------------------------------------------|
@@ -139,6 +140,7 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
+     | DIT                          | [51-48] |    y    |
      |--------------------------------------------------|
      | SVE                          | [35-32] |    y    |
      |--------------------------------------------------|
@@ -191,6 +193,14 @@ infrastructure:
      | DPB                          | [3-0]   |    y    |
      x--------------------------------------------------x
 
+  5) ID_AA64MMFR2_EL1 - Memory model feature register 2
+
+     x--------------------------------------------------x
+     | Name                         |  bits   | visible |
+     |--------------------------------------------------|
+     | AT                           | [35-32] |    y    |
+     x--------------------------------------------------x
+
 Appendix I: Example
 ---------------------------
 
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -375,6 +375,7 @@
 #define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_TS_SHIFT		52
 #define ID_AA64ISAR0_FHM_SHIFT		48
 #define ID_AA64ISAR0_DP_SHIFT		44
 #define ID_AA64ISAR0_SM4_SHIFT		40
@@ -396,6 +397,7 @@
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
+#define ID_AA64PFR0_DIT_SHIFT		48
 #define ID_AA64PFR0_GIC_SHIFT		24
 #define ID_AA64PFR0_ASIMD_SHIFT		20
 #define ID_AA64PFR0_FP_SHIFT		16
@@ -441,6 +443,7 @@
 #define ID_AA64MMFR1_VMIDBITS_16	2
 
 /* id_aa64mmfr2 */
+#define ID_AA64MMFR2_AT_SHIFT		32
 #define ID_AA64MMFR2_LVA_SHIFT		16
 #define ID_AA64MMFR2_IESB_SHIFT		12
 #define ID_AA64MMFR2_LSM_SHIFT		8
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -44,5 +44,9 @@
 #define HWCAP_SHA512		(1 << 21)
 #define HWCAP_SVE		(1 << 22)
 #define HWCAP_ASIMDFHM		(1 << 23)
+#define HWCAP_DIT		(1 << 24)
+#define HWCAP_USCAT		(1 << 25)
+#define HWCAP_ILRCPC		(1 << 26)
+#define HWCAP_FLAGM		(1 << 27)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,7 @@ cpufeature_pan_not_uao(const struct arm6
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_TS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_FHM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_DP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
@@ -132,6 +133,7 @@ static const struct arm64_ftr_bits ftr_i
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_DIT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -171,6 +173,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_IESB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LSM_SHIFT, 4, 0),
@@ -1054,14 +1057,18 @@ static const struct arm64_cpu_capabiliti
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM4_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM4),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_DP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDDP),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_FHM_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDFHM),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_TS_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FLAGM),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_FPHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_ASIMDHP),
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_DIT_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_DIT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_DPB_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_DCPOP),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_JSCVT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ILRCPC),
+	HWCAP_CAP(SYS_ID_AA64MMFR2_EL1, ID_AA64MMFR2_AT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_USCAT),
 	{},
 };
 
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -76,6 +76,10 @@ static const char *const hwcap_str[] = {
 	"sha512",
 	"sve",
 	"asimdfhm",
+	"dit",
+	"uscat",
+	"ilrcpc",
+	"flagm",
 	NULL
 };
 


