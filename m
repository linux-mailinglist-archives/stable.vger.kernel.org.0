Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99874A18CA
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfH2Lff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41767 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfH2Lff (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id 196so1856031pfz.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7tWZ4SSsguq1kKDGe+eHq1QEkjWGUVJOVs6gRGydRo=;
        b=pYRYAxtKgJJnWHVpW0dvFREmu6GDQq9DGA2/QUcdzPieHaQAPryaUQrqmtGboo0fNX
         ucmEoXA9ZB46cMtJGX78GnCicYNC++GJQJkMXz/tGcvUr4BEnOpiN6Vz2J5L77r9x9MM
         4mQWEHQHXhkTW+0xxyaKY8SSwx9IvM6cDDeWRkWv27lPUSj5O/lsYAKmoOvb0p24mbkb
         uWzPPL7Hdcn3bGGsED/RiRw/xRXzqUsF/ikKm4O7mO+iTHJpwDJeEsZ6cq+WYt08USGP
         xjz3Y/E/j9b+UxSntJWH+OukE40S8fXyZaHE7v1zcKaa7ATOWu4OkAXUOH78FOqmgnvz
         qUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7tWZ4SSsguq1kKDGe+eHq1QEkjWGUVJOVs6gRGydRo=;
        b=MXWyFY5+Jbo72cGs4oR/2GW4ve2Q87gZG57K7VDINgUzqrNzqU/0xKduXaDVZ25SMk
         erVz728HV43wdajfJEmAyDXvwzVGrfPSUbRT5nOc006mP+iQtSlzya3KwxGcxi8bN7RI
         lEXSOdf8M2pniT97tWRGglm6zeHBK4CWRNtNQg1Gx84X5xpsMabt+KWBuDxiovG3/8V0
         ffenjzCVRPFyCM71WmitNFs+rs8rcZHMtm3y4UvlHQ0ZpxvFfSDxC5UxWeJUUoba7dIQ
         eechgmLfvsRdxeSeM9Jxm5Hpa9pXNaQvu6+BJtiSUGq1lPn4ZjXlP2hd31kc9IGyN4gf
         0FpA==
X-Gm-Message-State: APjAAAWRjyWgIVQpD5IM9U+H7U39ej5mY245P4NbSVbdhtkPqvxakk5c
        fx16QprbytpvhX0+oVP96C0QJCDTAQA=
X-Google-Smtp-Source: APXvYqx/9bqZ348Ffe/5Oarap714tqQ6mvmVep5ft2QKUKQYOUyza6cxcIayEsdiiZ3jPUhZMrMTJw==
X-Received: by 2002:a17:90a:f485:: with SMTP id bx5mr9464169pjb.113.1567078534588;
        Thu, 29 Aug 2019 04:35:34 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e13sm6729834pfl.130.2019.08.29.04.35.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:33 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 16/44] arm64: Move cpu_die_early to smp.c
Date:   Thu, 29 Aug 2019 17:04:01 +0530
Message-Id: <59d2f5d6f0d1e777646712b74e542fdf160c953f.1567077734.git.viresh.kumar@linaro.org>
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

Commit fce6361fe9b0caeba0c05b7d72ceda406f8780df upstream.

This patch moves cpu_die_early to smp.c, where it fits better.
No functional changes, except for adding the necessary checks
for CONFIG_HOTPLUG_CPU.

Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/smp.h   |  1 +
 arch/arm64/kernel/cpufeature.c | 19 -------------------
 arch/arm64/kernel/smp.c        | 22 ++++++++++++++++++++++
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 53b53a9b3e5a..32e75ee21d5e 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -68,6 +68,7 @@ extern int __cpu_disable(void);
 
 extern void __cpu_die(unsigned int cpu);
 extern void cpu_die(void);
+extern void cpu_die_early(void);
 
 static inline void cpu_park_loop(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4adf18307568..a0273cd8be51 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -852,25 +852,6 @@ static inline void set_sys_caps_initialised(void)
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
-	cpu_park_loop();
-}
-
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 03c0946b79d2..23e8ae0c6305 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -312,6 +312,28 @@ void cpu_die(void)
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
+	cpu_park_loop();
+}
+
 static void __init hyp_mode_check(void)
 {
 	if (is_hyp_mode_available())
-- 
2.21.0.rc0.269.g1a574e7a288b

