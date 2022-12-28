Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C908657A7F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiL1PMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiL1PL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:11:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED5713E31
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26B3BB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F5CC433EF;
        Wed, 28 Dec 2022 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240301;
        bh=IcD1/66TizuD1aJVR30xqz3sj08V6WndN0jLJnwfLrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shqw9+ILWCOx9S4SqOTiecvZv3hr3eK2yWEf9FQZ4BdHWO1wkaOg1uAFadmMDdWKn
         hy8kG41Dn1/iNKevyqsrtOfClQ4zMPM5PADNvpRn1VLYYwUYx/HnFiewtA7GQ8cPBM
         c0JU1PuphTZPHG7qtE6l0k7uEeU5M9zRgIezwKb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0106/1146] sched/uclamp: Fix relationship between uclamp and migration margin
Date:   Wed, 28 Dec 2022 15:27:25 +0100
Message-Id: <20221228144333.027069786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 48d5e9daa8b767e75ed9421665b037a49ce4bc04 ]

fits_capacity() verifies that a util is within 20% margin of the
capacity of a CPU, which is an attempt to speed up upmigration.

But when uclamp is used, this 20% margin is problematic because for
example if a task is boosted to 1024, then it will not fit on any CPU
according to fits_capacity() logic.

Or if a task is boosted to capacity_orig_of(medium_cpu). The task will
end up on big instead on the desired medium CPU.

Similar corner cases exist for uclamp and usage of capacity_of().
Slightest irq pressure on biggest CPU for example will make a 1024
boosted task look like it can't fit.

What we really want is for uclamp comparisons to ignore the migration
margin and capacity pressure, yet retain them for when checking the
_actual_ util signal.

For example, task p:

	p->util_avg = 300
	p->uclamp[UCLAMP_MIN] = 1024

Will fit a big CPU. But

	p->util_avg = 900
	p->uclamp[UCLAMP_MIN] = 1024

will not, this should trigger overutilized state because the big CPU is
now *actually* being saturated.

Similar reasoning applies to capping tasks with UCLAMP_MAX. For example:

	p->util_avg = 1024
	p->uclamp[UCLAMP_MAX] = capacity_orig_of(medium_cpu)

Should fit the task on medium cpus without triggering overutilized
state.

Inlined comments expand more on desired behavior in more scenarios.

Introduce new util_fits_cpu() function which encapsulates the new logic.
The new function is not used anywhere yet, but will be used to update
various users of fits_capacity() in later patches.

Fixes: af24bde8df202 ("sched/uclamp: Add uclamp support to energy_compute()")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-2-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 123 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e4a0b8bd941c..0d193ef03730 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4426,6 +4426,129 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_se_tp(&p->se);
 }
 
