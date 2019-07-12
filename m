Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41996662E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGLF3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44227 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so4187046plr.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+8jS5wU9g41nb7lUYf6O/ux0jWphtxOIXXxsA7/oFkw=;
        b=KNfBp1g7S4eqR+RS92e7dLDP25RNS8lVmmr0lVF3A3MVIeuCHTEWx2dZYm3JSYgeOS
         +Jr6R2CWWlQU0MVR1YYad4On7zYD/qlaFG1j3LNdyrNLYoCKK6VE62z6/fzOI36xKcjK
         Eh6LTNogo1BK2DDZlAiBpgCYKHRxUwsZUsYhLO4jQmFkSPzUR5d8LG5ttCHhlC2U1kLZ
         j/7zXQgjvO/M701xXz0CZCTX1fBr3EGW+8PVZvc61QCjcElZY/tsei+BpoS1fk9EYCL6
         UaVK+UFMou7Ej7D0NRLSAc8uHuHklSOAVHd02USXT1BBXe/kcxrJfHPeco+/wjGEx4Vc
         hkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+8jS5wU9g41nb7lUYf6O/ux0jWphtxOIXXxsA7/oFkw=;
        b=hl+jgj9fifcKU7/juYUBmOOrX2+Xkd/TZH5f8a/iTzRQoTWrtzZTZUYg/YYG17J8bt
         qVG2g6W5End+Zo+m/qHRwwXdn+DTU7jp7927a4kDyvABkZW7iNwy1Ptq6V7+lGIn4dK+
         ZwxNUhPuP+vP6cVIRUBnZjZvacuoMuYoN/Z1C2kgL9oOnbssf04Z3BDl09DKkLnqbKOd
         +Qn3NpHn+paoZGD4Su84yPrmjvGn2f/T2qsUR3+vOfg/26JkM73eA++89lvfhSQ1RYjX
         /rXN4hZlKpvZi7JrOXT3Qdscw+FuFt/zGk+ongawX4fmwJEYCmnN5l4LLYsm513L6vm5
         ry1w==
X-Gm-Message-State: APjAAAWog/4sSAr844WorlcC8Amie4sWzK0c3BbLoZJxJQNMsoeiM+TO
        n+5M06HhDS470gyajO6OFks3tvOsrgQ=
X-Google-Smtp-Source: APXvYqwN7P7LFY34Lvch9qKU7Vc/mvHKJjQVUP2TIoZXkTwZiwbcMMpMpehj352dzrW1/WJzuMM5mA==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr8894647plj.116.1562909373996;
        Thu, 11 Jul 2019 22:29:33 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 33sm13035023pgy.22.2019.07.11.22.29.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:33 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 13/43] arm64: cpufeature: Add scope for capability check
Date:   Fri, 12 Jul 2019 10:58:01 +0530
Message-Id: <6fbec5c89811c069dcfaaaf55ad708c5f0922020.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 92406f0cc9e3d5cc77bf3de6d68c9c2373dcd701 upstream.

Add scope parameter to the arm64_cpu_capabilities::matches(), so that
this can be reused for checking the capability on a given CPU vs the
system wide. The system uses the default scope associated with the
capability for initialising the CPU_HWCAPs and ELF_HWCAPs.

Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ v4.4: Changes made according to 4.4 codebase ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |   9 ++-
 arch/arm64/kernel/cpu_errata.c      |   5 +-
 arch/arm64/kernel/cpufeature.c      | 105 +++++++++++++++-------------
 3 files changed, 70 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ad83c245781c..4c31e14c0f0e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -74,10 +74,17 @@ struct arm64_ftr_reg {
 	struct arm64_ftr_bits	*ftr_bits;
 };
 
+/* scope of capability check */
+enum {
+	SCOPE_SYSTEM,
+	SCOPE_LOCAL_CPU,
+};
+
 struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
-	bool (*matches)(const struct arm64_cpu_capabilities *);
+	int def_scope;			/* default scope */
+	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope);
 	int (*enable)(void *);		/* Called on all active CPUs */
 	union {
 		struct {	/* To be used for erratum handling only */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a3e846a28b05..0971d80d3623 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -29,10 +29,12 @@
 			MIDR_ARCHITECTURE_MASK)
 
 static bool __maybe_unused
-is_affected_midr_range(const struct arm64_cpu_capabilities *entry)
+is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	u32 midr = read_cpuid_id();
 
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
 	if ((midr & CPU_MODEL_MASK) != entry->midr_model)
 		return false;
 
@@ -42,6 +44,7 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry)
 }
 
 #define MIDR_RANGE(model, min, max) \
+	.def_scope = SCOPE_LOCAL_CPU, \
 	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = min, \
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bdb4cd9ffccf..d0c82bc02de4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -589,6 +589,48 @@ u64 read_system_reg(u32 id)
 	return regp->sys_val;
 }
 
