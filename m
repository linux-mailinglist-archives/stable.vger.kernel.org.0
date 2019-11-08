Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8AF571C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbfKHTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732926AbfKHTAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682CA2087E;
        Fri,  8 Nov 2019 19:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239630;
        bh=u4om3tbxfcn5qsLyuRNyA7htMtOOVZY1cPZ9PRVQ2xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txWtUZsCeGF8UuRp71ygjrf5dty46mx4x+0MqhwdV1dHth2jcUFxBeGEhOHM7jQL9
         gMAULwPkrdF0tiykVgqB/is4YvYRL6EufpsMSXaKnOit1OZRaLC8m+Ivd1Gt8m8hQE
         MKKt/bQIxANMyrMR6uQn1qVekSTI/thzOStNScBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongji Xie <elohimes@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Waiman Long <longman@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: [PATCH 4.14 51/62] sched/wake_q: Fix wakeup ordering for wake_q
Date:   Fri,  8 Nov 2019 19:50:39 +0100
Message-Id: <20191108174754.515925895@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 4c4e3731564c8945ac5ac90fc2a1e1f21cb79c92 upstream.

Notable cmpxchg() does not provide ordering when it fails, however
wake_q_add() requires ordering in this specific case too. Without this
it would be possible for the concurrent wakeup to not observe our
prior state.

Andrea Parri provided:

  C wake_up_q-wake_q_add

  {
	int next = 0;
	int y = 0;
  }

  P0(int *next, int *y)
  {
	int r0;

	/* in wake_up_q() */

	WRITE_ONCE(*next, 1);   /* node->next = NULL */
	smp_mb();               /* implied by wake_up_process() */
	r0 = READ_ONCE(*y);
  }

  P1(int *next, int *y)
  {
	int r1;

	/* in wake_q_add() */

	WRITE_ONCE(*y, 1);      /* wake_cond = true */
	smp_mb__before_atomic();
	r1 = cmpxchg_relaxed(next, 1, 2);
  }

  exists (0:r0=0 /\ 1:r1=0)

  This "exists" clause cannot be satisfied according to the LKMM:

  Test wake_up_q-wake_q_add Allowed
  States 3
  0:r0=0; 1:r1=1;
  0:r0=1; 1:r1=0;
  0:r0=1; 1:r1=1;
  No
  Witnesses
  Positive: 0 Negative: 3
  Condition exists (0:r0=0 /\ 1:r1=0)
  Observation wake_up_q-wake_q_add Never 0 3

Reported-by: Yongji Xie <elohimes@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -432,10 +432,11 @@ void wake_q_add(struct wake_q_head *head
 	 * its already queued (either by us or someone else) and will get the
 	 * wakeup due to that.
 	 *
-	 * This cmpxchg() implies a full barrier, which pairs with the write
-	 * barrier implied by the wakeup in wake_up_q().
+	 * In order to ensure that a pending wakeup will observe our pending
+	 * state, even in the failed case, an explicit smp_mb() must be used.
 	 */
-	if (cmpxchg(&node->next, NULL, WAKE_Q_TAIL))
+	smp_mb__before_atomic();
+	if (cmpxchg_relaxed(&node->next, NULL, WAKE_Q_TAIL))
 		return;
 
 	get_task_struct(task);


