Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BBEACE2F
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfIHMyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732762AbfIHMvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:46 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 958FE21924;
        Sun,  8 Sep 2019 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947105;
        bh=XCavZeCklK+Xxli7POWTyP/F3WBUq5pRLhQ3x40m2Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEZmN4+CDKYSfOgPZ2l3JqQO1wlqg72+j6qahnBAtrOueFU8oDuBGeb8IvsiUF2+m
         zMYVPkD26pXQ0vTd80q+YUOw17GY60vBP1gvGt0L+9mFRDhVYg4TQhpkRD2uvd2zRL
         TUyNT2nHl+sW019X84wFxcx/XcK/luIeSYFszYlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 64/94] kprobes: Fix potential deadlock in kprobe_optimizer()
Date:   Sun,  8 Sep 2019 13:42:00 +0100
Message-Id: <20190908121152.265892078@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1c6ece23729257fb46562ff9224cf5f61b818da ]

lockdep reports the following deadlock scenario:

 WARNING: possible circular locking dependency detected

 kworker/1:1/48 is trying to acquire lock:
 000000008d7a62b2 (text_mutex){+.+.}, at: kprobe_optimizer+0x163/0x290

 but task is already holding lock:
 00000000850b5e2d (module_mutex){+.+.}, at: kprobe_optimizer+0x31/0x290

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (module_mutex){+.+.}:
        __mutex_lock+0xac/0x9f0
        mutex_lock_nested+0x1b/0x20
        set_all_modules_text_rw+0x22/0x90
        ftrace_arch_code_modify_prepare+0x1c/0x20
        ftrace_run_update_code+0xe/0x30
        ftrace_startup_enable+0x2e/0x50
        ftrace_startup+0xa7/0x100
        register_ftrace_function+0x27/0x70
        arm_kprobe+0xb3/0x130
        enable_kprobe+0x83/0xa0
        enable_trace_kprobe.part.0+0x2e/0x80
        kprobe_register+0x6f/0xc0
        perf_trace_event_init+0x16b/0x270
        perf_kprobe_init+0xa7/0xe0
        perf_kprobe_event_init+0x3e/0x70
        perf_try_init_event+0x4a/0x140
        perf_event_alloc+0x93a/0xde0
        __do_sys_perf_event_open+0x19f/0xf30
        __x64_sys_perf_event_open+0x20/0x30
        do_syscall_64+0x65/0x1d0
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

 -> #0 (text_mutex){+.+.}:
        __lock_acquire+0xfcb/0x1b60
        lock_acquire+0xca/0x1d0
        __mutex_lock+0xac/0x9f0
        mutex_lock_nested+0x1b/0x20
        kprobe_optimizer+0x163/0x290
        process_one_work+0x22b/0x560
        worker_thread+0x50/0x3c0
        kthread+0x112/0x150
        ret_from_fork+0x3a/0x50

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(module_mutex);
                                lock(text_mutex);
                                lock(module_mutex);
   lock(text_mutex);

  *** DEADLOCK ***

As a reproducer I've been using bcc's funccount.py
(https://github.com/iovisor/bcc/blob/master/tools/funccount.py),
for example:

 # ./funccount.py '*interrupt*'

That immediately triggers the lockdep splat.

Fix by acquiring text_mutex before module_mutex in kprobe_optimizer().

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: d5b844a2cf50 ("ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()")
Link: http://lkml.kernel.org/r/20190812184302.GA7010@xps-13
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 445337c107e0f..2504c269e6583 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -470,6 +470,7 @@ static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
  */
 static void do_optimize_kprobes(void)
 {
+	lockdep_assert_held(&text_mutex);
 	/*
 	 * The optimization/unoptimization refers online_cpus via
 	 * stop_machine() and cpu-hotplug modifies online_cpus.
@@ -487,9 +488,7 @@ static void do_optimize_kprobes(void)
 	    list_empty(&optimizing_list))
 		return;
 
-	mutex_lock(&text_mutex);
 	arch_optimize_kprobes(&optimizing_list);
-	mutex_unlock(&text_mutex);
 }
 
 /*
@@ -500,6 +499,7 @@ static void do_unoptimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
+	lockdep_assert_held(&text_mutex);
 	/* See comment in do_optimize_kprobes() */
 	lockdep_assert_cpus_held();
 
@@ -507,7 +507,6 @@ static void do_unoptimize_kprobes(void)
 	if (list_empty(&unoptimizing_list))
 		return;
 
-	mutex_lock(&text_mutex);
 	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 	/* Loop free_list for disarming */
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
@@ -524,7 +523,6 @@ static void do_unoptimize_kprobes(void)
 		} else
 			list_del_init(&op->list);
 	}
-	mutex_unlock(&text_mutex);
 }
 
 /* Reclaim all kprobes on the free_list */
@@ -556,6 +554,7 @@ static void kprobe_optimizer(struct work_struct *work)
 {
 	mutex_lock(&kprobe_mutex);
 	cpus_read_lock();
+	mutex_lock(&text_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 
@@ -583,6 +582,7 @@ static void kprobe_optimizer(struct work_struct *work)
 	do_free_cleaned_kprobes();
 
 	mutex_unlock(&module_mutex);
+	mutex_unlock(&text_mutex);
 	cpus_read_unlock();
 	mutex_unlock(&kprobe_mutex);
 
-- 
2.20.1



