Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB9408DF4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhIMNav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242193AbhIMN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 378F1610A8;
        Mon, 13 Sep 2021 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539400;
        bh=iahcXtNmTikbc0e9WQ80924dKSq21TRzle63Y1mEAXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz2AOpYGOcZFVGwipjbmN++GBLQ6Yoqaiqs0/cbFN3ymoqHZvvHFecfhghVh7jA2j
         n3tPya+2EX+KeVCDA59DA1CZat753bf58MFVt/Qi8at5EE+Yp6RjrLhjSf7f4FAMjt
         cQH4DK7lrxaRhDJ0qBiZNzKDtgznnRa/YsDIWyBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/236] posix-cpu-timers: Force next expiration recalc after itimer reset
Date:   Mon, 13 Sep 2021 15:11:56 +0200
Message-Id: <20210913131100.714437277@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



