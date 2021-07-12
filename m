Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F23C453E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhGLGYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhGLGY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE03D61185;
        Mon, 12 Jul 2021 06:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070857;
        bh=VdU5if/H3h+GWxk3WVaJSJnSIav16mMlfhXKIH2qt40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZmGzhM1pvyTnI2wb3Bl7vQptBJ/C7nPZdoTGK+uaTM2mrfv8PaOQin1sSFisK4G0
         rUapk/YoPdfIPMQJ5zRJDoHkTJ/FTT/SJ5/pb1MlIAPFaX9fZv1G9GEmBt4tNZ/iEV
         TKYRbijfZFovKNOnUdtXaPWZjTQeYGOo6Ci+kYg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/348] sched/rt: Fix Deadline utilization tracking during policy change
Date:   Mon, 12 Jul 2021 08:09:15 +0200
Message-Id: <20210712060723.545687840@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 4ce8c11e5e4a..3cf776d5bce8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2392,6 +2392,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 			check_preempt_curr_dl(rq, p, 0);
 		else
 			resched_curr(rq);
+	} else {
+		update_dl_rq_load_avg(rq_clock_pelt(rq), rq, 0);
 	}
 }
 
-- 
2.30.2



