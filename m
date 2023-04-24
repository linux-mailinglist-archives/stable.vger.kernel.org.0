Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D102C6ECE03
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjDXN2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjDXN2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653256E89
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9BC61FB5
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAB1C4339B;
        Mon, 24 Apr 2023 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342890;
        bh=DvPSthoJ9vx6XXVbH8gClTBPobJidZlJ1R9E9vo00Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzUthmRKjGT0brfKoKGgq0X4n4GdAy+T0m7B2+WbXGTtw5N639hQW8RA7Dp1e7GXj
         StI6x39e7lZfAMDTqyfzV6jqBn27EWPNSAeHss4mXGIJGrbvqWX7VF/0KwfZbjB+6V
         yaRRuUFG4050Y7S8XodVATVhfSzKGvpdCwnuEy6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 6.1 79/98] sched/fair: Detect capacity inversion
Date:   Mon, 24 Apr 2023 15:17:42 +0200
Message-Id: <20230424131136.927856147@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit: 44c7b80bffc3a657a36857098d5d9c49d94e652b upstream.

Check each performance domain to see if thermal pressure is causing its
capacity to be lower than another performance domain.

We assume that each performance domain has CPUs with the same
capacities, which is similar to an assumption made in energy_model.c

We also assume that thermal pressure impacts all CPUs in a performance
domain equally.

If there're multiple performance domains with the same capacity_orig, we
will trigger a capacity inversion if the domain is under thermal
pressure.

The new cpu_in_capacity_inversion() should help users to know when
information about capacity_orig are not reliable and can opt in to use
the inverted capacity as the 'actual' capacity_orig.

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-9-qais.yousef@arm.com
(cherry picked from commit 44c7b80bffc3a657a36857098d5d9c49d94e652b)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c  |   63 ++++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h |   19 +++++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8866,16 +8866,73 @@ static unsigned long scale_rt_capacity(i
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
+	unsigned long capacity_orig = arch_scale_cpu_capacity(cpu);
 	unsigned long capacity = scale_rt_capacity(cpu);
 	struct sched_group *sdg = sd->groups;
+	struct rq *rq = cpu_rq(cpu);
 
-	cpu_rq(cpu)->cpu_capacity_orig = arch_scale_cpu_capacity(cpu);
+	rq->cpu_capacity_orig = capacity_orig;
 
 	if (!capacity)
 		capacity = 1;
 
-	cpu_rq(cpu)->cpu_capacity = capacity;
-	trace_sched_cpu_capacity_tp(cpu_rq(cpu));
+	rq->cpu_capacity = capacity;
+
+	/*
+	 * Detect if the performance domain is in capacity inversion state.
+	 *
+	 * Capacity inversion happens when another perf domain with equal or
+	 * lower capacity_orig_of() ends up having higher capacity than this
+	 * domain after subtracting thermal pressure.
+	 *
+	 * We only take into account thermal pressure in this detection as it's
+	 * the only metric that actually results in *real* reduction of
+	 * capacity due to performance points (OPPs) being dropped/become
+	 * unreachable due to thermal throttling.
+	 *
+	 * We assume:
+	 *   * That all cpus in a perf domain have the same capacity_orig
+	 *     (same uArch).
+	 *   * Thermal pressure will impact all cpus in this perf domain
+	 *     equally.
+	 */
+	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
+		struct perf_domain *pd = rcu_dereference(rq->rd->pd);
+
+		rq->cpu_capacity_inverted = 0;
+
+		for (; pd; pd = pd->next) {
+			struct cpumask *pd_span = perf_domain_span(pd);
+			unsigned long pd_cap_orig, pd_cap;
+
+			cpu = cpumask_any(pd_span);
+			pd_cap_orig = arch_scale_cpu_capacity(cpu);
+
+			if (capacity_orig < pd_cap_orig)
+				continue;
+
+			/*
+			 * handle the case of multiple perf domains have the
+			 * same capacity_orig but one of them is under higher
+			 * thermal pressure. We record it as capacity
+			 * inversion.
+			 */
+			if (capacity_orig == pd_cap_orig) {
+				pd_cap = pd_cap_orig - thermal_load_avg(cpu_rq(cpu));
+
+				if (pd_cap > inv_cap) {
+					rq->cpu_capacity_inverted = inv_cap;
+					break;
+				}
+			} else if (pd_cap_orig > inv_cap) {
+				rq->cpu_capacity_inverted = inv_cap;
+				break;
+			}
+		}
+	}
+
+	trace_sched_cpu_capacity_tp(rq);
 
 	sdg->sgc->capacity = capacity;
 	sdg->sgc->min_capacity = capacity;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1041,6 +1041,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct balance_callback *balance_callback;
 
@@ -2878,6 +2879,24 @@ static inline unsigned long capacity_ori
 	return cpu_rq(cpu)->cpu_capacity_orig;
 }
 
+/*
+ * Returns inverted capacity if the CPU is in capacity inversion state.
+ * 0 otherwise.
+ *
+ * Capacity inversion detection only considers thermal impact where actual
+ * performance points (OPPs) gets dropped.
+ *
+ * Capacity inversion state happens when another performance domain that has
+ * equal or lower capacity_orig_of() becomes effectively larger than the perf
+ * domain this CPU belongs to due to thermal pressure throttling it hard.
+ *
+ * See comment in update_cpu_capacity().
+ */
+static inline unsigned long cpu_in_capacity_inversion(int cpu)
+{
+	return cpu_rq(cpu)->cpu_capacity_inverted;
+}
+
 /**
  * enum cpu_util_type - CPU utilization type
  * @FREQUENCY_UTIL:	Utilization used to select frequency


