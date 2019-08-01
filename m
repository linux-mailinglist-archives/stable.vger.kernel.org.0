Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D352C7D731
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfHAIUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33775 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfHAIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so2293598pgn.0
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Arpm02aGI6YJCtpiPBRj6TsiybDi8jaAFcwPdh06aYE=;
        b=KFNcIvSPhxIo/odZ9ybPsb9qMK2cpgoaVZ8iH84d7RPdUFNek/1EEwSu9tw1iYMp+8
         t2bFOAkHVWg0hLqefH+McTYk9uLnPdwSNnfqVlQ9PHp3BCyUizQDCgGuuVIPQG17SlNg
         ycG0TRW4fcgFqkP6bWg44knQmV3arFqIJ03dRbjiM9rBG7mD7gBwjfBoME/qB8E2Whqa
         EdDkt9c955THlC0GL2hBqmmPTGw2rKKIkXiozQzic18cUfkXQvO2b+El/HmOK2wKEiBm
         WSuElSHgMmE9x0wz3ndbhJemenycSSwxXshFkg2hjJvBRRPDrKzTYeag28MFkyj/Fbc7
         mI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Arpm02aGI6YJCtpiPBRj6TsiybDi8jaAFcwPdh06aYE=;
        b=LoJhqviGtEuWXlZhKdsQd+un58ryxzC+AiBxW7l27SXs926WZfj7XZcf3SxGlMN/Qw
         b3eRd/xVomQ4g1OrBSbCEDs1xguR2qdfcl2TN+NdqHH4dLmD+l0nIxzXm0fMNiTunM7O
         Z2xL2PcUiSGLTISWm0hdfrPlYJrRfqKQhKIP1hCTucg9acraoSkjGaCl9HktxhB8q4nI
         LN1qqn//Pm/Dm+4WcKk4BYPEjzvKn8F5JZqZM6XHF+f5O6LNuSdIkiR4pw55Zk2+srxt
         MO7qoUN8b71wc9OPoKA/xS/mDdjjqfrqV7arR2XDyWfk1r8KNDCrJrFnNIH7hBYQOzCo
         IxJg==
X-Gm-Message-State: APjAAAX0h0EsygfDh4qMFWonPM+LtpV/6wfd1wAmM31GcryxhmM1IiWX
        jgO6ApndEbQVjlIVF+VuJnZoQkWPJnY=
X-Google-Smtp-Source: APXvYqwbu12n3uYWy4e6tAr7Volxz6tobUd7+JfG5OBzuqilJ86eVfILw5p8mwxbJriX300JBmLYSQ==
X-Received: by 2002:a17:90a:3ac2:: with SMTP id b60mr7327890pjc.74.1564647614913;
        Thu, 01 Aug 2019 01:20:14 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b26sm80003500pfo.129.2019.08.01.01.20.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:14 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 15/47] ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit
Date:   Thu,  1 Aug 2019 13:45:59 +0530
Message-Id: <9a610b2709bb86b37ec86270f023f5a3e18d3a7c.1564646727.git.viresh.kumar@linaro.org>
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

Commit e388b80288aade31135aca23d32eee93dd106795 upstream.

When the branch predictor hardening is enabled, firmware must have set
the IBE bit in the auxiliary control register.  If this bit has not
been set, the Spectre workarounds will not be functional.

Add validation that this bit is set, and print a warning at alert level
if this is not the case.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/Makefile       |  2 +-
 arch/arm/mm/proc-v7-bugs.c | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S      |  4 ++--
 3 files changed, 39 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mm/proc-v7-bugs.c

diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 7f76d96ce546..35307176e46c 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -92,7 +92,7 @@ obj-$(CONFIG_CPU_MOHAWK)	+= proc-mohawk.o
 obj-$(CONFIG_CPU_FEROCEON)	+= proc-feroceon.o
 obj-$(CONFIG_CPU_V6)		+= proc-v6.o
 obj-$(CONFIG_CPU_V6K)		+= proc-v6.o
-obj-$(CONFIG_CPU_V7)		+= proc-v7.o
+obj-$(CONFIG_CPU_V7)		+= proc-v7.o proc-v7-bugs.o
 obj-$(CONFIG_CPU_V7M)		+= proc-v7m.o
 
 AFLAGS_proc-v6.o	:=-Wa,-march=armv6
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
new file mode 100644
index 000000000000..e46557db6446
--- /dev/null
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/smp.h>
+
+static __maybe_unused void cpu_v7_check_auxcr_set(bool *warned,
+						  u32 mask, const char *msg)
+{
+	u32 aux_cr;
+
+	asm("mrc p15, 0, %0, c1, c0, 1" : "=r" (aux_cr));
+
+	if ((aux_cr & mask) != mask) {
+		if (!*warned)
+			pr_err("CPU%u: %s", smp_processor_id(), msg);
+		*warned = true;
+	}
+}
+
+static DEFINE_PER_CPU(bool, spectre_warned);
+
+static void check_spectre_auxcr(bool *warned, u32 bit)
+{
+	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
+		cpu_v7_check_auxcr_set(warned, bit,
+				       "Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable\n");
+}
+
+void cpu_v7_ca8_ibe(void)
+{
+	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6));
+}
+
+void cpu_v7_ca15_ibe(void)
+{
+	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0));
+}
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c2950317c7c2..1436ad424f2a 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -511,7 +511,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca8_ibe
 
 	@ Cortex-A9 - needs more registers preserved across suspend/resume
 	@ and bpiall switch_mm for hardening
@@ -544,7 +544,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca15_suspend_size,	cpu_v7_suspend_size
 	globl_equ	cpu_ca15_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca15_do_resume,	cpu_v7_do_resume
-	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca15_ibe
 #ifdef CONFIG_CPU_PJ4B
 	define_processor_functions pj4b, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
-- 
2.21.0.rc0.269.g1a574e7a288b

