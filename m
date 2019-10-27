Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A57E6937
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbfJ0VfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbfJ0VJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:31 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF61208C0;
        Sun, 27 Oct 2019 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210570;
        bh=Fjix/1wYoRrt88X6LT3sdeBrVg/SIuSCPYTz3CK56o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JokZBiY0VUNAMXICgPjv7FQDGONqtna7vHmzmCSSSyIb23/Cwyu/28XWRltOCpFyW
         8836+b1b5C+he5HGMKxxbszCmLMKigyEKZ/tsT+X44tExuYSnfdqbPYTb0Qyvb1Ti3
         +cfU1gaNIVcd3oZ6Kf5KN84M/6gKPKUF+N1/s7R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.14 062/119] arm64: Add helpers for checking CPU MIDR against a range
Date:   Sun, 27 Oct 2019 22:00:39 +0100
Message-Id: <20191027203328.256976128@linuxfoundation.org>
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
---
 arch/arm64/include/asm/cpufeature.h |    4 ++--
 arch/arm64/include/asm/cputype.h    |   30 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      |   18 +++++++-----------
 3 files changed, 39 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -10,6 +10,7 @@
 #define __ASM_CPUFEATURE_H
 
 #include <asm/cpucaps.h>
+#include <asm/cputype.h>
 #include <asm/hwcap.h>
 #include <asm/sysreg.h>
 
@@ -302,8 +303,7 @@ struct arm64_cpu_capabilities {
 	void (*cpu_enable)(const struct arm64_cpu_capabilities *cap);
 	union {
 		struct {	/* To be used for erratum handling only */
-			u32 midr_model;
-			u32 midr_range_min, midr_range_max;
+			struct midr_range midr_range;
 		};
 
 		struct {	/* Feature register checking */
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -126,6 +126,36 @@
 #define read_cpuid(reg)			read_sysreg_s(SYS_ ## reg)
 
 /*
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
+/*
  * The CPU ID never changes at run time, so we might as well tell the
  * compiler that it's constant.  Use this function to read the CPU ID
  * rather than directly reading processor_id or read_cpuid() directly.
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -26,10 +26,10 @@
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
 
 static bool __maybe_unused
@@ -43,7 +43,7 @@ is_kryo_midr(const struct arm64_cpu_capa
 	model &= MIDR_IMPLEMENTOR_MASK | (0xf00 << MIDR_PARTNUM_SHIFT) |
 		 MIDR_ARCHITECTURE_MASK;
 
-	return model == entry->midr_model;
+	return model == entry->midr_range.model;
 }
 
 static bool
@@ -407,15 +407,11 @@ static bool has_ssbd_mitigation(const st
 
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
@@ -556,7 +552,7 @@ const struct arm64_cpu_capabilities arm6
 		.desc = "Qualcomm Technologies Kryo erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
-		.midr_model = MIDR_QCOM_KRYO,
+		.midr_range.model = MIDR_QCOM_KRYO,
 		.matches = is_kryo_midr,
 	},
 #endif


