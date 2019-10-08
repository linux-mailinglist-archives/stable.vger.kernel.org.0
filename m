Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87347CFDD0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfJHPkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38411 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfJHPkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id w12so19987870wro.5
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2vH7NxScJDJcgais+WV+dY6yPF0+trUdQf6sN03YYQ=;
        b=akoxP6v69U5JfF0hRfeGvOgkbYBnvBnftCVcuLFKkqbcShNQh3iuI2xHPyxEFI/4dh
         hVLOvqh+6QQmFbxJt/xejTD0xZJL2GWkjSob7waLjyJM3tY2DKAlknToUy6kQx/O7sNq
         0wis12WTbE/cWUw0feNsYsVYFn+n5pjD9oVS+F7a668Snl5xD2VrV7u86Z6+uScS58S5
         cw214xAEnWTsvdeVaPwtoRrCZw5GBzOELBSVN1U6jEOyK0hZqPpJZkQk0yFerouRQ008
         RMhbE4UKPqP8RXPjoMn7mO1nfo0Wdodsd+NwRY32Uf88u2hn3ZfDlgTDU7cQwohDfmXB
         pnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2vH7NxScJDJcgais+WV+dY6yPF0+trUdQf6sN03YYQ=;
        b=fVDfYVJg25UVxO4g2RgiWFimPwxQaWO/w65y0jIjNszVSIRGltLiL/j0mNErmoXfnw
         zpF0B1rXcayMsefNf/8TDnSJNnwudfEpxelFqVOq6PHVQd9Ojw4wC5fi87dTrllUwroe
         4Eu0p5azEP/NyJFI+rFK60R1oRiUkaWwhHRoeetMiMTDYR52Ut0tigbK6ns+GFi1wgD+
         5L5926SLzkEGoliKIn3sqSSG659MVeZaWNqzByM6LvuTDAAGjphfnnHRJSwRZnfSoRUh
         S+KZZcNTocxSeRy4wbxGWeSGSGrVeLvfuK0KwphopjFKhCmB3XrfOFil6JL/tEy3U1la
         YZYQ==
X-Gm-Message-State: APjAAAXEZDkEQO2NfKYqCYi+qN8aP1lLKfY07zXcPb9i26IXmkWIVcWc
        JuXI3c3CERx/trqr2WVO8e5iPg==
X-Google-Smtp-Source: APXvYqxr8mQo1nqgLTQoZQXQJ+PtO4Jau0pdD6NE7rShoudolIFdwxyvgnj4tfmDIqzjxeMDVBq6sw==
X-Received: by 2002:adf:f104:: with SMTP id r4mr7815003wro.128.1570549209430;
        Tue, 08 Oct 2019 08:40:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 01/16] arm64: cpufeature: Detect SSBS and advertise to userspace
Date:   Tue,  8 Oct 2019 17:39:15 +0200
Message-Id: <20191008153930.15386-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
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
index 25ce9056cf64..c3de0bbf0e9a 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -52,7 +52,8 @@
 #define ARM64_MISMATCHED_CACHE_TYPE		31
 #define ARM64_HAS_STAGE2_FWB			32
 #define ARM64_WORKAROUND_1463225		33
+#define ARM64_SSBS				34
 
-#define ARM64_NCAPS				34
+#define ARM64_NCAPS				35
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c1470931b897..2fc6242baf11 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -419,6 +419,7 @@
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
 /* Common SCTLR_ELx flags. */
+#define SCTLR_ELx_DSSBS	(1UL << 44)
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_IESB	(1 << 21)
 #define SCTLR_ELx_WXN	(1 << 19)
@@ -439,7 +440,7 @@
 			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
 			 (1 << 17) | (1 << 20) | (1 << 24) | (1 << 26) | \
 			 (1 << 27) | (1 << 30) | (1 << 31) | \
-			 (0xffffffffUL << 32))
+			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
@@ -453,7 +454,7 @@
 #define SCTLR_EL2_SET	(SCTLR_ELx_IESB   | ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
 #define SCTLR_EL2_CLEAR	(SCTLR_ELx_M      | SCTLR_ELx_A    | SCTLR_ELx_C   | \
 			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
-			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
+			 SCTLR_ELx_DSSBS | ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
 
 #if (SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != 0xffffffffffffffff
 #error "Inconsistent SCTLR_EL2 set/clear bits"
@@ -477,7 +478,7 @@
 			 (1 << 29))
 #define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
 			 (1 << 27) | (1 << 30) | (1 << 31) | \
-			 (0xffffffffUL << 32))
+			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
@@ -494,7 +495,7 @@
 			 ENDIAN_SET_EL1 | SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
 #define SCTLR_EL1_CLEAR	(SCTLR_ELx_A   | SCTLR_EL1_CP15BEN | SCTLR_EL1_ITD    |\
 			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
-			 SCTLR_EL1_RES0)
+			 SCTLR_ELx_DSSBS | SCTLR_EL1_RES0)
 
 #if (SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != 0xffffffffffffffff
 #error "Inconsistent SCTLR_EL1 set/clear bits"
@@ -544,6 +545,13 @@
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
index a897efdb3ddd..d7552bbdf963 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -164,6 +164,11 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_SSBS_SHIFT, 4, ID_AA64PFR1_SSBS_PSTATE_NI),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
 	/*
 	 * We already refuse to boot CPUs that don't support our configured
@@ -379,7 +384,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
-	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_raz),
+	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1),
 	ARM64_FTR_REG(SYS_ID_AA64ZFR0_EL1, ftr_raz),
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
@@ -669,7 +674,6 @@ void update_cpu_features(int cpu,
 
 	/*
 	 * EL3 is not our concern.
-	 * ID_AA64PFR1 is currently RES0.
 	 */
 	taint |= check_update_ftr_reg(SYS_ID_AA64PFR0_EL1, cpu,
 				      info->reg_id_aa64pfr0, boot->reg_id_aa64pfr0);
@@ -1254,6 +1258,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_hw_dbm,
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
 
@@ -1299,6 +1313,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 #ifdef CONFIG_ARM64_SVE
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
 #endif
+	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_SSBS_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_SSBS_PSTATE_INSNS, CAP_HWCAP, HWCAP_SSBS),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index e9ab7b3ed317..dce971f2c167 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -81,6 +81,7 @@ static const char *const hwcap_str[] = {
 	"uscat",
 	"ilrcpc",
 	"flagm",
+	"ssbs",
 	NULL
 };
 
-- 
2.20.1

