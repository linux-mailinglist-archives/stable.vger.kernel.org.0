Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA85BBAA47
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfIVTYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388594AbfIVSwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B662190F;
        Sun, 22 Sep 2019 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178374;
        bh=kjUYmaBo4PVq9u9yyQ+YpRHxns2z/f+WYQMw69UXDSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTDKEaMdI+HPrkP4B6NmOzGM2uG7vNm5WylNbhjJcIVWkObwmLDG02k8WwsuvV/FM
         6TlKcOZ9iLB8tNtV7wDoxK89kJmctvg4Ki6eAtU0Mfwwquj5sMODTzsMUSKjsZjCDG
         J38dauooYRWPrc0I2oRnbL8SEPvrdFKd0iQzmU7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 124/185] sched/cpufreq: Align trace event behavior of fast switching
Date:   Sun, 22 Sep 2019 14:48:22 -0400
Message-Id: <20190922184924.32534-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ae3ec77bb92f6..e139b54716b4a 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -117,6 +117,7 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
 			      unsigned int next_freq)
 {
 	struct cpufreq_policy *policy = sg_policy->policy;
+	int cpu;
 
 	if (!sugov_update_next_freq(sg_policy, time, next_freq))
 		return;
@@ -126,7 +127,11 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
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

