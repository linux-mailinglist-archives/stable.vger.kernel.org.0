Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09B1A18D2
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfH2Lf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35833 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2Lf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so1458012pgv.2
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJU6AKZYmaWbov8SdJbQnRPRbYy33d5KJviuZzujVLk=;
        b=dqcvWNwwubf2tMZdjfDZVdEy20YtsPjDhDhWbmFRGhkS6M+0p8WhAHb1h9mJLlO5bB
         MXJ+Npy0rOlEgB40x1si1t5I1RjzIIXPKGU1DiemYgfre7ydctPf+tI530DGzmQuhMxf
         uEc2REBcDDWVPhog9xuQAxfG002E+4hr8p2aA2FB9ZMXRfj+XfudK5Kt0CjPeJ8xMn6S
         XpRWj8MnE5b9PKlb/pMxWLtC/UyYGG4DG/dZYcbc5awOUY0Xl8d7rqcIAnpVisM+7HOR
         ZNJG0LzsEZjPNg7MXYInnMaEIy86XNyAj/2j/JPL2Bw2YMF5CNTL17M0A178jlbp9jfj
         gJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJU6AKZYmaWbov8SdJbQnRPRbYy33d5KJviuZzujVLk=;
        b=i3omjPqCX+VyBYK4Iu5Msw7zaMbn9WELbg/mHeZMu3hawyMF87n1/hfQWrsFMHKaXN
         mwp/Gxsx3Wil6vGAfg6ay+PO8KcWDC1ge7vOYB+qHYL8ZAta9dKo5op/mE4SUsu9LZ4M
         MY/anWjIBB/obO8uUByiOuMWBt9vF3Fpj3Fzd/TEJpX/nYAYnYg7QTuS8CDPTtHNHnN5
         /9seehQYJqFGSmnjyIVe5+5gsjqEU0g3R+aZtatNLZUcVBYWIPVzK7ZRBl4/zdYkVCkp
         arnYoe/AxBfLfLX5XGLP1IBvBW4uLKYIxchdV9fgOWS6a05tUK1b13rJ5ZJkJ5gHLr7s
         zSuw==
X-Gm-Message-State: APjAAAX1taHRK+cMBkOf68Ckq+ciP48VHqY5VNtJRM9Uk7+x7vdpeYFl
        zHnmaJsB0AL0iKdILxTKxnvjInex/Ug=
X-Google-Smtp-Source: APXvYqzh0snpEB4vcsb0EEfd9ciRcX/Eo3TF5s52aPdlIA05YLa6bpzGQwyOHHKm8kCkbQY/5XpEjw==
X-Received: by 2002:a17:90a:21eb:: with SMTP id q98mr9127441pjc.23.1567078556757;
        Thu, 29 Aug 2019 04:35:56 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id v66sm5349202pfv.79.2019.08.29.04.35.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:56 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 24/44] arm64: Move post_ttbr_update_workaround to C code
Date:   Thu, 29 Aug 2019 17:04:09 +0530
Message-Id: <cd3f2322d6cb635e542ebb14da01585259ac92bb.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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

