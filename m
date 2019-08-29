Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEFA18CD
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfH2Lfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41779 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2Lfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id 196so1856255pfz.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkxeJKseCGMXAXIlAcnMLE13XsHo9zOa4aO4yBF3DzQ=;
        b=zujYWfHMa9zxuzfY/LQcJwmlrlpW6+RGRN39kKnJidiaUBoJD2N8W1guUFysCGBzJl
         JFT0avWA0hY3U2TiEmz24gW3sMQbukbVSS4GhboNaxVU9XZSjoKu0XF2up2i4dQOnthl
         7CxB3ITtZxylDXoZ6EOr0kcS2SB6ZjbPjKbm5svxLfKJXoFDYvjSEN89/JIlpK6vYmoT
         G3/tEEIrxx/o9bgCbZdCdKDGk9KEUQ6cqlpYUWXBNo9bX2YYizM0aTYeyzWbVCnB7KCD
         w8CUlC1bGmrjssa3WvBm4llSytGeqmtW3UI9IETOn5Nj5nCfrz3uepgysxFLqdtQIQ6D
         QCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkxeJKseCGMXAXIlAcnMLE13XsHo9zOa4aO4yBF3DzQ=;
        b=n+IbABvjq7wuHF+GQBKYXc85TLx/mY2mrBO0/zaU9O/u1vGfILUJ//ahYJEjy1xJFf
         lyxfg3zklqEFucvQJMvnDamp/q/FfnkJ1DdXHviLeCBJMxTH/bOfovI/Se7oUMTUAeZv
         tKI+A5+gAkO722LhrcKSgxnSeJEhx2kTI19j6s44gpmHJtcfFdr1UvMLnOUknkSr68GZ
         iyRtimxXkD1lUY3FkrUvNqxnT2FLQ00rCHgh4fA7V6WKkxcZAUWTfKfWZHeav/rpRlpM
         X+Tu3S9M1QKg9BtOizfz2akhX/wfTEfY0J/bZPKMlG3ySOdYkiaxwRbniLpdZ8rXfXyM
         DDng==
X-Gm-Message-State: APjAAAUDRuW8VCbKms8C8oY6H7YsNUjNrFqVIIp8GqF/NYrYIOa81+b1
        xbJ47nJkYpuOdklHWjr2UJCOmm4MvaA=
X-Google-Smtp-Source: APXvYqxe+8QX9yX8fdiQ5U4RTEZHX7kLARSc+TXaWsHD1QCjdjtb/93ErL/u3tIHlrpyw7YMpv8fSw==
X-Received: by 2002:a62:87c8:: with SMTP id i191mr10806160pfe.133.1567078543262;
        Thu, 29 Aug 2019 04:35:43 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e13sm6731082pfl.130.2019.08.29.04.35.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:42 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 19/44] arm64: Rearrange CPU errata workaround checks
Date:   Thu, 29 Aug 2019 17:04:04 +0530
Message-Id: <3d271452ae3c6ffe3c6ab1085d0dadb20f86a81e.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit c47a1900ad710fd2c97127e2ba19da1df79cf733 upstream.

Right now we run through the work around checks on a CPU
from __cpuinfo_store_cpu. There are some problems with that:

1) We initialise the system wide CPU feature registers only after the
Boot CPU updates its cpuinfo. Now, if a work around depends on the
variance of a CPU ID feature (e.g, check for Cache Line size mismatch),
we have no way of performing it cleanly for the boot CPU.

2) It is out of place, invoked from __cpuinfo_store_cpu() in cpuinfo.c. It
is not an obvious place for that.

This patch rearranges the CPU specific capability(aka work around) checks.

1) At the moment we use verify_local_cpu_capabilities() to check if a new
CPU has all the system advertised features. Use this for the secondary CPUs
to perform the work around check. For that we rename
  verify_local_cpu_capabilities() => check_local_cpu_capabilities()
which:

   If the system wide capabilities haven't been initialised (i.e, the CPU
   is activated at the boot), update the system wide detected work arounds.

   Otherwise (i.e a CPU hotplugged in later) verify that this CPU conforms to the
   system wide capabilities.

2) Boot CPU updates the work arounds from smp_prepare_boot_cpu() after we have
initialised the system wide CPU feature values.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |  8 +-------
 arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++--------
 arch/arm64/kernel/cpuinfo.c         |  2 --
 arch/arm64/kernel/smp.c             |  8 +++++++-
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 0267bab6ac18..1bc51f8835e5 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -177,13 +177,7 @@ void __init enable_errata_workarounds(void);
 
 void verify_local_cpu_errata(void);
 
-#ifdef CONFIG_HOTPLUG_CPU
-void verify_local_cpu_capabilities(void);
-#else
-static inline void verify_local_cpu_capabilities(void)
-{
-}
-#endif
+void check_local_cpu_capabilities(void);
 
 u64 read_system_reg(u32 id);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7773bea6927e..c74df3ca000e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -860,18 +860,11 @@ static inline void set_sys_caps_initialised(void)
  * cannot do anything to fix it up and could cause unexpected failures. So
  * we park the CPU.
  */
-void verify_local_cpu_capabilities(void)
+static void verify_local_cpu_capabilities(void)
 {
 	int i;
 	const struct arm64_cpu_capabilities *caps;
 
-	/*
-	 * If we haven't computed the system capabilities, there is nothing
-	 * to verify.
-	 */
-	if (!sys_caps_initialised)
-		return;
-
 	verify_local_cpu_errata();
 
 	caps = arm64_features;
@@ -902,6 +895,20 @@ void verify_local_cpu_capabilities(void)
 	}
 }
 
+void check_local_cpu_capabilities(void)
+{
+	/*
+	 * If we haven't finalised the system capabilities, this CPU gets
+	 * a chance to update the errata work arounds.
+	 * Otherwise, this CPU should verify that it has all the system
+	 * advertised capabilities.
+	 */
+	if (!sys_caps_initialised)
+		check_local_cpu_errata();
+	else
+		verify_local_cpu_capabilities();
+}
+
 #else	/* !CONFIG_HOTPLUG_CPU */
 
 static inline void set_sys_caps_initialised(void)
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 0166cfbc866c..13e659fda04a 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -239,8 +239,6 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_mvfr2 = read_cpuid(MVFR2_EL1);
 
 	cpuinfo_detect_icache_policy(info);
-
-	check_local_cpu_errata();
 }
 
 void cpuinfo_store_cpu(void)
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 23e8ae0c6305..02b76bb78d59 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -161,7 +161,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * this CPU ticks all of those. If it doesn't, the CPU will
 	 * fail to come online.
 	 */
-	verify_local_cpu_capabilities();
+	check_local_cpu_capabilities();
 
 	if (cpu_ops[cpu]->cpu_postboot)
 		cpu_ops[cpu]->cpu_postboot();
@@ -357,6 +357,12 @@ void __init smp_prepare_boot_cpu(void)
 {
 	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
 	cpuinfo_store_boot_cpu();
+	/*
+	 * Run the errata work around checks on the boot CPU, once we have
+	 * initialised the cpu feature infrastructure from
+	 * cpuinfo_store_boot_cpu() above.
+	 */
+	check_local_cpu_errata();
 }
 
 static u64 __init of_get_cpu_mpidr(struct device_node *dn)
-- 
2.21.0.rc0.269.g1a574e7a288b

