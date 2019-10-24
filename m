Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E600BE32EB
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502119AbfJXMtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46796 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMto (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id n15so15146127wrw.13
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SXt9eNYuLxQH8vdaVTO6E4vHbk3VezJUw+7ixKNI+0I=;
        b=wVJSMchEc5JYmnzCJVW31RQ/kZqtYFhaGX0biTt+vhsOc+bI3ImiY+BdRqXyJjH7xC
         KBOsDYhTpB4+8hD13dYuP5ZhIw2xLtPuhoRB9i8WCnLzp/MXJm2RLo9NDtcvbznqsgNq
         BQ/GayNTibUR7eqVGHHMGo2eg+/7iQzHiwT+Jmv7HAS4nFaQK5GrTo2RsNYQsCL/jehY
         1+eZ1tYCFYZTqqCWtlk7DfEDvoD/szqZp/cqTzNySI6pAUhrAaldxENtmsctP3M2i7ps
         N1NdkkWoYSW/BRvzhPuaMJFP0d1jAXeNXephkXQCdDQRZ4lp/Jifxav3aFK+LnGKYV7h
         Jr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SXt9eNYuLxQH8vdaVTO6E4vHbk3VezJUw+7ixKNI+0I=;
        b=UeNm+qFKra192PiDPeiM1oi414SHjtStbkLXWdUbCEC9WHcxp3sebc+hJzrG4jXidy
         04SNyVfSNDseKp0e2ubk93sAXdGJTtsEOKPd5WXXr/zaeDoXDHRt+DsisnW1ZVIecMF7
         vPS5E0J35SU8EXznwxf9VkqfRjzF7k0Exa4tk6nt87FEzdqsGSZQPGJufpJKfTB13LKn
         Y/XWR7+S0jZYQo0Y5/5ZCDBWbB50yJbH+Kgkme8oQNtxc5D7Xn/zde+XdxXhrYuJYzVU
         mTwHe11RuIaR0kY7s5RRxeDsxHzftBV7ZN7S+3zVAz9b8FoI/nV2dL+Qh+l1t0HD53kn
         FhQQ==
X-Gm-Message-State: APjAAAVbnsg/ZOE4CiADmJ7AlEyXK6x2PztPo5KlBu4zxxf2W7XpWRBR
        YVF9iTGQJxukzg/bU1cnrC5O0bBtfEfKMukA
X-Google-Smtp-Source: APXvYqwyyMMj8Bvb8RF0bX1oO+HaUphe9MkiLDxAjmvCkeby5JlCQtXP51NmEsOn6o3oLYeRKsSHbg==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr3671955wru.75.1571921379728;
        Thu, 24 Oct 2019 05:49:39 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:38 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 32/48] arm64: cpufeature: Detect SSBS and advertise to userspace
Date:   Thu, 24 Oct 2019 14:48:17 +0200
Message-Id: <20191024124833.4158-33-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit d71be2b6c0e19180b5f80a6d42039cc074a693a2 ]

Armv8.5 introduces a new PSTATE bit known as Speculative Store Bypass
Safe (SSBS) which can be used as a mitigation against Spectre variant 4.

Additionally, a CPU may provide instructions to manipulate PSTATE.SSBS
directly, so that userspace can toggle the SSBS control without trapping
to the kernel.

This patch probes for the existence of SSBS and advertise the new instructions
to userspace if they exist.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     | 16 ++++++++++++----
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 19 +++++++++++++++++--
 arch/arm64/kernel/cpuinfo.c         |  1 +
 5 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 0ed9f7951097..2f8bd0388905 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -44,7 +44,8 @@
 #define ARM64_HARDEN_BRANCH_PREDICTOR		24
 #define ARM64_SSBD				25
 #define ARM64_MISMATCHED_CACHE_TYPE		26
+#define ARM64_SSBS				27
 
-#define ARM64_NCAPS				27
+#define ARM64_NCAPS				28
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 5f391630d0f4..4724909642e7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -297,6 +297,7 @@
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
 /* Common SCTLR_ELx flags. */
