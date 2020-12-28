Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33E2E3F2E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505615AbgL1Og7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504852AbgL1OdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 729C020731;
        Mon, 28 Dec 2020 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165939;
        bh=QPsKZHQza4henJNpGHixnqaxrxt6Z2FKmPHmCG5Y2+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hu43qM1RVRmBllGn3NqQlRkJy1UqJFTtcpMPFLg+zr/eCvBKzuyT4mxRNF1dSM+lO
         Swwp/FPhqR/fd/9WiPYmXXgtlSQjVwaoY8DeaVSEXR/OR1mtPo0p6T/Tyovp0Ne0sW
         iOzFNrGMxNPamYbhELhKaAj6U7CzeofKGlgWGg5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 707/717] tracing: Disable ftrace selftests when any tracer is running
Date:   Mon, 28 Dec 2020 13:51:45 +0100
Message-Id: <20201228125054.861218470@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 60efe21e5976d3d4170a8190ca76a271d6419754 upstream.

Disable ftrace selftests when any tracer (kernel command line options
like ftrace=, trace_events=, kprobe_events=, and boot-time tracing)
starts running because selftest can disturb it.

Currently ftrace= and trace_events= are checked, but kprobe_events
has a different flag, and boot-time tracing didn't checked. This unifies
the disabled flag and all of those boot-time tracing features sets
the flag.

This also fixes warnings on kprobe-event selftest
(CONFIG_FTRACE_STARTUP_TEST=y and CONFIG_KPROBE_EVENTS=y) with boot-time
tracing (ftrace.event.kprobes.EVENT.probes) like below;

[   59.803496] trace_kprobe: Testing kprobe tracing:
[   59.804258] ------------[ cut here ]------------
[   59.805682] WARNING: CPU: 3 PID: 1 at kernel/trace/trace_kprobe.c:1987 kprobe_trace_self_tests_ib
[   59.806944] Modules linked in:
[   59.807335] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc7+ #172
[   59.808029] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/204
[   59.808999] RIP: 0010:kprobe_trace_self_tests_init+0x5f/0x42b
[   59.809696] Code: e8 03 00 00 48 c7 c7 30 8e 07 82 e8 6d 3c 46 ff 48 c7 c6 00 b2 1a 81 48 c7 c7 7
[   59.812439] RSP: 0018:ffffc90000013e78 EFLAGS: 00010282
[   59.813038] RAX: 00000000ffffffef RBX: 0000000000000000 RCX: 0000000000049443
[   59.813780] RDX: 0000000000049403 RSI: 0000000000049403 RDI: 000000000002deb0
[   59.814589] RBP: ffffc90000013e90 R08: 0000000000000001 R09: 0000000000000001
[   59.815349] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000ffffffef
[   59.816138] R13: ffff888004613d80 R14: ffffffff82696940 R15: ffff888004429138
[   59.816877] FS:  0000000000000000(0000) GS:ffff88807dcc0000(0000) knlGS:0000000000000000
[   59.817772] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.818395] CR2: 0000000001a8dd38 CR3: 0000000002222000 CR4: 00000000000006a0
[   59.819144] Call Trace:
[   59.819469]  ? init_kprobe_trace+0x6b/0x6b
[   59.819948]  do_one_initcall+0x5f/0x300
[   59.820392]  ? rcu_read_lock_sched_held+0x4f/0x80
[   59.820916]  kernel_init_freeable+0x22a/0x271
[   59.821416]  ? rest_init+0x241/0x241
[   59.821841]  kernel_init+0xe/0x10f
[   59.822251]  ret_from_fork+0x22/0x30
[   59.822683] irq event stamp: 16403349
[   59.823121] hardirqs last  enabled at (16403359): [<ffffffff810db81e>] console_unlock+0x48e/0x580
[   59.824074] hardirqs last disabled at (16403368): [<ffffffff810db786>] console_unlock+0x3f6/0x580
[   59.825036] softirqs last  enabled at (16403200): [<ffffffff81c0033a>] __do_softirq+0x33a/0x484
[   59.825982] softirqs last disabled at (16403087): [<ffffffff81a00f02>] asm_call_irq_on_stack+0x10
[   59.827034] ---[ end trace 200c544775cdfeb3 ]---
[   59.827635] trace_kprobe: error on probing function entry.

