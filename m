Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C514C6BFBFD
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCRRlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCRRkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99272222EE
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g18so5094268wmk.0
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=O0TecA5aW4OcQPOve6ygwHK8n/9HViqRpllwaOG/lsmZ8xqApzRLCnqGZqOyxyAXjy
         UbQwOkdeu1h4A9Zl2gnU8xsEZCRpxU6YyR1j4akTp7QNJ4O1XsQqxV8hbr1R6zZ7nbv5
         5cxUWJuUhxmJQ/VziiYrhhXNrLEIGf5Jd/HBbys8/aArcxC2zmToCO4slXqYGeGlCK4J
         px3kyBPiTDX+yGE8j1UspgpRFv4dKmYbwCt8O8WCSJYCuGD7IKBCw4IZ9uER9OmsZVzj
         /bBuSbS1b9TzX7YDxe0ZvUlYIAZ7/ZrQacWskhAIUKCpaUzSwbKRxScsJDrwaHW9+Wlb
         WGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGsgs47Kr7ZwyoxklfVRa+MrwFYXpxfnAT45sy1HJBg=;
        b=5iliyaT6vGLUfFPoDgeoJJP71TiBTvKHWKVbjWEmK7YS2AUXvi1w22363DoAH6IRey
         x67h/PR5UghgWLEiua3ukprgwvyLefr/9pUworJhPc8KlXw0YWOlGXkbfzD8EEgGrX2i
         UFeH+7Iwg4Gm691FwbbVZ9QS9fLkggD+9pQJq6RO4e8G1Pxux4fITa/fMgrZER+sxib7
         5yqRmWpGbcvB7twTgWznOEfsrZ/ZSHzN+i1sw4s+6KxiEFAeJ/jRmLUKTnDe7LUTuDW+
         f3spuHWC0b0E0FVntPPyF5cEnVLLR5xpVQfcAf1dN27ImOBDD4nWqfHyQIiswTPbHwBr
         9jzA==
X-Gm-Message-State: AO0yUKXThWwIuAavfSJpfwh2hw2ii3G7vqP0OCxf3l3OFr2B5dQNqjcQ
        ++J+Yrq8g29T3IznY2SJgMoged0DdWQPEcGfJp4=
X-Google-Smtp-Source: AK7set+2/HQr1DrwiL/iNWCzDFaNu2TE09Ittn2gAWX78oyjInI4zMurDFoaGPHbN+z7yw29cIljjw==
X-Received: by 2002:a05:600c:a46:b0:3ed:276d:81a4 with SMTP id c6-20020a05600c0a4600b003ed276d81a4mr19836816wmq.32.1679161249204;
        Sat, 18 Mar 2023 10:40:49 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:48 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 10/10] sched/fair: Fixes for capacity inversion detection
Date:   Sat, 18 Mar 2023 17:39:43 +0000
Message-Id: <20230318173943.3188213-11-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
References: <20230318173943.3188213-1-qyousef@layalina.io>
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

