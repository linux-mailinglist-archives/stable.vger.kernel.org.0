Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089616E66BB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDROKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDROKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:04 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996F910269
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:02 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n43-20020a05600c502b00b003f17466a9c1so3130807wmr.2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827001; x=1684419001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qYnf6bG4t/CZsEfkond99dTvRo5PJ1m29yCx2krtwQ=;
        b=rS6YSEt77e/3ayeFtTqKD5Qxkb226H+ChAHE2beahnX+PDjz1LvRnN0efyIdmmqVh2
         oCGrO3g5eFxm/+GHnB+3ppaGq9JALxmhwz+R7Va9chLM/aKIF4DrBFW3k9q5Uk+0rmum
         MW2yr+vm9ReQDiKe5EIGUmov6nRayuE4WXiFdI4Me2qLumbLeUSCcw+yBrDu6D4vRh/X
         o8xySRmn5bhLVRZQiKNI3hx1/K35vZugJylosD5ZR/sd+bhWZp+/cnSQlPlAGMUTqC6D
         4mK7girepDXOx3tvnt/zJYUI/r2ZO89lq5t5UC9QvQ+mxz/Oiflt4RaiQGl0bGoYmj19
         zRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827001; x=1684419001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qYnf6bG4t/CZsEfkond99dTvRo5PJ1m29yCx2krtwQ=;
        b=L/MaPY0fj+filESim0V/hIBXKRdvz20TwfuyiNkwzzV47Bhx5LWNji8hKDGWxj+fN8
         6ePF35Na84xTI0ObyT7CxI4Hx6qXsG94VDrshCPrFSUTjGjin3Ne6UqmAYuhr3pplx/f
         g0l9B08m2SrqjGJlpu8Lf8fNDW1Unawz/QtbYISc3jA5pxvoUits+pyXCzlxD7b7LuJR
         7k43D3zfnFRSgl6OKrzMvm9UDNFNqdsVD3hS1y6YNoAzmc8qerccz4Y/DvPOmgcilCpQ
         qtM9w04NMirTp+hmXZjUSMRo/qI/ITDywPnezhFLXLoSh342QAFrsCLlirfJr3FpSGZZ
         4FZg==
X-Gm-Message-State: AAQBX9ddVuWRD1es/nEFT3j5lPqXxOsit50DQWwhSp/0GdFEZVyYYLXt
        zjorGwMhrzAcJ5hlNPswQMXDRpP7CAScbtCvNoI=
X-Google-Smtp-Source: AKy350ahrifgbn8peUSjmOGHl11rytpEjBgz//PyBKn1Wl/xmTME72IPVhZgSYw1UyjpKy+JVTC2iw==
X-Received: by 2002:a05:600c:2216:b0:3ed:cf2a:3fe8 with SMTP id z22-20020a05600c221600b003edcf2a3fe8mr13979464wml.8.1681827001106;
        Tue, 18 Apr 2023 07:10:01 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:00 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Yun Hsiang <hsiang023167@gmail.com>
Subject: [PATCH v2 RESEND 02/10] sched/uclamp: Fix fits_capacity() check in feec()
Date:   Tue, 18 Apr 2023 15:09:35 +0100
Message-Id: <20230418140943.90621-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit 244226035a1f9b2b6c326e55ae5188fab4f428cb upstream.

As reported by Yun Hsiang [1], if a task has its uclamp_min >= 0.8 * 1024,
it'll always pick the previous CPU because fits_capacity() will always
return false in this case.

The new util_fits_cpu() logic should handle this correctly for us beside
more corner cases where similar failures could occur, like when using
UCLAMP_MAX.

We open code uclamp_rq_util_with() except for the clamp() part,
util_fits_cpu() needs the 'raw' values to be passed to it.

Also introduce uclamp_rq_{set, get}() shorthand accessors to get uclamp
value for the rq. Makes the code more readable and ensures the right
rules (use READ_ONCE/WRITE_ONCE) are respected transparently.

[1] https://lists.linaro.org/pipermail/eas-dev/2020-July/001488.html

Fixes: 1d42509e475c ("sched/fair: Make EAS wakeup placement consider uclamp restrictions")
Reported-by: Yun Hsiang <hsiang023167@gmail.com>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-4-qais.yousef@arm.com
(cherry picked from commit 244226035a1f9b2b6c326e55ae5188fab4f428cb)
[Fix trivial conflict in kernel/sched/fair.c due to new automatic
variables in master vs 5.10]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/core.c  | 10 +++++-----
 kernel/sched/fair.c  | 26 ++++++++++++++++++++++++--
 kernel/sched/sched.h | 42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1303a2607f1f..7c151cf7b7c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -980,7 +980,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
 		return;
 
