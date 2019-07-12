Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1266631
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfGLF3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34374 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so4215147plt.1
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XsKw19fTFieNWoM6VpeUN2a175ttgnWqs3kt6rmh49I=;
        b=iKPYCzvWW+66Pm/bOsNKrq5P7zLX7Gse55VsuCQJOKsYEXQJgYwZTl6ufTBi8ViuYK
         HVqUasJBncLGzqVq0OTEzoIpb21awZWXmMarGQg9BhWocyAf+boX3+XyZL9aO5fa20VQ
         NF1Qswif37U9oRv/De8zZokR8aXCAren/Vq91hDz3kBpLbpAV5sfYUHeSUrPRQaslkcz
         qVCNFXtFGaxFNIf+YJg1oWWhKMDwoYNEnadjNsjigTvmD1kqDDXndRa3Ktej+sBYoTaK
         /utuZ7pqW9y8QXFOKLw704iIzoo5Qarpys4miw0IMnmfvclAOvlmTL5awCM03/XljFsO
         +zIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XsKw19fTFieNWoM6VpeUN2a175ttgnWqs3kt6rmh49I=;
        b=of72YPMmPOcSehz5MXZPjADjBUKRqB6hKTLT1K+FNVMD5bToOiWZHdow8j8vbGKMMe
         N+ci6WwTIZI5ehghA2L1NBoZorRtLTVh4U+6DgUHjvHF0e8blEXuk9azn31oeaparbJf
         gt3Z5Bp6t3VJrMhSmuERegTxi9YlVrP3bEY1J5J0vHzh84HroifCn332TMfOiVycEn/8
         0+UOSaUDCvNgUXnkxzp1sNxp4yImNEa2rramzDic73Wis6jdnv6GpPX7JMC7ttbCwv6H
         UG8bBKCseWpm3MK8pDaqRUAgyBHwYDuXTBMSvRLfKqfCDVHsNsbQ+7XznLA5VCdQjFhR
         MAzQ==
X-Gm-Message-State: APjAAAWnl1qb2F7WE6SwJoOt/73A7KDA3kDuLurGDD8BVFQjWW4F6oFG
        sieUOswuHWTl9fYrSZm/x4jiBAuQ4fQ=
X-Google-Smtp-Source: APXvYqxvUAGGZyaOV3mER1kvI8Y7VJk6rQ6uomE1FtsKj4vu6FKLnf2EM2So364aisCPwN6zEMhNOA==
X-Received: by 2002:a17:902:aa09:: with SMTP id be9mr8935831plb.52.1562909379536;
        Thu, 11 Jul 2019 22:29:39 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 131sm10394940pfx.57.2019.07.11.22.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:39 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 15/43] arm64: Move cpu_die_early to smp.c
Date:   Fri, 12 Jul 2019 10:58:03 +0530
Message-Id: <dd031e0851c01a0cfe275c05dc24935580d2fd78.1562908075.git.viresh.kumar@linaro.org>
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

commit fce6361fe9b0caeba0c05b7d72ceda406f8780df upstream.

This patch moves cpu_die_early to smp.c, where it fits better.
No functional changes, except for adding the necessary checks
for CONFIG_HOTPLUG_CPU.

Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Viresh: Resolved rebase conflict ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/smp.h   |  1 +
 arch/arm64/kernel/cpufeature.c | 22 ----------------------
 arch/arm64/kernel/smp.c        | 25 +++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index d9c3d6a6100a..13ce01fe6237 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -68,5 +68,6 @@ extern int __cpu_disable(void);
 
 extern void __cpu_die(unsigned int cpu);
 extern void cpu_die(void);
+extern void cpu_die_early(void);
 
 #endif /* ifndef __ASM_SMP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b7f01bf47988..a0273cd8be51 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -852,28 +852,6 @@ static inline void set_sys_caps_initialised(void)
 	sys_caps_initialised = true;
 }
 
-/*
- * Kill the calling secondary CPU, early in bringup before it is turned
- * online.
- */
-void cpu_die_early(void)
-{
-	int cpu = smp_processor_id();
-
-	pr_crit("CPU%d: will not boot\n", cpu);
-
-	/* Mark this CPU absent */
-	set_cpu_present(cpu, 0);
-
-	/* Check if we can park ourselves */
-	if (cpu_ops[cpu] && cpu_ops[cpu]->cpu_die)
-		cpu_ops[cpu]->cpu_die(cpu);
-	asm(
-	"1:	wfe\n"
-	"	wfi\n"
-	"	b	1b");
-}
-
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 03c0946b79d2..752b53daac23 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -312,6 +312,31 @@ void cpu_die(void)
 }
 #endif
 
+/*
+ * Kill the calling secondary CPU, early in bringup before it is turned
+ * online.
+ */
+void cpu_die_early(void)
+{
+	int cpu = smp_processor_id();
+
+	pr_crit("CPU%d: will not boot\n", cpu);
+
+	/* Mark this CPU absent */
+	set_cpu_present(cpu, 0);
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* Check if we can park ourselves */
+	if (cpu_ops[cpu] && cpu_ops[cpu]->cpu_die)
+		cpu_ops[cpu]->cpu_die(cpu);
+#endif
+
+	asm(
+	"1:	wfe\n"
+	"	wfi\n"
+	"	b	1b");
+}
+
 static void __init hyp_mode_check(void)
 {
 	if (is_hyp_mode_available())
-- 
2.21.0.rc0.269.g1a574e7a288b