Link: https://lkml.kernel.org/r/160741764955.3448999.3347769358299456915.stgit@devnote2

Fixes: 4d655281eb1b ("tracing/boot Add kprobe event support")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c          |   19 +++++++++++++------
 kernel/trace/trace.h          |    5 +++++
 kernel/trace/trace_boot.c     |    2 ++
 kernel/trace/trace_events.c   |    2 +-
 kernel/trace/trace_kprobe.c   |    9 +++------
 kernel/trace/trace_selftest.c |    2 +-
 6 files changed, 25 insertions(+), 14 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -68,10 +68,21 @@ bool ring_buffer_expanded;
 static bool __read_mostly tracing_selftest_running;
 
 /*
- * If a tracer is running, we do not want to run SELFTEST.
+ * If boot-time tracing including tracers/events via kernel cmdline
+ * is running, we do not want to run SELFTEST.
  */
 bool __read_mostly tracing_selftest_disabled;
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+void __init disable_tracing_selftest(const char *reason)
+{
+	if (!tracing_selftest_disabled) {
+		tracing_selftest_disabled = true;
+		pr_info("Ftrace startup test is disabled due to %s\n", reason);
+	}
+}
+#endif
+
 /* Pipe tracepoints to printk */
 struct trace_iterator *tracepoint_print_iter;
 int tracepoint_printk;
@@ -2113,11 +2124,7 @@ int __init register_tracer(struct tracer
 	apply_trace_boot_options();
 
 	/* disable other selftests, since this will break it. */
-	tracing_selftest_disabled = true;
-#ifdef CONFIG_FTRACE_STARTUP_TEST
-	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
-	       type->name);
-#endif
+	disable_tracing_selftest("running a tracer");
 
  out_unlock:
 	return ret;
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -896,6 +896,8 @@ extern bool ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
+extern void __init disable_tracing_selftest(const char *reason);
+
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
 extern int trace_selftest_startup_function_graph(struct tracer *trace,
@@ -919,6 +921,9 @@ extern int trace_selftest_startup_branch
  */
 #define __tracer_data		__refdata
 #else
+static inline void __init disable_tracing_selftest(const char *reason)
+{
+}
 /* Tracers are seldom changed. Optimize when selftests are disabled. */
 #define __tracer_data		__read_mostly
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -344,6 +344,8 @@ static int __init trace_boot_init(void)
 	trace_boot_init_one_instance(tr, trace_node);
 	trace_boot_init_instances(trace_node);
 
+	disable_tracing_selftest("running boot-time tracing");
+
 	return 0;
 }
 /*
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3201,7 +3201,7 @@ static __init int setup_trace_event(char
 {
 	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
 	ring_buffer_expanded = true;
-	tracing_selftest_disabled = true;
+	disable_tracing_selftest("running event tracing");
 
 	return 1;
 }
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -25,11 +25,12 @@
 
 /* Kprobe early definition from command line */
 static char kprobe_boot_events_buf[COMMAND_LINE_SIZE] __initdata;
-static bool kprobe_boot_events_enabled __initdata;
 
 static int __init set_kprobe_boot_events(char *str)
 {
 	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
+	disable_tracing_selftest("running kprobe events");
+
 	return 0;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
@@ -1887,8 +1888,6 @@ static __init void setup_boot_kprobe_eve
 		ret = trace_run_command(cmd, create_or_delete_trace_kprobe);
 		if (ret)
 			pr_warn("Failed to add event(%d): %s\n", ret, cmd);
-		else
-			kprobe_boot_events_enabled = true;
 
 		cmd = p;
 	}
@@ -1973,10 +1972,8 @@ static __init int kprobe_trace_self_test
 	if (tracing_is_disabled())
 		return -ENODEV;
 
-	if (kprobe_boot_events_enabled) {
-		pr_info("Skipping kprobe tests due to kprobe_event on cmdline\n");
+	if (tracing_selftest_disabled)
 		return 0;
-	}
 
 	target = kprobe_trace_selftest_target;
 
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -787,7 +787,7 @@ trace_selftest_startup_function_graph(st
 
 	/* Have we just recovered from a hang? */
 	if (graph_hang_thresh > GRAPH_MAX_FUNC_TEST) {
-		tracing_selftest_disabled = true;
+		disable_tracing_selftest("recovering from a hang");
 		ret = -1;
 		goto out;
 	}


