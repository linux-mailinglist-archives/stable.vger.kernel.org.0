Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5A11B864
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfLKQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:17:32 -0500
Received: from mail.efficios.com ([167.114.142.138]:44020 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbfLKQRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:17:24 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 4DCBC686C36;
        Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id UiFR_Ndqp7KF; Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id E1BE8686C16;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E1BE8686C16
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576081042;
        bh=CW7O/eexWxWU/jqLoVA/R48UmfGB4ZgQkMjz0vziYZ4=;
        h=From:To:Date:Message-Id;
        b=N78kdbeAoUT6+6zZxmcukQlaGitp3OE6qtADiHTpYxB/0vMclZonHI4s/lV/vX+rp
         HLftT7/FmObmCkQ5bGMtwiHsQYr7IrXrlPvgikhxSoLOvjRpm2tBkZpgqqVChCz+wy
         EUC7SIvZvs9IZ307BhoQ44SwDgEVhl1XnbEGfXyUt0OEQPykGqFRyvI+mRx0GTrBUk
         zJyaEvvvxwSy31DEonacsfNHVJ+MHzVHkHPxbXIIE59RKoOh+nCIAERVZZB/0iWmGl
         XmX6My7PQpFDDzdnhBzSCinvTwoDEX7mi2h8Fw8FLxIrWWPY3Oghlb6xERwZ0x+b8a
         AGw1J6UKX+wLw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id UR1g6HRdpZL3; Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 9FE94686C04;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Subject: [PATCH for 5.5 2/3] rseq: Fix: Unregister rseq for clone CLONE_VM
Date:   Wed, 11 Dec 2019 11:17:12 -0500
Message-Id: <20191211161713.4490-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported by Google that rseq is not behaving properly
with respect to clone when CLONE_VM is used without CLONE_THREAD.
It keeps the prior thread's rseq TLS registered when the TLS of the
thread has moved, so the kernel can corrupt the TLS of the parent.

The approach of clearing the per task-struct rseq registration
on clone with CLONE_THREAD flag is incomplete. It does not cover
the use-case of clone with CLONE_VM set, but without CLONE_THREAD.

Here is the rationale for unregistering rseq on clone with CLONE_VM
flag set:

1) CLONE_THREAD requires CLONE_SIGHAND, which requires CLONE_VM to be
   set. Therefore, just checking for CLONE_VM covers all CLONE_THREAD
   uses. There is no point in checking for both CLONE_THREAD and
   CLONE_VM,

2) There is the possibility of an unlikely scenario where CLONE_SETTLS
   is used without CLONE_VM. In order to be an issue, it would require
   that the rseq TLS is in a shared memory area.

   I do not plan on adding CLONE_SETTLS to the set of clone flags which
   unregister RSEQ, because it would require that we also unregister RSEQ
   on set_thread_area(2) and arch_prctl(2) ARCH_SET_FS for completeness.
   So rather than doing a partial solution, it appears better to let
   user-space explicitly perform rseq unregistration across clone if
   needed in scenarios where CLONE_VM is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: linux-api@vger.kernel.org
Cc: <stable@vger.kernel.org>	# v4.18+
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 467d26046416..716ad1d8d95e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1929,11 +1929,11 @@ static inline void rseq_migrate(struct task_struct *t)
 
 /*
  * If parent process has a registered restartable sequences area, the
- * child inherits. Only applies when forking a process, not a thread.
+ * child inherits. Unregister rseq for a clone with CLONE_VM set.
  */
 static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
 {
-	if (clone_flags & CLONE_THREAD) {
+	if (clone_flags & CLONE_VM) {
 		t->rseq = NULL;
 		t->rseq_sig = 0;
 		t->rseq_event_mask = 0;
-- 
2.17.1

