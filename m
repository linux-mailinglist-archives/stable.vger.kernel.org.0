Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088A6CAA18
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388247AbfJCQTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389487AbfJCQTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:19:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A21B20865;
        Thu,  3 Oct 2019 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119556;
        bh=/ok+yJILJ8USFatLtQTy93jwL1cEUtOxh6rBIm5eFvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jncjc/sLOJ5v6uUz14GWHWURr8+FInnI9Q+tcz1JWBgpv4dmJKXUqrbih7UTuysmK
         mmuVmBhhk9o9DXbfS+037txFO4/XBFGz55+/jM6jdBJHTOqJID+juS04amkqpS6XTV
         yJgadwC7q/eSxN6FkOOD7SxW4p3cOA4EXjnFkfZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Douglas RAILLARD <douglas.raillard@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/211] sched/cpufreq: Align trace event behavior of fast switching
Date:   Thu,  3 Oct 2019 17:52:53 +0200
Message-Id: <20191003154511.856176954@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas RAILLARD <douglas.raillard@arm.com>

[ Upstream commit 77c84dd1881d0f0176cb678d770bfbda26c54390 ]

Fast switching path only emits an event for the CPU of interest, whereas the
regular path emits an event for all the CPUs that had their frequency changed,
i.e. all the CPUs sharing the same policy.

With the current behavior, looking at cpu_frequency event for a given CPU that
is using the fast switching path will not give the correct frequency signal.

Signed-off-by: Douglas RAILLARD <douglas.raillard@arm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 64d54acc99282..54fcff656ecd7 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -118,6 +118,7 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
 			      unsigned int next_freq)
 {
 	struct cpufreq_policy *policy = sg_policy->policy;
+	int cpu;
 
 	if (!sugov_update_next_freq(sg_policy, time, next_freq))
 		return;
@@ -127,7 +128,11 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
 		return;
 
 	policy->cur = next_freq;
-	trace_cpu_frequency(next_freq, smp_processor_id());
+
+	if (trace_cpu_frequency_enabled()) {
+		for_each_cpu(cpu, policy->cpus)
+			trace_cpu_frequency(next_freq, cpu);
+	}
 }
 
 static void sugov_deferred_update(struct sugov_policy *sg_policy, u64 time,
-- 
2.20.1



