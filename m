Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3981F104
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbfEOLTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730983AbfEOLTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4628120843;
        Wed, 15 May 2019 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919174;
        bh=Gxzzm52SvFSc58QxyKol0CPdIXirWqE5tMHv0WuaNKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+7UgSVJmc5YRY6dVdVq8Kbd0d2k3IluATYLy4k9OxL3YdfNh/quD95XWpZgjhWq0
         lsXxXDOj2IR4ja/9SztWvnGN4wLTIlimUMGmM+NY3P5Y/Kv+Rn9JgnhC1g9OuLMubx
         LBHhuUlUqhtdMlnZxTyNPrt3rmj/g2+75o3xScac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 093/115] x86/kprobes: Avoid kretprobe recursion bug
Date:   Wed, 15 May 2019 12:56:13 +0200
Message-Id: <20190515090705.984839036@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/x86/kernel/kprobes/core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 56cf6c2632549..9d7bb8de2917e 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -744,11 +744,16 @@ asm(
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
@@ -758,6 +763,17 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
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
@@ -833,10 +849,9 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
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
@@ -852,6 +867,9 @@ __visible __used void *trampoline_handler(struct pt_regs *regs)
 
 	kretprobe_hash_unlock(current, &flags);
 
+	__this_cpu_write(current_kprobe, NULL);
+	preempt_enable();
+
 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
-- 
2.20.1