+static inline int util_fits_cpu(unsigned long util,
+				unsigned long uclamp_min,
+				unsigned long uclamp_max,
+				int cpu)
+{
+	unsigned long capacity_orig, capacity_orig_thermal;
+	unsigned long capacity = capacity_of(cpu);
+	bool fits, uclamp_max_fits;
+
+	/*
+	 * Check if the real util fits without any uclamp boost/cap applied.
+	 */
+	fits = fits_capacity(util, capacity);
+
+	if (!uclamp_is_used())
+		return fits;
+
+	/*
+	 * We must use capacity_orig_of() for comparing against uclamp_min and
+	 * uclamp_max. We only care about capacity pressure (by using
+	 * capacity_of()) for comparing against the real util.
+	 *
+	 * If a task is boosted to 1024 for example, we don't want a tiny
+	 * pressure to skew the check whether it fits a CPU or not.
+	 *
+	 * Similarly if a task is capped to capacity_orig_of(little_cpu), it
+	 * should fit a little cpu even if there's some pressure.
+	 *
+	 * Only exception is for thermal pressure since it has a direct impact
+	 * on available OPP of the system.
+	 *
+	 * We honour it for uclamp_min only as a drop in performance level
+	 * could result in not getting the requested minimum performance level.
+	 *
+	 * For uclamp_max, we can tolerate a drop in performance level as the
+	 * goal is to cap the task. So it's okay if it's getting less.
+	 *
+	 * In case of capacity inversion, which is not handled yet, we should
+	 * honour the inverted capacity for both uclamp_min and uclamp_max all
+	 * the time.
+	 */
+	capacity_orig = capacity_orig_of(cpu);
+	capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
+
+	/*
+	 * We want to force a task to fit a cpu as implied by uclamp_max.
+	 * But we do have some corner cases to cater for..
+	 *
+	 *
+	 *                                 C=z
+	 *   |                             ___
+	 *   |                  C=y       |   |
+	 *   |_ _ _ _ _ _ _ _ _ ___ _ _ _ | _ | _ _ _ _ _  uclamp_max
+	 *   |      C=x        |   |      |   |
+	 *   |      ___        |   |      |   |
+	 *   |     |   |       |   |      |   |    (util somewhere in this region)
+	 *   |     |   |       |   |      |   |
+	 *   |     |   |       |   |      |   |
+	 *   +----------------------------------------
+	 *         cpu0        cpu1       cpu2
+	 *
+	 *   In the above example if a task is capped to a specific performance
+	 *   point, y, then when:
+	 *
+	 *   * util = 80% of x then it does not fit on cpu0 and should migrate
+	 *     to cpu1
+	 *   * util = 80% of y then it is forced to fit on cpu1 to honour
+	 *     uclamp_max request.
+	 *
+	 *   which is what we're enforcing here. A task always fits if
+	 *   uclamp_max <= capacity_orig. But when uclamp_max > capacity_orig,
+	 *   the normal upmigration rules should withhold still.
+	 *
+	 *   Only exception is when we are on max capacity, then we need to be
+	 *   careful not to block overutilized state. This is so because:
+	 *
+	 *     1. There's no concept of capping at max_capacity! We can't go
+	 *        beyond this performance level anyway.
+	 *     2. The system is being saturated when we're operating near
+	 *        max capacity, it doesn't make sense to block overutilized.
+	 */
+	uclamp_max_fits = (capacity_orig == SCHED_CAPACITY_SCALE) && (uclamp_max == SCHED_CAPACITY_SCALE);
+	uclamp_max_fits = !uclamp_max_fits && (uclamp_max <= capacity_orig);
+	fits = fits || uclamp_max_fits;
+
+	/*
+	 *
+	 *                                 C=z
+	 *   |                             ___       (region a, capped, util >= uclamp_max)
+	 *   |                  C=y       |   |
+	 *   |_ _ _ _ _ _ _ _ _ ___ _ _ _ | _ | _ _ _ _ _ uclamp_max
+	 *   |      C=x        |   |      |   |
+	 *   |      ___        |   |      |   |      (region b, uclamp_min <= util <= uclamp_max)
+	 *   |_ _ _|_ _|_ _ _ _| _ | _ _ _| _ | _ _ _ _ _ uclamp_min
+	 *   |     |   |       |   |      |   |
+	 *   |     |   |       |   |      |   |      (region c, boosted, util < uclamp_min)
+	 *   +----------------------------------------
+	 *         cpu0        cpu1       cpu2
+	 *
+	 * a) If util > uclamp_max, then we're capped, we don't care about
+	 *    actual fitness value here. We only care if uclamp_max fits
+	 *    capacity without taking margin/pressure into account.
+	 *    See comment above.
+	 *
+	 * b) If uclamp_min <= util <= uclamp_max, then the normal
+	 *    fits_capacity() rules apply. Except we need to ensure that we
+	 *    enforce we remain within uclamp_max, see comment above.
+	 *
+	 * c) If util < uclamp_min, then we are boosted. Same as (b) but we
+	 *    need to take into account the boosted value fits the CPU without
+	 *    taking margin/pressure into account.
+	 *
+	 * Cases (a) and (b) are handled in the 'fits' variable already. We
+	 * just need to consider an extra check for case (c) after ensuring we
+	 * handle the case uclamp_min > uclamp_max.
+	 */
+	uclamp_min = min(uclamp_min, uclamp_max);
+	if (util < uclamp_min && capacity_orig != SCHED_CAPACITY_SCALE)
+		fits = fits && (uclamp_min <= capacity_orig_thermal);
+
+	return fits;
+}
+
 static inline int task_fits_capacity(struct task_struct *p,
 				     unsigned long capacity)
 {
-- 
2.35.1



