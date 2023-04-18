Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1866C6E66A3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDROGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjDROGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:09 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C59C83D4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:08 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso1040827wmo.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826767; x=1684418767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=kEmEm+4WB0Al2ZYlQqliD84V0rGvER8bYwuKnd/5uvspmmheeVfq34Imv7q07CLNs5
         SaqP2PfJi+VgRBiTbbyJ0t8Qe76ge7j/8IQDj/utn0iaijtvRKO6ShcqM7u4lX2abBm8
         TSU9hhZoWv5jsezYcmzUhCQnL5lFxZ1mNgt3SK6q29yqWWUhdQ2tTNCZ0+WJlgomy008
         RlJEaNuzEBryjEIc7eNyaE+E4F0rGnXd+11689p5bpPCrrf/1RXIG7KKu7FiE75SpfHv
         s5WfkXAoynHCyKTbmFyHNIZncS8nyEuQcVbAWMOH/5hHPs4PkrBsXklZqfUdwyggupg9
         mhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826767; x=1684418767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=OpN0gIiX1FZgSq9Z7aAGhqoQ4R2dL4tEZ2WoCozf8ToNvqj99QrUDh79G84w0ohTGM
         frwt+LPEsF50eRh9+4gEKtM/1ZG0BJtV7XUnE+IVk9VdO8wTekkCSgqwgdMHsDUIc7Sl
         Rrvo8vp04aVIYsr1FmtBVTx6nlw2N9uWQ76dHBmQAEUpeQlYyTNEem0HkDuej2CABk6k
         I/BeYxtZl5IJXjIO6f4N2v/e5EgDTMZtz/5cqVVwQ1Wb61bI3feV+cSCvunEYO/LWQXg
         TOL4bhF3xeMHh4uRBHLmRCRGjV4pCxmQKdw+Dw3qGodAnS4kOCwP1P5J+CgIEV4Oh6E0
         XPmw==
X-Gm-Message-State: AAQBX9eIuBoFx8ubZgCmor5OObTKXmDXUM+n/6l4jujMNWoB1fcra6Hv
        1EdTnDbFupLR5UfQVAOSomIUF/0V58d21MqlfIE=
X-Google-Smtp-Source: AKy350Za4R5NwX31KuzpqzX6p4tVXG1mAplZkWYDtKjXZjse9uRk4ORqzDJvtuSokAEEmD9+1x7TPg==
X-Received: by 2002:a05:600c:228b:b0:3f1:718d:a21c with SMTP id 11-20020a05600c228b00b003f1718da21cmr5855030wmf.31.1681826766848;
        Tue, 18 Apr 2023 07:06:06 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:06:06 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH RESEND 7/7] sched/fair: Fixes for capacity inversion detection
Date:   Tue, 18 Apr 2023 15:05:47 +0100
Message-Id: <20230418140547.88035-8-qyousef@layalina.io>
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
index 1a78a7882868..5a050c827113 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8605,16 +8605,23 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
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
 
@@ -8639,6 +8646,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 				break;
 			}
 		}
+
+		rcu_read_unlock();
 	}
 
 	trace_sched_cpu_capacity_tp(rq);
-- 
2.25.1

