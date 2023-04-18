Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD06E66C2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjDROKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDROKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:14 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5366783FE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f0a0c4e1ebso25392525e9.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827012; x=1684419012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=uX0Z3CiahNWDyx79fLd2qGc+u7W8AnxJ738m8EERABRKceu1xMF+/yJ45EGrOB2NeP
         BIkT6DNuZZmkAg6KX9Rz8ouq7OOwuFeRizEXTM9k1A4FPDicxiDbU0ChV6UYeSxwOc3y
         Mj1TnJEZZiQRhdKd+o16gv9GIiUKs5DNuE+vxwnt+skmcC+leqdCdQOhAGY+c2qVa4J/
         yUrIq2UHNHEM79ehwakBYh0FlHxHgr4xDTQm6i6/c5jDHWDKhHRsFAUCCqiM0JLi0ZNQ
         KPDAlR+swX41BR6jZ/zR3SW6+94TBtalI+eQtMFeFHee4B+pMguZhEXQJEIYKPGIEOb9
         Nk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827012; x=1684419012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=lX9URGgZQypdN5SRDGXsOM4qCXnD1AJhqrdhD5i1XRgp5saRUqtbwC3KIytUZBserm
         WZB9KLyRPvecHthSbpqAraLDMKA8UolQTgxmElrqcpGr/artXKlTutxSnhMqwE64EJ5B
         Vur/mhv3lRX8oUPn9l2veG/LJ/yU58X8kvYCCBYNCEJJUiGAKKzN9JeT665y6Urx14gO
         2HG3eUjptVKxOyUkjCa9ht19Y1ciEQ7dgJSJq/dFnnMwHbL0EzSLwvpP63YKRGso6Qp6
         u9cyDWMv69dEs5ippvs+zkcsXoc8SieBW33nX9wshOLwabF/NTYm1iPuuE84paifsfsY
         J7lQ==
X-Gm-Message-State: AAQBX9cZ5OIyLt7se27xhgVbTnvmwmebco5sHVAymuUsKwqF2ku/h5ni
        fvnS1RdJm2pkNhTis5IFGaGA5c3GuL5nEBZR3CI=
X-Google-Smtp-Source: AKy350aP2xMBMrKY4ljFqzoTznpJgTkWZAWAFtnfzaCw4kCEINsupPrSFGp6w7q/YgK+Zl/TYYQC8A==
X-Received: by 2002:a05:6000:47:b0:2f4:a3ea:65d2 with SMTP id k7-20020a056000004700b002f4a3ea65d2mr2252040wrx.57.1681827011918;
        Tue, 18 Apr 2023 07:10:11 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:11 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2 RESEND 09/10] sched/uclamp: Fix a uninitialized variable warnings
Date:   Tue, 18 Apr 2023 15:09:42 +0100
Message-Id: <20230418140943.90621-10-qyousef@layalina.io>
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
[Conflict in kernel/sched/fair.c due to new automatic variable in
master vs 5.10 and new code around for loop]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67db24a7a5f8..e3910f73ad65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6799,9 +6799,9 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long util_min, util_max;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
@@ -6810,6 +6810,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		base_energy += base_energy_pd;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -6825,24 +6827,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with schedutil_cpu_util().
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

