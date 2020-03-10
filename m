Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299D817FAD2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgCJNIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgCJNIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706D120409;
        Tue, 10 Mar 2020 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845713;
        bh=a/S5nGQZLSk83xkWXDu61r6mGcJa5cWNkEOt3jJGtic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyOTKiw1bWx8QKOnFx9YJq79ZkhV5htibtEcH+mQJ+WIjAY0fasP3VnsicJRpLK+R
         bR5IEy2ksLQII1VDtULJDbbHhdUil0mAdcSLrik5rMAZKy1ULZdUSnGSQqYN3Mkam7
         8y3WR3WHIunkHKrnWmZm5/+4FyDy49PkJ0X6fMQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/126] kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic
Date:   Tue, 10 Mar 2020 13:41:34 +0100
Message-Id: <20200310124208.657258685@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit e4add247789e4ba5e08ad8256183ce2e211877d4 ]

optimize_kprobe() and unoptimize_kprobe() cancels if a given kprobe
is on the optimizing_list or unoptimizing_list already. However, since
the following commit:

  f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")

modified the update timing of the KPROBE_FLAG_OPTIMIZED, it doesn't
work as expected anymore.

The optimized_kprobe could be in the following states:

- [optimizing]: Before inserting jump instruction
  op.kp->flags has KPROBE_FLAG_OPTIMIZED and
  op->list is not empty.

- [optimized]: jump inserted
  op.kp->flags has KPROBE_FLAG_OPTIMIZED and
  op->list is empty.

- [unoptimizing]: Before removing jump instruction (including unused
  optprobe)
  op.kp->flags has KPROBE_FLAG_OPTIMIZED and
  op->list is not empty.

- [unoptimized]: jump removed
  op.kp->flags doesn't have KPROBE_FLAG_OPTIMIZED and
  op->list is empty.

Current code mis-expects [unoptimizing] state doesn't have
KPROBE_FLAG_OPTIMIZED, and that can cause incorrect results.

To fix this, introduce optprobe_queued_unopt() to distinguish [optimizing]
and [unoptimizing] states and fixes the logic in optimize_kprobe() and
unoptimize_kprobe().

[ mingo: Cleaned up the changelog and the code a bit. ]

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bristot@redhat.com
Fixes: f66c0447cca1 ("kprobes: Set unoptimized flag after unoptimizing code")
Link: https://lkml.kernel.org/r/157840814418.7181.13478003006386303481.stgit@devnote2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 67 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 48bf93bbb22e2..66f1818d47620 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -625,6 +625,18 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
+static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+{
+	struct optimized_kprobe *_op;
+
+	list_for_each_entry(_op, &unoptimizing_list, list) {
+		if (op == _op)
+			return true;
+	}
+
+	return false;
+}
+
 /* Optimize kprobe if p is ready to be optimized */
 static void optimize_kprobe(struct kprobe *p)
 {
@@ -646,17 +658,21 @@ static void optimize_kprobe(struct kprobe *p)
 		return;
 
 	/* Check if it is already optimized. */
-	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED)
+	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED) {
+		if (optprobe_queued_unopt(op)) {
+			/* This is under unoptimizing. Just dequeue the probe */
+			list_del_init(&op->list);
+		}
 		return;
+	}
 	op->kp.flags |= KPROBE_FLAG_OPTIMIZED;
 
-	if (!list_empty(&op->list))
-		/* This is under unoptimizing. Just dequeue the probe */
-		list_del_init(&op->list);
-	else {
-		list_add(&op->list, &optimizing_list);
-		kick_kprobe_optimizer();
-	}
+	/* On unoptimizing/optimizing_list, op must have OPTIMIZED flag */
+	if (WARN_ON_ONCE(!list_empty(&op->list)))
+		return;
+
+	list_add(&op->list, &optimizing_list);
+	kick_kprobe_optimizer();
 }
 
 /* Short cut to direct unoptimizing */
@@ -678,30 +694,33 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
 		return; /* This is not an optprobe nor optimized */
 
 	op = container_of(p, struct optimized_kprobe, kp);
-	if (!kprobe_optimized(p)) {
-		/* Unoptimized or unoptimizing case */
-		if (force && !list_empty(&op->list)) {
-			/*
-			 * Only if this is unoptimizing kprobe and forced,
-			 * forcibly unoptimize it. (No need to unoptimize
-			 * unoptimized kprobe again :)
-			 */
-			list_del_init(&op->list);
-			force_unoptimize_kprobe(op);
-		}
+	if (!kprobe_optimized(p))
 		return;
-	}
 
 	if (!list_empty(&op->list)) {
-		/* Dequeue from the optimization queue */
-		list_del_init(&op->list);
+		if (optprobe_queued_unopt(op)) {
+			/* Queued in unoptimizing queue */
+			if (force) {
+				/*
+				 * Forcibly unoptimize the kprobe here, and queue it
+				 * in the freeing list for release afterwards.
+				 */
+				force_unoptimize_kprobe(op);
+				list_move(&op->list, &freeing_list);
+			}
+		} else {
+			/* Dequeue from the optimizing queue */
+			list_del_init(&op->list);
+			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+		}
 		return;
 	}
+
 	/* Optimized kprobe case */
-	if (force)
+	if (force) {
 		/* Forcibly update the code: this is a special case */
 		force_unoptimize_kprobe(op);
-	else {
+	} else {
 		list_add(&op->list, &unoptimizing_list);
 		kick_kprobe_optimizer();
 	}
-- 
2.20.1



