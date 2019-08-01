Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDBC7D755
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfHAIVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35379 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730688AbfHAIVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so27433436pgr.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ea6sM+FtbjaUvKE8XTo8IrkOgZbBdosuDWN0NMu3JEA=;
        b=IqgMWC+doqxZ/x9SW9opxGfpwlsiAyQDTKWOiIlR0W4chV0hNWekn8EH67WIsJo7r7
         tGHL37Y5GWbCA74ReUFqeSKAAs8gOSdGslZ0rY5riXYyM+Nmr7hjPiEr5XuQQuRdFNss
         rZr3eZ6x8gRF1jdGXT+WJo+5N1MHeZqMl25r6qJEsR1nFISh2pFEC/F29TkrwoJZ4mgU
         X4WGLXr6pcnpr/EmZWFfQORxn2Mr8rd0LF6yeeo0iQdI8GbACrwZkzeOP1Ffk6fQ+6xF
         U+0mJeTXirqYQdR0a7U1BQV/SOPMFILzWfKSe3nJbln8rg+OJDsEKuAZVfiORH1yci53
         OmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ea6sM+FtbjaUvKE8XTo8IrkOgZbBdosuDWN0NMu3JEA=;
        b=YR1nXlMY8m5ojd/VWGKWjqNynMZLSkO9RR/llPm2EJKNSYLAhjc3SFM7Cjm3bhFkJO
         ctqUaZqT2Zo/Es+xcQggFvkdMTM7Jx8/8wEaPyrReQKYDWGLpWEEBUO7J5tbU6b4TNQl
         yrCSRZzf2O1YDGQqhSZpTKkqRX8qnp8RElgjUQEmCdQiSWEOfvYXamiXjP/nf8giziNK
         N3M1Mw0pz/zDJEjPkpyruEZdP5wt7RESyUQMq/afY9rEHAE7AvhT998SzPmCitkm7XOE
         rniixkBS4qC15KVFKeXANEMBu47M4e0NE2Mc231+BdW0qUse5gMAJRPrkDy6NtuIMW43
         mBeA==
X-Gm-Message-State: APjAAAVoGQk/E2eUTBMCT6KDKVYRIg2djnxuCFO1SNPJNNIgKbjrN2Nc
        gHwtGE0sJvBbiSALYv0rqSI3+woNkk4=
X-Google-Smtp-Source: APXvYqw0PAqPaGk4hWjyFbvlyejncVcUiQTq3n7cbWPXrKNvQoJaFsq4FxSG/OTM180Q3cX7bL1lpw==
X-Received: by 2002:a17:90a:9905:: with SMTP id b5mr7468850pjp.70.1564647678567;
        Thu, 01 Aug 2019 01:21:18 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id y194sm47245954pfg.116.2019.08.01.01.21.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:18 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 40/47] ARM: split out processor lookup
Date:   Thu,  1 Aug 2019 13:46:24 +0530
Message-Id: <d3607e643b719b26753e3a70ea33d5914367f50e.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 65987a8553061515b5851b472081aedb9837a391 upstream.

Split out the lookup of the processor type and associated error handling
from the rest of setup_processor() - we will need to use this in the
secondary CPU bringup path for big.Little Spectre variant 2 mitigation.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/cputype.h |  1 +
 arch/arm/kernel/setup.c        | 31 +++++++++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 76bb3bd060d1..53125dad6edd 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -93,6 +93,7 @@
 #define ARM_CPU_PART_SCORPION		0x510002d0
 
 extern unsigned int processor_id;
+struct proc_info_list *lookup_processor(u32 midr);
 
 #ifdef CONFIG_CPU_CP15
 #define read_cpuid(reg)							\
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 20edd349d379..5aa9c08de410 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -599,22 +599,29 @@ static void __init smp_build_mpidr_hash(void)
 }
 #endif
 
-static void __init setup_processor(void)
+/*
+ * locate processor in the list of supported processor types.  The linker
+ * builds this table for us from the entries in arch/arm/mm/proc-*.S
+ */
+struct proc_info_list *lookup_processor(u32 midr)
 {
-	struct proc_info_list *list;
+	struct proc_info_list *list = lookup_processor_type(midr);
 
-	/*
-	 * locate processor in the list of supported processor
-	 * types.  The linker builds this table for us from the
-	 * entries in arch/arm/mm/proc-*.S
-	 */
-	list = lookup_processor_type(read_cpuid_id());
 	if (!list) {
-		pr_err("CPU configuration botched (ID %08x), unable to continue.\n",
-		       read_cpuid_id());
-		while (1);
+		pr_err("CPU%u: configuration botched (ID %08x), CPU halted\n",
+		       smp_processor_id(), midr);
+		while (1)
+		/* can't use cpu_relax() here as it may require MMU setup */;
 	}
 
+	return list;
+}
+
+static void __init setup_processor(void)
+{
+	unsigned int midr = read_cpuid_id();
+	struct proc_info_list *list = lookup_processor(midr);
+
 	cpu_name = list->cpu_name;
 	__cpu_architecture = __get_cpu_architecture();
 
@@ -632,7 +639,7 @@ static void __init setup_processor(void)
 #endif
 
 	pr_info("CPU: %s [%08x] revision %d (ARMv%s), cr=%08lx\n",
-		cpu_name, read_cpuid_id(), read_cpuid_id() & 15,
+		list->cpu_name, midr, midr & 15,
 		proc_arch[cpu_architecture()], get_cr());
 
 	snprintf(init_utsname()->machine, __NEW_UTS_LEN + 1, "%s%c",
-- 
2.21.0.rc0.269.g1a574e7a288b

