Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ABF3AF051
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhFUQsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhFUQqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8E2613B2;
        Mon, 21 Jun 2021 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293189;
        bh=6FbYkhJMn2N0WyVHtkjTZp2t6XKY0Cc1Iu8MvkMCgdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xx5I5ghLDnzSTHcI6wAi8TJymUF4mdfZP4/2vlqrB3jm/CIBMu+ytKCz5UXLSMGLB
         OJvla+GwaQXH/wGuhvth5E5PfHi5YFU28VUQzz+SqPix378qEt+ikGtRmi/eT4tBaW
         p3XdHYpz7Semkxh25YQU3kz4FS9R/5dHoA+uNoXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 098/178] sched/pelt: Ensure that *_sum is always synced with *_avg
Date:   Mon, 21 Jun 2021 18:15:12 +0200
Message-Id: <20210621154926.100007082@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 487312a5ceab..47fcc3fe9dc5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3760,11 +3760,17 @@ static void attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
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



