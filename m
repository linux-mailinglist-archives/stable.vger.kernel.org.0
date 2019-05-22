Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACEA26F55
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbfEVTYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbfEVTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:24:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D2EF2173C;
        Wed, 22 May 2019 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553093;
        bh=TVgHAsyH4rPgT15fmHL2KXvgi3eWmCoEVO52DV8rrnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5IRXEaFQKOw/PU1o/48keqRnpSMxuEe/yR3j5QMzKdgKcSleaDyOL1jyeBBElcyd
         Dwl6/YshI1cR3GtYDGmUPCaSyvaN+yd57AmaBFsdVQqWABY3TWJgjLg/MtxMXkJ7P8
         zWI1lOrC1y32VDXNi6H7+S9m2fePfsWp8Me1G+Dc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 043/317] sched/cpufreq: Fix kobject memleak
Date:   Wed, 22 May 2019 15:19:04 -0400
Message-Id: <20190522192338.23715-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 9a4f26cc98d81b67ecc23b890c28e2df324e29f3 ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking
the kobject.

Fix it by adding a call to kobject_put() in the error path of
kobject_init_and_add().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Link: http://lkml.kernel.org/r/20190430001144.24890-1-tobin@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c          | 1 +
 drivers/cpufreq/cpufreq_governor.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ef0e33e21b988..97b094963253d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1103,6 +1103,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 				   cpufreq_global_kobject, "policy%u", cpu);
 	if (ret) {
 		pr_err("%s: failed to init policy->kobj: %d\n", __func__, ret);
+		kobject_put(&policy->kobj);
 		goto err_free_real_cpus;
 	}
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index ffa9adeaba31b..9d1d9bf02710b 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -459,6 +459,8 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 	/* Failure, so roll back. */
 	pr_err("initialization failed (dbs_data kobject init error %d)\n", ret);
 
+	kobject_put(&dbs_data->attr_set.kobj);
+
 	policy->governor_data = NULL;
 
 	if (!have_governor_per_policy())
-- 
2.20.1

