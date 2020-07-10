Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3611021B960
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGJPYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 11:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgGJPYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 11:24:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4C6C08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 08:24:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j18so6580807wmi.3
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ssK+8iLM11qslosSf1j2G0wYl7L4CVX8Ifo/vpqTDIQ=;
        b=FrtYecrJ5Ux8Bb2xvNXWLMKdeSCTBFcqZ62IVxO3EETjjgKNau0aI78KHeFHXroO8g
         tDa9gmjvjjYHtht++RtdJuo5FfhTK8eqA++q3zeIPPXHOK/qZ2pfo88L7+oT6suKjxLs
         PBFah0+fIX9gNI28ehCXzMgLzcD+OvmjDMFsSwDGyXDkkiQRyOMcrOwf7WjWQoaEM5HT
         9AGAjfURfd6aw6W0KDxnaiX0JkmgX6zUiz0JTV+vV9ik2DuBDnNkhoEfLEyYZkPb0cND
         mhE5HAb1UFnn8EheHec94E4X6qSfMtGdR6mnNw1DintDuCPBgbUWYFsU1MFcecdp37UV
         AsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ssK+8iLM11qslosSf1j2G0wYl7L4CVX8Ifo/vpqTDIQ=;
        b=olDjldElQgYCVagAWVLo1+7Izbx7iyRuoPgDiPqkNOSCwfIJdlSxhbvzrG3AMtL2j3
         iuVyaXkkRtLygckcZTHavLRPoJfQr9gyPPiG2RcWQgcOYO/6KMH09PNXeMJd8+xczGc3
         X+vt7f80ZYXw+hniXiK7LAe1Xo6/MCvAYcG7HlfV4EvUJ23ZXTm8gygazSRdc1+/Jp++
         /PzDNFgTy3dDMbS696RdFBTTEEyzhNbjXiBgVqZSExQpDLkfUy+7Vfkhq05V0Tmzz3L/
         6RySu/QYuuFzOrCs87HsuGyJiboAYgXRGr7l6Xs3VGF7baBXeqwEHyVhg/FAfnzxMvbC
         DXFQ==
X-Gm-Message-State: AOAM530PsRq/WCnfszUdGpJTQmnauO+d19NyUoPxw9gl67moZXZqhYnO
        c98rEjPEdrOK6AQuVpw9eaP0Uw==
X-Google-Smtp-Source: ABdhPJy1IkcK+d02lK9Yiiu/N3xEyya1puU9CiIr/AfoqwCcNGhXhnOadBrXZoTy4jkFPzYaFEl5Sg==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr5605806wmh.130.1594394671937;
        Fri, 10 Jul 2020 08:24:31 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:f:6020:3448:acab:4d05:2aee])
        by smtp.gmail.com with ESMTPSA id m10sm10673506wru.4.2020.07.10.08.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 08:24:30 -0700 (PDT)
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Cc:     valentin.schneider@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] sched/fair: handle case of task_h_load() returning 0
Date:   Fri, 10 Jul 2020 17:24:26 +0200
Message-Id: <20200710152426.16981-1-vincent.guittot@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

task_h_load() can return 0 in some situations like running stress-ng
mmapfork, which forks thousands of threads, in a sched group on a 224 cores
system. The load balance doesn't handle this correctly because
env->imbalance never decreases and it will stop pulling tasks only after
reaching loop_max, which can be equal to the number of running tasks of
the cfs. Make sure that imbalance will be decreased by at least 1.

misfit task is the other feature that doesn't handle correctly such
situation although it's probably more difficult to face the problem
because of the smaller number of CPUs and running tasks on heterogenous
system.

We can't simply ensure that task_h_load() returns at least one because it
would imply to handle underflow in other places.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
---

Changes v3:
- Fix warning about cast reported by lkp@intel.com>

 kernel/sched/fair.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b9b9f19e80c1..71a372e3707a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4049,7 +4049,11 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 		return;
 	}
 
-	rq->misfit_task_load = task_h_load(p);
+	/*
+	 * Make sure that misfit_task_load will not be null even if
+	 * task_h_load() returns 0.
+	 */
+	rq->misfit_task_load = max_t(unsigned long, task_h_load(p), 1);
 }
 
 #else /* CONFIG_SMP */
@@ -7648,7 +7652,14 @@ static int detach_tasks(struct lb_env *env)
 
 		switch (env->migration_type) {
 		case migrate_load:
-			load = task_h_load(p);
+			/*
+			 * Depending of the number of CPUs and tasks and the
+			 * cgroup hierarchy, task_h_load() can return a null
+			 * value. Make sure that env->imbalance decreases
+			 * otherwise detach_tasks() will stop only after
+			 * detaching up to loop_max tasks.
+			 */
+			load = max_t(unsigned long, task_h_load(p), 1);
 
 			if (sched_feat(LB_MIN) &&
 			    load < 16 && !env->sd->nr_balance_failed)
-- 
2.17.1

