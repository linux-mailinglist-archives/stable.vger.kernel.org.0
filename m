Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E7F6B0E5F
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjCHQRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjCHQRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:04 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84D0C640A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso1686216wmi.4
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpl1fGDFa7NIf4ibt6+6TLsITKYBHH6E6JI05P9cCU8=;
        b=aIh00trmgeTZkSSOH0p4HIyB+S7KdxP/ClE7cZ+P9+evd/2JNfIJi0eQDYS1exHrT1
         CZROJfEbwbhJqYYYuBc8JQPFz3nNYpcF67JAYkhveGsNTrmO2qDBVRJ161BU63IgHNLA
         lSJwStVrq5aq+TSlsBiQvopISqsyCvGysQKPAskPn/83bXxQT1MtriOIpDnbYFqdxh3j
         wGcvM476SSHZWL28854VlSDOsWnyxbpEAtEbYlzHINlV784uRe4jyeNSmuvQ5iPbvE7f
         Q6Ypo9vJleItvTJ7V+1qNBgYIsaJy/XPYPnE9TcvOLAUKC2ZLNWj5flgne82uT1FKjXY
         sMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpl1fGDFa7NIf4ibt6+6TLsITKYBHH6E6JI05P9cCU8=;
        b=mQWyVINv2F69L+99yaqAHaJRAcoUVKVK0hG1Q8yDvCvnollMKJMSPCSJS7iZCiljK9
         lKdYRXdXh3MZs9Woo2tBHxkMt0+wrvE1j6XVUWUFCgXa09ty4nlGtEDFHQ/jg3QqUw2f
         iYgxl6pU+aeOnf7y1u2hs9RGsbtgrarr6L/XUZv+YKaILjdGfLppk3EB2JmgsE5WTbRS
         TDJr6x2JQJkUMjBBVv07bTUlQKR2JftpkFgMTLCoG0a5cVfBAx9Dmjmut9j2amAGbj6d
         jf8DLAbfFPclhiyjwE67ejA+mVXgIAMKQDHmxgmCjzHECKmoz3FlG5Bs65FrLBx9Ffqu
         TboQ==
X-Gm-Message-State: AO0yUKUyLgrycUa0JsqLHFHNu4NV2ng+zB2TnNxafdlyL2q6TXIel328
        S4g4Mohcv6hPEdrxejZ1GOeCSQcn4cq+VmQR4wU=
X-Google-Smtp-Source: AK7set/xlcYNwZG/hunpS9InjaFcIvPfb74sjgJ2nj6PmauK0fjfmVJaprX8G3AiA7wehXsy8xzXow==
X-Received: by 2002:a05:600c:5251:b0:3da:2ba4:b97 with SMTP id fc17-20020a05600c525100b003da2ba40b97mr13544429wmb.19.1678292201986;
        Wed, 08 Mar 2023 08:16:41 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:41 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 07/10] sched/fair: Detect capacity inversion
Date:   Wed,  8 Mar 2023 16:15:55 +0000
Message-Id: <20230308161558.2882972-8-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308161558.2882972-2-qyousef@layalina.io>
References: <20230308161558.2882972-2-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
[Trivial conflict in kernel/sched/fair.c due to code shuffling]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c  | 63 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h | 19 +++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d25c6122e243..b22f6e80ed62 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8332,16 +8332,73 @@ static unsigned long scale_rt_capacity(int cpu)
 
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
index d4632e50d8b3..10b717533f62 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -973,6 +973,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct callback_head	*balance_callback;
 
@@ -2541,6 +2542,24 @@ static inline unsigned long capacity_orig_of(int cpu)
 }
 #endif
 
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
  * enum schedutil_type - CPU utilization type
  * @FREQUENCY_UTIL:	Utilization used to select frequency
-- 
2.25.1

