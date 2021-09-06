Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B6740143B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241281AbhIFBcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345218AbhIFB3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7579D611CC;
        Mon,  6 Sep 2021 01:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891413;
        bh=YcuAE+zGNjEpbYtV8qs07F+5J1E2nWT+L99bwhXST28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZTSHR1ARlK3hm3Mj8pPP1Ly64OWfezfok9ywWOJRwW8gb8QtUWLqypRLRW9zq3ou
         deY3AM66ziNIPhCDV1CcN543YDhjAD0gzOkMOGSB7ci0B+eZKG8fwvx3/mFhGD2heq
         lcipVSiXAPc+JA0tAf2wuwjgzAckyTH4H2m/Hiu54Xq79cVAZyPzlnamg7TU2/BYWc
         znrSDzTkVGFN8jGDVakbpgSImVMGXeCeVz2jDIhulhb71gcArnDWAsJabP84vpVDdt
         aAGKb/S0pgK5vb+0r2K3t8Vl0v56k/dUb0JjgT+GaRPoRkwL3vyEkQP9cBSQ37ApJD
         D4fa7T7luJ8tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 08/23] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Sun,  5 Sep 2021 21:23:07 -0400
Message-Id: <20210906012322.930668-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 406dd42bd1ba0c01babf9cde169bb319e52f6147 ]

When an itimer deactivates a previously armed expiration, it simply doesn't
do anything. As a result the process wide cputime counter keeps running and
the tick dependency stays set until it reaches the old ghost expiration
value.

This can be reproduced with the following snippet:

	void trigger_process_counter(void)
	{
		struct itimerval n = {};

		n.it_value.tv_sec = 100;
		setitimer(ITIMER_VIRTUAL, &n, NULL);
		n.it_value.tv_sec = 0;
		setitimer(ITIMER_VIRTUAL, &n, NULL);
	}

Fix this with resetting the relevant base expiration. This is similar to
disarming a timer.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210726125513.271824-4-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-cpu-timers.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index bfaa44a80c03..d9feac7aad52 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1230,8 +1230,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			}
 		}
 
-		if (!*newval)
-			return;
 		*newval += now;
 	}
 
-- 
2.30.2

