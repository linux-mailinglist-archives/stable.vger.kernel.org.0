Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC15688BCB
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjBCA2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjBCA2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671052CC76;
        Thu,  2 Feb 2023 16:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08FF4B828DC;
        Fri,  3 Feb 2023 00:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B3DC433EF;
        Fri,  3 Feb 2023 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384089;
        bh=uR+rWazLwbtNzV99k2M2cRim465eq897QVUvq4Ip/WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrN8c1zq+J+itxtunkdMTASPZg3ADtKBZAoYkr5TDGJnnVIXeFU58Tj7z0Tk0OQWl
         cdPhkafoM3qHSPg/G4FqZwCFBOVREy+4vmcsZBuaE7BKER/x6bAHvCxLzNheJvIHO+
         87K1PrwD/bskFQRy6EzWeoyigHHdWmmLgrN5lURl0B+IOWwnHXigvRbMZT+rPWuADu
         AhyB7bUO4yTzLYhqHYPz8nFcIF+rxSRm+zaiRvGI2WqZoanyIgBEZ0bKoY9On1MAkS
         sXv+I+bXzQlKd6L3stJdGVJTfb086t+szFLDUNsMemTi+8/47v5/j/+HMBOUyB8Erk
         5sLGxv6kzY0oQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
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
Subject: [PATCH 4.19 v2 11/15] panic: Consolidate open-coded panic_on_warn checks
Date:   Thu,  2 Feb 2023 16:27:13 -0800
Message-Id: <20230203002717.49198-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203002717.49198-1-ebiggers@kernel.org>
References: <20230203002717.49198-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 kernel/panic.c         | 9 +++++++--
 kernel/sched/core.c    | 3 +--
 mm/kasan/report.c      | 3 +--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 50733abbe548e..a28ec4c2f3f5a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -327,6 +327,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
diff --git a/kernel/panic.c b/kernel/panic.c
index a078d413042f2..08b8adc55b2bf 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -125,6 +125,12 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 }
 EXPORT_SYMBOL(nmi_panic);
 
+void check_panic_on_warn(const char *origin)
+{
+	if (panic_on_warn)
+		panic("%s: panic_on_warn set ...\n", origin);
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -540,8 +546,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (args)
 		vprintk(args->fmt, args->args);
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("kernel");
 
 	print_modules();
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a034642497718..46227cc48124d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3316,8 +3316,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		print_ip_sym(preempt_disable_ip);
 		pr_cont("\n");
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 5c169aa688fde..3ae996824a040 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -176,8 +176,7 @@ static void kasan_end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KASAN");
 	kasan_enable_current();
 }
 
-- 
2.39.1

