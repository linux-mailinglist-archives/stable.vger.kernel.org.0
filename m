Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DCD6B0E5A
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCHQRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCHQQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:16:58 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A73C1C34
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:34 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e13so15894751wro.10
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=SJ3CQHO+MpEfFqrXYNQh85OFOViP2l4VbIgPzl+4zUroGi2NfxIwgyW6xQ221uWLz2
         96himMTnhayfZZ8MqlaHrCSRrUPKqza2m0Ws4SFI8sN2r+DOGU6cBfmPtOZy9MiW8sD2
         QF1ejdm3qIOi4z1Qjve6pr6Y0zp7f699ivQNS5ReVD68YGEDigtY5QkPL2gasTdIRvMg
         4723YaVqC3kFbdAGSDJaLF7MlL0A4m8xG7ZutlXJY93Rkhh9z6/UYzAhPo7L0TndPUbA
         dyxcKO8XA1k2G2T+SkyQuW83sRRPvY/9SxuKKsLEScGNichnvM/CTFJT7VRKifZEs5fS
         /Nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=p9pUrpR11vnB0VsAVV4kLwKaZpRq6Y7dvhtNJdaWREnxk1DHLFCjwH3QI9fjGAnVWc
         7gTE7VKKSGaBGcSX8wiPvQs3ZINrsina2IKWmHpKX1AgweUIUKcpjwC5xHUgE6AhWcn2
         t4rVeQOFM7um+vMJQSFTGDF+Jh6klD9MFrbGinUcEBg4etHrKpBjC/eJ/ElSjZEtS+fu
         FYiNbBQJKWNwZiB5ZeWLQk1xpmfsIaIBP/w/2QkbisbAbuAIBNiBJe8fuvTvVCiemtyx
         XqGgRFQmh+KMmvsNG0mTvtpP3CZz9W1o5PMEAEp0ftPukLN2sOA4RXsohsj7yfH1+4k/
         b3ow==
X-Gm-Message-State: AO0yUKXiWhqKyHkuZ0fGinXZkbpXgeEJAsNvCEdx/7SPvXVKQ2OaMde5
        ZLyIdetGUs/FP9sXtmc2fXt6c3GsZ1JKgGsHEFg=
X-Google-Smtp-Source: AK7set/0PDPPfVgGuqvDDl27ie7CBneerMtEeilKg99/mgb8xH1h88aRpmA+cUgTDUXN8D9vhSwtaw==
X-Received: by 2002:a5d:452b:0:b0:2c7:56b:863 with SMTP id j11-20020a5d452b000000b002c7056b0863mr12834899wra.10.1678292193283;
        Wed, 08 Mar 2023 08:16:33 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:33 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 03/10] sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:15:51 +0000
Message-Id: <20230308161558.2882972-4-qyousef@layalina.io>
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

