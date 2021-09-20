Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615A441251C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381417AbhITSlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381508AbhITSia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EAA963323;
        Mon, 20 Sep 2021 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159011;
        bh=RuQbcAWp8KjO8TDel+qgvI82nX4UgHWdCfW8M5Fi32Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/3nQf4gL//OtLwrjd2enqloRqJvrgrPN9vIzdUPTz5ck7iAO66VEt2HgbcG4x4xq
         tu1PwnMBLmPaowjyWcWkkzhq1/w1XdzLDeSZ29kcgeaUY3powLg8xanzUcsTjVYHo3
         cFRTUeEVHthV6VMC4BFblD7NjLbfQXI27wvlf30w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 036/168] x86/mce: Avoid infinite loop for copy from user recovery
Date:   Mon, 20 Sep 2021 18:42:54 +0200
Message-Id: <20210920163922.834660648@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit 81065b35e2486c024c7aa86caed452e1f01a59d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |   45 ++++++++++++++++++++++++++++++-----------
 include/linux/sched.h          |    1 
 2 files changed, 34 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1253,6 +1253,9 @@ static void __mc_scan_banks(struct mce *
 
 static void kill_me_now(struct callback_head *ch)
 {
+	struct task_struct *p = container_of(ch, struct task_struct, mce_kill_me);
+
+	p->mce_count = 0;
 	force_sig(SIGBUS);
 }
 
@@ -1262,6 +1265,7 @@ static void kill_me_maybe(struct callbac
 	int flags = MF_ACTION_REQUIRED;
 	int ret;
 
+	p->mce_count = 0;
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
 
 	if (!p->mce_ripv)
@@ -1290,17 +1294,34 @@ static void kill_me_maybe(struct callbac
 	}
 }
 
-static void queue_task_work(struct mce *m, int kill_current_task)
+static void queue_task_work(struct mce *m, char *msg, int kill_current_task)
 {
-	current->mce_addr = m->addr;
-	current->mce_kflags = m->kflags;
-	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
-	current->mce_whole_page = whole_page(m);
-
-	if (kill_current_task)
-		current->mce_kill_me.func = kill_me_now;
-	else
-		current->mce_kill_me.func = kill_me_maybe;
+	int count = ++current->mce_count;
+
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
@@ -1438,7 +1459,7 @@ noinstr void do_machine_check(struct pt_
 		/* If this triggers there is no way to recover. Die hard. */
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
-		queue_task_work(&m, kill_current_task);
+		queue_task_work(&m, msg, kill_current_task);
 
 	} else {
 		/*
@@ -1456,7 +1477,7 @@ noinstr void do_machine_check(struct pt_
 		}
 
 		if (m.kflags & MCE_IN_KERNEL_COPYIN)
-			queue_task_work(&m, kill_current_task);
+			queue_task_work(&m, msg, kill_current_task);
 	}
 out:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1394,6 +1394,7 @@ struct task_struct {
 					mce_whole_page : 1,
 					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
+	int				mce_count;
 #endif
 
 #ifdef CONFIG_KRETPROBES


