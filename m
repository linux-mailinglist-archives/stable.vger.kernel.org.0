Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6BA6E66A0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjDROGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjDROGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:05 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9090A12CB0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v10so8967285wmn.5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826762; x=1684418762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRvzTVIJXV6lk/OJjB1fbt539L+//3d2alB/GLO6Bww=;
        b=IylncqlZcVkBBgRpdLG5DVJTHliebmx++D7Noh7NxSMHcxFmcj6tK9lcRvY1bAKG7+
         56s/Z95SJBsC57sGSRzq5SVB+6AK7vsKB1DfolCgqvbbWosyE4poxXnYJZ6CaDlcOiHS
         XggLsn2JObjCT9FsC7s5QZdrxAXfNthisKeI5JVc96m8hdzz6kBrzDPUzMT1GkgTnJVP
         cdc9spxr58tqYbMHaqzth8rxpWtVp61D6JoweaJ0OPnc5p7YbxqA+zpvvQTfPzlGahm8
         2UR68LYsEmKGssx6MlGiABGIQan3T6XtdX2/nElfvlxsN31gmZOkm+fGB86qOr1/nk1F
         45qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826762; x=1684418762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRvzTVIJXV6lk/OJjB1fbt539L+//3d2alB/GLO6Bww=;
        b=GHurGSbE6x2TYVN3ENVIk39cZFCjBDN80Z2ML31dKDpaisKWqfewVPUeaDsJgf24H9
         6LWMkIZSSNIUwqWPW0f6lLyC6hfkBTcA8zgY6lsg+Qfi7TiHOFrBy2Fz5jVVpOEmZNq8
         9wqbkWJe449nWTYftoW0AZBr04ZubPSSUjtB50pE8L1iJmM7Suhyp7BxPGexoIZ+1p9R
         v8F0zZucT9bVUGt1EC3iOHuL+/exU6TthSM4k47xMki+4E336o6WDrg5RvWgHVY55KwZ
         0CHDrdsBP6SwDqvDJ9KaMXFlwwKPb8D1itZcdBJMsIZMX3QIV8QnWIz5TjmRl2+8xumP
         rdHg==
X-Gm-Message-State: AAQBX9f8fIvL5Homup5KZz/CK1XqinLZyuc6rhuAX9CwYYaejLzjsB4Q
        qTbV5DeFq58T/cCpuIOawnm8vSSRmZJXAegHvzs=
X-Google-Smtp-Source: AKy350YPo3GSLokKRbcn74HGYzWr/r0Z2gB9+tgYkH2Pd+tTZ8yXvkvkwvrF52iJZYTzhZu9bA82rA==
X-Received: by 2002:a05:600c:2141:b0:3f1:7ae0:8256 with SMTP id v1-20020a05600c214100b003f17ae08256mr1410949wml.34.1681826762051;
        Tue, 18 Apr 2023 07:06:02 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:06:01 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 4/7] sched/fair: Detect capacity inversion
Date:   Tue, 18 Apr 2023 15:05:44 +0100
Message-Id: <20230418140547.88035-5-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140547.88035-1-qyousef@layalina.io>
References: <20230418140547.88035-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit 44c7b80bffc3a657a36857098d5d9c49d94e652b upstream.

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
[fix trivial conflict in kernel/sched/sched.h due to code shuffling]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c  | 63 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h | 19 +++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 66939333bdd1..e472f1849092 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8574,16 +8574,73 @@ static unsigned long scale_rt_capacity(int cpu)
 
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 47d40f8ef1b0..6312f1904825 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1003,6 +1003,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct callback_head	*balance_callback;
 
@@ -2993,6 +2994,24 @@ static inline unsigned long capacity_orig_of(int cpu)
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
-- 
2.25.1

