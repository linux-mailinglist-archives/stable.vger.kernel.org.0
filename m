Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF034F68E8
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiDFSIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240404AbiDFSHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 889A816F6CE;
        Wed,  6 Apr 2022 09:46:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6626D23A;
        Wed,  6 Apr 2022 09:46:11 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B89003F73B;
        Wed,  6 Apr 2022 09:46:10 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 10/43] arm64: Add helpers for checking CPU MIDR against a range
Date:   Wed,  6 Apr 2022 17:45:13 +0100
Message-Id: <20220406164546.1888528-10-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 1df310505d6d544802016f6bae49aab836ae8510 ]

Add helpers for checking if the given CPU midr falls in a range
of variants/revisions for a given model.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  4 ++--
 arch/arm64/include/asm/cputype.h    | 30 +++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      | 14 +++++---------
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 542a082dfdfc..f8646d7fae49 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -10,6 +10,7 @@
 #define __ASM_CPUFEATURE_H
 
 #include <asm/cpucaps.h>
+#include <asm/cputype.h>
 #include <asm/hwcap.h>
 #include <asm/sysreg.h>
 
@@ -229,8 +230,7 @@ struct arm64_cpu_capabilities {
 	void (*cpu_enable)(const struct arm64_cpu_capabilities *cap);
 	union {
 		struct {	/* To be used for erratum handling only */
-			u32 midr_model;
-			u32 midr_range_min, midr_range_max;
+			struct midr_range midr_range;
 		};
 
 		struct {	/* Feature register checking */
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 2270a5f31271..e76245ea6b60 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -113,6 +113,36 @@
 
 #define read_cpuid(reg)			read_sysreg_s(SYS_ ## reg)
 
+/*
+ * Represent a range of MIDR values for a given CPU model and a
+ * range of variant/revision values.
+ *
+ * @model	- CPU model as defined by MIDR_CPU_MODEL
+ * @rv_min	- Minimum value for the revision/variant as defined by
+ *		  MIDR_CPU_VAR_REV
+ * @rv_max	- Maximum value for the variant/revision for the range.
+ */
+struct midr_range {
+	u32 model;
+	u32 rv_min;
+	u32 rv_max;
+};
+
+#define MIDR_RANGE(m, v_min, r_min, v_max, r_max)		\
+	{							\
+		.model = m,					\
+		.rv_min = MIDR_CPU_VAR_REV(v_min, r_min),	\
+		.rv_max = MIDR_CPU_VAR_REV(v_max, r_max),	\
+	}
+
+#define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
+
+static inline bool is_midr_in_range(u32 midr, struct midr_range const *range)
+{
+	return MIDR_IS_CPU_MODEL_RANGE(midr, range->model,
+				 range->rv_min, range->rv_max);
+}
+
 /*
  * The CPU ID never changes at run time, so we might as well tell the
  * compiler that it's constant.  Use this function to read the CPU ID
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 858a4954907d..e2630e88e8ad 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -27,10 +27,10 @@
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 {
+	u32 midr = read_cpuid_id();
+
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return MIDR_IS_CPU_MODEL_RANGE(read_cpuid_id(), entry->midr_model,
-				       entry->midr_range_min,
-				       entry->midr_range_max);
+	return is_midr_in_range(midr, &entry->midr_range);
 }
 
 static bool
@@ -370,15 +370,11 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
-	.midr_model = model,					\
-	.midr_range_min = MIDR_CPU_VAR_REV(v_min, r_min),	\
-	.midr_range_max = MIDR_CPU_VAR_REV(v_max, r_max)
+	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
 
 #define CAP_MIDR_ALL_VERSIONS(model)					\
 	.matches = is_affected_midr_range,				\
-	.midr_model = model,						\
-	.midr_range_min = MIDR_CPU_VAR_REV(0, 0),			\
-	.midr_range_max = (MIDR_VARIANT_MASK | MIDR_REVISION_MASK)
+	.midr_range = MIDR_ALL_VERSIONS(model)
 
 #define MIDR_FIXED(rev, revidr_mask) \
 	.fixed_revs = (struct arm64_midr_revidr[]){{ (rev), (revidr_mask) }, {}}
-- 
2.30.2

