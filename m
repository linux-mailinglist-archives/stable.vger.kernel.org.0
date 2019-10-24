Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEE9E32E2
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502107AbfJXMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50746 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502106AbfJXMt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id q13so2706064wmj.0
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gP22+EN20t8XuAgVVLPZCSvR9l9f1V9JzOAF+RDbNYk=;
        b=zGScEvvsES9rHEMaubooMfvweePjcNyG0ck9V7HyD41Cd2wWsQwAyNf3tQmWBW5wWw
         RmAciHrtWFZlU3PzEKayfG5Jw7nxDCHLbeY9ljoH5jvVgZSb6yUMRNTG6jFoowAtx+/r
         7bLTskw9pXmygMvgc0KzkSgWecZ2BskUWWZEXvUWaPhizb25CVJV3PX8vRBLUouB0thj
         k/PIm1oZl9D/mPdbs5hmiCSpUo0av5k3x8+VinOyoTLRphsg4qmTpI/AznD0KG/2mTnq
         rWeXyFyoc4JDOwSWVJNL2BpJHsLZ8An+DB0MRffoSn8G+wuIMBcidOW4gc6gkYBcQIw6
         CDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gP22+EN20t8XuAgVVLPZCSvR9l9f1V9JzOAF+RDbNYk=;
        b=k+2NoGr5QdoNkcG1/fioa+o4zAtqIfx6bM/1IQLg5y+nhBqILMvUpD2TYpkDCzY1h1
         I3AIdzj0TzjT8zZq7ArTFDq8tHn5Ujvo0Qvw98chuFiLYhgl7p2pQDdshKh0Q4UXxkM9
         fS+zzD2vCFpf5mCwpYVdMKNsEiThDx8m6yR8kxHr//8bOztzIQXSj3IKq01OE8z3JvWw
         P8xBT6/yFH1RhMuxYNxo5x37SmokGuPk+yaeE56RJUn3mUz0zMr+ZNVsuPG2tzESnazj
         T1XM094xBppdsY61o8CrGCU1xBWYmgh1Z85kfmXBHT0XRxRmRe2KICiWJwYSv6X2XDRg
         IzXQ==
X-Gm-Message-State: APjAAAUmAs5PtP4i9R1GxrBW7kt3GWob8/P9iG9ESGgpGxSOlkEdu4We
        uvvc4GMemU+C1FNOIv1V1YvZzPH79ExCMH2u
X-Google-Smtp-Source: APXvYqyPXdoKcHyk8RtzykQkWXFZB5ueSrmhtRd5OeoxNT3MkyEDgk/Kwzv+fXCNPel2EWo+dKvvrQ==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr4731322wmj.126.1571921363292;
        Thu, 24 Oct 2019 05:49:23 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:22 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 22/48] arm64: capabilities: Restrict KPTI detection to boot-time CPUs
Date:   Thu, 24 Oct 2019 14:48:07 +0200
Message-Id: <20191024124833.4158-23-ard.biesheuvel@linaro.org>
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

[ Upstream commit d3aec8a28be3b88bf75442e7c24fd9da8d69a6df ]

KPTI is treated as a system wide feature and is only detected if all
the CPUs in the sysetm needs the defense, unless it is forced via kernel
command line. This leaves a system with a mix of CPUs with and without
the defense vulnerable. Also, if a late CPU needs KPTI but KPTI was not
activated at boot time, the CPU is currently allowed to boot, which is a
potential security vulnerability.
This patch ensures that the KPTI is turned on if at least one CPU detects
the capability (i.e, change scope to SCOPE_LOCAL_CPU). Also rejetcs a late
CPU, if it requires the defense, when the system hasn't enabled it,

Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |  9 +++++++++
 arch/arm64/kernel/cpufeature.c      | 16 +++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 09825b667af0..96c99b201b2f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -244,6 +244,15 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 	 ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU	|	\
 	 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU)
 
+/*
+ * CPU feature detected at boot time, on one or more CPUs. A late CPU
+ * is not allowed to have the capability when the system doesn't have it.
+ * It is Ok for a late CPU to miss the feature.
+ */
+#define ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE	\
+	(ARM64_CPUCAP_SCOPE_LOCAL_CPU		|	\
+	 ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
+
 struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 439cdca71024..b3ebbc56bebb 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,10 +824,9 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
-				int __unused)
+				int scope)
 {
 	char const *str = "command line option";
-	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
@@ -863,8 +862,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	}
 
 	/* Defer to CPU feature registers */
-	return !cpuid_feature_extract_unsigned_field(pfr0,
-						     ID_AA64PFR0_CSV3_SHIFT);
+	return !has_cpuid_feature(entry, scope);
 }
 
 static void
@@ -1011,7 +1009,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE,
+		/*
+		 * The ID feature fields below are used to indicate that
+		 * the CPU doesn't need KPTI. See unmap_kernel_at_el0 for
+		 * more details.
+		 */
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.field_pos = ID_AA64PFR0_CSV3_SHIFT,
+		.min_field_value = 1,
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
-- 
2.20.1

