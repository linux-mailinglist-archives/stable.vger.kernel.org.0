Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820596BFBF2
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCRRkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCRRkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CE22A3E
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:33 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso5118786wmq.5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=7WgmI/gVuom7cCR2D/7qrmk9I7F+Z90/0j2jLqhDAALTNgt58e9qgLAyJ64hrxsPFO
         nyD88tA66eGHbwIYsbKdmHeu77T8qP1C9iy/3LlAsotRpwfcZed2XvuVfo3WTjpnfwq/
         TIUybaFV7MrlNYOgE8086LVaoY2sPiwfCmXnXONUMjdoaBQ4cR1SxjmtGewduwj6CN6y
         MHeO9AlBJEnKEjZWypvrQEuSCDH4fgLc3XiRgs31g4jI1mQ1cDggr+P28NwHpQqDb2UK
         wUJAHxCfdut04BaOiSNHQz0I+zukZLyuc4v4HLPjwng88VGZO3M55n8DTu1PuSeGpX5i
         nRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=HjgQk0Sr8MrCEitAA3V2p7DnDaYm+5ijlaPLErWwcFx7FVrSrDmA/PaWT/YgppNPCZ
         OX1vcVYBXXXNec4EBh4o+QWmrPITjSremwAAw5/o5Met273c4cMeffTojpBC1YejhbNJ
         PojI3DG4xqqSZvUQMssrJFHL65HJe8Tk1Ra2L9XiRRWZKQso9QvZ0+DP3lOUG3hN1wkf
         a1FGVyrCUtTspwtkBl3trj6/+JnrhW80rHOaIz9cO//QQ6zqwJpRjwblpc7ZSUNksHJD
         JEQRDrzkgrbiioNQJz4OdnQcsNN+RtpTFs13S2v8TBXnslQwfewQgZzLHm7E9JQKuFpt
         ac3g==
X-Gm-Message-State: AO0yUKX7ixIsk1G1XKFwnYYqoVirplSc2YAqekaxg1XFaPBPksrWjqxz
        DKJGA/GAszZyvNuqy9RThdCOS/l/mwrZHvCsFmw=
X-Google-Smtp-Source: AK7set8MwzjwFAiLT/4uARrhzEghaa3kmwd22jgTWbHeJ0wnbhYis84SO9qC0lg8KA4w3ljTTo0ARA==
X-Received: by 2002:a05:600c:1e02:b0:3ed:31f5:11e with SMTP id ay2-20020a05600c1e0200b003ed31f5011emr13058182wmb.5.1679161232115;
        Sat, 18 Mar 2023 10:40:32 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:31 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 01/10] sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
Date:   Sat, 18 Mar 2023 17:39:34 +0000
Message-Id: <20230318173943.3188213-2-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
References: <20230318173943.3188213-1-qyousef@layalina.io>
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

