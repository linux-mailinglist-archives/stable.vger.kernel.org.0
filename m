Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAEC7D757
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbfHAIVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39225 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHAIVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so29615011pfn.6
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bD+Nn9yJj6UL1BxkfmyNVyFE/Bkgh8dLgfivcvvulBg=;
        b=ANFP8g1p8JFQVKTJYFx6Vw0TW4voibG5DCIASdhkve+IYqSbpJ4pf1CPI/gRJ9yt9S
         Exd2NJ/005eJrvN/yD3fqP0TfCskg40yqFmckXx7hep+VMMYb4kaUeqZgNxjwXXFeGLC
         O3Ushag+gGUFO2uvKX4/gXf4FklbrwOHxejkTxQhoge9Yh0YBa9qCcs7TDt/NyGFFi4o
         gTbulqNmF52VLHNlryHUkhlrggT41FV0BmdZM6Tsypos2QcAO39GpCKgBwmqbDroqaal
         K618LSh+GSZQjXSoXrvv+ILwOFzCzenhlRDr2gjgi3/ik+gpk9I1T9beafOOAiHqpqDx
         BioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bD+Nn9yJj6UL1BxkfmyNVyFE/Bkgh8dLgfivcvvulBg=;
        b=WCvFRpGo0TSF2za8ocOPPaBKwwIedsgZcEg2JX/ysQNXtquhoXQNi7r2mlsTW43dKY
         Y9AVvKIWL3HfuKfFjGyxKnHj6lnl92uhmflTs/m+WXVsVQ24Xao1Lsm0rIzE/PYSMgHi
         ZSb2JJ04L7+nd4BIbbZicixZgLinmjwxZgLPTpBv9fhyUyGgBYA72RqhJS2KcLoYilA+
         ZQ6WF+M7alEqj39yOMkjCxeOtBMDFx0Oh30b2o+rusgpSQVnkHHy36Bkn/QtQiGwIehf
         K8YrNEDxovUWLL8DNAournZicMXtWaywExPRFCNodpG4xQsKmQZe4FNtEc1GNspmyb9L
         ExlA==
X-Gm-Message-State: APjAAAUVaLtCi0Y1LSYgBXeCjdL4jJQd33iPKe5N8CHTy4gUicJNZErS
        GnGN4eWsajRYXJekOcmjZGZ4eyvEDFs=
X-Google-Smtp-Source: APXvYqypoB0dNvIfWnZO4fN9gYvd+RKBGHdAxLgr2a8Ae+fHpzOWFZr7WBaSVZCjI7TMwOfX4wnj9g==
X-Received: by 2002:a63:e20a:: with SMTP id q10mr115552737pgh.24.1564647683731;
        Thu, 01 Aug 2019 01:21:23 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id p13sm6487461pjb.30.2019.08.01.01.21.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:23 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 42/47] ARM: add PROC_VTABLE and PROC_TABLE macros
Date:   Thu,  1 Aug 2019 13:46:26 +0530
Message-Id: <888892dc104d817f590058687946b7f6078d328c.1564646727.git.viresh.kumar@linaro.org>
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

Commit e209950fdd065d2cc46e6338e47e52841b830cba upstream.

Allow the way we access members of the processor vtable to be changed
at compile time.  We will need to move to per-CPU vtables to fix the
Spectre variant 2 issues on big.Little systems.

However, we have a couple of calls that do not need the vtable
treatment, and indeed cause a kernel warning due to the (later) use
of smp_processor_id(), so also introduce the PROC_TABLE macro for
these which always use CPU 0's function pointers.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/proc-fns.h | 39 ++++++++++++++++++++++-----------
 arch/arm/kernel/setup.c         |  4 +---
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 19939e88efca..a1a71b068edc 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -23,7 +23,7 @@ struct mm_struct;
 /*
  * Don't change this structure - ASM code relies on it.
  */
-extern struct processor {
+struct processor {
 	/* MISC
 	 * get data abort address/flags
 	 */
@@ -79,9 +79,13 @@ extern struct processor {
 	unsigned int suspend_size;
 	void (*do_suspend)(void *);
 	void (*do_resume)(void *);
-} processor;
+};
 
 #ifndef MULTI_CPU
+static inline void init_proc_vtable(const struct processor *p)
+{
+}
+
 extern void cpu_proc_init(void);
 extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
@@ -98,18 +102,27 @@ extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
 extern void cpu_do_suspend(void *);
 extern void cpu_do_resume(void *);
 #else
-#define cpu_proc_init			processor._proc_init
-#define cpu_check_bugs			processor.check_bugs
-#define cpu_proc_fin			processor._proc_fin
-#define cpu_reset			processor.reset
-#define cpu_do_idle			processor._do_idle
-#define cpu_dcache_clean_area		processor.dcache_clean_area
-#define cpu_set_pte_ext			processor.set_pte_ext
-#define cpu_do_switch_mm		processor.switch_mm
 
-/* These three are private to arch/arm/kernel/suspend.c */
-#define cpu_do_suspend			processor.do_suspend
-#define cpu_do_resume			processor.do_resume
+extern struct processor processor;
+#define PROC_VTABLE(f)			processor.f
+#define PROC_TABLE(f)			processor.f
+static inline void init_proc_vtable(const struct processor *p)
+{
+	processor = *p;
+}
+
+#define cpu_proc_init			PROC_VTABLE(_proc_init)
+#define cpu_check_bugs			PROC_VTABLE(check_bugs)
+#define cpu_proc_fin			PROC_VTABLE(_proc_fin)
+#define cpu_reset			PROC_VTABLE(reset)
+#define cpu_do_idle			PROC_VTABLE(_do_idle)
+#define cpu_dcache_clean_area		PROC_TABLE(dcache_clean_area)
+#define cpu_set_pte_ext			PROC_TABLE(set_pte_ext)
+#define cpu_do_switch_mm		PROC_VTABLE(switch_mm)
+
+/* These two are private to arch/arm/kernel/suspend.c */
+#define cpu_do_suspend			PROC_VTABLE(do_suspend)
+#define cpu_do_resume			PROC_VTABLE(do_resume)
 #endif
 
 extern void cpu_resume(void);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 5aa9c08de410..13bda9574e18 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -625,9 +625,7 @@ static void __init setup_processor(void)
 	cpu_name = list->cpu_name;
 	__cpu_architecture = __get_cpu_architecture();
 
-#ifdef MULTI_CPU
-	processor = *list->proc;
-#endif
+	init_proc_vtable(list->proc);
 #ifdef MULTI_TLB
 	cpu_tlb = *list->tlb;
 #endif
-- 
2.21.0.rc0.269.g1a574e7a288b

