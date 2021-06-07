Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B591639DE30
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGOAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 10:00:20 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:31483 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230302AbhFGOAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 10:00:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yang.wei@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UbemBfZ_1623074283;
Received: from localhost(mailfrom:yang.wei@linux.alibaba.com fp:SMTPD_---0UbemBfZ_1623074283)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 21:58:16 +0800
From:   Yang Wei <yang.wei@linux.alibaba.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Yang Wei <yang.wei@linux.alibaba.com>,
        Yang Wei <albin.yangwei@alibaba-inc.com>
Subject: [PATCH v2 4.14] sched/fair: Optimize select_idle_cpu
Date:   Mon,  7 Jun 2021 21:58:03 +0800
Message-Id: <1623074283-34764-1-git-send-email-yang.wei@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Jian <cj.chengjian@huawei.com>

commit 60588bfa223ff675b95f866249f90616613fbe31 upstream.

select_idle_cpu() will scan the LLC domain for idle CPUs,
it's always expensive. so the next commit :

    1ad3aaf3fcd2 ("sched/core: Implement new approach to scale select_idle_cpu()")

introduces a way to limit how many CPUs we scan.

But it consume some CPUs out of 'nr' that are not allowed
for the task and thus waste our attempts. The function
always return nr_cpumask_bits, and we can't find a CPU
which our task is allowed to run.

Cpumask may be too big, similar to select_idle_core(), use
per_cpu_ptr 'select_idle_mask' to prevent stack overflow.

Fixes: 1ad3aaf3fcd2 ("sched/core: Implement new approach to scale select_idle_cpu()")
Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20191213024530.28052-1-cj.chengjian@huawei.com
Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
---
 kernel/sched/fair.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81096dd..37ac76d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5779,6 +5779,7 @@ static inline int select_idle_smt(struct task_struct *p, struct sched_domain *sd
  */
 static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int target)
 {
+	struct cpumask *cpus = this_cpu_cpumask_var_ptr(select_idle_mask);
 	struct sched_domain *this_sd;
 	u64 avg_cost, avg_idle;
 	u64 time, cost;
@@ -5809,11 +5810,11 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 
 	time = local_clock();
 
-	for_each_cpu_wrap(cpu, sched_domain_span(sd), target) {
+	cpumask_and(cpus, sched_domain_span(sd), &p->cpus_allowed);
+
+	for_each_cpu_wrap(cpu, cpus, target) {
 		if (!--nr)
 			return -1;
-		if (!cpumask_test_cpu(cpu, &p->cpus_allowed))
-			continue;
 		if (idle_cpu(cpu))
 			break;
 	}
-- 
1.8.3.1

