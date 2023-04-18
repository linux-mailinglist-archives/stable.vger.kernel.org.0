Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC76E6698
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjDROFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDROFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:05:17 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950283D4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:15 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f17ac82ec1so4003675e9.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826714; x=1684418714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/XeuJqfcaMzq/1+zNuKBGfQtMC7yLwDx6QYSIy2riM=;
        b=VU+/xGXpco6a4aNNeXcg5zzYXnMIUGTqpb59Ws6/h06uY7Cj3z5TlPqImK6uXx0kQZ
         G1LkKfCu1KSoZ3z8o7AKet4I4gcUM+LygSsE0reiKV9idcx3Q6yv7rct9MKsRXCj3cl6
         WnqRocgAknxSHeG98/c0DXUCwq1uYs8XjvgJPDG7KVvP5MbAsw0kAtz5ZA08BHl+DO1O
         odhccWyGoVSWHYJUWmeR9es0qbeCEOkYazF94UCVNkq60WZxsTIXP2L2bM/EU3sKA3+X
         v0FWbPVS32D4a5SGtUp1eaKYW69po3ZR/cwnxmN87xSJDCZXUO2Z6KqTGuMiTt3T+rTz
         zr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826714; x=1684418714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/XeuJqfcaMzq/1+zNuKBGfQtMC7yLwDx6QYSIy2riM=;
        b=F+MRYsaos9P1aMwzz/JS8Z865Er99xg33aggyvWLbHfG4ft+vjdgG6qQLwWiDLkLuz
         qkf1jiUe5pje4BfMjpV1+DzMZm8WhKV2PBv7gPMpyXA85cOB0YfKPW6iQ5uwTQycktJi
         NWI7oHKvzXcUoCGlc91BGDkWE/6/Q28j+6RqnssCnLxrUmCO9VK93khYrm/3WL4oG0kI
         AOGi2sLRnH3BnnYLMDc2ftPWDrgKJhsxEtF3ZKOiEwSo5pMWqWgvW2J5dpaZxk+g2AYO
         U6kO3PtvinXHSDMXLaC57I6bXtzMUhGk7QTMUgaUZaW22laVJ+LDt5Xyuc/3fMlNr4WO
         VGqw==
X-Gm-Message-State: AAQBX9djQOVaceWwI3UYGlJSNTcpAbPTTYVMSSya/dOXK769sCNeIY2B
        jch8xhCNQuYnY3t4TzA9V+OPCgDmc0B5ck66uU8=
X-Google-Smtp-Source: AKy350ZuQaO415sPVWndsKqd42tY91Nz7s5A+J0lYZlIZAly1gqM29haT4dApXzuMES9PYNV7xgfWA==
X-Received: by 2002:a5d:6408:0:b0:2ef:b977:ee3a with SMTP id z8-20020a5d6408000000b002efb977ee3amr1950298wru.34.1681826713419;
        Tue, 18 Apr 2023 07:05:13 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d4e90000000b002f2782978d8sm13101943wru.20.2023.04.18.07.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:13 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 1/3] sched/fair: Detect capacity inversion
Date:   Tue, 18 Apr 2023 15:04:52 +0100
Message-Id: <20230418140454.87367-2-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140454.87367-1-qyousef@layalina.io>
References: <20230418140454.87367-1-qyousef@layalina.io>
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
---
 kernel/sched/fair.c  | 63 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h | 19 +++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 88821ab009b3..b53b6f6e56d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8866,16 +8866,73 @@ static unsigned long scale_rt_capacity(int cpu)
 
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
index d6d488e8eb55..5f18460f62f0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1041,6 +1041,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct balance_callback *balance_callback;
 
@@ -2878,6 +2879,24 @@ static inline unsigned long capacity_orig_of(int cpu)
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

