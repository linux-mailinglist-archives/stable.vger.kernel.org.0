Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993A96B0E58
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjCHQQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCHQQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:16:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6660F5FA5A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:17 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t15so15908991wrz.7
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=539hZgZAmhl24JYVqPCSlddjtJpaxw03+Khwclt5v2Rlp/Ft/rLqSEv/4t8Qm2AsLp
         cuw49kzjeD/Hm1HU9d6PmWZ+kJl0697M2RQ6bMlzCpvUHYEZfW3K6ATzAxjUeBDtBwkv
         fPrpkfWcwHSub6BRuxxyMwX373LU7/jKEx771JTOQBZiFf121+Y8x2He/NUcSRY6zB2j
         IZbknWBiiSMQZM5YI4aZs8kCMHdCWM2zgPwA0W12M276siGlos+iVday4kqPma+jC3Rm
         Ww6xvhX1cUWFc/0M0dxveM2Z2ihQE53n2HVtUw02HWD6c1J04vKzA+1VAPZKZ6tkha27
         K5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=JaGGfBh99Tam3gCq5xveD2YPUXdoY9WjUTFZEjbvvz1c1/RvYBIrtR0Zot9z20RZk4
         oPENQvhP88V30Ga+ivTMPTWMlD28tvdgzR+gvA8FdATJFsX1sePdn2c6CTO9owgrg6Po
         wuFw3FBHiGiw1x5PEzDJyn6pS9X7D29eUP5yNMjfFCxtJSeigOnVe5FTi20l71INSlgy
         xqhGe0TPJ7FZrkGRLD9+6sYt6ERAiaXb5d/qPWuGLdTgZiSwoePkHFFx+TJthzacd8BQ
         +2Yli9bis47/27ssmSNwXcLIpswr5m1I7t1zy2Hf87QBEb/JZW8LE3Y82slKecjjBhDV
         1sYA==
X-Gm-Message-State: AO0yUKWyOoev2OC3+Re/s/wCJ+8oFrAmBVC9Bj2NlCOdQ8z4bVEm5a83
        5Sz8mG/C6xdTJC+RpeRf5civbLYfnwy3DIyPYME=
X-Google-Smtp-Source: AK7set9/fnV/SQ3APi7tjnVobKQ/siqHU3f3Ktf8tEMxy2lrXZwTRq+PyHBJ2c0jfSwwRzcBWACdkw==
X-Received: by 2002:a5d:45d0:0:b0:2c5:54a7:3630 with SMTP id b16-20020a5d45d0000000b002c554a73630mr12953586wrs.46.1678292175856;
        Wed, 08 Mar 2023 08:16:15 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:15 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 01/10] sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:15:49 +0000
Message-Id: <20230308161558.2882972-2-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
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

commit b48e16a69792b5dc4a09d6807369d11b2970cc36 upstream.

So that the new uclamp rules in regard to migration margin and capacity
pressure are taken into account correctly.

Fixes: a7008c07a568 ("sched/fair: Make task_fits_capacity() consider uclamp restrictions")
Co-developed-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-3-qais.yousef@arm.com
(cherry picked from commit b48e16a69792b5dc4a09d6807369d11b2970cc36)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c  | 26 ++++++++++++++++----------
 kernel/sched/sched.h |  9 +++++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c39d2fc3f994..de7e81cbfed2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4197,10 +4197,12 @@ static inline int util_fits_cpu(unsigned long util,
 	return fits;
 }
 
-static inline int task_fits_capacity(struct task_struct *p,
-				     unsigned long capacity)
+static inline int task_fits_cpu(struct task_struct *p, int cpu)
 {
-	return fits_capacity(uclamp_task_util(p), capacity);
+	unsigned long uclamp_min = uclamp_eff_value(p, UCLAMP_MIN);
+	unsigned long uclamp_max = uclamp_eff_value(p, UCLAMP_MAX);
+	unsigned long util = task_util_est(p);
+	return util_fits_cpu(util, uclamp_min, uclamp_max, cpu);
 }
 
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
@@ -4213,7 +4215,7 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 		return;
 	}
 
-	if (task_fits_capacity(p, capacity_of(cpu_of(rq)))) {
+	if (task_fits_cpu(p, cpu_of(rq))) {
 		rq->misfit_task_load = 0;
 		return;
 	}
@@ -7898,7 +7900,7 @@ static int detach_tasks(struct lb_env *env)
 
 		case migrate_misfit:
 			/* This is not a misfit task */
-			if (task_fits_capacity(p, capacity_of(env->src_cpu)))
+			if (task_fits_cpu(p, env->src_cpu))
 				goto next;
 
 			env->imbalance = 0;
@@ -8840,6 +8842,10 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 
 	memset(sgs, 0, sizeof(*sgs));
 
+	/* Assume that task can't fit any CPU of the group */
+	if (sd->flags & SD_ASYM_CPUCAPACITY)
+		sgs->group_misfit_task_load = 1;
+
 	for_each_cpu(i, sched_group_span(group)) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
@@ -8859,12 +8865,12 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 		if (!nr_running && idle_cpu_without(i, p))
 			sgs->idle_cpus++;
 
-	}
+		/* Check if task fits in the CPU */
+		if (sd->flags & SD_ASYM_CPUCAPACITY &&
+		    sgs->group_misfit_task_load &&
+		    task_fits_cpu(p, i))
+			sgs->group_misfit_task_load = 0;
 
-	/* Check if task fits in the group */
-	if (sd->flags & SD_ASYM_CPUCAPACITY &&
-	    !task_fits_capacity(p, group->sgc->max_capacity)) {
-		sgs->group_misfit_task_load = 1;
 	}
 
 	sgs->group_capacity = group->sgc->capacity;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 12c65628801c..3758f98c068c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2468,6 +2468,15 @@ static inline bool uclamp_is_used(void)
 	return static_branch_likely(&sched_uclamp_used);
 }
 #else /* CONFIG_UCLAMP_TASK */
+static inline unsigned long uclamp_eff_value(struct task_struct *p,
+					     enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
 static inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 				  struct task_struct *p)
-- 
2.25.1

