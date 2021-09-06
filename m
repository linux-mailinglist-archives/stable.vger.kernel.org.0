Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7113E4013F1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhIFBcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239971AbhIFB1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20A0D61054;
        Mon,  6 Sep 2021 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891375;
        bh=dd0+vEyGnn4ll4F9/tTk78sT6GA7/5zJigxaZ8m1hmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQIgDUIhdRKyYjd6c0BtcvyZF+TKMO4Yil0lJybBzulwa2YsiCluGDxAo2LrI8uk+
         ulM+t4eBF7P++tWNsLzjihFmeyUq4lb/KVKsMvfE6fE0Hi4oZC1u4viAUZCYPbvLMq
         AzHHjxGkyvHiyE05oseKdRBy7qcC85vsbaoKyKTshtJeoZxM7OXo04Q5wptfJAn0D0
         4egDrIHKpKOEBQOI6HYbf2dWn5lHGC0ciy5RKkcvH8AmjC5gPrrEBoFWQK2sP45YIH
         XwZWvpOA7aKKYtQKrZuxMGtzAWZc6hfKgNf10cm8CXOuHX1eusV+UJo2ysKTYzqR4/
         7f3/HqcJHS3Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/30] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Sun,  5 Sep 2021 21:22:22 -0400
Message-Id: <20210906012244.930338-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
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
index eacb0ca30193..30e061b210b7 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1201,8 +1201,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
 			}
 		}
 
-		if (!*newval)
-			return;
 		*newval += now;
 	}
 
-- 
2.30.2

