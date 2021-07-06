Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2BE3BCEB0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhGFL1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232674AbhGFLXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8366161CBB;
        Tue,  6 Jul 2021 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570293;
        bh=1hk0Em0/ug60WbfbMmumFuUee5iyo4A13yg6TV8wlDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdm9+Epq0Sg1zg6SYHzOpEEM0uircxjUP/krDc47yFL0u/QZYMLj4mcz+JYTaRhwe
         sZRqEfYKF0pSuBvMK01+nbqEbyVucttoopnof4NuzF2kY3IBx/w7jHFZDzXSzk2os1
         ul96CU8v2pMD8r6GwPgJKgJLG/DntOoNHb8iT2hMO6j56v8Bo75jOiVQa2444aT19M
         FQFjdXy5myHU4QZ6msv9tvrdtfgeTMDXYgR8XeDj4hv3F8Fb1kXpLor2xjKbV1/qhZ
         Dts2xHO8lmd1jCZyR9dbyaXvFMVUeSkViJDQTWdK9lqVqX76OEU3BrfMIS3T7fcA9v
         32tz8IHdUtcXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 182/189] sched/fair: Ensure _sum and _avg values stay consistent
Date:   Tue,  6 Jul 2021 07:14:02 -0400
Message-Id: <20210706111409.2058071-182-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit 1c35b07e6d3986474e5635be566e7bc79d97c64d ]

The _sum and _avg values are in general sync together with the PELT
divider. They are however not always completely in perfect sync,
resulting in situations where _sum gets to zero while _avg stays
positive. Such situations are undesirable.

This comes from the fact that PELT will increase period_contrib, also
increasing the PELT divider, without updating _sum and _avg values to
stay in perfect sync where (_sum == _avg * divider). However, such PELT
change will never lower _sum, making it impossible to end up in a
situation where _sum is zero and _avg is not.

Therefore, we need to ensure that when subtracting load outside PELT,
that when _sum is zero, _avg is also set to zero. This occurs when
(_sum < _avg * divider), and the subtracted (_avg * divider) is bigger
or equal to the current _sum, while the subtracted _avg is smaller than
the current _avg.

Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20210624111815.57937-1-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 23663318fb81..1dd1ed98171b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3716,15 +3716,15 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 
 		r = removed_load;
 		sub_positive(&sa->load_avg, r);
-		sub_positive(&sa->load_sum, r * divider);
+		sa->load_sum = sa->load_avg * divider;
 
 		r = removed_util;
 		sub_positive(&sa->util_avg, r);
-		sub_positive(&sa->util_sum, r * divider);
+		sa->util_sum = sa->util_avg * divider;
 
 		r = removed_runnable;
 		sub_positive(&sa->runnable_avg, r);
-		sub_positive(&sa->runnable_sum, r * divider);
+		sa->runnable_sum = sa->runnable_avg * divider;
 
 		/*
 		 * removed_runnable is the unweighted version of removed_load so we
-- 
2.30.2

