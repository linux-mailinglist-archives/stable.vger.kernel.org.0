Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3EA657A21
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbiL1PIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiL1PIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B413D74
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1AABB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AD0C433F0;
        Wed, 28 Dec 2022 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240086;
        bh=/c9C9mJ9CKkjQftVYdYFu9De2QD1xum/wepONp3i3Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQrlvTJMDKUwIgk+sn/TqJkfxdb0TFW1dQw4ww6Jj19mspNQ2qf2wtdumG2rRdFk9
         i9zShMreZiQuD3i1oOwxPDPGXu03ff07krWY/fhiJoOeHXpef4Rry741d7voSfG8vT
         9MUThVQL2Nrz44LIKWuh80LpcdO9iTCW8IP6e1lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0101/1073] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()s early exit condition
Date:   Wed, 28 Dec 2022 15:28:09 +0100
Message-Id: <20221228144330.791861087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit d81304bc6193554014d4372a01debdf65e1e9a4d ]

If the utilization of the woken up task is 0, we skip the energy
calculation because it has no impact.

But if the task is boosted (uclamp_min != 0) will have an impact on task
placement and frequency selection. Only skip if the util is truly
0 after applying uclamp values.

Change uclamp_task_cpu() signature to avoid unnecessary additional calls
to uclamp_eff_get(). feec() is the only user now.

Fixes: 732cd75b8c920 ("sched/fair: Select an energy-efficient CPU on task wake-up")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-8-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2e782d79e80f..532e6cdf706d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4108,14 +4108,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
-	return clamp(task_util_est(p),
-		     uclamp_eff_value(p, UCLAMP_MIN),
-		     uclamp_eff_value(p, UCLAMP_MAX));
+	return clamp(task_util_est(p), uclamp_min, uclamp_max);
 }
 #else
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
 	return task_util_est(p);
 }
@@ -7029,7 +7031,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	eenv_task_busy_time(&eenv, p, prev_cpu);
-- 
2.35.1



