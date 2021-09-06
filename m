Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CA6401463
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244010AbhIFBdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351568AbhIFBam (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD806120D;
        Mon,  6 Sep 2021 01:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891439;
        bh=Q2eiMxAv0qvv9SReasBpQPHpA9B/idhT1OHfk18rqQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV9aHelhTVKCUdg1WBMh03QV9Anurq1N1CEw8vQBkukPOcJkeOoeZRaPvPbltQGZS
         5jffcM7SDYEdEKW38/9PqmAnAi4X7RS4FwPdampynC3Xpd+viB3XV30Eg1dvDuMpFz
         MeB465m+iTbOA7OPWOOBgKBhEfdPkBoKqXjrIzbc5KOIzBOjMdii+5uumaG8HPr04b
         4mg/93M1wTLoB6CQBVYkB32PrBOzMUIvCsqMY4nGd8WyGkJ5glQ1/dBkbkoBZ8F6vN
         L8SR7swq1Kyr6NXHLiW0HahDNZCTpoj8c/h4wLgvy//VKaojpO0WZODB0avTXWw/zn
         Tfuu/UXIqlPGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 05/17] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Sun,  5 Sep 2021 21:23:40 -0400
Message-Id: <20210906012352.930954-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012352.930954-1-sashal@kernel.org>
References: <20210906012352.930954-1-sashal@kernel.org>
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
index fb5a57ffb98c..495d690cc92b 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1207,8 +1207,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			}
 		}
 
-		if (!*newval)
-			return;
 		*newval += now;
 	}
 
-- 
2.30.2

