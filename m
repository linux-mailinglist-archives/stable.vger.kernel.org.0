Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815486BFC75
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCRTdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCRTds (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6826618B3E
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m2so7097168wrh.6
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=s8mdU6sEzFxAT9RBDu7QL95HTdTTSg/IjE2rNrhgjRNZXxo7OTLBq777dJ8NlNFHwe
         r372F8xt/He2bs2eBH89BN9rj0kZSLBpZ9uiGHoApvwJJ4Y0PxdEBvE6JU68e74GLj/x
         5PT4udBQ0fKtPdUTnjal7rVgHhJrjZOO9fOpOX61Fflpa3yoxZEvCzSY3PvXK3xKsTFz
         XTtSU9EKm5zicsxP7SvSBPby8OvqRBlDnq3xYIzSIRzZ+z0mUwnWbmttHVnT4lrIGsnI
         796qmENTCVA4+lvgOj+Kl0Je/XqocouvY53KGvs/B2l3CtfYbEGnfLu3pDr3oEFwEMVn
         GHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=p/lN2FCh4vWm6VwSy7tA13/EPQho3TgS0/rCLO36Cm0qpuBCBiwfyEhSdUkP4Kljdy
         dMNW6ZMNlMFiD5cxQNbhN+Cx9Pab4FaYwh/ZX438uBhOw2tFftAO+cO4GkBLKUcbIdTD
         lzlu2i6kRnIiohO9EylvNbJDfR4r+rnN702Iubh22QkWZ93IL0pNHJsm//A+l1BJEEzn
         iX+QH6OSqXYcJ3dajtbNDKpCrgwMe/8ndj2kk/w/8Pr34Sj7/IeK0WSMoA4sOYtMCMg3
         6sHWOtZZJPAhLY8CEW5CMGEvg4O3QEuWbHf8SkaqkhYVRFz1rziWt0QWKHc7c6wrumLi
         IJow==
X-Gm-Message-State: AO0yUKUZkT6g7DsX5uvg1GxfTgIDvsjqihEsFpfJcWApm+K55ybiJ59m
        k7jDF4dPXBTCEttb7XFctO7RpbBe3O84zxpts4A=
X-Google-Smtp-Source: AK7set9RNQqPiDb4X0iau3nMPL/yt5KDDK8UfBdcxkPrQ7P1LAGTKEHBM3Mcilkv4zd5SAG/Ac3yBQ==
X-Received: by 2002:a5d:468c:0:b0:2ce:ac31:54fb with SMTP id u12-20020a5d468c000000b002ceac3154fbmr9604742wrq.33.1679168026033;
        Sat, 18 Mar 2023 12:33:46 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:45 -0700 (PDT)
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
Date:   Sat, 18 Mar 2023 19:33:01 +0000
Message-Id: <20230318193302.3194615-7-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318193302.3194615-1-qyousef@layalina.io>
References: <20230318193302.3194615-1-qyousef@layalina.io>
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

