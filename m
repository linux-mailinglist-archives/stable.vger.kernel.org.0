Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4C328D20
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbhCATGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240053AbhCAS7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:59:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD6C65264;
        Mon,  1 Mar 2021 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619777;
        bh=OVW+nWUjdwmhnLrWLdIKyQX9rgaJtV79DiRG7+yIcf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0fCFGjwsRjU0pqHlAjhlZhNKOoerzJjWzshcupLfh7lA5LcKKqCciWl4vBfl9iq+
         3YMDRsuvxeYLc8YSAj6UwI+dVBQP8bSp/EBVMYkcT0qFGOKS8cOmtyTLHSqYOModEE
         zW5IqDOiBaXTNdVrUrBWKFQC8SI7DXh2zLD0l1oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        RCU <rcu@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Axtens <dja@axtens.net>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Michal Hocko <mhocko@suse.com>,
        "Theodore Y . Tso" <tytso@mit.edu>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Uladzislau Rezki <urezki@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 577/663] kprobes: Fix to delay the kprobes jump optimization
Date:   Mon,  1 Mar 2021 17:13:45 +0100
Message-Id: <20210301161210.404772506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit c85c9a2c6e368dc94907e63babb18a9788e5c9b6 upstream.

Commit 36dadef23fcc ("kprobes: Init kprobes in early_initcall")
moved the kprobe setup in early_initcall(), which includes kprobe
jump optimization.
The kprobes jump optimizer involves synchronize_rcu_tasks() which
depends on the ksoftirqd and rcu_spawn_tasks_*(). However, since
those are setup in core_initcall(), kprobes jump optimizer can not
run at the early_initcall().

To avoid this issue, make the kprobe optimization disabled in the
early_initcall() and enables it in subsys_initcall().

Note that non-optimized kprobes is still available after
early_initcall(). Only jump optimization is delayed.

Link: https://lkml.kernel.org/r/161365856280.719838.12423085451287256713.stgit@devnote2

Fixes: 36dadef23fcc ("kprobes: Init kprobes in early_initcall")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: RCU <rcu@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: stable@vger.kernel.org
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Uladzislau Rezki <urezki@gmail.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -871,7 +871,6 @@ out:
 	cpus_read_unlock();
 }
 
-#ifdef CONFIG_SYSCTL
 static void optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -897,6 +896,7 @@ out:
 	mutex_unlock(&kprobe_mutex);
 }
 
+#ifdef CONFIG_SYSCTL
 static void unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -2627,18 +2627,14 @@ static int __init init_kprobes(void)
 		}
 	}
 
-#if defined(CONFIG_OPTPROBES)
-#if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
-	/* Init kprobe_optinsn_slots */
-	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
-#endif
-	/* By default, kprobes can be optimized */
-	kprobes_allow_optimization = true;
-#endif
-
 	/* By default, kprobes are armed */
 	kprobes_all_disarmed = false;
 
+#if defined(CONFIG_OPTPROBES) && defined(__ARCH_WANT_KPROBES_INSN_SLOT)
+	/* Init kprobe_optinsn_slots for allocation */
+	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
+#endif
+
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
@@ -2653,6 +2649,21 @@ static int __init init_kprobes(void)
 }
 early_initcall(init_kprobes);
 
+#if defined(CONFIG_OPTPROBES)
+static int __init init_optprobes(void)
+{
+	/*
+	 * Enable kprobe optimization - this kicks the optimizer which
+	 * depends on synchronize_rcu_tasks() and ksoftirqd, that is
+	 * not spawned in early initcall. So delay the optimization.
+	 */
+	optimize_all_kprobes();
+
+	return 0;
+}
+subsys_initcall(init_optprobes);
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static void report_probe(struct seq_file *pi, struct kprobe *p,
 		const char *sym, int offset, char *modname, struct kprobe *pp)


