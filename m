Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FCA6E66BC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjDROKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjDROKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CD883FE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id he13so20606831wmb.2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827002; x=1684419002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=uwi8x/LTOdm04UJk1BYANyv8qTb+RtEjp+ckuUpbNebBmOKO0PboRWkhpedYp80rQT
         mKa3OT6UvE/cj/rD21Jr045ScpS/3C2+OftBkMTHKnsL5Ch/u70jyFhKgh26oIIAEtun
         I8a+GzB4bNajXHgPQWCbhIon6YVBcbfqTzXL6Y10AYiG+KYFTKPs34rR5HmQ7LxQo4Yd
         gZ6Yrm8TrBe/M+86Rmv3MYDqCZX7DYJQpMeM9YmbPit6epdRM0AeMUJR+tWiCl64syJ/
         vJnYhx2t0yaVYF0TeMAW9zcUJ+bQlGjfj+/dPia3k49k2jqqsEsxq0oWja4fGlB6i7uH
         VRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827002; x=1684419002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekao1vbWkoixOB74kYWyyN/3c+WurDIPKF0+QTmzG6o=;
        b=WJNVS3LZMpNX+e7HU2mOVNLOzjyb0lsKFFWRfzwc2+FktbwPa/NArhaApMkcXfysU+
         clKWfiDVkTwVe6TQ/lc6Bf+9OsOWkhJm2nqXGzdGyyx8ufKmuDmMGpYE2HKGka5+Y4/L
         pQoVQkzAav2xG+gcegu+iHtw23v6MHGdVyVVBGa3xzvHXegKCR+huzSispBvzKdYORGD
         lmjaJV8aidgzxWLD9SfRojkbLFemZVvKz/I8VuSNS2f80EexaVPxFK7QK/oztl8HrEOT
         eDKxC3f8Qg5yMduteME6XuNbtzjL/0d+igI9NFxYa1yXWiwC5H0I44kc+nbkPZNtBHx5
         l3iw==
X-Gm-Message-State: AAQBX9f95io/g0KlIVfbpqQg/aSb3eCPg9ebyTLB9eoCBLFi9iXcpI+q
        qC+uaV2tjFzMgCWOOCfTfExSvxZy3fr9OU/C/bY=
X-Google-Smtp-Source: AKy350YM/PfJsT8wpgCtZQayviNbIpCoW6EkYegxWSWdL/m2jZb1XAflWj8NQv6H71+kXOSIN58aCQ==
X-Received: by 2002:a7b:c848:0:b0:3f1:7343:8b49 with SMTP id c8-20020a7bc848000000b003f173438b49mr5329637wml.3.1681827002546;
        Tue, 18 Apr 2023 07:10:02 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:02 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 03/10] sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:09:36 +0100
Message-Id: <20230418140943.90621-4-qyousef@layalina.io>
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

