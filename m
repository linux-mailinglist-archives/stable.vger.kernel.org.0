Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E466634
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfGLF3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40580 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so4000352pgj.7
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUdOby9mUIJ5g7nxMiQ+DmGQefEZUa89WzEBGK5DmD0=;
        b=AboBRh8MfdxTXoZvpkpTrMwzfGFExqOWODf+W95I9f1LqpR4v4X8RaMAGhzpU6Ldgf
         2Of4QPmJ9YYALJILmxz5mvoF72Cb05nUdoAuIoQaQofPG/N0Nw+Ctfgyedb0ir8iZXSA
         4zPXQvhExq3s5lZ2QugOie5u+LJIPNowtWVI0SffAIDa0pLiaUNxABiL+D5LEdeI1kKp
         JE195sEj3U6FYu5xp+L7eP4HidL2n1RYqK53wr6NsJ+93QygtBZXR9dASgjQugtleC36
         4K5FCgyTIQATBRO7g+oeAv5Jd54b/v07lziyQEgJ+ncoW4fJ9sYkopNRz4NZ3ihrMvaQ
         JZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUdOby9mUIJ5g7nxMiQ+DmGQefEZUa89WzEBGK5DmD0=;
        b=XVkQ49ylrH4ZU2yFjxrnQiMv+ZVI5i+fFDNy0MdYogH+L7lVYKLolwZPfg/4jIoMwW
         6KQePH4T1VKg9AlWZjX4iqXS5ElklJEsdiHz54Iy3BHDCKFOTdC9Vq2uYmb8k267CrMB
         pgcKOZUpFVkZsit5vEczffHtsptiqJzB7V7aAz8Gjn/yZFjPQp4fGO/Q5rwHwgFEoKIm
         5HgISjNAUIWGCf+I0rxejHUwPw1M+O1egfHhI0rQzyY+Bk+De7Mu2UeigTEZgZheaYma
         1ZeOnEZZ8erxqCdP0qF8SX2/PSErI1aUF2yJLlBnaGx02bLxI6J3SC0DOAX5SSKT05IU
         MwUA==
X-Gm-Message-State: APjAAAUWjhlhvSLjjc+c1otyjPoRV63jNCIPQZ76xaNegUioGb3+CSgq
        +Lx+etCnmqYJwk6V5fIul71Uk56W3sE=
X-Google-Smtp-Source: APXvYqwSjyqxaUdjbcdf8HLu32WhC1K/AZ7yPdKlvWPW5ICuoruk/scKndDoeJVHSUCUHFOYRicFgQ==
X-Received: by 2002:a63:ed06:: with SMTP id d6mr8600073pgi.267.1562909387463;
        Thu, 11 Jul 2019 22:29:47 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id r2sm9904015pfl.67.2019.07.11.22.29.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:47 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 18/43] arm64: Rearrange CPU errata workaround checks
Date:   Fri, 12 Jul 2019 10:58:06 +0530
Message-Id: <4c595dbb19c7b70c007b6bfa068c1b22dca4bdec.1562908075.git.viresh.kumar@linaro.org>
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
index 752b53daac23..7a9eff0d1ebe 100644
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
@@ -360,6 +360,12 @@ void __init smp_prepare_boot_cpu(void)
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

