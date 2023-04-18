Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F606E66A2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjDROGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDROGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:08 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C5613840
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id iw7-20020a05600c54c700b003f16fce55b5so4033192wmb.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826765; x=1684418765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=nvmX8p0+Jgqwwe6eLuVVL/ZB1250ynHBJm2boYsg6F0d7TrrFc4y8zsuNh1sPCBwUv
         yVq/WEZ7ZSbUXmSZitQZEqs/wPP5w/Eit7C61cP3m8Mn6m3YflqUeaAtwo9EyZ/EYmLe
         EgxStXjADWgRabCDs3wxbqC+U7GgJj48aIWEfnU/J/bM/bQNVi15qLBVbh2nxWg9lwKE
         2lTjN8rT81Z/v9xXet2ZKBcKRJWHaK+ICSZyIcdgLA15fq5PyEroYfvWixPs0XN73r9W
         zGQzmgX+0QSgmldpvsRgYJK0vkFV9Zl+UqPIboJlK/4tzU/QScd8CtBQhJJqbDNTuUwn
         XVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826765; x=1684418765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=fZ/wG8qKGO6STa0IB6scclmMxR26lRKnYTQbu9mhgxdnOo83tTCUoygQjPZJc935Kz
         wivJzBOTn7CSr2awSWlGkIB73jHsDm0/Qov//Y5plcv6EGgVcq78aPuorG2zTtpciBPn
         TgMG07dBwQBkcwu3op5ffiLKRiHQsDBrvJmkyQYb2h37w8yvg8yaw3RS28aqH0yzb4PJ
         qfkCrzuPycj7A4jhEvrJwlC1a4uDG4azJm5kugGLnbo7d0yJLfLA4vgAqpG8n+/qeZB6
         PQwSKsOgRmuUNWTRWwtc1wxMkYqDD/SaWwQ7dJ+/KKdsoHXR5cwh4vPB2dWnZ9lz93pY
         GD2g==
X-Gm-Message-State: AAQBX9cnCvWYZ5quBhdsahdrXBIfNpIwpTGHRe8FjvSPa4ItbHFU29hT
        xqNpUEtYCH5LfrbaRqEW51hrvdKBGb2JY/Lq0UU=
X-Google-Smtp-Source: AKy350Y7+nfotx4uoipQk4wEXLHsmPRShm6eVm4AepG/Wqb98tfYhutm7Bh4pK7FUn1CJ2q6tDIGBg==
X-Received: by 2002:a1c:6a0d:0:b0:3f1:7364:930e with SMTP id f13-20020a1c6a0d000000b003f17364930emr5806674wmc.4.1681826765323;
        Tue, 18 Apr 2023 07:06:05 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:06:05 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH RESEND 6/7] sched/uclamp: Fix a uninitialized variable warnings
Date:   Tue, 18 Apr 2023 15:05:46 +0100
Message-Id: <20230418140547.88035-7-qyousef@layalina.io>
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

commit e26fd28db82899be71b4b949527373d0a6be1e65 upstream.

Addresses the following warnings:

> config: riscv-randconfig-m031-20221111
> compiler: riscv64-linux-gcc (GCC) 12.1.0
>
> smatch warnings:
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_min'.
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_max'.

Fixes: 244226035a1f ("sched/uclamp: Fix fits_capacity() check in feec()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-2-qyousef@layalina.io
(cherry picked from commit e26fd28db82899be71b4b949527373d0a6be1e65)
[Conflict in kernel/sched/fair.c due to new automatic variables being
added on master vs 5.15]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a9ae621d58cb..1a78a7882868 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6977,14 +6977,16 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long util_min, util_max;
 		bool compute_prev_delta = false;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -7000,24 +7002,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
 			 */
-			if (uclamp_is_used()) {
-				if (uclamp_rq_is_idle(cpu_rq(cpu))) {
-					util_min = p_util_min;
-					util_max = p_util_max;
-				} else {
-					/*
-					 * Open code uclamp_rq_util_with() except for
-					 * the clamp() part. Ie: apply max aggregation
-					 * only. util_fits_cpu() logic requires to
-					 * operate on non clamped util but must use the
-					 * max-aggregated uclamp_{min, max}.
-					 */
-					rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
-					rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
-
-					util_min = max(rq_util_min, p_util_min);
-					util_max = max(rq_util_max, p_util_max);
-				}
+			if (uclamp_is_used() && !uclamp_rq_is_idle(rq)) {
+				/*
+				 * Open code uclamp_rq_util_with() except for
+				 * the clamp() part. Ie: apply max aggregation
+				 * only. util_fits_cpu() logic requires to
+				 * operate on non clamped util but must use the
+				 * max-aggregated uclamp_{min, max}.
+				 */
+				rq_util_min = uclamp_rq_get(rq, UCLAMP_MIN);
+				rq_util_max = uclamp_rq_get(rq, UCLAMP_MAX);
+
+				util_min = max(rq_util_min, p_util_min);
+				util_max = max(rq_util_max, p_util_max);
 			}
 			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
-- 
2.25.1