+#define SCTLR_ELx_DSSBS	(1UL << 44)
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_WXN	(1 << 19)
 #define SCTLR_ELx_I	(1 << 12)
@@ -316,7 +317,7 @@
 			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
 			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
 			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31) | \
-			 (0xffffffffUL << 32))
+			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
@@ -330,7 +331,7 @@
 #define SCTLR_EL2_SET	(ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
 #define SCTLR_EL2_CLEAR	(SCTLR_ELx_M      | SCTLR_ELx_A    | SCTLR_ELx_C   | \
 			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
-			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
+			 SCTLR_ELx_DSSBS | ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
 
 #if (SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != 0xffffffffffffffff
 #error "Inconsistent SCTLR_EL2 set/clear bits"
@@ -354,7 +355,7 @@
 			 (1 << 29))
 #define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
 			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31) | \
-			 (0xffffffffUL << 32))
+			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
@@ -371,7 +372,7 @@
 			 SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
 #define SCTLR_EL1_CLEAR	(SCTLR_ELx_A   | SCTLR_EL1_CP15BEN | SCTLR_EL1_ITD    |\
 			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
-			 SCTLR_EL1_RES0)
+			 SCTLR_ELx_DSSBS | SCTLR_EL1_RES0)
 
 #if (SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != 0xffffffffffffffff
 #error "Inconsistent SCTLR_EL1 set/clear bits"
@@ -417,6 +418,13 @@
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
 
+/* id_aa64pfr1 */
+#define ID_AA64PFR1_SSBS_SHIFT		4
+
+#define ID_AA64PFR1_SSBS_PSTATE_NI	0
+#define ID_AA64PFR1_SSBS_PSTATE_ONLY	1
+#define ID_AA64PFR1_SSBS_PSTATE_INSNS	2
+
 /* id_aa64mmfr0 */
 #define ID_AA64MMFR0_TGRAN4_SHIFT	28
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 17c65c8f33cb..2bcd6e4f3474 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -48,5 +48,6 @@
 #define HWCAP_USCAT		(1 << 25)
 #define HWCAP_ILRCPC		(1 << 26)
 #define HWCAP_FLAGM		(1 << 27)
+#define HWCAP_SSBS		(1 << 28)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ebc9fd869577..2a0d76698f34 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -145,6 +145,11 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_SSBS_SHIFT, 4, ID_AA64PFR1_SSBS_PSTATE_NI),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN4_SHIFT, 4, ID_AA64MMFR0_TGRAN4_NI),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN64_SHIFT, 4, ID_AA64MMFR0_TGRAN64_NI),
@@ -345,7 +350,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
-	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_raz),
+	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1),
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
 	ARM64_FTR_REG(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0),
@@ -625,7 +630,6 @@ void update_cpu_features(int cpu,
 
 	/*
 	 * EL3 is not our concern.
-	 * ID_AA64PFR1 is currently RES0.
 	 */
 	taint |= check_update_ftr_reg(SYS_ID_AA64PFR0_EL1, cpu,
 				      info->reg_id_aa64pfr0, boot->reg_id_aa64pfr0);
@@ -1045,6 +1049,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 	},
 #endif
+	{
+		.desc = "Speculative Store Bypassing Safe (SSBS)",
+		.capability = ARM64_SSBS,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR1_EL1,
+		.field_pos = ID_AA64PFR1_SSBS_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = ID_AA64PFR1_SSBS_PSTATE_ONLY,
+	},
 	{},
 };
 
@@ -1087,6 +1101,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ILRCPC),
 	HWCAP_CAP(SYS_ID_AA64MMFR2_EL1, ID_AA64MMFR2_AT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_USCAT),
+	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_SSBS_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_SSBS_PSTATE_INSNS, CAP_HWCAP, HWCAP_SSBS),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 2188db11b654..9ff64e04e63d 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -80,6 +80,7 @@ static const char *const hwcap_str[] = {
 	"uscat",
 	"ilrcpc",
 	"flagm",
+	"ssbs",
 	NULL
 };
 
-- 
2.20.1

