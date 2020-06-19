Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0A2200EB3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392012AbgFSPKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388839AbgFSPKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B9A20734;
        Fri, 19 Jun 2020 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579419;
        bh=3J//wm36//AEStju1ppLMr4exvv9fdRyG83XN1eX8ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kok5cJU0/ZzmRC9/h/LgyF5td8OxZNRNiCZBCUYhPd5BA2rxDOVIN/YDAq85bhGZZ
         Xgjt+Y7VHh4gLvslQkFD7L6ga83UQAjydZv6NO4LyOEyK0IAGHuFbpgacWBLzIYnyt
         JHD9xe0gleE3YV7zP892s/LgMGiadofUwVXFGINo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Huaixin Chang <changhuaixin@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/261] sched: Defend cfs and rt bandwidth quota against overflow
Date:   Fri, 19 Jun 2020 16:32:12 +0200
Message-Id: <20200619141655.669305317@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huaixin Chang <changhuaixin@linux.alibaba.com>

[ Upstream commit d505b8af58912ae1e1a211fabc9995b19bd40828 ]

When users write some huge number into cpu.cfs_quota_us or
cpu.rt_runtime_us, overflow might happen during to_ratio() shifts of
schedulable checks.

to_ratio() could be altered to avoid unnecessary internal overflow, but
min_cfs_quota_period is less than 1 << BW_SHIFT, so a cutoff would still
be needed. Set a cap MAX_BW for cfs_quota_us and rt_runtime_us to
prevent overflow.

Signed-off-by: Huaixin Chang <changhuaixin@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Link: https://lkml.kernel.org/r/20200425105248.60093-1-changhuaixin@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  |  8 ++++++++
 kernel/sched/rt.c    | 12 +++++++++++-
 kernel/sched/sched.h |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4874e1468279..361cbc2dc966 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7374,6 +7374,8 @@ static DEFINE_MUTEX(cfs_constraints_mutex);
 
 const u64 max_cfs_quota_period = 1 * NSEC_PER_SEC; /* 1s */
 static const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
+/* More than 203 days if BW_SHIFT equals 20. */
+static const u64 max_cfs_runtime = MAX_BW * NSEC_PER_USEC;
 
 static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
@@ -7401,6 +7403,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	if (period > max_cfs_quota_period)
 		return -EINVAL;
 
+	/*
+	 * Bound quota to defend quota against overflow during bandwidth shift.
+	 */
+	if (quota != RUNTIME_INF && quota > max_cfs_runtime)
+		return -EINVAL;
+
 	/*
 	 * Prevent race between setting of cfs_rq->runtime_enabled and
 	 * unthrottle_offline_cfs_rqs().
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7bf917e4d63a..5b04bba4500d 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -9,6 +9,8 @@
 
 int sched_rr_timeslice = RR_TIMESLICE;
 int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;
+/* More than 4 hours if BW_SHIFT equals 20. */
+static const u64 max_rt_runtime = MAX_BW;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
@@ -2513,6 +2515,12 @@ static int tg_set_rt_bandwidth(struct task_group *tg,
 	if (rt_period == 0)
 		return -EINVAL;
 
+	/*
+	 * Bound quota to defend quota against overflow during bandwidth shift.
+	 */
+	if (rt_runtime != RUNTIME_INF && rt_runtime > max_rt_runtime)
+		return -EINVAL;
+
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
 	err = __rt_schedulable(tg, rt_period, rt_runtime);
@@ -2634,7 +2642,9 @@ static int sched_rt_global_validate(void)
 		return -EINVAL;
 
 	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
-		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
+		((sysctl_sched_rt_runtime > sysctl_sched_rt_period) ||
+		 ((u64)sysctl_sched_rt_runtime *
+			NSEC_PER_USEC > max_rt_runtime)))
 		return -EINVAL;
 
 	return 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c7e7481968bf..570659f1c6e2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1889,6 +1889,8 @@ extern void init_dl_rq_bw_ratio(struct dl_rq *dl_rq);
 #define BW_SHIFT		20
 #define BW_UNIT			(1 << BW_SHIFT)
 #define RATIO_SHIFT		8
+#define MAX_BW_BITS		(64 - BW_SHIFT)
+#define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
 unsigned long to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
-- 
2.25.1



