Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6029C34C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821527AbgJ0Roj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902147AbgJ0ObC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D56A220780;
        Tue, 27 Oct 2020 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809061;
        bh=Q7s2e4JccszcPEZZZ2r/6Nif1WeoarCHcmCBLfoWw14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh43uoTkEMP+VrOSW3rmm5+rK5N8zQvKWdE2i5q7O1HvOhrWs2VgZmx4dfrkyt4Kl
         LQabyi0bg8CunDrhBkWftrBK6lVtziKBZvnXtugMJzJX6+6HlSrEmFWrzizqZZESIy
         UalKMHqFPsUbzDsv1Huue4EAMmO7xVMohVu4YEVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wetp Zhang <wetp.zy@linux.alibaba.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/408] sched/fair: Fix wrong cpu selecting from isolated domain
Date:   Tue, 27 Oct 2020 14:50:00 +0100
Message-Id: <20201027135457.942357675@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>

[ Upstream commit df3cb4ea1fb63ff326488efd671ba3c39034255e ]

We've met problems that occasionally tasks with full cpumask
(e.g. by putting it into a cpuset or setting to full affinity)
were migrated to our isolated cpus in production environment.

After some analysis, we found that it is due to the current
select_idle_smt() not considering the sched_domain mask.

Steps to reproduce on my 31-CPU hyperthreads machine:
1. with boot parameter: "isolcpus=domain,2-31"
   (thread lists: 0,16 and 1,17)
2. cgcreate -g cpu:test; cgexec -g cpu:test "test_threads"
3. some threads will be migrated to the isolated cpu16~17.

Fix it by checking the valid domain mask in select_idle_smt().

Fixes: 10e2f1acd010 ("sched/core: Rewrite and improve select_idle_siblings())
Reported-by: Wetp Zhang <wetp.zy@linux.alibaba.com>
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/1600930127-76857-1-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b02a83ff40687..dddaf61378f62 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5936,7 +5936,7 @@ static int select_idle_core(struct task_struct *p, struct sched_domain *sd, int
 /*
  * Scan the local SMT mask for idle CPUs.
  */
-static int select_idle_smt(struct task_struct *p, int target)
+static int select_idle_smt(struct task_struct *p, struct sched_domain *sd, int target)
 {
 	int cpu, si_cpu = -1;
 
@@ -5944,7 +5944,8 @@ static int select_idle_smt(struct task_struct *p, int target)
 		return -1;
 
 	for_each_cpu(cpu, cpu_smt_mask(target)) {
-		if (!cpumask_test_cpu(cpu, p->cpus_ptr))
+		if (!cpumask_test_cpu(cpu, p->cpus_ptr) ||
+		    !cpumask_test_cpu(cpu, sched_domain_span(sd)))
 			continue;
 		if (available_idle_cpu(cpu))
 			return cpu;
@@ -5962,7 +5963,7 @@ static inline int select_idle_core(struct task_struct *p, struct sched_domain *s
 	return -1;
 }
 
-static inline int select_idle_smt(struct task_struct *p, int target)
+static inline int select_idle_smt(struct task_struct *p, struct sched_domain *sd, int target)
 {
 	return -1;
 }
@@ -6072,7 +6073,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	if ((unsigned)i < nr_cpumask_bits)
 		return i;
 
-	i = select_idle_smt(p, target);
+	i = select_idle_smt(p, sd, target);
 	if ((unsigned)i < nr_cpumask_bits)
 		return i;
 
-- 
2.25.1



