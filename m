Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DDD137D65
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgAKJ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgAKJ5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:57:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB122064C;
        Sat, 11 Jan 2020 09:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736619;
        bh=B/WPZinwqaU3N5CEePyKCWSzXduU7EUxFTX6m0gZr/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuyjnaTMGXBZXanc/NYQQG7eEZB+HqRPQrY+dp/e358xR8M+4yARuvQyk0P/3r9nS
         ncHnp/Phcrf46ZmUaa13rzEHzNLrXrWnz/tCDzjIHS7QLB/yvwZeqBIZ3zq3zn07+w
         vnb/PE46L6DIwk/dxE4h/EmL7be32kFqGm7WISoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 36/59] ARM: vexpress: Set-up shared OPP table instead of individual for each CPU
Date:   Sat, 11 Jan 2020 10:49:45 +0100
Message-Id: <20200111094845.435506033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5766ce2be32b..29eb945075e3 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -555,8 +555,9 @@ static struct clk *ve_spc_clk_register(struct device *cpu_dev)
 
 static int __init ve_spc_clk_init(void)
 {
-	int cpu;
+	int cpu, cluster;
 	struct clk *clk;
+	bool init_opp_table[MAX_CLUSTERS] = { false };
 
 	if (!info)
 		return 0; /* Continue only if SPC is initialised */
@@ -582,8 +583,17 @@ static int __init ve_spc_clk_init(void)
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



