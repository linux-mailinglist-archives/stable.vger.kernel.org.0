Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8580265784F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiL1OtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiL1OtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:49:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485F111A36
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:49:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D991B61130
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98C1C433D2;
        Wed, 28 Dec 2022 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238948;
        bh=OxOfa36AZ5YA2eM4oPG7ItALw+5O5hz5ifvP9Yugu7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtrtM4aT8ciLNVp8FtsfP0n25/DMhGGdXYr92tEpNSSvdvchNgTVwJhH2fCjHxAIw
         iWZcEd6O6LMp5wCqQ6sJakZ+yjjpToV6Q9jTNK0bFK7i6qI2+ct/bYaC08R4RRjsjq
         Bl5ZZNm088tjYWaiwa+1YQOiO7haNSZAhlwpIx3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/731] sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
Date:   Wed, 28 Dec 2022 15:32:57 +0100
Message-Id: <20221228144258.580227275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit b759caa1d9f667b94727b2ad12589cbc4ce13a82 ]

Use the new util_fits_cpu() to ensure migration margin and capacity
pressure are taken into account correctly when uclamp is being used
otherwise we will fail to consider CPUs as fitting in scenarios where
they should.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-5-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4c71dfae95e..9e2c6e38342c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6498,21 +6498,23 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, bool
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
2.35.1



