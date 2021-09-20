Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0EF411893
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbhITPqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:46:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:27749 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238233AbhITPqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 11:46:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="286836136"
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="286836136"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 08:40:51 -0700
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="548836396"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 08:40:51 -0700
Date:   Mon, 20 Sep 2021 08:40:50 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     gregkh@linuxfoundation.org
Cc:     bp@suse.de, stable@vger.kernel.org, tony.luck@intel.com
Subject: [PATCH v5.10.67] x86/mce: Avoid infinite loop for copy from user
 recovery
Message-ID: <YUirguJmYnlxQ63R@agluck-desk2.amr.corp.intel.com>
References: <163212173281150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163212173281150@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 81065b35e2486c024c7aa86caed452e1f01a59d4

There are two cases for machine check recovery:

1) The machine check was triggered by ring3 (application) code.
   This is the simpler case. The machine check handler simply queues
   work to be executed on return to user. That code unmaps the page
   from all users and arranges to send a SIGBUS to the task that
   triggered the poison.

2) The machine check was triggered in kernel code that is covered by
   an exception table entry. In this case the machine check handler
   still queues a work entry to unmap the page, etc. but this will
   not be called right away because the #MC handler returns to the
   fix up code address in the exception table entry.

Problems occur if the kernel triggers another machine check before the
return to user processes the first queued work item.

Specifically, the work is queued using the ->mce_kill_me callback
structure in the task struct for the current thread. Attempting to queue
a second work item using this same callback results in a loop in the
linked list of work functions to call. So when the kernel does return to
user, it enters an infinite loop processing the same entry for ever.

There are some legitimate scenarios where the kernel may take a second
machine check before returning to the user.

1) Some code (e.g. futex) first tries a get_user() with page faults
   disabled. If this fails, the code retries with page faults enabled
   expecting that this will resolve the page fault.

2) Copy from user code retries a copy in byte-at-time mode to check
   whether any additional bytes can be copied.

On the other side of the fence are some bad drivers that do not check
the return value from individual get_user() calls and may access
multiple user addresses without noticing that some/all calls have
failed.

Fix by adding a counter (current->mce_count) to keep track of repeated
machine checks before task_work() is called. First machine check saves
the address information and calls task_work_add(). Subsequent machine
checks before that task_work call back is executed check that the address
is in the same page as the first machine check (since the callback will
offline exactly one page).

Expected worst case is four machine checks before moving on (e.g. one
user access with page faults disabled, then a repeat to the same address
with page faults enabled ... repeat in copy tail bytes). Just in case
there is some code that loops forever enforce a limit of 10.

 [ bp: Massage commit message, drop noinstr, fix typo, extend panic
   messages. ]

Fixes: 5567d11c21a1 ("x86/mce: Send #MC singal from task work")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/YT/IJ9ziLqmtqEPu@agluck-desk2.amr.corp.intel.com
---
 arch/x86/kernel/cpu/mce/core.c | 43 +++++++++++++++++++++++++---------
 include/linux/sched.h          |  1 +
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 056d0367864e..14b34963eb1f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1241,6 +1241,9 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 
 static void kill_me_now(struct callback_head *ch)
 {
+	struct task_struct *p = container_of(ch, struct task_struct, mce_kill_me);
+
+	p->mce_count = 0;
 	force_sig(SIGBUS);
 }
 
@@ -1249,6 +1252,7 @@ static void kill_me_maybe(struct callback_head *cb)
 	struct task_struct *p = container_of(cb, struct task_struct, mce_kill_me);
 	int flags = MF_ACTION_REQUIRED;
 
+	p->mce_count = 0;
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
 
 	if (!p->mce_ripv)
@@ -1269,17 +1273,34 @@ static void kill_me_maybe(struct callback_head *cb)
 	}
 }
 
-static void queue_task_work(struct mce *m, int kill_it)
+static void queue_task_work(struct mce *m, char *msg, int kill_current_task)
 {
-	current->mce_addr = m->addr;
-	current->mce_kflags = m->kflags;
-	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
-	current->mce_whole_page = whole_page(m);
+	int count = ++current->mce_count;
 
-	if (kill_it)
-		current->mce_kill_me.func = kill_me_now;
-	else
-		current->mce_kill_me.func = kill_me_maybe;
+	/* First call, save all the details */
+	if (count == 1) {
+		current->mce_addr = m->addr;
+		current->mce_kflags = m->kflags;
+		current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
+		current->mce_whole_page = whole_page(m);
+
+		if (kill_current_task)
+			current->mce_kill_me.func = kill_me_now;
+		else
+			current->mce_kill_me.func = kill_me_maybe;
+	}
+
+	/* Ten is likely overkill. Don't expect more than two faults before task_work() */
+	if (count > 10)
+		mce_panic("Too many consecutive machine checks while accessing user data", m, msg);
+
+	/* Second or later call, make sure page address matches the one from first call */
+	if (count > 1 && (current->mce_addr >> PAGE_SHIFT) != (m->addr >> PAGE_SHIFT))
+		mce_panic("Consecutive machine checks to different user pages", m, msg);
+
+	/* Do not call task_work_add() more than once */
+	if (count > 1)
+		return;
 
 	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
 }
@@ -1427,7 +1448,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		/* If this triggers there is no way to recover. Die hard. */
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
-		queue_task_work(&m, kill_it);
+		queue_task_work(&m, msg, kill_it);
 
 	} else {
 		/*
@@ -1445,7 +1466,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		}
 
 		if (m.kflags & MCE_IN_KERNEL_COPYIN)
-			queue_task_work(&m, kill_it);
+			queue_task_work(&m, msg, kill_it);
 	}
 out:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2660ee4b08ad..29c7ccd5ae42 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1354,6 +1354,7 @@ struct task_struct {
 					mce_whole_page : 1,
 					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
+	int				mce_count;
 #endif
 
 	/*
-- 
2.31.1

