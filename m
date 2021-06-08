Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC563A005C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhFHSmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234674AbhFHSkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D526261351;
        Tue,  8 Jun 2021 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177287;
        bh=pIIGlN9EPcfE33lJxRnT5yrbrIVU1+ivFW8PN9HZ+A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCEfNaNte5AIT705vNBNyw/KDQyyawQhJL7fUyVgo6qaiJDgOC7DOiAbr/AMCOf0x
         rPFwrw8Y068FaBnd2m158hslSHamz33Oyeq3VGoiUvAXcKqu7Y5MDYt7SJjBKgkUb9
         ZD2CaqIqKoCpQVuLqxKSIpj+QNolj6kLsTlEPXBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Jian <cj.chengjian@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Yang Wei <yang.wei@linux.alibaba.com>
Subject: [PATCH 4.19 57/58] sched/fair: Optimize select_idle_cpu
Date:   Tue,  8 Jun 2021 20:27:38 +0200
Message-Id: <20210608175934.158307657@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6154,6 +6154,7 @@ static inline int select_idle_smt(struct
  */
 static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int target)
 {
+	struct cpumask *cpus = this_cpu_cpumask_var_ptr(select_idle_mask);
 	struct sched_domain *this_sd;
 	u64 avg_cost, avg_idle;
 	u64 time, cost;
@@ -6184,11 +6185,11 @@ static int select_idle_cpu(struct task_s
 
 	time = local_clock();
 
-	for_each_cpu_wrap(cpu, sched_domain_span(sd), target) {
+	cpumask_and(cpus, sched_domain_span(sd), &p->cpus_allowed);
+
+	for_each_cpu_wrap(cpu, cpus, target) {
 		if (!--nr)
 			return -1;
-		if (!cpumask_test_cpu(cpu, &p->cpus_allowed))
-			continue;
 		if (available_idle_cpu(cpu))
 			break;
 	}


