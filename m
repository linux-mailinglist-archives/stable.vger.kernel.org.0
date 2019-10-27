Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07B5E6957
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJ0VIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbfJ0VIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:30 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643B62064A;
        Sun, 27 Oct 2019 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210508;
        bh=LrEnPeVhq6yQcz7sd9WQA4o5nzujb5fKi9TILZ/Py4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zygmlp0iVFHYZYCamVGBHB8RHy151419CtlrCRiyY2zL/9MfGGhuhIcqEhydDI8vf
         1VR2u/NYWuFoK5ccFFvgE6EI7DeCnGLd7oe3vTf+VbJAw3MjCR6qAwbfSbypEgd3hK
         zrwn1jBjstwUaWHJUihgNqi+Ig9jrZrHgz4h6Qz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 038/119] arm64: Expose support for optional ARMv8-A features
Date:   Sun, 27 Oct 2019 22:00:15 +0100
Message-Id: <20191027203313.223888035@linuxfoundation.org>
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

[ Upstream commit f5e035f8694c3bdddc66ea46ecda965ee6853718 ]

ARMv8-A adds a few optional features for ARMv8.2 and ARMv8.3.
Expose them to the userspace via HWCAPs and mrs emulation.

SHA2-512  - Instruction support for SHA512 Hash algorithm (e.g SHA512H,
	    SHA512H2, SHA512U0, SHA512SU1)
SHA3 	  - SHA3 crypto instructions (EOR3, RAX1, XAR, BCAX).
SM3	  - Instruction support for Chinese cryptography algorithm SM3
SM4 	  - Instruction support for Chinese cryptography algorithm SM4
DP	  - Dot Product instructions (UDOT, SDOT).

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.txt |   12 +++++++++++-
 arch/arm64/include/asm/sysreg.h               |    4 ++++
 arch/arm64/include/uapi/asm/hwcap.h           |    5 +++++
 arch/arm64/kernel/cpufeature.c                |    9 +++++++++
 arch/arm64/kernel/cpuinfo.c                   |    5 +++++
 5 files changed, 34 insertions(+), 1 deletion(-)

--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,10 +110,20 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-32] |    n    |
+     | RES0                         | [63-48] |    n    |
+     |--------------------------------------------------|
+     | DP                           | [47-44] |    y    |
+     |--------------------------------------------------|
+     | SM4                          | [43-40] |    y    |
+     |--------------------------------------------------|
+     | SM3                          | [39-36] |    y    |
+     |--------------------------------------------------|
+     | SHA3                         | [35-32] |    y    |
      |--------------------------------------------------|
      | RDM                          | [31-28] |    y    |
      |--------------------------------------------------|
+     | RES0                         | [27-24] |    n    |
+     |--------------------------------------------------|
      | ATOMICS                      | [23-20] |    y    |
      |--------------------------------------------------|
      | CRC32                        | [19-16] |    y    |
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -375,6 +375,10 @@
 #define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_DP_SHIFT		44
+#define ID_AA64ISAR0_SM4_SHIFT		40
+#define ID_AA64ISAR0_SM3_SHIFT		36
+#define ID_AA64ISAR0_SHA3_SHIFT		32
 #define ID_AA64ISAR0_RDM_SHIFT		28
 #define ID_AA64ISAR0_ATOMICS_SHIFT	20
 #define ID_AA64ISAR0_CRC32_SHIFT	16
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -37,5 +37,10 @@
 #define HWCAP_FCMA		(1 << 14)
 #define HWCAP_LRCPC		(1 << 15)
 #define HWCAP_DCPOP		(1 << 16)
+#define HWCAP_SHA3		(1 << 17)
+#define HWCAP_SM3		(1 << 18)
+#define HWCAP_SM4		(1 << 19)
+#define HWCAP_ASIMDDP		(1 << 20)
+#define HWCAP_SHA512		(1 << 21)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,10 @@ cpufeature_pan_not_uao(const struct arm6
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_DP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SM3_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SHA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_RDM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_ATOMICS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_CRC32_SHIFT, 4, 0),
@@ -1040,9 +1044,14 @@ static const struct arm64_cpu_capabiliti
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_AES),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA1),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA2),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_SHA512),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_CRC32_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_CRC32),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_ATOMICS_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ATOMICS),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_RDM_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDRDM),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA3),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM3),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM4_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM4),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_DP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDDP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_FPHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -69,6 +69,11 @@ static const char *const hwcap_str[] = {
 	"fcma",
 	"lrcpc",
 	"dcpop",
+	"sha3",
+	"sm3",
+	"sm4",
+	"asimddp",
+	"sha512",
 	NULL
 };
 


