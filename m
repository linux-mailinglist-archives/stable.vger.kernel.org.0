Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEC3A8476
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhFOPvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhFOPup (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CDE616E9;
        Tue, 15 Jun 2021 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772120;
        bh=fM36BTlAU8OIDOXfnCFdIFs5M/DA6mjrPZ/gWgcnLYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQPE+9R/iNU/799Ztx4YaDiME3J97HXvV0DezXd+RSIqnX/NizwZh/uyc9GHs5L1l
         mBb8RLyxY9ZbZciR3SaMlwxbJzhh6+1fPZc7WaCZiR4b/hKql0rQ3nj3Gy2INa3Tfs
         VIr0h0FDlo/45qXxiP3UwUHdgev/F+KbXAyGIY5L0DuRrOFW0UI611Pl+7OuOgINb6
         OoZ/xG1rcv8fvputNWDB7QLoHUyaMiFfIGZq0z1sJlxbMOBLOlevWkC14VHu9aI9td
         79WD7/YejA4fYPsKl8WRvp3puiHPUbMzJvQhq1h+Xiov+ZBXSYQkaKJ6oxE14tBIEo
         HGmEkACnpbHaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 13/33] sched/pelt: Ensure that *_sum is always synced with *_avg
Date:   Tue, 15 Jun 2021 11:48:04 -0400
Message-Id: <20210615154824.62044-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit fcf6631f3736985ec89bdd76392d3c7bfb60119f ]

Rounding in PELT calculation happening when entities are attached/detached
of a cfs_rq can result into situations where util/runnable_avg is not null
but util/runnable_sum is. This is normally not possible so we need to
ensure that util/runnable_sum stays synced with util/runnable_avg.

detach_entity_load_avg() is the last place where we don't sync
util/runnable_sum with util/runnbale_avg when moving some sched_entities

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210601085832.12626-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a073a839cd06..a9c4f0370bdc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3761,11 +3761,17 @@ static void attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
  */
 static void detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	/*
+	 * cfs_rq->avg.period_contrib can be used for both cfs_rq and se.
+	 * See ___update_load_avg() for details.
+	 */
+	u32 divider = get_pelt_divider(&cfs_rq->avg);
+
 	dequeue_load_avg(cfs_rq, se);
 	sub_positive(&cfs_rq->avg.util_avg, se->avg.util_avg);
-	sub_positive(&cfs_rq->avg.util_sum, se->avg.util_sum);
+	cfs_rq->avg.util_sum = cfs_rq->avg.util_avg * divider;
 	sub_positive(&cfs_rq->avg.runnable_avg, se->avg.runnable_avg);
-	sub_positive(&cfs_rq->avg.runnable_sum, se->avg.runnable_sum);
+	cfs_rq->avg.runnable_sum = cfs_rq->avg.runnable_avg * divider;
 
 	add_tg_cfs_propagate(cfs_rq, -se->avg.load_sum);
 
-- 
2.30.2

