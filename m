Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88391E6959
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfJ0VIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbfJ0VIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:35 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA75D2064A;
        Sun, 27 Oct 2019 21:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210514;
        bh=sZk67HLjrgXpirIOaPWbDB2dGtoSAtvE4M5NOkvG/pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izHqWapfoJ1t2uy94Ycl4PRWYQT6wJC4hmSMtchv8cdNGYEmd1CE01wFGzBk5t+av
         EocKaFdzlTkES7w1KXKR56+wECWD7igjvkY/FPGu3kNuJ62F/fKSd66MC8OD0nEk/O
         aUuYfWGiHScz+Y4CTkG2lcgqXr0wg0+QUkyADTA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 040/119] arm64: v8.4: Support for new floating point multiplication instructions
Date:   Sun, 27 Oct 2019 22:00:17 +0100
Message-Id: <20191027203314.480084740@linuxfoundation.org>
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

From: Dongjiu Geng <gengdongjiu@huawei.com>

[ Upstream commit 3b3b681097fae73b7f5dcdd42db6cfdf32943d4c ]

ARM v8.4 extensions add new neon instructions for performing a
multiplication of each FP16 element of one vector with the corresponding
FP16 element of a second vector, and to add or subtract this without an
intermediate rounding to the corresponding FP32 element in a third vector.

This patch detects this feature and let the userspace know about it via a
HWCAP bit and MRS emulation.

Cc: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ardb: fix up for missing SVE in context]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.txt |    4 +++-
 arch/arm64/include/asm/sysreg.h               |    1 +
 arch/arm64/include/uapi/asm/hwcap.h           |    2 ++
 arch/arm64/kernel/cpufeature.c                |    2 ++
 arch/arm64/kernel/cpuinfo.c                   |    2 ++
 5 files changed, 10 insertions(+), 1 deletion(-)

--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,7 +110,9 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-48] |    n    |
+     | RES0                         | [63-52] |    n    |
+     |--------------------------------------------------|
+     | FHM                          | [51-48] |    y    |
      |--------------------------------------------------|
      | DP                           | [47-44] |    y    |
      |--------------------------------------------------|
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -375,6 +375,7 @@
 #define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_FHM_SHIFT		48
 #define ID_AA64ISAR0_DP_SHIFT		44
 #define ID_AA64ISAR0_SM4_SHIFT		40
 #define ID_AA64ISAR0_SM3_SHIFT		36
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -42,5 +42,7 @@
 #define HWCAP_SM4		(1 << 19)
 #define HWCAP_ASIMDDP		(1 << 20)
 #define HWCAP_SHA512		(1 << 21)
+#define HWCAP_SVE		(1 << 22)
+#define HWCAP_ASIMDFHM		(1 << 23)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,7 @@ cpufeature_pan_not_uao(const struct arm6
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_FHM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_DP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM3_SHIFT, 4, 0),
@@ -1052,6 +1053,7 @@ static const struct arm64_cpu_capabiliti
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM3),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM4_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM4),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_DP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDDP),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_FHM_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDFHM),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_FPHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -74,6 +74,8 @@ static const char *const hwcap_str[] = {
 	"sm4",
 	"asimddp",
 	"sha512",
+	"sve",
+	"asimdfhm",
 	NULL
 };
 


