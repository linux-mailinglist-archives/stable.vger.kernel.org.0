Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3CA2541
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfH2SOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbfH2SOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A532C23404;
        Thu, 29 Aug 2019 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102491;
        bh=Sjz+ob3tjn27OF37DZBGEmsnfNuVRsOjYEddGEdbDeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nm/W27LvX5q6jIutVpNBx4y9VV45hJGKvwDYLv2D9OPRfC8mUhw3H49VTEC9BbUSb
         V/efdCElcEh30PXIAD1svT6WraFeTy2/GLL26XHSLDzjfpPv1AYYtoVzXl6PNtWZKe
         WePXPeZF2R4MBdqiYgaFw1vdMg+XV343dN9stSa4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 47/76] sched/core: Schedule new worker even if PI-blocked
Date:   Thu, 29 Aug 2019 14:12:42 -0400
Message-Id: <20190829181311.7562-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit b0fdc01354f45d43f082025636ef808968a27b36 ]

If a task is PI-blocked (blocking on sleeping spinlock) then we don't want to
schedule a new kworker if we schedule out due to lock contention because !RT
does not do that as well. A spinning spinlock disables preemption and a worker
does not schedule out on lock contention (but spin).

On RT the RW-semaphore implementation uses an rtmutex so
tsk_is_pi_blocked() will return true if a task blocks on it. In this case we
will now start a new worker which may deadlock if one worker is waiting on
progress from another worker. Since a RW-semaphore starts a new worker on !RT,
we should do the same on RT.

XFS is able to trigger this deadlock.

Allow to schedule new worker if the current worker is PI-blocked.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20190816160626.12742-1-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4d5962232a553..42bc2986520d7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3469,7 +3469,7 @@ void __noreturn do_task_dead(void)
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state || tsk_is_pi_blocked(tsk))
+	if (!tsk->state)
 		return;
 
 	/*
@@ -3485,6 +3485,9 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		preempt_enable_no_resched();
 	}
 
+	if (tsk_is_pi_blocked(tsk))
+		return;
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
-- 
2.20.1

