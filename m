Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A296E66C3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjDROKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjDROKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:16 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD07F9EC7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:14 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o9-20020a05600c510900b003f17012276fso4201854wms.4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827013; x=1684419013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=Nl5NN8W8AElnbXzIUaeVbPB7B2MN74TysqLr/qhjeJ5qS45p1bM6OO4vVQrroPuqEj
         TWu+DH/YvPUe3jr65JV6va7pZt3Gk6SbfyB7I+HKKqrzpsd10vqe+XMg1RQxEz8m0quM
         3RijlOAD3J5L6Q1Bud9PV6O0rVg8MmFmcWyupqMtKOtmlwaRLigEX2mv20FkMttew3AP
         qL1o8461ZAa3UFX7qEAB2CvX5ssku86BJ6KIysFcTc8M70DcJUIsSOU64T9DswgAccip
         83Tq1pEPj4RRBk9D9go5LQoSBTTEtIWKJMe+w9aB6d+Le0GjipN2WZvBZvL3hdnxFgXT
         570A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827013; x=1684419013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=ZMFD1txX0r6EiaEdm/T0L+DM/XoBq0iiqfJ5rUhcJOwZaC24tjRMxl6tJl9XWJu29C
         gJ/w9c0iju1eoCtp/7BcICkMAcLd9CLzXnQhXJqa91sQA/s3qnt69PCxbGHc3D9W+edE
         dPh5AkvsIxWzH3D8wvZhRT41j+OpTXH7NGqApm4grcoHyZW+QQ5BIN2OXVkEf9daAL/B
         pD/C95gc6H4BkzVUvqKDm495SCEvnM2ZzVLOjfWqD5z2Jvn9piUzpAD0gAvfh7qEcVEr
         1+tSQMdstDRbhbtmoQgYJjIBthXMnhZ2kfgr7j0l77LG5LHK5lT8nB0aNe+xZwAuEIqr
         yP0A==
X-Gm-Message-State: AAQBX9cpL3mham47/+d2YUeeZ0mWhQR4SpF8A4wIwQ5PCeFNGZebEhIp
        8bS7C3X7Is3gENHZ8sgCg/9AD5qQSTPZ7IwRYyg=
X-Google-Smtp-Source: AKy350ZMRDBd0/qTIJjxGxCeAExEqwUX0/oH5hHc9XioxZr3EZwL6LHbOUhh05mTFWbb6jUAZuAKuQ==
X-Received: by 2002:a05:600c:22c7:b0:3eb:3945:d405 with SMTP id 7-20020a05600c22c700b003eb3945d405mr13807797wmg.38.1681827013471;
        Tue, 18 Apr 2023 07:10:13 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:13 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 RESEND 10/10] sched/fair: Fixes for capacity inversion detection
Date:   Tue, 18 Apr 2023 15:09:43 +0100
Message-Id: <20230418140943.90621-11-qyousef@layalina.io>
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