-	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+	uclamp_rq_set(rq, clamp_id, clamp_value);
 }
 
 static inline
@@ -1158,8 +1158,8 @@ static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
 	if (bucket->tasks == 1 || uc_se->value > bucket->value)
 		bucket->value = uc_se->value;
 
-	if (uc_se->value > READ_ONCE(uc_rq->value))
-		WRITE_ONCE(uc_rq->value, uc_se->value);
+	if (uc_se->value > uclamp_rq_get(rq, clamp_id))
+		uclamp_rq_set(rq, clamp_id, uc_se->value);
 }
 
 /*
@@ -1225,7 +1225,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	if (likely(bucket->tasks))
 		return;
 
-	rq_clamp = READ_ONCE(uc_rq->value);
+	rq_clamp = uclamp_rq_get(rq, clamp_id);
 	/*
 	 * Defensive programming: this should never happen. If it happens,
 	 * e.g. due to future modification, warn and fixup the expected value.
@@ -1233,7 +1233,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	SCHED_WARN_ON(bucket->value > rq_clamp);
 	if (bucket->value >= rq_clamp) {
 		bkt_clamp = uclamp_rq_max_value(rq, clamp_id, uc_se->value);
-		WRITE_ONCE(uc_rq->value, bkt_clamp);
+		uclamp_rq_set(rq, clamp_id, bkt_clamp);
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de7e81cbfed2..642869018e42 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6755,6 +6755,8 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
+	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
+	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	unsigned long cpu_cap, util, base_energy = 0;
 	int cpu, best_energy_cpu = prev_cpu;
@@ -6782,6 +6784,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 	for (; pd; pd = pd->next) {
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
+		unsigned long rq_util_min, rq_util_max;
+		unsigned long util_min, util_max;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
@@ -6805,8 +6809,26 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with schedutil_cpu_util().
 			 */
-			util = uclamp_rq_util_with(cpu_rq(cpu), util, p);
-			if (!fits_capacity(util, cpu_cap))
+			if (uclamp_is_used()) {
+				if (uclamp_rq_is_idle(cpu_rq(cpu))) {
+					util_min = p_util_min;
+					util_max = p_util_max;
+				} else {
+					/*
+					 * Open code uclamp_rq_util_with() except for
+					 * the clamp() part. Ie: apply max aggregation
+					 * only. util_fits_cpu() logic requires to
+					 * operate on non clamped util but must use the
+					 * max-aggregated uclamp_{min, max}.
+					 */
+					rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+					rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+					util_min = max(rq_util_min, p_util_min);
+					util_max = max(rq_util_max, p_util_max);
+				}
+			}
+			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
 
 			/* Always use prev_cpu as a candidate. */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3758f98c068c..d4632e50d8b3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2402,6 +2402,23 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #ifdef CONFIG_UCLAMP_TASK
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
 
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	return READ_ONCE(rq->uclamp[clamp_id].value);
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+	WRITE_ONCE(rq->uclamp[clamp_id].value, value);
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return rq->uclamp_flags & UCLAMP_FLAG_IDLE;
+}
+
 /**
  * uclamp_rq_util_with - clamp @util with @rq and @p effective uclamp values.
  * @rq:		The rq to clamp against. Must not be NULL.
@@ -2437,12 +2454,12 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 		 * Ignore last runnable task's max clamp, as this task will
 		 * reset it. Similarly, no need to read the rq's min clamp.
 		 */
-		if (rq->uclamp_flags & UCLAMP_FLAG_IDLE)
+		if (uclamp_rq_is_idle(rq))
 			goto out;
 	}
 
-	min_util = max_t(unsigned long, min_util, READ_ONCE(rq->uclamp[UCLAMP_MIN].value));
-	max_util = max_t(unsigned long, max_util, READ_ONCE(rq->uclamp[UCLAMP_MAX].value));
+	min_util = max_t(unsigned long, min_util, uclamp_rq_get(rq, UCLAMP_MIN));
+	max_util = max_t(unsigned long, max_util, uclamp_rq_get(rq, UCLAMP_MAX));
 out:
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
@@ -2488,6 +2505,25 @@ static inline bool uclamp_is_used(void)
 {
 	return false;
 }
+
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return false;
+}
 #endif /* CONFIG_UCLAMP_TASK */
 
 #ifdef arch_scale_freq_capacity
-- 
2.25.1

