Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00EF67A321
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjAXTfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjAXTf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9193E1;
        Tue, 24 Jan 2023 11:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10C8461342;
        Tue, 24 Jan 2023 19:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E30C4339B;
        Tue, 24 Jan 2023 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588924;
        bh=JC2+EMbos5TBR494RoDJ5sZ3d1gFp/k7/wYCmMfhrS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyDF0M7VJk1oRWOfjicjagvFY7kExFslKvZldSGNATHhwUM8hb1DkczpSPS0Ylrb/
         6K1ph6/NGgxfeKpSOzZS5JCUA+icIS46/I/ba3JIm4MWsyIXqx9MPySu/4M1/etzcw
         PDKFqVZyA55IQ+VQl+LYpUsfJilU3jHXzsAsO6tnnOdyW8tLgE7cCstCHIn52/9lbk
         +pvqJeT66G5MvY97jVapnjqsBmgRUqFsWKPHYJnwfRfQjOwJyfAE3whbEyJLt1pYAD
         WiEkLgCI7P6cQGlOapGP6nvOmRAM4gpCLMFM/rVSbu1+DGMS0xKl0l4WTBjLYx/Oky
         Vsomx3qhnRD7g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        tangmeng <tangmeng@uniontech.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Petr Mladek <pmladek@suse.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 16/20] panic: Consolidate open-coded panic_on_warn checks
Date:   Tue, 24 Jan 2023 11:30:00 -0800
Message-Id: <20230124193004.206841-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 79cc1ba7badf9e7a12af99695a557e9ce27ee967 upstream.

Several run-time checkers (KASAN, UBSAN, KFENCE, KCSAN, sched) roll
their own warnings, and each check "panic_on_warn". Consolidate this
into a single function so that future instrumentation can be added in
a single location.

Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Gow <davidgow@google.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20221117234328.594699-4-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/kernel.h | 1 +
 kernel/kcsan/report.c  | 4 ++--
 kernel/panic.c         | 9 +++++++--
 kernel/sched/core.c    | 3 +--
 lib/ubsan.c            | 3 +--
 mm/kasan/report.c      | 4 ++--
 6 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 084d97070ed99..394f10fc29aad 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -320,6 +320,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
diff --git a/kernel/kcsan/report.c b/kernel/kcsan/report.c
index d3bf87e6007ca..069830f5a5d24 100644
--- a/kernel/kcsan/report.c
+++ b/kernel/kcsan/report.c
@@ -630,8 +630,8 @@ void kcsan_report(const volatile void *ptr, size_t size, int access_type,
 		bool reported = value_change != KCSAN_VALUE_CHANGE_FALSE &&
 				print_report(value_change, type, &ai, other_info);
 
-		if (reported && panic_on_warn)
-			panic("panic_on_warn set ...\n");
+		if (reported)
+			check_panic_on_warn("KCSAN");
 
 		release_report(&flags, other_info);
 	}
diff --git a/kernel/panic.c b/kernel/panic.c
index 09f0802212c38..0da47888f72e8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -192,6 +192,12 @@ static void panic_print_sys_info(void)
 		ftrace_dump(DUMP_ALL);
 }
 
+void check_panic_on_warn(const char *origin)
+{
+	if (panic_on_warn)
+		panic("%s: panic_on_warn set ...\n", origin);
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -630,8 +636,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (regs)
 		show_regs(regs);
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("kernel");
 
 	if (!regs)
 		dump_stack();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a875bc59804eb..1303a2607f1f8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4280,8 +4280,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		pr_err("Preemption disabled at:");
 		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
diff --git a/lib/ubsan.c b/lib/ubsan.c
index d81d107f64f41..ee14c46cac897 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -151,8 +151,7 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("UBSAN");
 }
 
 static void handle_overflow(struct overflow_data *data, void *lhs,
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 91714acea0d61..2f5e96ac4d008 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -95,8 +95,8 @@ static void end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
-		panic("panic_on_warn set ...\n");
+	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+		check_panic_on_warn("KASAN");
 	kasan_enable_current();
 }
 
-- 
2.39.1

