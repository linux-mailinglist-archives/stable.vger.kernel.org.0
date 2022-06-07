Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1808A54089C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348411AbiFGSCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349776AbiFGSA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C225B14A247;
        Tue,  7 Jun 2022 10:42:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6049B615B4;
        Tue,  7 Jun 2022 17:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBCEC385A5;
        Tue,  7 Jun 2022 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623725;
        bh=NZOjF323UZNafxUxjZt3FD7HpP5qouR5J6a9gRbV+4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJdWlt/MJsfIUs7HX0n0xbQO0jyQUc50/czP5kFtIjCLvr2uOS+Ty2V98CS6a265d
         +bw7dj/aGtmjXDykUUeJTUhbjGGzjyLGcxkekg/r9bgCGXDTmg5J1RX4if+TlXp4i/
         U9n0Q9zRbUQbi7JeK5z02NUpLdWnJhKNTsmKvETM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maulik Shah <quic_mkshah@quicinc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/667] cpuidle: PSCI: Improve support for suspend-to-RAM for PSCI OSI mode
Date:   Tue,  7 Jun 2022 18:55:34 +0200
Message-Id: <20220607164936.887202614@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 171b66e2e2e9d80b93c8cff799e6175074b22297 ]

When PSCI OSI mode is supported the syscore flag is set for the CPU devices
that becomes attached to their PM domains (genpds). In the suspend-to-idle
case, we call dev_pm_genpd_suspend|resume() to allow genpd to properly
manage the power-off/on operations (pick an idlestate and manage the on/off
notifications).

For suspend-to-ram, dev_pm_genpd_suspend|resume() is currently not being
called, which causes a problem that the genpd on/off notifiers do not get
sent as expected. This prevents the platform-specific operations from being
executed, typically needed just before/after the boot CPU is being turned
off/on.

To deal with this problem, let's register a syscore ops for cpuidle-psci
when PSCI OSI mode is being used and call dev_pm_genpd_suspend|resume()
from them. In this way, genpd regains control of the PM domain topology and
then sends the on/off notifications when it's appropriate.

Reported-by: Maulik Shah <quic_mkshah@quicinc.com>
Suggested-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-psci.c | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-psci.c b/drivers/cpuidle/cpuidle-psci.c
index b51b5df08450..540105ca0781 100644
--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -23,6 +23,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/cpuidle.h>
 
@@ -131,6 +132,49 @@ static int psci_idle_cpuhp_down(unsigned int cpu)
 	return 0;
 }
 
+static void psci_idle_syscore_switch(bool suspend)
+{
+	bool cleared = false;
+	struct device *dev;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		dev = per_cpu_ptr(&psci_cpuidle_data, cpu)->dev;
+
+		if (dev && suspend) {
+			dev_pm_genpd_suspend(dev);
+		} else if (dev) {
+			dev_pm_genpd_resume(dev);
+
+			/* Account for userspace having offlined a CPU. */
+			if (pm_runtime_status_suspended(dev))
+				pm_runtime_set_active(dev);
+
+			/* Clear domain state to re-start fresh. */
+			if (!cleared) {
+				psci_set_domain_state(0);
+				cleared = true;
+			}
+		}
+	}
+}
+
+static int psci_idle_syscore_suspend(void)
+{
+	psci_idle_syscore_switch(true);
+	return 0;
+}
+
+static void psci_idle_syscore_resume(void)
+{
+	psci_idle_syscore_switch(false);
+}
+
+static struct syscore_ops psci_idle_syscore_ops = {
+	.suspend = psci_idle_syscore_suspend,
+	.resume = psci_idle_syscore_resume,
+};
+
 static void psci_idle_init_cpuhp(void)
 {
 	int err;
@@ -138,6 +182,8 @@ static void psci_idle_init_cpuhp(void)
 	if (!psci_cpuidle_use_cpuhp)
 		return;
 
+	register_syscore_ops(&psci_idle_syscore_ops);
+
 	err = cpuhp_setup_state_nocalls(CPUHP_AP_CPU_PM_STARTING,
 					"cpuidle/psci:online",
 					psci_idle_cpuhp_up,
-- 
2.35.1



