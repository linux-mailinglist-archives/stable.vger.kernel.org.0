Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344E221B120
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGJIVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJIVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 04:21:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2770FC08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 01:21:14 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r12so4960522wrj.13
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ynM2bWxeTn3B4stC5l/mKdyKaAKd6qyXtb9n0JAnXl4=;
        b=M4hbIimDWHDxIoruPmVjldouGQ0JTd7k2pZVcvJqCY8mySTjJ5pjjutdN2Ii65L4uN
         Kr12V8DVUvNSPBeDsNCkpeI0NfUWGtZ6CCOj2h53ons0CGCJn5kZXuUbgwx8Qku5oYE+
         Oo+ER0fV4J0DB0Lkd/SiZnXUiBmYZ9z505Ln+5+7tosaaPf9cwHD9WwsXhEi/dYhM0Mo
         2NdSx+evdM/1bkqNdeV0qPvKIhi0tfQbmDVK4Eh+HfMleM8eoBg4+kARnj8qzOYwjrEI
         DMS+tV1eAYdvwi5v9Q+UC3i7K0b9jwOXLdDRB4ZHbkdE36mJ+k01jJ/VrEmMwIlV735p
         lRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ynM2bWxeTn3B4stC5l/mKdyKaAKd6qyXtb9n0JAnXl4=;
        b=nu/MLQ/1b2zgiLb97KKiJU0Iz477NKCgMeOmL/5AXGJmM7F/zHdfU+1vRL9w4TD/oL
         /S3Dogk+5bTMGruJA1/CbhjyiDhIb7lCGpHNlQtqJ7Z+O3dic13PsB2TeCMTNifMRV3f
         dNhhmxjzneudwOqMZIgDNcqKm30yO7MbZKtOVKFrKqd5xkKcndXCxKnZTZBqFyab/SsL
         o2rbjjcbhrONNJyV65nR5hxYxeDeUpCukxl3gX91SftWDLdtINk/803OuWKoiEc/rdHo
         wwiaLUsHn07j08Z3yo3v5BcCpsiUL1S4TiRJFdoa68C7ixzxLaYJU9Si1dgayfKqY3kV
         DqGQ==
X-Gm-Message-State: AOAM530Diby1gfSxTakP3jIazMVGrPnwU+QoKkKhbyotlnoNZ18YW5sE
        bHgIwkwBhwtnnw++OigNxbyHNcQgL78=
X-Google-Smtp-Source: ABdhPJzZLZzBvSRLSRAJRsB3jQELprbOVOua3kFEM8pXN4wt4he7YoHxeiwH0kL7aV6pdF08UEO8/g==
X-Received: by 2002:adf:de12:: with SMTP id b18mr71994886wrm.390.1594369272647;
        Fri, 10 Jul 2020 01:21:12 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:f:6020:5569:1070:a96a:6ac])
        by smtp.gmail.com with ESMTPSA id q3sm7939260wmq.22.2020.07.10.01.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 01:21:11 -0700 (PDT)
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Cc:     valentin.schneider@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] sched/fair: handle case of task_h_load() returning 0
Date:   Fri, 10 Jul 2020 10:21:05 +0200
Message-Id: <20200710082105.3809-1-vincent.guittot@linaro.org>
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

Changes v2:
- use max() instead of adding 1
- add review and tested tag

 kernel/sched/fair.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b9b9f19e80c1..ffd23caa5799 100644
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
+	rq->misfit_task_load = max(task_h_load(p), 1);
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
+			load = max(task_h_load(p), 1);
 
 			if (sched_feat(LB_MIN) &&
 			    load < 16 && !env->sd->nr_balance_failed)
-- 
2.17.1

