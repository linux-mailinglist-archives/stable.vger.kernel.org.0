Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F5ACDA0
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbfIHMvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732675AbfIHMvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:43 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EAE20693;
        Sun,  8 Sep 2019 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947102;
        bh=gZVmyGNN3awcb8D19eauWMRQw0XXcTPKXUb62OgyKc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVWoal+aRtJZIPF2BcyEmLMazuQrR05pQy5SSz04FpN7zuqLjGqpD1PVgGUAlT3lt
         DrIUlvtqEuC0+7h3rcrzeSBC/EeAyx5z076nRzh/I6Q8cCAyE3CfzAwv382m1fOMgP
         JI4zCHcaMco44LzMw75VlurWGb/MsBCV4oWbcQF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 63/94] sched/core: Schedule new worker even if PI-blocked
Date:   Sun,  8 Sep 2019 13:41:59 +0100
Message-Id: <20190908121152.237568541@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



