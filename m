Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548B46BFBF4
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCRRkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCRRki (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:38 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5C622A3E
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:37 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p16so5065344wmq.5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=e4RQrc4+3TyiGxf7L47k8zc7FuQRt1kKNrtKOV2ck/VBhhLYTQ/bVCRSzwMsKn3agh
         dnblxG2N/jLT7hRDi7ewePDrWBQbd/9qNICqJg230s9J151uwf379/A02ZMx31L7O13P
         F2w+4fcpim9V4wK//rgV/6iyRpMO7xa2gAasKcnVCUs6nhWm4jDVEer0mw3187Yl5lXy
         0gQuRFpXgNygTBEYB4SRzxoi6jaKIDtiEDeNquc9Jt4nFHtOjC3OcZzcDuUlgvEIuB0x
         Dq89v3nJH1DkG7ueaWw/rGs4adESx0eRU7HNh50S3Wzikrrh029fSJ8ihALgKcwb3DX/
         nzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=gEKTViTwfaoQtF5B/ke7a7Z4AT0aCu4WMxkeFbAGvqg0nEWiBM7/s7wE/mulS5QPST
         qpt0gKsrCwppuxpA4se8aNCq6Z+9FcAb2sV+r7ySOOTb0FtMfigkpYm2RgReFrg+pJmq
         mZyteQW01lKL1hj3nl/cxxQBpLaLC6xFuX97n+Q7Kl31rp02RRk5EJk/XFNCHkCUFtjl
         50/7PIb0fetSmgYlXojwmZ1Ytr69MwzLhW5GpLKVgYyG+ZndzHgBkQbgHCaCyod2UbwI
         pKp9rQXIpfugGD2JLZXt4bHnYKWn6+y4WvzIRM0bl/oOnEAthoPZZs13Ktwci3J4oNta
         xTow==
X-Gm-Message-State: AO0yUKUBMuH3roYlbHliMPVaCXMvNRjBafT9mwBoChLfMf7Kq5ICQiSv
        11pgzgXBhjN7cHcJdRndRUM4+ZVXqGlBacQRoas=
X-Google-Smtp-Source: AK7set/pvzogBCcp6OjkBjOX03f29LfAFvXeIoGEPegXJOIhIZlASFgD48kUY1U67f937v5z7SIwWg==
X-Received: by 2002:a05:600c:511c:b0:3ed:2b49:eefc with SMTP id o28-20020a05600c511c00b003ed2b49eefcmr16304052wms.3.1679161236385;
        Sat, 18 Mar 2023 10:40:36 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:35 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 03/10] sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
Date:   Sat, 18 Mar 2023 17:39:36 +0000
Message-Id: <20230318173943.3188213-4-qyousef@layalina.io>
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

From: Qais Yousef <qais.yousef@arm.com>

commit b759caa1d9f667b94727b2ad12589cbc4ce13a82 upstream.

Use the new util_fits_cpu() to ensure migration margin and capacity
pressure are taken into account correctly when uclamp is being used
otherwise we will fail to consider CPUs as fitting in scenarios where
they should.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-5-qais.yousef@arm.com
(cherry picked from commit b759caa1d9f667b94727b2ad12589cbc4ce13a82)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 642869018e42..efbd1cdce508 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6347,21 +6347,23 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 static int
 select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 {
-	unsigned long task_util, best_cap = 0;
+	unsigned long task_util, util_min, util_max, best_cap = 0;
 	int cpu, best_cpu = -1;
 	struct cpumask *cpus;
 
 	cpus = this_cpu_cpumask_var_ptr(select_idle_mask);
 	cpumask_and(cpus, sched_domain_span(sd), p->cpus_ptr);
 
-	task_util = uclamp_task_util(p);
+	task_util = task_util_est(p);
+	util_min = uclamp_eff_value(p, UCLAMP_MIN);
+	util_max = uclamp_eff_value(p, UCLAMP_MAX);
 
 	for_each_cpu_wrap(cpu, cpus, target) {
 		unsigned long cpu_cap = capacity_of(cpu);
 
 		if (!available_idle_cpu(cpu) && !sched_idle_cpu(cpu))
 			continue;
-		if (fits_capacity(task_util, cpu_cap))
+		if (util_fits_cpu(task_util, util_min, util_max, cpu))
 			return cpu;
 
 		if (cpu_cap > best_cap) {
-- 
2.25.1

