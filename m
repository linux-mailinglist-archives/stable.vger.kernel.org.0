Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA3150D48
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgBCQcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgBCQcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:06 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1431E21582;
        Mon,  3 Feb 2020 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747525;
        bh=0ZbjyXeSGqs3vPWbhO5WXJOnQJXkUM8xCFg3+RP15C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks1FpNP+d7HKkrR96E1h2JK/kqvycXj/CRQUuYdtO9gVzg4C6TzXB0ozmJ8Bsuieu
         HlqKngsHh2NZyvnkfMx2lCm84K3Hb4YoBF9Yc1RQkg+g24lflR7xM8ltNCt+hf7SIj
         EJCIAHBhDIMBu35GI1gXLDrK0RQ0mdM3Oz5UB2jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/70] rseq: Unregister rseq for clone CLONE_VM
Date:   Mon,  3 Feb 2020 16:19:42 +0000
Message-Id: <20200203161916.905521381@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 463f550fb47bede3a5d7d5177f363a6c3b45d50b ]

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191211161713.4490-3-mathieu.desnoyers@efficios.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20f5ba262cc0d..0530de9a4efcc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1843,11 +1843,11 @@ static inline void rseq_migrate(struct task_struct *t)
 
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
 		t->rseq_len = 0;
 		t->rseq_sig = 0;
-- 
2.20.1



