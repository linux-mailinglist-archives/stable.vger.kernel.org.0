Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC79449B549
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 14:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391950AbiAYNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 08:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351546AbiAYNm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 08:42:26 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73799C061774
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:42:20 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u14so25852911lfo.11
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ojgoY+KUyxiibIuMzhCoB4rg4Imbet3s08pVEvqDBx4=;
        b=MCM1/8M2NziPVqX0m7+Em5anPyiici4oInyCSDGq1B9pO+aAEzN2h2Dzvpo3t+VI7I
         oRGU/8VsEo8r4qMnyUXsm2xz6Y2Lmg20iikDL2yKiIsixm61mQ8I2Xm6vSNplDt3zO5A
         OjwKla8MRgABnfFfJOI+jWnbhVvwwcLh6XzpHTR6pTxT2NB7sLy4tKIP8yRiyp4cJDm+
         QCIRw5xL7NzZf/4F8KPjDcbsvHKR6R8uVhgr1yYXtmk45R3Yb9UsyssQ/ZTtk/QvtDh2
         J3SIh1JIARoz9pnbf4EPxnvjGffo8SlKScOmzj64s+OQkfR/Yz0D7PydYbtJoPm+fINz
         B0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ojgoY+KUyxiibIuMzhCoB4rg4Imbet3s08pVEvqDBx4=;
        b=H7bgTeJSOEU/katO/5T8ydD9/ijIFOqq7OUas6Mre4+aP6ylK6y9CReOKjEceuKeij
         jO55ArBZ+UgU1NrD7L/xYgj9bfOIpLRTqV/sfxgx/OB07lbxVFuPxzWqz6TL0ZXT2ZQI
         3HKTS1mB1HSPj5RN8F6jz1921h2XtyF+0sJv3nwyWLRMpAFWBJd0DdwqTBWpu7s7VZ0l
         +oTCgY/0Yo+KYdVGofJ8Ze+dkYO0jsDrc4ZjqJ+z/UlsXnvYgDgSNdBKk1eeoyt/p0pj
         y2Ipasv0vx019s+tgOtZDG77iPR9gRs70BdmsatdLipB+xPa+JQO65+1nrJDtFdM4AYM
         HPZQ==
X-Gm-Message-State: AOAM530oqcv6ZzjY5mM0nkbGEzdyYHwD6tHbwvMAfl96Ig1nZXgDJMNC
        cLaXPcVREzJR8HkvAw31VSDx1VSyV1rlcQ==
X-Google-Smtp-Source: ABdhPJwzWP0Vkniwk8qfbEF+/pX9FC2wXrfjLy0kl++aFH5+MySBTQVWDICmbqT5iD62u8EWPoGZfQ==
X-Received: by 2002:a05:6512:1506:: with SMTP id bq6mr17300338lfb.444.1643118138782;
        Tue, 25 Jan 2022 05:42:18 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id p16sm895859ljn.55.2022.01.25.05.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 05:42:18 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Stefan Agner <stefan@agner.ch>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [4.9 PATCH] ARM: 8800/1: use choice for kernel unwinders
Date:   Tue, 25 Jan 2022 14:41:48 +0100
Message-Id: <20220125134148.3390940-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

commit f9b58e8c7d031b0daa5c9a9ee27f5a4028ba53ac upstream.

While in theory multiple unwinders could be compiled in, it does
not make sense in practise. Use a choice to make the unwinder
selection mutually exclusive and mandatory.

Already before this commit it has not been possible to deselect
FRAME_POINTER. Remove the obsolete comment.

Furthermore, to produce a meaningful backtrace with FRAME_POINTER
enabled the kernel needs a specific function prologue:
    mov    ip, sp
    stmfd    sp!, {fp, ip, lr, pc}
    sub    fp, ip, #4

To get to the required prologue gcc uses apcs and no-sched-prolog.
This compiler options are not available on clang, and clang is not
able to generate the required prologue. Make the FRAME_POINTER
config symbol depending on !clang.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/arm/Kconfig.debug | 44 +++++++++++++++++++++++++++---------------
 lib/Kconfig.debug      |  6 +++---
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8349a171a8f3..e1d21c6449ea 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -15,30 +15,42 @@ config ARM_PTDUMP
 	  kernel.
 	  If in doubt, say "N"
 
-# RMK wants arm kernels compiled with frame pointers or stack unwinding.
-# If you know what you are doing and are willing to live without stack
-# traces, you can get a slightly smaller kernel by setting this option to
-# n, but then RMK will have to kill you ;).
-config FRAME_POINTER
-	bool
-	depends on !THUMB2_KERNEL
-	default y if !ARM_UNWIND || FUNCTION_GRAPH_TRACER
+choice
+	prompt "Choose kernel unwinder"
+	default UNWINDER_ARM if AEABI && !FUNCTION_GRAPH_TRACER
+	default UNWINDER_FRAME_POINTER if !AEABI || FUNCTION_GRAPH_TRACER
+	help
+	  This determines which method will be used for unwinding kernel stack
+	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
+	  livepatch, lockdep, and more.
+
+config UNWINDER_FRAME_POINTER
+	bool "Frame pointer unwinder"
+	depends on !THUMB2_KERNEL && !CC_IS_CLANG
+	select ARCH_WANT_FRAME_POINTERS
+	select FRAME_POINTER
 	help
-	  If you say N here, the resulting kernel will be slightly smaller and
-	  faster. However, if neither FRAME_POINTER nor ARM_UNWIND are enabled,
-	  when a problem occurs with the kernel, the information that is
-	  reported is severely limited.
+	  This option enables the frame pointer unwinder for unwinding
+	  kernel stack traces.
 
-config ARM_UNWIND
-	bool "Enable stack unwinding support (EXPERIMENTAL)"
+config UNWINDER_ARM
+	bool "ARM EABI stack unwinder"
 	depends on AEABI
-	default y
+	select ARM_UNWIND
 	help
 	  This option enables stack unwinding support in the kernel
 	  using the information automatically generated by the
 	  compiler. The resulting kernel image is slightly bigger but
 	  the performance is not affected. Currently, this feature
-	  only works with EABI compilers. If unsure say Y.
+	  only works with EABI compilers.
+
+endchoice
+
+config ARM_UNWIND
+	bool
+
+config FRAME_POINTER
+	bool
 
 config OLD_MCOUNT
 	bool
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bc5ff3a53d4a..e7addfcd302f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1091,7 +1091,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC && !SCORE
+	select FRAME_POINTER if !MIPS && !PPC && !ARM && !S390 && !MICROBLAZE && !ARC && !SCORE
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1670,7 +1670,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC && !SCORE
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !SCORE
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
@@ -1679,7 +1679,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
2.34.1

