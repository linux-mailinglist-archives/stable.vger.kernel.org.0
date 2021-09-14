Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7240A953
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhINIfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:35:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60280 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhINIff (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 04:35:35 -0400
Date:   Tue, 14 Sep 2021 08:34:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631608457;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttKDHmXZ2SEwq47IpdZatFDKfcVfOeIjAV/RlgHOenw=;
        b=i3EfgYX6baQhL4M3cGGU3q/t1sLEMnMptcnDteXJewWS6phLVeRGz5n6i3Esl4KYhSciK3
        94sic7AHXSAmRUMq0z1EhxZGp5YRo0+NMsgLahEv4KLQMhbEsQG6mMVofbCvw26abUr3xy
        ZyY343P72tU+pZuF9DCi3HNUCSSJo+c45nwl6IXODcK+B2TlpAejRnsclE1mrx4u5m5m9w
        bbDxpV6kOoSocB7eVKk0ZGDoxKqa4h/pxWsrHqLGoG9srAwCc5ZpAwj+X+R5spDODuV6iK
        UzuSOr3U6sGr4vvR6eZ1ToZSNc7eyhsrh8iFNktet27au5p1z/6Dhre4iXNyPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631608457;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttKDHmXZ2SEwq47IpdZatFDKfcVfOeIjAV/RlgHOenw=;
        b=VoGMVACfHT9Ht7p359zxvp2XjY00qeZkqa6FqjexySUw3mSBloerIzK6bVBSqHfRgSYugq
        w8CrDWQNMyN75zCw==
From:   "tip-bot2 for Tony Luck" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mce: Avoid infinite loop for copy from user recovery
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <IJ9ziLqmtqEPu@agluck-desk2.amr.corp.intel.com>
References: <IJ9ziLqmtqEPu@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Message-ID: <163160845622.25758.10454193494124931065.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     81065b35e2486c024c7aa86caed452e1f01a59d4
Gitweb:        https://git.kernel.org/tip/81065b35e2486c024c7aa86caed452e1f01a59d4
Author:        Tony Luck <tony.luck@intel.com>
AuthorDate:    Mon, 13 Sep 2021 14:52:39 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 14 Sep 2021 10:27:03 +02:00

x86/mce: Avoid infinite loop for copy from user recovery

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
 arch/x86/kernel/cpu/mce/core.c | 43 ++++++++++++++++++++++++---------
 include/linux/sched.h          |  1 +-
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 8cb7816..193204a 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1253,6 +1253,9 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 
 static void kill_me_now(struct callback_head *ch)
 {
+	struct task_struct *p = container_of(ch, struct task_struct, mce_kill_me);
+
+	p->mce_count = 0;
 	force_sig(SIGBUS);
 }
 
@@ -1262,6 +1265,7 @@ static void kill_me_maybe(struct callback_head *cb)
 	int flags = MF_ACTION_REQUIRED;
 	int ret;
 
+	p->mce_count = 0;
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
 
 	if (!p->mce_ripv)
@@ -1290,17 +1294,34 @@ static void kill_me_maybe(struct callback_head *cb)
 	}
 }
 
-static void queue_task_work(struct mce *m, int kill_current_task)
+static void queue_task_work(struct mce *m, char *msg, int kill_current_task)
 {
-	current->mce_addr = m->addr;
-	current->mce_kflags = m->kflags;
-	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
-	current->mce_whole_page = whole_page(m);
+	int count = ++current->mce_count;
 
-	if (kill_current_task)
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
@@ -1438,7 +1459,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		/* If this triggers there is no way to recover. Die hard. */
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
-		queue_task_work(&m, kill_current_task);
+		queue_task_work(&m, msg, kill_current_task);
 
 	} else {
 		/*
@@ -1456,7 +1477,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		}
 
 		if (m.kflags & MCE_IN_KERNEL_COPYIN)
-			queue_task_work(&m, kill_current_task);
+			queue_task_work(&m, msg, kill_current_task);
 	}
 out:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1780260..361c7bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1468,6 +1468,7 @@ struct task_struct {
 					mce_whole_page : 1,
 					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
+	int				mce_count;
 #endif
 
 #ifdef CONFIG_KRETPROBES
