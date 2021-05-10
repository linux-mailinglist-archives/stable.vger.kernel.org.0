Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B037888E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEJLWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237227AbhEJLLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D4561923;
        Mon, 10 May 2021 11:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644901;
        bh=46dDPIUcHdAge07sTTt6Ge+ELHpEmttpkPKsRaehUMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+mkNh8V9cbehnVh5n+Gp2qEqApzEiFKmrqSMs52UjQ645VmHw8cED2K7xepVV3Qj
         uPxgx+WlZ7PYd8EPWQVbDOTpXW0b2Pt+s7mYG8r6Ri18Kpy39xYGnQ55PF7IyeXevQ
         WOoV4FImnUWLDZBvo+I7hse7WkXIXWjD+wH5eMZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 263/384] sched,fair: Alternative sched_slice()
Date:   Mon, 10 May 2021 12:20:52 +0200
Message-Id: <20210510102023.526463927@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 0c2de3f054a59f15e01804b75a04355c48de628c ]

The current sched_slice() seems to have issues; there's two possible
things that could be improved:

 - the 'nr_running' used for __sched_period() is daft when cgroups are
   considered. Using the RQ wide h_nr_running seems like a much more
   consistent number.

 - (esp) cgroups can slice it real fine, which makes for easy
   over-scheduling, ensure min_gran is what the name says.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210412102001.611897312@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c     | 12 +++++++++++-
 kernel/sched/features.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d89ddacc1148..0eeeeeb66f33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -682,7 +682,13 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
+	unsigned int nr_running = cfs_rq->nr_running;
+	u64 slice;
+
+	if (sched_feat(ALT_PERIOD))
+		nr_running = rq_of(cfs_rq)->cfs.h_nr_running;
+
+	slice = __sched_period(nr_running + !se->on_rq);
 
 	for_each_sched_entity(se) {
 		struct load_weight *load;
@@ -699,6 +705,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 		slice = __calc_delta(slice, se->load.weight, load);
 	}
+
+	if (sched_feat(BASE_SLICE))
+		slice = max(slice, (u64)sysctl_sched_min_granularity);
+
 	return slice;
 }
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 1bc2b158fc51..e911111df83a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -90,3 +90,6 @@ SCHED_FEAT(WA_BIAS, true)
  */
 SCHED_FEAT(UTIL_EST, true)
 SCHED_FEAT(UTIL_EST_FASTUP, true)
+
+SCHED_FEAT(ALT_PERIOD, true)
+SCHED_FEAT(BASE_SLICE, true)
-- 
2.30.2



