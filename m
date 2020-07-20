Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9393F225A1E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGTIeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 04:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgGTIeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 04:34:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE0DC0619D2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 01:34:10 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f2so16899356wrp.7
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 01:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NQ0TByaTMYGuIND8hZglNUNSd92F891BfsAU17IV3Es=;
        b=T4pO31UmMyzqx2qMpzkFtoXF19ZYw+k2zekVoaJTg9KWSyQR7wqjM5sIhpsYrkhi+Y
         sZtQOwDUt3iffbHLIxLwpS4yX8pYmSVWIlgcwtBtVVH/1mdwHWHtBZLo9sZVwObEDcna
         +rE1aqP4cr0i1kcqEdrlc+9FnNGFI5S15lALJizv4NXARKUdDmo+n4XbrvccZixmOyIj
         l+lpDfOih5/VJoLWBus67FuxgoToWVZdNxrwyXrPe0uS8/AI1yukwTW5ZkYJ4WQQJEA8
         rQ5QWdeeRC7OqPKL10nPa0+XZXk/Yr6sEd68AdmXNTeUF5v0KhGkyQWnQzwxHDJW4gRb
         uSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NQ0TByaTMYGuIND8hZglNUNSd92F891BfsAU17IV3Es=;
        b=jFSAGMrha4VjLvBU42D3smVW7lCrwYdbMaHbiI+vv4B5E2D2162ZGIiI9teo5b2X4t
         IoO8FJFt4BZQzYxt8XPDFbtW/MP3MJHz4NPlXaD3RxuLp8vSMMeXQ60yJx1Bj28oGJlq
         viOH52bNnovUm4PQYdQm4P9hCNR/blK12tTFYPfjKzbJDq+GCnxomluJbTfHTFXfwBm5
         KOas7obSgcg2KenymIdWxldnDk2NKgu+WuhWDu7JVejTIZvsbs/usstyFczlT37SYeS5
         kR2Oyow/HjVhpFyr/rHIZGgXHauPuWJ3d0P9BASsSEV5+Xk83fKugfBL3kc0EEFJPKUT
         fK2Q==
X-Gm-Message-State: AOAM531/3kLXX4OFNhjO1ABG3IkhACs1FCc+dXxtDcnRet0qBj8Zi294
        DQcxSb71kCxiYFr1yIEWCB+JQA==
X-Google-Smtp-Source: ABdhPJyeRmjM6YW4smhNoddhd9H6Ani7/2lNJbdQ2aEYH9cTra5Q7pDpUmKJMR/9CQuCkQ/9g6ou6Q==
X-Received: by 2002:adf:82a5:: with SMTP id 34mr10385755wrc.266.1595234049333;
        Mon, 20 Jul 2020 01:34:09 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:f:6020:7da7:684d:4a8a:3f66])
        by smtp.gmail.com with ESMTPSA id b8sm405707wrv.4.2020.07.20.01.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 01:34:08 -0700 (PDT)
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     valentin.schneider@arm.com, sashal@kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4.19] sched/fair: handle case of task_h_load() returning 0
Date:   Mon, 20 Jul 2020 10:34:01 +0200
Message-Id: <20200720083401.22164-1-vincent.guittot@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01cfcde9c26d8555f0e6e9aea9d6049f87683998 ]

task_h_load() can return 0 in some situations like running stress-ng
mmapfork, which forks thousands of threads, in a sched group on a 224 cores
system. The load balance doesn't handle this correctly because
env->imbalance never decreases and it will stop pulling tasks only after
reaching loop_max, which can be equal to the number of running tasks of
the cfs. Make sure that imbalance will be decreased by at least 1.

We can't simply ensure that task_h_load() returns at least one because it
would imply to handle underflow in other places.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
[removed misfit part which was not implemented yet]
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: <stable@vger.kernel.org> # v4.19 v4.14 v4.9 v4.4
cc: Sasha Levin <sashal@kernel.org>
Link: https://lkml.kernel.org/r/20200710152426.16981-1-vincent.guittot@linaro.org
---

This patch also applies on v4.14.188 v4.9.230 and v4.4.230

 kernel/sched/fair.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 92b1e71f13c8..d8c249e6dcb7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7337,7 +7337,15 @@ static int detach_tasks(struct lb_env *env)
 		if (!can_migrate_task(p, env))
 			goto next;
 
-		load = task_h_load(p);
+		/*
+		 * Depending of the number of CPUs and tasks and the
+		 * cgroup hierarchy, task_h_load() can return a null
+		 * value. Make sure that env->imbalance decreases
+		 * otherwise detach_tasks() will stop only after
+		 * detaching up to loop_max tasks.
+		 */
+		load = max_t(unsigned long, task_h_load(p), 1);
+
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
-- 
2.17.1

