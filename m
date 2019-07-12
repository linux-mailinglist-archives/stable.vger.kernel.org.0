Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72C6663A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfGLFaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:02 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43644 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:02 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so3993322pgv.10
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJU6AKZYmaWbov8SdJbQnRPRbYy33d5KJviuZzujVLk=;
        b=oTIW5muK69AdMouGYZaAMlK4ixcRjKc300NdxL++0acaOTqPjxquvKY7YsdTL9AC+B
         V+VLf6JLk3mcGcNgKatuXiHW1TfF61Jeip6tBgU65a2JsHVwYt/e4ZgPGv5gi3a+7OFJ
         YKCMOcIup9XvQ0B2uAfcsJdpbjpW04F/TZvjR1b07hZhDqKBM39RA0uN6gHTUbWPMoPC
         NMBH/lfsVBTID+k/O2ADpzawZ0f3ltnbd7zr3xHWuul40WbLvsF0k6OZeYtB5T/aT33W
         JJSbow1Whs0d1fYqZOdY4pN7d9dtWQrJ9C7ycz8djHRTu9tQHSPxhuV0Tt+yu3N989WY
         QslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJU6AKZYmaWbov8SdJbQnRPRbYy33d5KJviuZzujVLk=;
        b=oCXa7EbLO6h/39eEV4yOlHcW4dTXzr0lnATK9O4jfs4RUZQStaPEEtZK2FpLf5yhjF
         UdsSWipmsVnm0Dld0VTn480fWQ6ENOjGuFDppDY7oNjguZNbpovs5jBBIVmiBV9jR7n/
         sBvqUWQGgc+RRrmabHFq4VlluHiQEcEn1TOxxJD1lLW6A3Ln2KPOee3Aa9OHMB9yYWCv
         3XpzLT+Vh12hrdP7a0ZdFFjIKI6e/2CeDZbxbLThRsydyHdJFHEAl19JXou3PW0aTTqz
         vC74rL7z855vvOr3kTDwLrZTwhYn9XR5WU+XBGL8C7qyJEZ8auAOlRUjl9YPtTtUl8KF
         SnjQ==
X-Gm-Message-State: APjAAAW7tELQaavhI1+Gu14qS9AtIDCmeQk+T7Z8sSxhQj1SDFEjDulb
        FKPch7jhdYAMuKEIAsNz65Tj/DJabJk=
X-Google-Smtp-Source: APXvYqyd2eTBndw3HNQi/J7oWKkj4d0i8FiZzOONfRIsUgFf2Xkw2bRQXcNdXIPpw+H1vRn8QgjLgA==
X-Received: by 2002:a17:90a:cb8e:: with SMTP id a14mr9246370pju.124.1562909401554;
        Thu, 11 Jul 2019 22:30:01 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id q1sm7566238pfg.84.2019.07.11.22.30.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:00 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 23/43] arm64: Move post_ttbr_update_workaround to C code
Date:   Fri, 12 Jul 2019 10:58:11 +0530
Message-Id: <158a87f9ed59c4e39c1e52dc771d0803ea7c7b2d.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 95e3de3590e3f2358bb13f013911bc1bfa5d3f53 upstream.

We will soon need to invoke a CPU-specific function pointer after changing
page tables, so move post_ttbr_update_workaround out into C code to make
this possible.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Removed cpufeature.h, included alternative.h, dropped entry.S
	changes and adapted to drop alternative_if_not ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 18 ------------------
 arch/arm64/mm/context.c            | 10 ++++++++++
 arch/arm64/mm/proc.S               |  3 +--
 3 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 8ab46508e836..2b30363a3a89 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -23,7 +23,6 @@
 #ifndef __ASM_ASSEMBLER_H
 #define __ASM_ASSEMBLER_H
 
-#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
@@ -283,21 +282,4 @@ lr	.req	x30		// link register
 .Ldone\@:
 	.endm
 
-/*
- * Errata workaround post TTBR0_EL1 update.
- */
-	.macro	post_ttbr0_update_workaround
-#ifdef CONFIG_CAVIUM_ERRATUM_27456
-alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
-       ret
-       nop
-       nop
-       nop
-alternative_else
-       ic      iallu
-       dsb     nsh
-       isb
-#endif
-	.endm
-
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index e87f53ff5f58..492d2968fa8f 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 
+#include <asm/alternative.h>
 #include <asm/cpufeature.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -185,6 +186,15 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	cpu_switch_mm(mm->pgd, mm);
 }
 
+/* Errata workaround post TTBRx_EL1 update. */
+asmlinkage void post_ttbr_update_workaround(void)
+{
+	asm(ALTERNATIVE("nop; nop; nop",
+			"ic iallu; dsb nsh; isb",
+			ARM64_WORKAROUND_CAVIUM_27456,
+			CONFIG_CAVIUM_ERRATUM_27456));
+}
+
 static int asids_init(void)
 {
 	int fld = cpuid_feature_extract_field(read_cpuid(ID_AA64MMFR0_EL1), 4);
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 4eb1084e203a..a70b712ca94a 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -139,8 +139,7 @@ ENTRY(cpu_do_switch_mm)
 	bfi	x0, x1, #48, #16		// set the ASID
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
-	post_ttbr0_update_workaround
-	ret
+	b	post_ttbr_update_workaround	// Back to C code...
 ENDPROC(cpu_do_switch_mm)
 
 	.section ".text.init", #alloc, #execinstr
-- 
2.21.0.rc0.269.g1a574e7a288b

