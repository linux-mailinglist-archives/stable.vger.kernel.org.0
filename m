Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCE3B231B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 17:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391313AbfIMPMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 11:12:32 -0400
Received: from mail.efficios.com ([167.114.142.138]:52500 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389163AbfIMPM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 11:12:26 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 2BCCB2D10D7;
        Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id twKIsIjuDRvb; Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id D2BE72D10CB;
        Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D2BE72D10CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568387544;
        bh=HUhXlddIR0ayNdxCc8DHV66AuBM69hftfD2geU7aTqE=;
        h=From:To:Date:Message-Id;
        b=tP7X6ryBYfZBI+vmVx15zugftJOB0zj75/RbET8mn42SXAOrtdP3IgVS6STJ3Zbij
         M2c5rTPeLd+f1SudZWi4sKR/vWGVmQuaczfKFFJgfTLITV3dFwPdV76Gt8wYtGNJNa
         RX5LUNyxq5M8KcYrmiCSjFxpV34pdcdzcNGHpgB6eXq0Q5smeLgi0x0uGhWBaRn8e8
         9JIGYCzdXqkt78588lI79h4iTYSoH6lFYB0yLGUCDCcZAIpvp8VMAIPMTkF7mHrTCz
         mCWbf0bw8zmJ3RvJW5Qpakn4lrxKq3WC6LPIldYXy9mhs3zv6KbKjnHoSlh0hiPp/l
         HODfq7Uk4LyGw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id KXxwLFY74But; Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 979132D10C0;
        Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH for 5.3 2/3] rseq: Fix: Unregister rseq for CLONE_SETTLS
Date:   Fri, 13 Sep 2019 11:12:19 -0400
Message-Id: <20190913151220.3105-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
References: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported by Google that rseq is not behaving properly
with respect to clone when CLONE_VM is used without CLONE_THREAD.
It keeps the prior thread's rseq TLS registered when the TLS of the
thread has moved, so the kernel deals with the wrong TLS.

The approach of clearing the per task-struct rseq registration
on clone with CLONE_THREAD flag is incomplete. It does not cover
the use-case of clone with CLONE_VM set, but without CLONE_THREAD.

Looking more closely at each of the clone flags:

- CLONE_THREAD,
- CLONE_VM,
- CLONE_SETTLS.

It appears that the flag we really want to track is CLONE_SETTLS, which
moves the location of the TLS for the child, making the rseq
registration point to the wrong TLS.

Suggested-by: "H . Peter Anvin" <hpa@zytor.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-api@vger.kernel.org
Cc: <stable@vger.kernel.org>
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9f51932bd543..76bf55b5cccf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1919,11 +1919,11 @@ static inline void rseq_migrate(struct task_struct *t)
 
 /*
  * If parent process has a registered restartable sequences area, the
- * child inherits. Only applies when forking a process, not a thread.
+ * child inherits. Unregister rseq for a clone with CLONE_SETTLS set.
  */
 static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
 {
-	if (clone_flags & CLONE_THREAD) {
+	if (clone_flags & CLONE_SETTLS) {
 		t->rseq = NULL;
 		t->rseq_sig = 0;
 		t->rseq_event_mask = 0;
-- 
2.17.1

