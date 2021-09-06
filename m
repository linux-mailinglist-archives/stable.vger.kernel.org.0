Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF30401371
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhIFB0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239576AbhIFBYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A28626112E;
        Mon,  6 Sep 2021 01:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891327;
        bh=iahcXtNmTikbc0e9WQ80924dKSq21TRzle63Y1mEAXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUn0m32xom6F8Xwe+IeQgIghRf3Q+0skhaFALnC5lvre8un4crN5LWz+MHNYwDT2i
         76sRt72qVoWe6AXbdEIjn3B+3L/mVPI4YfQjZbYkBgYgqTL4o2h10pc2nLn/A4wFry
         9OLkplML5rTsbjw/z/8aDpNW7yOUXLRBGFqWDM97uQblHxnBfnVENFNuNtQqBJ8tI6
         kWfokwccwpCxhfcQLoQ0XP4hQGUWJG97Mc/DEI9CLn30r6hHPkysD5aGxA5UklrSJi
         wmwtDIiJX9hZcBjooIfWzRsMYWekp8ssfV9tyBx87/nU2lc6NWGQzJVKo7fX/QxYQi
         hmolukxrheRQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 11/39] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Sun,  5 Sep 2021 21:21:25 -0400
Message-Id: <20210906012153.929962-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 08c033b80256..d3d42b7637a1 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1346,8 +1346,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
-		if (!*newval)
-			return;
 		*newval += now;
 	}
 
-- 
2.30.2

