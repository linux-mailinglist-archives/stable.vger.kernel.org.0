Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACFFE690E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfJ0VLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfJ0VL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:29 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C9F02064A;
        Sun, 27 Oct 2019 21:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210688;
        bh=uRdX94xamSskpty51sM7C30qYAN0ElM4sNj9f1TtzW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujMfOLKEoVY4xyUPl07AKFwPT+Id/eetW/ltXiVAuJEwDqRhjKYIeb0zzc77M4x4c
         tB+auBSKK0H0XF++1h9aT4OjwTmhxlv+/C2Wq+cON9CrsimY6T04OZJp/Mycbj2JjH
         Xazx2yMjAfAU18G3rrz1FZ94xcd0jWTpzAzY60Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 058/119] arm64: capabilities: Restrict KPTI detection to boot-time CPUs
Date:   Sun, 27 Oct 2019 22:00:35 +0100
Message-Id: <20191027203325.571416083@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    9 +++++++++
 arch/arm64/kernel/cpufeature.c      |   16 +++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -244,6 +244,15 @@ extern struct arm64_ftr_reg arm64_ftr_re
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
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,10 +824,9 @@ static bool has_no_fpsimd(const struct a
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
-				int __unused)
+				int scope)
 {
 	char const *str = "command line option";
-	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
@@ -863,8 +862,7 @@ static bool unmap_kernel_at_el0(const st
 	}
 
 	/* Defer to CPU feature registers */
-	return !cpuid_feature_extract_unsigned_field(pfr0,
-						     ID_AA64PFR0_CSV3_SHIFT);
+	return !has_cpuid_feature(entry, scope);
 }
 
 static void
@@ -1011,7 +1009,15 @@ static const struct arm64_cpu_capabiliti
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


