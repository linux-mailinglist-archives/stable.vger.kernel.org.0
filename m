Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE493CE371
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbhGSPiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348470AbhGSPfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24BFB6161F;
        Mon, 19 Jul 2021 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711227;
        bh=QhB3fuEgoUJggLBXEFnE+5pmiY1T3OzUYbMVISNzp6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEBoH40W3mC4tIsJ28E9bXKzfxY6vGKVaeRnEURQ9rewE+AV30oJBIXAMlvU8CI0h
         cshdyndEj+VF36o2tlk+LR7T2b8BtT+zbg4IL3XJwTwkp/arkBmGDHoMTlx5gcGUrJ
         gVJv7Xosde5DJ7DedAwdUVGT9oOiie3nOdfnLS54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Qian Cai <quic_qiancai@quicinc.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 241/351] arch_topology: Avoid use-after-free for scale_freq_data
Date:   Mon, 19 Jul 2021 16:53:07 +0200
Message-Id: <20210719144952.920595699@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 83150f5d05f065fb5c12c612f119015cabdcc124 ]

Currently topology_scale_freq_tick() (which gets called from
scheduler_tick()) may end up using a pointer to "struct
scale_freq_data", which was previously cleared by
topology_clear_scale_freq_source(), as there is no protection in place
here. The users of topology_clear_scale_freq_source() though needs a
guarantee that the previously cleared scale_freq_data isn't used
anymore, so they can free the related resources.

Since topology_scale_freq_tick() is called from scheduler tick, we don't
want to add locking in there. Use the RCU update mechanism instead
(which is already used by the scheduler's utilization update path) to
guarantee race free updates here.

synchronize_rcu() makes sure that all RCU critical sections that started
before it is called, will finish before it returns. And so the callers
of topology_clear_scale_freq_source() don't need to worry about their
callback getting called anymore.

Cc: Paul E. McKenney <paulmck@kernel.org>
Fixes: 01e055c120a4 ("arch_topology: Allow multiple entities to provide sched_freq_tick() callback")
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Ionela Voinescu <ionela.voinescu@arm.com>
Tested-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/arch_topology.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index c1179edc0f3b..921312a8d957 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -18,10 +18,11 @@
 #include <linux/cpumask.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 
-static DEFINE_PER_CPU(struct scale_freq_data *, sft_data);
+static DEFINE_PER_CPU(struct scale_freq_data __rcu *, sft_data);
 static struct cpumask scale_freq_counters_mask;
 static bool scale_freq_invariant;
 
@@ -66,16 +67,20 @@ void topology_set_scale_freq_source(struct scale_freq_data *data,
 	if (cpumask_empty(&scale_freq_counters_mask))
 		scale_freq_invariant = topology_scale_freq_invariant();
 
+	rcu_read_lock();
+
 	for_each_cpu(cpu, cpus) {
-		sfd = per_cpu(sft_data, cpu);
+		sfd = rcu_dereference(*per_cpu_ptr(&sft_data, cpu));
 
 		/* Use ARCH provided counters whenever possible */
 		if (!sfd || sfd->source != SCALE_FREQ_SOURCE_ARCH) {
-			per_cpu(sft_data, cpu) = data;
+			rcu_assign_pointer(per_cpu(sft_data, cpu), data);
 			cpumask_set_cpu(cpu, &scale_freq_counters_mask);
 		}
 	}
 
+	rcu_read_unlock();
+
 	update_scale_freq_invariant(true);
 }
 EXPORT_SYMBOL_GPL(topology_set_scale_freq_source);
@@ -86,22 +91,32 @@ void topology_clear_scale_freq_source(enum scale_freq_source source,
 	struct scale_freq_data *sfd;
 	int cpu;
 
+	rcu_read_lock();
+
 	for_each_cpu(cpu, cpus) {
-		sfd = per_cpu(sft_data, cpu);
+		sfd = rcu_dereference(*per_cpu_ptr(&sft_data, cpu));
 
 		if (sfd && sfd->source == source) {
-			per_cpu(sft_data, cpu) = NULL;
+			rcu_assign_pointer(per_cpu(sft_data, cpu), NULL);
 			cpumask_clear_cpu(cpu, &scale_freq_counters_mask);
 		}
 	}
 
+	rcu_read_unlock();
+
+	/*
+	 * Make sure all references to previous sft_data are dropped to avoid
+	 * use-after-free races.
+	 */
+	synchronize_rcu();
+
 	update_scale_freq_invariant(false);
 }
 EXPORT_SYMBOL_GPL(topology_clear_scale_freq_source);
 
 void topology_scale_freq_tick(void)
 {
-	struct scale_freq_data *sfd = *this_cpu_ptr(&sft_data);
+	struct scale_freq_data *sfd = rcu_dereference_sched(*this_cpu_ptr(&sft_data));
 
 	if (sfd)
 		sfd->set_freq_scale();
-- 
2.30.2



