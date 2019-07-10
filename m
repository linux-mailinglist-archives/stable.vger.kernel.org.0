Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7214662246
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfGHPYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388305AbfGHPYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCBB216C4;
        Mon,  8 Jul 2019 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599449;
        bh=ffkKMTjjL/zXWruMx2YSoBusLaoF6V5nNpsEbZQw9HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFqwCLUWr5XRAqRm8Kytw+fCUXttjyCyoCsE7Qj2h7XMHgZdgjxVEJR1ku38HjB9r
         bvCYRQIWVENdFFGEXBmnmLUfj363QaEidZUFBpOvCtwW3dcowpHsO5kl9WpMSrb5Go
         pdtpOdUo6SE/NyxxJSJWymmDVU9pzXMGwHSH3MCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Erdfelt <johannes@erdfelt.com>,
        Jessica Yu <jeyu@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/56] module: Fix livepatch/ftrace module text permissions race
Date:   Mon,  8 Jul 2019 17:13:11 +0200
Message-Id: <20190708150520.398798901@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9f255b632bf12c4dd7fc31caee89aa991ef75176 ]

It's possible for livepatch and ftrace to be toggling a module's text
permissions at the same time, resulting in the following panic:

  BUG: unable to handle page fault for address: ffffffffc005b1d9
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  PGD 3ea0c067 P4D 3ea0c067 PUD 3ea0e067 PMD 3cc13067 PTE 3b8a1061
  Oops: 0003 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 453 Comm: insmod Tainted: G           O  K   5.2.0-rc1-a188339ca5 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
  RIP: 0010:apply_relocate_add+0xbe/0x14c
  Code: fa 0b 74 21 48 83 fa 18 74 38 48 83 fa 0a 75 40 eb 08 48 83 38 00 74 33 eb 53 83 38 00 75 4e 89 08 89 c8 eb 0a 83 38 00 75 43 <89> 08 48 63 c1 48 39 c8 74 2e eb 48 83 38 00 75 32 48 29 c1 89 08
  RSP: 0018:ffffb223c00dbb10 EFLAGS: 00010246
  RAX: ffffffffc005b1d9 RBX: 0000000000000000 RCX: ffffffff8b200060
  RDX: 000000000000000b RSI: 0000004b0000000b RDI: ffff96bdfcd33000
  RBP: ffffb223c00dbb38 R08: ffffffffc005d040 R09: ffffffffc005c1f0
  R10: ffff96bdfcd33c40 R11: ffff96bdfcd33b80 R12: 0000000000000018
  R13: ffffffffc005c1f0 R14: ffffffffc005e708 R15: ffffffff8b2fbc74
  FS:  00007f5f447beba8(0000) GS:ffff96bdff900000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffffffc005b1d9 CR3: 000000003cedc002 CR4: 0000000000360ea0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   klp_init_object_loaded+0x10f/0x219
   ? preempt_latency_start+0x21/0x57
   klp_enable_patch+0x662/0x809
   ? virt_to_head_page+0x3a/0x3c
   ? kfree+0x8c/0x126
   patch_init+0x2ed/0x1000 [livepatch_test02]
   ? 0xffffffffc0060000
   do_one_initcall+0x9f/0x1c5
   ? kmem_cache_alloc_trace+0xc4/0xd4
   ? do_init_module+0x27/0x210
   do_init_module+0x5f/0x210
   load_module+0x1c41/0x2290
   ? fsnotify_path+0x3b/0x42
   ? strstarts+0x2b/0x2b
   ? kernel_read+0x58/0x65
   __do_sys_finit_module+0x9f/0xc3
   ? __do_sys_finit_module+0x9f/0xc3
   __x64_sys_finit_module+0x1a/0x1c
   do_syscall_64+0x52/0x61
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The above panic occurs when loading two modules at the same time with
ftrace enabled, where at least one of the modules is a livepatch module:

CPU0					CPU1
klp_enable_patch()
  klp_init_object_loaded()
    module_disable_ro()
    					ftrace_module_enable()
					  ftrace_arch_code_modify_post_process()
				    	    set_all_modules_text_ro()
      klp_write_object_relocations()
        apply_relocate_add()
	  *patches read-only code* - BOOM

A similar race exists when toggling ftrace while loading a livepatch
module.

Fix it by ensuring that the livepatch and ftrace code patching
operations -- and their respective permissions changes -- are protected
by the text_mutex.

Link: http://lkml.kernel.org/r/ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com

Reported-by: Johannes Erdfelt <johannes@erdfelt.com>
Fixes: 444d13ff10fb ("modules: add ro_after_init support")
Acked-by: Jessica Yu <jeyu@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/livepatch/core.c |  6 ++++++
 kernel/trace/ftrace.c   | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 7c51f065b212..88754e9790f9 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -30,6 +30,7 @@
 #include <linux/elf.h>
 #include <linux/moduleloader.h>
 #include <linux/completion.h>
+#include <linux/memory.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -635,16 +636,21 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	struct klp_func *func;
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	module_disable_ro(patch->mod);
 	ret = klp_write_object_relocations(patch->mod, obj);
 	if (ret) {
 		module_enable_ro(patch->mod, true);
+		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
 	arch_klp_init_object_loaded(patch, obj);
 	module_enable_ro(patch->mod, true);
 
+	mutex_unlock(&text_mutex);
+
 	klp_for_each_func(obj, func) {
 		ret = klp_find_object_symbol(obj->name, func->old_name,
 					     func->old_sympos,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3e92852c8b23..4e4b88047fcc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -34,6 +34,7 @@
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
+#include <linux/memory.h>
 
 #include <trace/events/sched.h>
 
@@ -2692,10 +2693,12 @@ static void ftrace_run_update_code(int command)
 {
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	ret = ftrace_arch_code_modify_prepare();
 	FTRACE_WARN_ON(ret);
 	if (ret)
-		return;
+		goto out_unlock;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2707,6 +2710,9 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
+
+out_unlock:
+	mutex_unlock(&text_mutex);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
@@ -5791,6 +5797,7 @@ void ftrace_module_enable(struct module *mod)
 	struct ftrace_page *pg;
 
 	mutex_lock(&ftrace_lock);
+	mutex_lock(&text_mutex);
 
 	if (ftrace_disabled)
 		goto out_unlock;
@@ -5851,6 +5858,7 @@ void ftrace_module_enable(struct module *mod)
 		ftrace_arch_code_modify_post_process();
 
  out_unlock:
+	mutex_unlock(&text_mutex);
 	mutex_unlock(&ftrace_lock);
 
 	process_cached_mods(mod->name);
-- 
2.20.1



