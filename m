Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD2B3C5352
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352290AbhGLHyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350019AbhGLHuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E3AA61932;
        Mon, 12 Jul 2021 07:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075831;
        bh=L8Cx/kkEvyweIygyDPjlm3FTKhiPZuiHb64oG5vPbyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p65Xz5eQrm1dHwbnxI75pz9D3BedBKl41wYyN9cR67mdLAr5a/XsMJyT2PBOUBlTR
         eMOxrDjfRwXr5HGDAH6HXWHI/ZzkRoM5VHvY0i97WTTVwP+rAWkr5CLbgw5p9Kb+N3
         /hcD3BVqOMiL3avf/9rfJ3sUBg/Tb1GhENIzOSBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 340/800] sched/rt: Fix Deadline utilization tracking during policy change
Date:   Mon, 12 Jul 2021 08:06:03 +0200
Message-Id: <20210712061002.988657174@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit d7d607096ae6d378b4e92d49946d22739c047d4c ]

DL keeps track of the utilization on a per-rq basis with the structure
avg_dl. This utilization is updated during task_tick_dl(),
put_prev_task_dl() and set_next_task_dl(). However, when the current
running task changes its policy, set_next_task_dl() which would usually
take care of updating the utilization when the rq starts running DL
tasks, will not see a such change, leaving the avg_dl structure outdated.
When that very same task will be dequeued later, put_prev_task_dl() will
then update the utilization, based on a wrong last_update_time, leading to
a huge spike in the DL utilization signal.

The signal would eventually recover from this issue after few ms. Even
if no DL tasks are run, avg_dl is also updated in
__update_blocked_others(). But as the CPU capacity depends partly on the
avg_dl, this issue has nonetheless a significant impact on the scheduler.

Fix this issue by ensuring a load update when a running task changes
its policy to DL.

Fixes: 3727e0e ("sched/dl: Add dl_rq utilization tracking")
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/1624271872-211872-3-git-send-email-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9a2989749b8d..2f9964b467e0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2486,6 +2486,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 			check_preempt_curr_dl(rq, p, 0);
 		else
 			resched_curr(rq);
+	} else {
+		update_dl_rq_load_avg(rq_clock_pelt(rq), rq, 0);
 	}
 }
 
-- 
2.30.2



