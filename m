Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D598D31BD2D
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBOPle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231618AbhBOPiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE5464EEC;
        Mon, 15 Feb 2021 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403241;
        bh=y7eQowfWRCiPs6rqvJgWxNBr3H42kcUQxHDrWQVFBLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGY2U7ZeWRma1HuKoBix1lqA3z4HY29Y6zbYuQD2yT4wn9WfjJG54UpGlguKRJg4N
         ygLhQqC2dO27WvdbDeC496MuHJAwic1FPlefP1jc+nbiHCQDXIdzbVz8vOeB0GzrAb
         B6wkyMSv6vcLcsJwktrrul4QDTwEQfjNdeYEL1h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        davem@davemloft.net, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/104] Revert "lib: Restrict cpumask_local_spread to houskeeping CPUs"
Date:   Mon, 15 Feb 2021 16:26:58 +0100
Message-Id: <20210215152720.928637631@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2452483d9546de1c540f330469dc4042ff089731 ]

This reverts commit 1abdfe706a579a702799fce465bceb9fb01d407c.

This change is broken and not solving any problem it claims to solve.

Robin reported that cpumask_local_spread() now returns any cpu out of
cpu_possible_mask in case that NOHZ_FULL is disabled (runtime or compile
time). It can also return any offline or not-present CPU in the
housekeeping mask. Before that it was returning a CPU out of
online_cpu_mask.

While the function is racy against CPU hotplug if the caller does not
protect against it, the actual use cases are not caring much about it as
they use it mostly as hint for:

 - the user space affinity hint which is unused by the kernel
 - memory node selection which is just suboptimal
 - network queue affinity which might fail but is handled gracefully

But the occasional fail vs. hotplug is very different from returning
anything from possible_cpu_mask which can have a large amount of offline
CPUs obviously.

The changelog of the commit claims:

 "The current implementation of cpumask_local_spread() does not respect
  the isolated CPUs, i.e., even if a CPU has been isolated for Real-Time
  task, it will return it to the caller for pinning of its IRQ
  threads. Having these unwanted IRQ threads on an isolated CPU adds up
  to a latency overhead."

The only correct part of this changelog is:

 "The current implementation of cpumask_local_spread() does not respect
  the isolated CPUs."

Everything else is just disjunct from reality.

Reported-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: abelits@marvell.com
Cc: davem@davemloft.net
Link: https://lore.kernel.org/r/87y2g26tnt.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/cpumask.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 85da6ab4fbb5a..fb22fb266f937 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -6,7 +6,6 @@
 #include <linux/export.h>
 #include <linux/memblock.h>
 #include <linux/numa.h>
-#include <linux/sched/isolation.h>
 
 /**
  * cpumask_next - get the next cpu in a cpumask
@@ -206,27 +205,22 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
  */
 unsigned int cpumask_local_spread(unsigned int i, int node)
 {
-	int cpu, hk_flags;
-	const struct cpumask *mask;
+	int cpu;
 
-	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
-	mask = housekeeping_cpumask(hk_flags);
 	/* Wrap: we always want a cpu. */
-	i %= cpumask_weight(mask);
+	i %= num_online_cpus();
 
 	if (node == NUMA_NO_NODE) {
-		for_each_cpu(cpu, mask) {
+		for_each_cpu(cpu, cpu_online_mask)
 			if (i-- == 0)
 				return cpu;
-		}
 	} else {
 		/* NUMA first. */
-		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
+		for_each_cpu_and(cpu, cpumask_of_node(node), cpu_online_mask)
 			if (i-- == 0)
 				return cpu;
-		}
 
-		for_each_cpu(cpu, mask) {
+		for_each_cpu(cpu, cpu_online_mask) {
 			/* Skip NUMA nodes, done above. */
 			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
 				continue;
-- 
2.27.0



