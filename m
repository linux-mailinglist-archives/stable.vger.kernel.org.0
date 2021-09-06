Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B64012F1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhIFBXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239223AbhIFBWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A81F610C8;
        Mon,  6 Sep 2021 01:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891266;
        bh=DelnyK5aGGO1NlE3oLFF/jPq7d7Uch5KUCgn/kFffBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pnp/P1SavOcNx89+lGjgTV9P5cLM4qpV16HYYj5naoeYTv4j15pcH8tGXE2GQZbrm
         HTf3qn6TxRLtyZdtgxwV82bUsMRY2LmEegQ9IRpJe1wzt2EUQC3FGoVoWvzOdOI+HV
         uE09DQC+rlQVvjsDhSa0YZWknH32IQoQnDRoOBKf+YN6tgS0X2im/WY71500vrCFQP
         MHCwk/Cve+OZo0rmAjDHF6pqK78uHMOLgeqMRYDq9lSzEYced+GR++KftszUUOsZJC
         tlzho+1dg8kE2LkRNFBvA6uzzBmbw4V7RgD+ypaJEwsci9oyenFzmJ2xKWs1Wx+7mM
         Nn14HTridsZCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 11/46] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Sun,  5 Sep 2021 21:20:16 -0400
Message-Id: <20210906012052.929174-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index aa52fc85dbcb..a9f8d25220b1 100644
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

