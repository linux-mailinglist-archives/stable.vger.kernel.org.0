Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEF1622C7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbfGHP24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389380AbfGHP2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6F5204EC;
        Mon,  8 Jul 2019 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599734;
        bh=oqeTBDmP+jcF4KXAKud7C7kJr8HLWLVMDQ8MvwIky9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A019ZZSvywTWFkxKIjlM498utq3pub3x6aRqLqOHVSMG41RIK4XFHrMl/1HK9pkJa
         gq30YqPWPlhOpRvzMljuUuOlFsBuwk765fgLnbf5OSmRXqywST9EECLhrSzW54lF4V
         w+ya1Jp61urBSPqg6AZORjXpI5r9R8Eskg8baYLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 60/90] ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()
Date:   Mon,  8 Jul 2019 17:13:27 +0200
Message-Id: <20190708150525.457685976@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit d5b844a2cf507fc7642c9ae80a9d585db3065c28 upstream.

The commit 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module text
permissions race") causes a possible deadlock between register_kprobe()
and ftrace_run_update_code() when ftrace is using stop_machine().

The existing dependency chain (in reverse order) is:

-> #1 (text_mutex){+.+.}:
       validate_chain.isra.21+0xb32/0xd70
       __lock_acquire+0x4b8/0x928
       lock_acquire+0x102/0x230
       __mutex_lock+0x88/0x908
       mutex_lock_nested+0x32/0x40
       register_kprobe+0x254/0x658
       init_kprobes+0x11a/0x168
       do_one_initcall+0x70/0x318
       kernel_init_freeable+0x456/0x508
       kernel_init+0x22/0x150
       ret_from_fork+0x30/0x34
       kernel_thread_starter+0x0/0xc

-> #0 (cpu_hotplug_lock.rw_sem){++++}:
       check_prev_add+0x90c/0xde0
       validate_chain.isra.21+0xb32/0xd70
       __lock_acquire+0x4b8/0x928
       lock_acquire+0x102/0x230
       cpus_read_lock+0x62/0xd0
       stop_machine+0x2e/0x60
       arch_ftrace_update_code+0x2e/0x40
       ftrace_run_update_code+0x40/0xa0
       ftrace_startup+0xb2/0x168
       register_ftrace_function+0x64/0x88
       klp_patch_object+0x1a2/0x290
       klp_enable_patch+0x554/0x980
       do_one_initcall+0x70/0x318
       do_init_module+0x6e/0x250
       load_module+0x1782/0x1990
       __s390x_sys_finit_module+0xaa/0xf0
       system_call+0xd8/0x2d0

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(text_mutex);
                               lock(cpu_hotplug_lock.rw_sem);
                               lock(text_mutex);
  lock(cpu_hotplug_lock.rw_sem);

It is similar problem that has been solved by the commit 2d1e38f56622b9b
("kprobes: Cure hotplug lock ordering issues"). Many locks are involved.
To be on the safe side, text_mutex must become a low level lock taken
after cpu_hotplug_lock.rw_sem.

This can't be achieved easily with the current ftrace design.
For example, arm calls set_all_modules_text_rw() already in
ftrace_arch_code_modify_prepare(), see arch/arm/kernel/ftrace.c.
This functions is called:

  + outside stop_machine() from ftrace_run_update_code()
  + without stop_machine() from ftrace_module_enable()

Fortunately, the problematic fix is needed only on x86_64. It is
the only architecture that calls set_all_modules_text_rw()
in ftrace path and supports livepatching at the same time.

Therefore it is enough to move text_mutex handling from the generic
kernel/trace/ftrace.c into arch/x86/kernel/ftrace.c:

   ftrace_arch_code_modify_prepare()
   ftrace_arch_code_modify_post_process()

This patch basically reverts the ftrace part of the problematic
commit 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module
text permissions race"). And provides x86_64 specific-fix.

Some refactoring of the ftrace code will be needed when livepatching
is implemented for arm or nds32. These architectures call
set_all_modules_text_rw() and use stop_machine() at the same time.

Link: http://lkml.kernel.org/r/20190627081334.12793-1-pmladek@suse.com

Fixes: 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module text permissions race")
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
[
  As reviewed by Miroslav Benes <mbenes@suse.cz>, removed return value of
  ftrace_run_update_code() as it is a void function.
]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ftrace.c |    3 +++
 kernel/trace/ftrace.c    |   10 +---------
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/memory.h>
 
 #include <trace/syscall.h>
 
@@ -35,6 +36,7 @@
 
 int ftrace_arch_code_modify_prepare(void)
 {
+	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
 	return 0;
@@ -44,6 +46,7 @@ int ftrace_arch_code_modify_post_process
 {
 	set_all_modules_text_ro();
 	set_kernel_text_ro();
+	mutex_unlock(&text_mutex);
 	return 0;
 }
 
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -35,7 +35,6 @@
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
-#include <linux/memory.h>
 
 #include <trace/events/sched.h>
 
@@ -2628,12 +2627,10 @@ static void ftrace_run_update_code(int c
 {
 	int ret;
 
-	mutex_lock(&text_mutex);
-
 	ret = ftrace_arch_code_modify_prepare();
 	FTRACE_WARN_ON(ret);
 	if (ret)
-		goto out_unlock;
+		return;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2645,9 +2642,6 @@ static void ftrace_run_update_code(int c
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
-
-out_unlock:
-	mutex_unlock(&text_mutex);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
@@ -5771,7 +5765,6 @@ void ftrace_module_enable(struct module
 	struct ftrace_page *pg;
 
 	mutex_lock(&ftrace_lock);
-	mutex_lock(&text_mutex);
 
 	if (ftrace_disabled)
 		goto out_unlock;
@@ -5833,7 +5826,6 @@ void ftrace_module_enable(struct module
 		ftrace_arch_code_modify_post_process();
 
  out_unlock:
-	mutex_unlock(&text_mutex);
 	mutex_unlock(&ftrace_lock);
 
 	process_cached_mods(mod->name);