+/*
+ * __raw_read_system_reg() - Used by a STARTING cpu before cpuinfo is populated.
+ * Read the system register on the current CPU
+ */
+static u64 __raw_read_system_reg(u32 sys_id)
+{
+	switch (sys_id) {
+	case SYS_ID_PFR0_EL1:		return (u64)read_cpuid(ID_PFR0_EL1);
+	case SYS_ID_PFR1_EL1:		return (u64)read_cpuid(ID_PFR1_EL1);
+	case SYS_ID_DFR0_EL1:		return (u64)read_cpuid(ID_DFR0_EL1);
+	case SYS_ID_MMFR0_EL1:		return (u64)read_cpuid(ID_MMFR0_EL1);
+	case SYS_ID_MMFR1_EL1:		return (u64)read_cpuid(ID_MMFR1_EL1);
+	case SYS_ID_MMFR2_EL1:		return (u64)read_cpuid(ID_MMFR2_EL1);
+	case SYS_ID_MMFR3_EL1:		return (u64)read_cpuid(ID_MMFR3_EL1);
+	case SYS_ID_ISAR0_EL1:		return (u64)read_cpuid(ID_ISAR0_EL1);
+	case SYS_ID_ISAR1_EL1:		return (u64)read_cpuid(ID_ISAR1_EL1);
+	case SYS_ID_ISAR2_EL1:		return (u64)read_cpuid(ID_ISAR2_EL1);
+	case SYS_ID_ISAR3_EL1:		return (u64)read_cpuid(ID_ISAR3_EL1);
+	case SYS_ID_ISAR4_EL1:		return (u64)read_cpuid(ID_ISAR4_EL1);
+	case SYS_ID_ISAR5_EL1:		return (u64)read_cpuid(ID_ISAR4_EL1);
+	case SYS_MVFR0_EL1:		return (u64)read_cpuid(MVFR0_EL1);
+	case SYS_MVFR1_EL1:		return (u64)read_cpuid(MVFR1_EL1);
+	case SYS_MVFR2_EL1:		return (u64)read_cpuid(MVFR2_EL1);
+
+	case SYS_ID_AA64PFR0_EL1:	return (u64)read_cpuid(ID_AA64PFR0_EL1);
+	case SYS_ID_AA64PFR1_EL1:	return (u64)read_cpuid(ID_AA64PFR0_EL1);
+	case SYS_ID_AA64DFR0_EL1:	return (u64)read_cpuid(ID_AA64DFR0_EL1);
+	case SYS_ID_AA64DFR1_EL1:	return (u64)read_cpuid(ID_AA64DFR0_EL1);
+	case SYS_ID_AA64MMFR0_EL1:	return (u64)read_cpuid(ID_AA64MMFR0_EL1);
+	case SYS_ID_AA64MMFR1_EL1:	return (u64)read_cpuid(ID_AA64MMFR1_EL1);
+	case SYS_ID_AA64ISAR0_EL1:	return (u64)read_cpuid(ID_AA64ISAR0_EL1);
+	case SYS_ID_AA64ISAR1_EL1:	return (u64)read_cpuid(ID_AA64ISAR1_EL1);
+
+	case SYS_CNTFRQ_EL0:		return (u64)read_cpuid(CNTFRQ_EL0);
+	case SYS_CTR_EL0:		return (u64)read_cpuid(CTR_EL0);
+	case SYS_DCZID_EL0:		return (u64)read_cpuid(DCZID_EL0);
+	default:
+		BUG();
+		return 0;
+	}
+}
+
 #include <linux/irqchip/arm-gic-v3.h>
 
 static bool
@@ -600,19 +642,24 @@ feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
 }
 
 static bool
-has_cpuid_feature(const struct arm64_cpu_capabilities *entry)
+has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	u64 val;
 
-	val = read_system_reg(entry->sys_reg);
+	WARN_ON(scope == SCOPE_LOCAL_CPU && preemptible());
+	if (scope == SCOPE_SYSTEM)
+		val = read_system_reg(entry->sys_reg);
+	else
+		val = __raw_read_system_reg(entry->sys_reg);
+
 	return feature_matches(val, entry);
 }
 
-static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry)
+static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	bool has_sre;
 
-	if (!has_cpuid_feature(entry))
+	if (!has_cpuid_feature(entry, scope))
 		return false;
 
 	has_sre = gic_enable_sre();
@@ -627,6 +674,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
 		.capability = ARM64_HAS_SYSREG_GIC_CPUIF,
+		.def_scope = SCOPE_SYSTEM,
 		.matches = has_useable_gicv3_cpuif,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_GIC_SHIFT,
@@ -636,6 +684,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Privileged Access Never",
 		.capability = ARM64_HAS_PAN,
+		.def_scope = SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR1_EL1,
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
@@ -647,6 +696,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
+		.def_scope = SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR0_EL1,
 		.field_pos = ID_AA64ISAR0_ATOMICS_SHIFT,
@@ -656,6 +706,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "32-bit EL0 Support",
 		.capability = ARM64_HAS_32BIT_EL0,
