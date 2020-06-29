Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0799E20D6FD
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732688AbgF2TZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbgF2TZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9988253EA;
        Mon, 29 Jun 2020 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445331;
        bh=+pJodRaQLTNHHoXcFk3mFgnI3zSVwETZbusdVpaYPD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgT4W4Qa2sCYVmE/YJyM2vXVBoF+2hqWYkeN7amtliPCIYAYiZrr1kULFmDnH1qG+
         +IC1j667mafdToQQ06bQkoNuSZz3dufyh0khRAOT6rfRGeWe5kLNCPs/uoPqu2rzUs
         iC8y/Bm5Q/8qkIW/0sQ/YjLw0gOiwBNAQP7zC4Yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrea Righi <righi.andrea@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 094/191] x86/kprobes: Avoid kretprobe recursion bug
Date:   Mon, 29 Jun 2020 11:38:30 -0400
Message-Id: <20200629154007.2495120-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit b191fa96ea6dc00d331dcc28c1f7db5e075693a0 ]

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
Cc: stable@vger.kernel.org
Fixes: c9becf58d935 ("[PATCH] kretprobe: kretprobe-booster")
Link: http://lkml.kernel.org/r/155094064889.6137.972160690963039.stgit@devbox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index dcd6df5943d60..118f66a609ced 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -740,11 +740,16 @@ asm(
 NOKPROBE_SYMBOL(kretprobe_trampoline);
 STACK_FRAME_NON_STANDARD(kretprobe_trampoline);
 
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
@@ -754,6 +759,17 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
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
@@ -829,10 +845,9 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
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
@@ -848,6 +863,9 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
 
 	kretprobe_hash_unlock(current, &flags);
 
+	__this_cpu_write(current_kprobe, NULL);
+	preempt_enable();
+
 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
-- 
2.25.1

