Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097751488DE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgAXOU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgAXOU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA9C24687;
        Fri, 24 Jan 2020 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875626;
        bh=0ZbjyXeSGqs3vPWbhO5WXJOnQJXkUM8xCFg3+RP15C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPCv+BggK4YEyecs9X0UUmkD4WJZEYwmpykM/5IFYA6Um+wGCocfLRBbLnVfR2+Nr
         ii2Y5B7qHmQlzTqdyz1UeYMy3qs9k4rXmxfj69ZOxHfjcwlOjV6X+7nEU5B1kR3Rgu
         2qVwMIzr6eq51ZvGhgtfE/dROBN3munZ4dNFw0kQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 11/56] rseq: Unregister rseq for clone CLONE_VM
Date:   Fri, 24 Jan 2020 09:19:27 -0500
Message-Id: <20200124142012.29752-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

