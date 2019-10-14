Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5582CD6294
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfJNMdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 08:33:02 -0400
Received: from foss.arm.com ([217.140.110.172]:42556 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbfJNMdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 08:33:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1380B1000;
        Mon, 14 Oct 2019 05:33:01 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7E353F68E;
        Mon, 14 Oct 2019 05:32:59 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        maz@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable-4.4][PATCH 1/2] arm64: capabilities: Handle sign of the feature bit
Date:   Mon, 14 Oct 2019 13:32:53 +0100
Message-Id: <20191014123254.22002-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191014123254.22002-1-suzuki.poulose@arm.com>
References: <20191014123254.22002-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ff96f7bc7bf6393eef8ff2bde1279715ce13343a usptream

Use the appropriate accessor for the feature bit by keeping
track of the sign of the feature.

This is a pre-requisite for the commit 28c5dcb22f90 upstream,
which fixes the arm64_ftr_value() for signed feature fields.

Cc: stable@vger.kernel.org # v4.4
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  7 +++---
 arch/arm64/kernel/cpufeature.c      | 33 +++++++++++++++++------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 0a66f8241f18..690961a749da 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -88,9 +88,10 @@ struct arm64_cpu_capabilities {
 
 		struct {	/* Feature register checking */
 			u32 sys_reg;
-			int field_pos;
-			int min_field_value;
-			int hwcap_type;
+			u8 field_pos;
+			u8 min_field_value;
+			u8 hwcap_type;
+			bool sign;
 			unsigned long hwcap;
 		};
 	};
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 062484d34450..3949991e544b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -636,6 +636,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_useable_gicv3_cpuif,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_GIC_SHIFT,
+		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 	},
 #ifdef CONFIG_ARM64_PAN
@@ -645,6 +646,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR1_EL1,
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
+		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 		.enable = cpu_enable_pan,
 	},
@@ -656,6 +658,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR0_EL1,
 		.field_pos = ID_AA64ISAR0_ATOMICS_SHIFT,
+		.sign = FTR_UNSIGNED,
 		.min_field_value = 2,
 	},
 #endif /* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
@@ -665,37 +668,39 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
+		.sign = FTR_UNSIGNED,
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
 	{},
 };
 
-#define HWCAP_CAP(reg, field, min_value, type, cap)		\
+#define HWCAP_CAP(reg, field, s, min_value, type, cap)	\
 	{							\
 		.desc = #cap,					\
 		.matches = has_cpuid_feature,			\
 		.sys_reg = reg,					\
 		.field_pos = field,				\
+		.sign = s,					\
 		.min_field_value = min_value,			\
 		.hwcap_type = type,				\
 		.hwcap = cap,					\
 	}
 
 static const struct arm64_cpu_capabilities arm64_hwcaps[] = {
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, 2, CAP_HWCAP, HWCAP_PMULL),
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, 1, CAP_HWCAP, HWCAP_AES),
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA1_SHIFT, 1, CAP_HWCAP, HWCAP_SHA1),
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, 1, CAP_HWCAP, HWCAP_SHA2),
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_CRC32_SHIFT, 1, CAP_HWCAP, HWCAP_CRC32),
-	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_ATOMICS_SHIFT, 2, CAP_HWCAP, HWCAP_ATOMICS),
-	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, 0, CAP_HWCAP, HWCAP_FP),
-	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, 0, CAP_HWCAP, HWCAP_ASIMD),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_PMULL),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_AES),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA1),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA2),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_CRC32_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_CRC32),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_ATOMICS_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ATOMICS),
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
 #ifdef CONFIG_COMPAT
-	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, 2, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_PMULL),
-	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_AES),
-	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA1_SHIFT, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA1),
-	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA2_SHIFT, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA2),
-	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_CRC32_SHIFT, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_CRC32),
+	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 2, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_PMULL),
+	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_AES),
+	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA1),
+	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA2_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA2),
+	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_CRC32_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_CRC32),
 #endif
 	{},
 };
-- 
2.21.0

