Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7BF6E66BA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjDROKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDROKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:02 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B518113866
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so14903549wms.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826999; x=1684418999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=xJsQixJe3V8cj0GJOkgzWwFty6VSXjkAYDQLKSkJmLFmQds+F48htoY2H9AJlZUXgk
         nieOj+qyrvXWsnbclihnK/8MCy2dB6wEZI171DS9u1uvzCbdYGFqFDPtu+1hsSc/eLx/
         43oXkbFtFIMnuYYwXU6CltlMt5qRS9i7RmeIaGW1lPb6S4dmIYDHAdIz2qELisi+sf9a
         yS9Fn6ImyovDxA234er2OabmvGbtQT74bQ3kj2tk+G5jQ+PR3d4xDuO6HbmV6sJkVpRo
         Ej3zEQPs3sRdxmBDk/NfucecPOSn9VbjQCV18VBGulI9KVTb6byol0dFXj0KL/zz5H4Z
         cT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826999; x=1684418999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8V9YSwmWG8n2IxSW6nZDku18nbiFHuZNDpp6hhof7U=;
        b=AnDMAyBbd0gF6q5dSV264xME6L3FnbjGB3nfTs1rBETUBqJh4co1S6wN7S4jedSQZ5
         pSfgSTqAcz7yebgsJXSVTEe84HrN7VOcym7+/N843NL0USbYk1xUoGVQSkCY0t7+tjWx
         KHHCzDWxFqLD2nLk5FE7dtc3AM5r2vJnge/T6S9+IPzU7qO5lTvylr+gY7ElwqfAiaru
         yZabHPL8IMduVz2KZIVA6QVqB4fSCnybnUjJdi+qbjy/1mkuW/MEOAW6bwfbu5bJtqfd
         g9AEezk9YOIWe7pmYo8IgAMiJNItBy7MyM3Q3IHL8zTY72JEwwRiUMvORZrTgCrFq5Fy
         tPJg==
X-Gm-Message-State: AAQBX9fviikP1L5QjPQAOwQxr3WmMzOF4pj7MhrJk8XAkUdk5npaT4YS
        JASwgcXBnjxv6gT4J0z9rTfXkUcm2r21Jv4F7MQ=
X-Google-Smtp-Source: AKy350YDHCMSy9OfHqLkBwk2gIQg29lQe+28M4eqOIlIhXR1Gegs+KKQZznDjBGr8Y0f8Z75FC1MqQ==
X-Received: by 2002:a7b:ce8e:0:b0:3f1:7397:6dd with SMTP id q14-20020a7bce8e000000b003f1739706ddmr5329441wmj.10.1681826999148;
        Tue, 18 Apr 2023 07:09:59 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:09:58 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 01/10] sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:09:34 +0100
Message-Id: <20230418140943.90621-2-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
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

