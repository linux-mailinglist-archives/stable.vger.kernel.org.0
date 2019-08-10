Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C688DAF
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfHJUsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54992 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbfHJUoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053L-9x; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003gM-JK; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andrea Righi" <righi.andrea@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.507169080@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 098/157] x86/kprobes: Avoid kretprobe recursion bug
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit b191fa96ea6dc00d331dcc28c1f7db5e075693a0 upstream.

Avoid kretprobe recursion loop bg by setting a dummy
kprobes to current_kprobe per-CPU variable.

This bug has been introduced with the asm-coded trampoline
code, since previously it used another kprobe for hooking
the function return placeholder (which only has a nop) and
trampoline handler was called from that kprobe.

This revives the old lost kprobe again.

With this fix, we don't see deadlock anymore.

And you can see that all inner-called kretprobe are skipped.

  event_1                                  235               0
  event_2                                19375           19612

The 1st column is recorded count and the 2nd is missed count.
Above shows (event_1 rec) + (event_2 rec) ~= (event_2 missed)
(some difference are here because the counter is racy)

Reported-by: Andrea Righi <righi.andrea@gmail.com>
Tested-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: c9becf58d935 ("[PATCH] kretprobe: kretprobe-booster")
Link: http://lkml.kernel.org/r/155094064889.6137.972160690963039.stgit@devbox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/kprobes/core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -686,11 +686,16 @@ static void __used kretprobe_trampoline_
 NOKPROBE_SYMBOL(kretprobe_trampoline_holder);
 NOKPROBE_SYMBOL(kretprobe_trampoline);
 
+static struct kprobe kretprobe_kprobe = {
+	.addr = (void *)kretprobe_trampoline,
+};
+
 /*
  * Called from kretprobe_trampoline
  */
 __visible __used void *trampoline_handler(struct pt_regs *regs)
 {
+	struct kprobe_ctlblk *kcb;
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
 	struct hlist_node *tmp;
@@ -700,6 +705,17 @@ __visible __used void *trampoline_handle
 	void *frame_pointer;
 	bool skipped = false;
 
+	preempt_disable();
+
+	/*
+	 * Set a dummy kprobe for avoiding kretprobe recursion.
+	 * Since kretprobe never run in kprobe handler, kprobe must not
+	 * be running at this point.
+	 */
+	kcb = get_kprobe_ctlblk();
+	__this_cpu_write(current_kprobe, &kretprobe_kprobe);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
 	/* fixup registers */
@@ -775,10 +791,9 @@ __visible __used void *trampoline_handle
 		orig_ret_address = (unsigned long)ri->ret_addr;
 		if (ri->rp && ri->rp->handler) {
 			__this_cpu_write(current_kprobe, &ri->rp->kp);
-			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
-			__this_cpu_write(current_kprobe, NULL);
+			__this_cpu_write(current_kprobe, &kretprobe_kprobe);
 		}
 
 		recycle_rp_inst(ri, &empty_rp);
@@ -794,6 +809,9 @@ __visible __used void *trampoline_handle
 
 	kretprobe_hash_unlock(current, &flags);
 
+	__this_cpu_write(current_kprobe, NULL);
+	preempt_enable();
+
 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);