+		.def_scope = SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
@@ -667,6 +718,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 #define HWCAP_CAP(reg, field, min_value, type, cap)		\
 	{							\
 		.desc = #cap,					\
+		.def_scope = SCOPE_SYSTEM,			\
 		.matches = has_cpuid_feature,			\
 		.sys_reg = reg,					\
 		.field_pos = field,				\
@@ -745,7 +797,7 @@ static void setup_cpu_hwcaps(void)
 	const struct arm64_cpu_capabilities *hwcaps = arm64_hwcaps;
 
 	for (i = 0; hwcaps[i].matches; i++)
-		if (hwcaps[i].matches(&hwcaps[i]))
+		if (hwcaps[i].matches(&hwcaps[i], hwcaps[i].def_scope))
 			cap_set_hwcap(&hwcaps[i]);
 }
 
@@ -755,7 +807,7 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 	int i;
 
 	for (i = 0; caps[i].matches; i++) {
-		if (!caps[i].matches(&caps[i]))
+		if (!caps[i].matches(&caps[i], caps[i].def_scope))
 			continue;
 
 		if (!cpus_have_cap(caps[i].capability) && caps[i].desc)
@@ -800,47 +852,6 @@ static inline void set_sys_caps_initialised(void)
 	sys_caps_initialised = true;
 }
 
-/*
- * __raw_read_system_reg() - Used by a STARTING cpu before cpuinfo is populated.
- */
-static u64 __raw_read_system_reg(u32 sys_id)
-{
-	switch (sys_id) {
-	case SYS_ID_PFR0_EL1:		return (u64)read_cpuid(ID_PFR0_EL1);
-	case SYS_ID_PFR1_EL1:		return (u64)read_cpuid(ID_PFR1_EL1);
-	case SYS_ID_DFR0_EL1:		return (u64)read_cpuid(ID_DFR0_EL1);
-	case SYS_ID_MMFR0_EL1:		return (u64)read_cpuid(ID_MMFR0_EL1);
-	case SYS_ID_MMFR1_EL1:		return (u64)read_cpuid(ID_MMFR1_EL1);
-	case SYS_ID_MMFR2_EL1:		return (u64)read_cpuid(ID_MMFR2_EL1);
-	case SYS_ID_MMFR3_EL1:		return (u64)read_cpuid(ID_MMFR3_EL1);
-	case SYS_ID_ISAR0_EL1:		return (u64)read_cpuid(ID_ISAR0_EL1);
-	case SYS_ID_ISAR1_EL1:		return (u64)read_cpuid(ID_ISAR1_EL1);
-	case SYS_ID_ISAR2_EL1:		return (u64)read_cpuid(ID_ISAR2_EL1);
-	case SYS_ID_ISAR3_EL1:		return (u64)read_cpuid(ID_ISAR3_EL1);
-	case SYS_ID_ISAR4_EL1:		return (u64)read_cpuid(ID_ISAR4_EL1);
-	case SYS_ID_ISAR5_EL1:		return (u64)read_cpuid(ID_ISAR4_EL1);
-	case SYS_MVFR0_EL1:		return (u64)read_cpuid(MVFR0_EL1);
-	case SYS_MVFR1_EL1:		return (u64)read_cpuid(MVFR1_EL1);
-	case SYS_MVFR2_EL1:		return (u64)read_cpuid(MVFR2_EL1);
-
-	case SYS_ID_AA64PFR0_EL1:	return (u64)read_cpuid(ID_AA64PFR0_EL1);
-	case SYS_ID_AA64PFR1_EL1:	return (u64)read_cpuid(ID_AA64PFR0_EL1);
-	case SYS_ID_AA64DFR0_EL1:	return (u64)read_cpuid(ID_AA64DFR0_EL1);
-	case SYS_ID_AA64DFR1_EL1:	return (u64)read_cpuid(ID_AA64DFR0_EL1);
-	case SYS_ID_AA64MMFR0_EL1:	return (u64)read_cpuid(ID_AA64MMFR0_EL1);
-	case SYS_ID_AA64MMFR1_EL1:	return (u64)read_cpuid(ID_AA64MMFR1_EL1);
-	case SYS_ID_AA64ISAR0_EL1:	return (u64)read_cpuid(ID_AA64ISAR0_EL1);
-	case SYS_ID_AA64ISAR1_EL1:	return (u64)read_cpuid(ID_AA64ISAR1_EL1);
-
-	case SYS_CNTFRQ_EL0:		return (u64)read_cpuid(CNTFRQ_EL0);
-	case SYS_CTR_EL0:		return (u64)read_cpuid(CTR_EL0);
-	case SYS_DCZID_EL0:		return (u64)read_cpuid(DCZID_EL0);
-	default:
-		BUG();
-		return 0;
-	}
-}
-
 /*
  * Park the CPU which doesn't have the capability as advertised
  * by the system.
-- 
2.21.0.rc0.269.g1a574e7a288b

