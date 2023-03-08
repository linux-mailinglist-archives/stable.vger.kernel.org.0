Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435C86B0E65
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjCHQRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjCHQRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:23 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E89B5A8A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:17:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e13so15896333wro.10
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=LoQIlbKrh6yMAU/+S6AS4Ckulq+DydZjeYVI4LDgQ3cwWBwZTt+N8NJ4QNIxjvSM9/
         9jLLkLGZmrnTI89TDS/o9U0BYGfAX+oym/KGvICLrpW7aJBsUbcncjDmo6RQwmO2/hUC
         WQkR3FiUgrLhv33Ftz0JImdV3awfjxHrW3P5z8khu98g9/JIMBFFLi1g8JgtKV4b3HdD
         LUYomEpbdnOVHshAR2sse2/eY3/jgiAepHsw7RiwgBXCCshkOlbNby+Y4qRMZeT7yV7s
         VxQhrOHO/OT0OLUI5+Qfo5vpjHDktfxmzx4yKNgqyzxDfFw20G+pheztl9aQSmbtXxKU
         AgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=Sv2npXzKazvTkI+QMuN68khO5CERXQVMF7GLI7IY84AQKmY2b6tP+fRNM5E4xjejMA
         qQGH9yrD1Hjx4G+AoRSojuutca+/6TDPUyJ9JsLmZ9sZYhHeIrwoMz7ZkEYG4dewSM5t
         h6vUNQ+7qMj8g7VoK1TqcsiTv6EmLnHWNeFlAhhra4uySzQxhMs+pJF77Z9kwgctndTZ
         1LLgiHc63HX6kPjL5SvYdEk6RlOtlEjqeAV7EGrgmOSnIgYxmt46DrX1gENOEU1lhArS
         I1kj/03rzFe4oVPT5i0Jcu1vxnjvAtgVwi6BuEOSL8MIEhaf1DF0OQHQx0fW2HanoQK7
         O2dw==
X-Gm-Message-State: AO0yUKWxAShHXhLPBSl81gDkDptgseztmPUoFbi6fUMJOQO7Nw8TJFxs
        aeeQumMYwF+ZnvzaQ40t1F3TSjEEsvv3Rw478LI=
X-Google-Smtp-Source: AK7set//8QsLT0LZ6OUSp3SzEq0Q6HnGwqnuuCFLJMvuGbo5AOJvLl26mZiw2u47gXORTX6NOzSBZA==
X-Received: by 2002:a5d:678b:0:b0:2c5:5870:b589 with SMTP id v11-20020a5d678b000000b002c55870b589mr12788180wru.14.1678292224718;
        Wed, 08 Mar 2023 08:17:04 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:17:04 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 10/10] sched/fair: Fixes for capacity inversion detection
Date:   Wed,  8 Mar 2023 16:15:58 +0000
Message-Id: <20230308161558.2882972-11-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308161558.2882972-2-qyousef@layalina.io>
References: <20230308161558.2882972-2-qyousef@layalina.io>
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

commit da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.

Traversing the Perf Domains requires rcu_read_lock() to be held and is
conditional on sched_energy_enabled(). Ensure right protections applied.

Also skip capacity inversion detection for our own pd; which was an
error.

Fixes: 44c7b80bffc3 ("sched/fair: Detect capacity inversion")
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-3-qyousef@layalina.io
(cherry picked from commit da07d2f9c153e457e845d4dcfdd13568d71d18a4)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e3910f73ad65..b654c25a26cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8363,16 +8363,23 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	 *   * Thermal pressure will impact all cpus in this perf domain
 	 *     equally.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_energy_enabled()) {
 		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
-		struct perf_domain *pd = rcu_dereference(rq->rd->pd);
+		struct perf_domain *pd;
+
+		rcu_read_lock();
 
+		pd = rcu_dereference(rq->rd->pd);
 		rq->cpu_capacity_inverted = 0;
 
 		for (; pd; pd = pd->next) {
 			struct cpumask *pd_span = perf_domain_span(pd);
 			unsigned long pd_cap_orig, pd_cap;
 
+			/* We can't be inverted against our own pd */
+			if (cpumask_test_cpu(cpu_of(rq), pd_span))
+				continue;
+
 			cpu = cpumask_any(pd_span);
 			pd_cap_orig = arch_scale_cpu_capacity(cpu);
 
@@ -8397,6 +8404,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 				break;
 			}
 		}
+
+		rcu_read_unlock();
 	}
 
 	trace_sched_cpu_capacity_tp(rq);
-- 
2.25.1

