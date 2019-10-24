Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D3EE32E5
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502112AbfJXMtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40571 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502106AbfJXMtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so1306206wmm.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gzFM3RyzENfVewP1wnm0lxMkCup4hV7qkdK3Ri3PuLQ=;
        b=SAOryz4qpF7vLLg8STwu/HsXJnEmiJKZ6wctIgxpjR42vqnnEn9dUORMvRtal8iNeG
         hi0m0QtCMdEhFInZZw3rkEEUj+/ewHeIhYGzxO1DYgl8UkS90BJbOFX7ES84MVB537zn
         MYCJyLiN7mb127hwZoaIWuSQDrW5jKb1ue1z9EUIJwHTxQ5AB192EmhdkfMM8GvaPZSk
         IDx2KwCH95cY/ceZ8Bq8Leu69oNtSkYdNPX67FaFIdyE67RNmNURmN6GlojwSJ2+ceKh
         E8q6LeGZjRyDU3rsuVOhkj0t65PgFowrIDKYs/m7mYWviR/1L+LPLbQ4Czf/Jok210YH
         qpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gzFM3RyzENfVewP1wnm0lxMkCup4hV7qkdK3Ri3PuLQ=;
        b=kcodhzDRbrhKXX7xEmlbIcnJW2H+QOi3Kn/JKSs4bdFdUeWH5TvurqiFYsZ1lxB53G
         gNLhijQjBtE7EkFyfvCqQAYmule9InfYdCBRN3QSKpoLrFzQeDradJ6YbCHOAzVKz2Ip
         jemOlqr85PFsXDTdBFv3gk4DHStPIaKrm7x7eIAcVCmgbbfbEb6iwEO645ysCz3kpJyd
         iiJDTKVJSGk5cUtS3oegRygE76HkscOB8VFPZollJ7zB2Pzm6eAXOPaRnuPEOo25eK3L
         y1Iexww4yV6mueoRzWAFQJpylYPJPD/q/w7ZLkH2hFkOxMPDwEWCpQz8GVcrVLc9Wk4w
         Pktw==
X-Gm-Message-State: APjAAAX1elAwt2Mg73AZdRlzN1NlVqYNSNsm2821I/10Na9fobI1uPQY
        NrVrkLuUwr/6c4A8A3FaqYvuBsp4ohEFaLpv
X-Google-Smtp-Source: APXvYqyj/Sj4E41LfuERM6jrNgtz92qufNbFsd18sDKiI8NFBFzUnXPCgmW+lj1ArkkgRB++VMMqcQ==
X-Received: by 2002:a1c:f018:: with SMTP id a24mr4666375wmb.77.1571921371016;
        Thu, 24 Oct 2019 05:49:31 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:30 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 26/48] arm64: Add helpers for checking CPU MIDR against a range
Date:   Thu, 24 Oct 2019 14:48:11 +0200
Message-Id: <20191024124833.4158-27-ard.biesheuvel@linaro.org>
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
---
 arch/arm64/include/asm/cpufeature.h |  4 +--
 arch/arm64/include/asm/cputype.h    | 30 ++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      | 18 +++++-------
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 839aaa1505a3..ade058ada2b0 100644
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
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 04569aa267fd..c60eb29ea261 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -125,6 +125,36 @@
 
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
index 1e87e1427cc3..a3675d279b90 100644
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
@@ -43,7 +43,7 @@ is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
 	model &= MIDR_IMPLEMENTOR_MASK | (0xf00 << MIDR_PARTNUM_SHIFT) |
 		 MIDR_ARCHITECTURE_MASK;
 
-	return model == entry->midr_model;
+	return model == entry->midr_range.model;
 }
 
 static bool
@@ -407,15 +407,11 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
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
@@ -556,7 +552,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "Qualcomm Technologies Kryo erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
-		.midr_model = MIDR_QCOM_KRYO,
+		.midr_range.model = MIDR_QCOM_KRYO,
 		.matches = is_kryo_midr,
 	},
 #endif
-- 
2.20.1

