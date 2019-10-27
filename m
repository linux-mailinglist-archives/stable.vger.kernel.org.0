Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF321E6927
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbfJ0VJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbfJ0VJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:30 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB4F20873;
        Sun, 27 Oct 2019 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210568;
        bh=SaGmG2k4icvDvSDGJ8RyFroeyuRhek0Hlm5Dl/gqCQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zujfGU8eq8uDTOoWw52Y3jmFn/fIdaUQPI/RZ03eQHgQXi9gh4D5ipe8UAlEL4QfW
         E92GAi15HX3Y61E8z2kJUtSqQgcWer2Dl2pjFYX/YLvuPgM20TyDUd+nseEjcuwI8h
         3HVoaMJM/q9x/eq7eJn5pxCVRvKskIbt0D48PdFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.14 061/119] arm64: capabilities: Clean up midr range helpers
Date:   Sun, 27 Oct 2019 22:00:38 +0100
Message-Id: <20191027203327.195419255@linuxfoundation.org>
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

[ Upstream commit 5e7951ce19abf4113645ae789c033917356ee96f ]

We are about to introduce generic MIDR range helpers. Clean
up the existing helpers in erratum handling, preparing them
to use generic version.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |  109 +++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 47 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -405,20 +405,38 @@ static bool has_ssbd_mitigation(const st
 }
 #endif	/* CONFIG_ARM64_SSBD */
 
-#define MIDR_RANGE(model, min, max) \
-	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
-	.matches = is_affected_midr_range, \
-	.midr_model = model, \
-	.midr_range_min = min, \
-	.midr_range_max = max
-
-#define MIDR_ALL_VERSIONS(model) \
-	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
-	.matches = is_affected_midr_range, \
-	.midr_model = model, \
-	.midr_range_min = 0, \
+#define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
+	.matches = is_affected_midr_range,			\
+	.midr_model = model,					\
+	.midr_range_min = MIDR_CPU_VAR_REV(v_min, r_min),	\
+	.midr_range_max = MIDR_CPU_VAR_REV(v_max, r_max)
+
+#define CAP_MIDR_ALL_VERSIONS(model)					\
+	.matches = is_affected_midr_range,				\
+	.midr_model = model,						\
+	.midr_range_min = MIDR_CPU_VAR_REV(0, 0),			\
 	.midr_range_max = (MIDR_VARIANT_MASK | MIDR_REVISION_MASK)
 
+#define MIDR_FIXED(rev, revidr_mask) \
+	.fixed_revs = (struct arm64_midr_revidr[]){{ (rev), (revidr_mask) }, {}}
+
+#define ERRATA_MIDR_RANGE(model, v_min, r_min, v_max, r_max)		\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,				\
+	CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
+
+/* Errata affecting a range of revisions of  given model variant */
+#define ERRATA_MIDR_REV_RANGE(m, var, r_min, r_max)	 \
+	ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
+
+/* Errata affecting a single variant/revision of a model */
+#define ERRATA_MIDR_REV(model, var, rev)	\
+	ERRATA_MIDR_RANGE(model, var, rev, var, rev)
+
+/* Errata affecting all variants/revisions of a given a model */
+#define ERRATA_MIDR_ALL_VERSIONS(model)				\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
+	CAP_MIDR_ALL_VERSIONS(model)
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -427,7 +445,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[012] */
 		.desc = "ARM errata 826319, 827319, 824069",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 2),
 		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
@@ -436,7 +454,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[01] */
 		.desc = "ARM errata 819472",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x01),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 1),
 		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
@@ -445,9 +463,9 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 832075",
 		.capability = ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE,
-		MIDR_RANGE(MIDR_CORTEX_A57,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 2)),
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
+				  0, 0,
+				  1, 2),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_834220
@@ -455,9 +473,9 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 834220",
 		.capability = ARM64_WORKAROUND_834220,
-		MIDR_RANGE(MIDR_CORTEX_A57,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 2)),
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
+				  0, 0,
+				  1, 2),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
@@ -465,7 +483,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A53 r0p[01234] */
 		.desc = "ARM erratum 845719",
 		.capability = ARM64_WORKAROUND_845719,
-		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x04),
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
@@ -473,7 +491,7 @@ const struct arm64_cpu_capabilities arm6
 	/* Cavium ThunderX, pass 1.x */
 		.desc = "Cavium erratum 23154",
 		.capability = ARM64_WORKAROUND_CAVIUM_23154,
-		MIDR_RANGE(MIDR_THUNDERX, 0x00, 0x01),
+		ERRATA_MIDR_REV_RANGE(MIDR_THUNDERX, 0, 0, 1),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
@@ -481,15 +499,15 @@ const struct arm64_cpu_capabilities arm6
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
-		MIDR_RANGE(MIDR_THUNDERX,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(1, 1)),
+		ERRATA_MIDR_RANGE(MIDR_THUNDERX,
+				  0, 0,
+				  1, 1),
 	},
 	{
 	/* Cavium ThunderX, T81 pass 1.0 */
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
-		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x00),
+		ERRATA_MIDR_REV(MIDR_THUNDERX_81XX, 0, 0),
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_30115
@@ -497,20 +515,21 @@ const struct arm64_cpu_capabilities arm6
 	/* Cavium ThunderX, T88 pass 1.x - 2.2 */
 		.desc = "Cavium erratum 30115",
 		.capability = ARM64_WORKAROUND_CAVIUM_30115,
-		MIDR_RANGE(MIDR_THUNDERX, 0x00,
-			   (1 << MIDR_VARIANT_SHIFT) | 2),
+		ERRATA_MIDR_RANGE(MIDR_THUNDERX,
+				      0, 0,
+				      1, 2),
 	},
 	{
 	/* Cavium ThunderX, T81 pass 1.0 - 1.2 */
 		.desc = "Cavium erratum 30115",
 		.capability = ARM64_WORKAROUND_CAVIUM_30115,
-		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x02),
+		ERRATA_MIDR_REV_RANGE(MIDR_THUNDERX_81XX, 0, 0, 2),
 	},
 	{
 	/* Cavium ThunderX, T83 pass 1.0 */
 		.desc = "Cavium erratum 30115",
 		.capability = ARM64_WORKAROUND_CAVIUM_30115,
-		MIDR_RANGE(MIDR_THUNDERX_83XX, 0x00, 0x00),
+		ERRATA_MIDR_REV(MIDR_THUNDERX_83XX, 0, 0),
 	},
 #endif
 	{
@@ -531,9 +550,7 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.desc = "Qualcomm Technologies Falkor erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
-		MIDR_RANGE(MIDR_QCOM_FALKOR_V1,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(0, 0)),
+		ERRATA_MIDR_REV(MIDR_QCOM_FALKOR_V1, 0, 0),
 	},
 	{
 		.desc = "Qualcomm Technologies Kryo erratum 1003",
@@ -547,9 +564,7 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.desc = "Qualcomm Technologies Falkor erratum 1009",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
-		MIDR_RANGE(MIDR_QCOM_FALKOR_V1,
-			   MIDR_CPU_VAR_REV(0, 0),
-			   MIDR_CPU_VAR_REV(0, 0)),
+		ERRATA_MIDR_REV(MIDR_QCOM_FALKOR_V1, 0, 0),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_858921
@@ -557,56 +572,56 @@ const struct arm64_cpu_capabilities arm6
 	/* Cortex-A73 all versions */
 		.desc = "ARM erratum 858921",
 		.capability = ARM64_WORKAROUND_858921,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 	},
 #endif
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
 		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
 		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 #endif


