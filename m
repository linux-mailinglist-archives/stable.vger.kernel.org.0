Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5DC12B795
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfL0RuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbfL0RoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DDFC21D7E;
        Fri, 27 Dec 2019 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468655;
        bh=fohQj2/as9dqSua8w1ktK1w4smDl+xuPyoiq0d5bKiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5QKJWt3pRGPNfknowc7L7YQyiXUSZaf632OEbCSuxmyVDxaFF5Po6/PUzre6y7pM
         AmC7VfsFKHH/eMqClCPRkAzMmZtRHeN7vi0AxVjVU5q4exPImAIzL2EHlLbbcRQ5i3
         QmH7WfnY9uWuMdwZiwpYUc8IZExm0rIpF+wt/QLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 17/84] ARM: vexpress: Set-up shared OPP table instead of individual for each CPU
Date:   Fri, 27 Dec 2019 12:42:45 -0500
Message-Id: <20191227174352.6264-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 2a76352ad2cc6b78e58f737714879cc860903802 ]

Currently we add individual copy of same OPP table for each CPU within
the cluster. This is redundant and doesn't reflect the reality.

We can't use core cpumask to set policy->cpus in ve_spc_cpufreq_init()
anymore as it gets called via cpuhp_cpufreq_online()->cpufreq_online()
->cpufreq_driver->init() and the cpumask gets updated upon CPU hotplug
operations. It also may cause issues when the vexpress_spc_cpufreq
driver is built as a module.

Since ve_spc_clk_init is built-in device initcall, we should be able to
use the same topology_core_cpumask to set the opp sharing cpumask via
dev_pm_opp_set_sharing_cpus and use the same later in the driver via
dev_pm_opp_get_sharing_cpus.

Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/spc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 0f5381d13494..55bbbc3b328f 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -551,8 +551,9 @@ static struct clk *ve_spc_clk_register(struct device *cpu_dev)
 
 static int __init ve_spc_clk_init(void)
 {
-	int cpu;
+	int cpu, cluster;
 	struct clk *clk;
+	bool init_opp_table[MAX_CLUSTERS] = { false };
 
 	if (!info)
 		return 0; /* Continue only if SPC is initialised */
@@ -578,8 +579,17 @@ static int __init ve_spc_clk_init(void)
 			continue;
 		}
 
+		cluster = topology_physical_package_id(cpu_dev->id);
+		if (init_opp_table[cluster])
+			continue;
+
 		if (ve_init_opp_table(cpu_dev))
 			pr_warn("failed to initialise cpu%d opp table\n", cpu);
+		else if (dev_pm_opp_set_sharing_cpus(cpu_dev,
+			 topology_core_cpumask(cpu_dev->id)))
+			pr_warn("failed to mark OPPs shared for cpu%d\n", cpu);
+		else
+			init_opp_table[cluster] = true;
 	}
 
 	platform_device_register_simple("vexpress-spc-cpufreq", -1, NULL, 0);
-- 
2.20.1

