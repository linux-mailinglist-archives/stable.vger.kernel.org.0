Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D717FE29
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCJMsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbgCJMsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E76A20674;
        Tue, 10 Mar 2020 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844487;
        bh=fVMYinxaYFkfkSebpKMHUC3DxbydeGk4V7PgQkK/xyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnMVRUgq+cJxvTn1hm8/kHnuX7WLl7vtdDLYgsKmDU8ti/a9J1xgHnyW+0PqK7Gac
         ZoEZmdYtwi9dM36X++1P9T7exGuWGX0IxIkjmt0+gf7pK7u+B848LWhebShuWOLmnE
         7cI4GNuXxVCy4mKA052cHuBHBXYLsrrkKg8yAOYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/168] kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic
Date:   Tue, 10 Mar 2020 13:37:37 +0100
Message-Id: <20200310123636.899326378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
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
index 34e28b236d680..2625c241ac00f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -612,6 +612,18 @@ void wait_for_kprobe_optimizer(void)
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
@@ -633,17 +645,21 @@ static void optimize_kprobe(struct kprobe *p)
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
@@ -665,30 +681,33 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
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



