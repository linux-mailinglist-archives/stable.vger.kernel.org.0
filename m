Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AB46ECECB
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbjDXNf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbjDXNfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4597A9C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B941C62332
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD88C433EF;
        Mon, 24 Apr 2023 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343291;
        bh=WzjqRGY6nXFFFaf7uh7lafQkRYJ4BgoM7BWaZc60UC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1a7N04LrMK6dBqo4QmvF3bae2706iT14/3wBzELWm8JBs8ldV/Mr1aaItEsu0wVlB
         6semZ3QLvbUCifY8r9/h+mTb2Y0v1Bm+2kuGFEVA6G+JQM2h9DZAggT9jX6Lk3QGaN
         IIvfURuUezwvs5SwgueJAmJWbrFEYd2H6nDgigEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 5.10 38/68] sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
Date:   Mon, 24 Apr 2023 15:18:09 +0200
Message-Id: <20230424131129.130371538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6394,21 +6394,23 @@ static int select_idle_cpu(struct task_s
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


