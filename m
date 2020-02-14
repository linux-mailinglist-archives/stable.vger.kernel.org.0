Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B8415DBC9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgBNPuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgBNPuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74C124650;
        Fri, 14 Feb 2020 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695415;
        bh=vra5Iov8kMoiTcjt7/yz+FaHmHlIAp8cXCJ/a9dcOwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFov258gGPUAxNCb6/skAyXb/xq29nJGo6uJ9eStYWMaFXil14iTplpHns+JDf0Xa
         rJ0jgui8nLRZ4r2Tb3JVtB5fED5fMWakYiXIc/4RYNPjAF6SJdA0HHM0ga2M1aFz6s
         +uu2GW/xCIxIj++0QUDnAzivlB8wmrLl+ziLqZ44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 061/542] kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic
Date:   Fri, 14 Feb 2020 10:40:53 -0500
Message-Id: <20200214154854.6746-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 53534aa258a60..fd81882f05210 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -610,6 +610,18 @@ void wait_for_kprobe_optimizer(void)
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
@@ -631,17 +643,21 @@ static void optimize_kprobe(struct kprobe *p)
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
@@ -662,31 +678,34 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
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
 
 	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
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

