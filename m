Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C891E32D0
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502083AbfJXMtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51413 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfJXMtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id q70so2712848wme.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfRV9jAD/0mxb0QXBX+/toKsoafQ0jV5cVryoy3RLjU=;
        b=lAgjuHkuKClft2A/rGRnEcsYJKMR0mKFoSyaRW8wKOgdWaHlsLBDVhC+ji1j93REhs
         SRvf/IZIVEdiCVk1NZ11JBRDVFTtEYBK6ySGirff7hYr6v+TCZr/bZvpceCGey7LrP34
         RXSxk0+nQd2gwkO2ESMzINP9bKZH02+yUqixoqD3HVwSTSd9v9xsDuwHFcFOEm+JKQnV
         rYp+IRnl8jeIlbuhzp6p0Cp5KOo+NKX3zxKKxBtKYdbJYZdZ/CwNjkmD7AMlbORqVs1H
         m5geBn5U2azFp8myu4FMT9L5mN3ayz3OYGXN5jk7nZwNXwcNUTgFtfcSDI31RarpWdzs
         xOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfRV9jAD/0mxb0QXBX+/toKsoafQ0jV5cVryoy3RLjU=;
        b=Lq7FdSUZmqsv3jA/wKA5LVjWkmeyU4z9xdTNniP1OurU67Gwp4uTbwXmEXGoViwaMi
         qaEJoUSxzwR7BWYMADyyWaYsSxxJfFcSthkAy4KNdyzuDWS0pIXlCJr28mw6o+ba806a
         Gfk1LgC1CdH4lBFw74TuKQQQSTB/w9LRcoEd5RVgfrttPWbU55JSDaHn0gPHigbH9l3p
         k/VZkJwKQK/x96aaW1ZsIZA30jswS2PC8ruwOZZS08Wwug7epE+NhidQ7x2KB+iJs21v
         bCMITMV6qI9bvq/LOAOef+RaCJk4TbcP0F+/9M/xQinEWD3B4ujzmAw5WAgaczxkGXTz
         eE1Q==
X-Gm-Message-State: APjAAAXG8dHCvrfERGEPoGTSASVcxhn0fe9aiYigl8GttoKAZSht6lae
        pjOIfXSB+nky6R44NpcfDBTPvNYtQ4AD712l
X-Google-Smtp-Source: APXvYqydXFfWPwZWW0a5bYAJQn1iSVmDd/yQBsIbbnpxSC4AVIeCkVT1Bn6YdC8zMwQiMHuX4PUDPw==
X-Received: by 2002:a1c:f011:: with SMTP id a17mr4662797wmb.18.1571921336261;
        Thu, 24 Oct 2019 05:48:56 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 06/48] arm64: Expose Arm v8.4 features
Date:   Thu, 24 Oct 2019 14:47:51 +0200
Message-Id: <20191024124833.4158-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
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
---
 Documentation/arm64/cpu-feature-registers.txt | 10 ++++++++++
 arch/arm64/include/asm/sysreg.h               |  3 +++
 arch/arm64/include/uapi/asm/hwcap.h           |  4 ++++
 arch/arm64/kernel/cpufeature.c                |  7 +++++++
 arch/arm64/kernel/cpuinfo.c                   |  4 ++++
 5 files changed, 28 insertions(+)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index 22cfb86143ee..7964f03846b1 100644
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
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ee4b7935155b..eab67c2e2bb3 100644
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
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index f018c3deea3b..17c65c8f33cb 100644
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
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 258921542b00..d3a93e23a87c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,7 @@ cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused)
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_TS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_FHM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_DP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
@@ -132,6 +133,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_DIT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -171,6 +173,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_IESB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LSM_SHIFT, 4, 0),
@@ -1054,14 +1057,18 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
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
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 67afe69efb61..2188db11b654 100644
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
 
-- 
2.20.1

