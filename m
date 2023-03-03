Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA326A93EB
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCCJZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjCCJZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:25:40 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6E47410;
        Fri,  3 Mar 2023 01:25:18 -0800 (PST)
X-UUID: 4d9ce2b2b9a511eda06fc9ecc4dadd91-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=bSqog9Arn5WTEwlshb3YMHHP4Vbkyic4vpImRhlxN2s=;
        b=QoDQZZsGQTgmBo/JH8zHNLrEWXnnB/v1Fw8/8F/Yi3KOuO8sjOZtM6dfeqXLerob30RKTF2QGUmPnpxt7g7Ub7PVxwBksizZeOMyHjjGJ+NYudFv5qYv1rKfu397hBSQaxp2ctTMBV28TPYJ1GLqAGfkG6aeTWxZUcfZcAN3D08=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:959b73a5-cab3-4986-8e8b-e46402f9969d,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:25b5999,CLOUDID:0c70abf4-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 4d9ce2b2b9a511eda06fc9ecc4dadd91-20230303
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1005376028; Fri, 03 Mar 2023 17:25:14 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 17:25:13 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 17:25:12 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 03/10] cpuidle, tegra: Push RCU-idle into driver
Date:   Fri, 3 Mar 2023 17:23:25 +0800
Message-ID: <20230303092347.4825-4-cheng-jui.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
References: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 5fca0d9f5d76664786ca6c09076341def165a677 upstream.

Doing RCU-idle outside the driver, only to then temporarily enable it
again, at least twice, before going idle is suboptimal.

Notably once implicitly through the cpu_pm_*() calls and once
explicitly doing RCU_NONIDLE().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230112195539.699546331@infradead.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
---
 drivers/cpuidle/cpuidle-tegra.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-tegra.c b/drivers/cpuidle/cpuidle-tegra.c
index 9845629aeb6d..3ca5cfb9d322 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -180,9 +180,11 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 	}
 
 	local_fiq_disable();
-	RCU_NONIDLE(tegra_pm_set_cpu_in_lp2());
+	tegra_pm_set_cpu_in_lp2();
 	cpu_pm_enter();
 
+	ct_idle_enter();
+
 	switch (index) {
 	case TEGRA_C7:
 		err = tegra_cpuidle_c7_enter();
@@ -197,8 +199,10 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 		break;
 	}
 
+	ct_idle_exit();
+
 	cpu_pm_exit();
-	RCU_NONIDLE(tegra_pm_clear_cpu_in_lp2());
+	tegra_pm_clear_cpu_in_lp2();
 	local_fiq_enable();
 
 	return err ?: index;
@@ -226,6 +230,7 @@ static int tegra_cpuidle_enter(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv,
 			       int index)
 {
+	bool do_rcu = drv->states[index].flags & CPUIDLE_FLAG_RCU_IDLE;
 	unsigned int cpu = cpu_logical_map(dev->cpu);
 	int ret;
 
@@ -233,9 +238,13 @@ static int tegra_cpuidle_enter(struct cpuidle_device *dev,
 	if (dev->states_usage[index].disable)
 		return -1;
 
-	if (index == TEGRA_C1)
+	if (index == TEGRA_C1) {
+		if (do_rcu)
+			ct_idle_enter();
 		ret = arm_cpuidle_simple_enter(dev, drv, index);
-	else
+		if (do_rcu)
+			ct_idle_exit();
+	} else
 		ret = tegra_cpuidle_state_enter(dev, index, cpu);
 
 	if (ret < 0) {
@@ -285,7 +294,8 @@ static struct cpuidle_driver tegra_idle_driver = {
 			.exit_latency		= 2000,
 			.target_residency	= 2200,
 			.power_usage		= 100,
-			.flags			= CPUIDLE_FLAG_TIMER_STOP,
+			.flags			= CPUIDLE_FLAG_TIMER_STOP |
+						  CPUIDLE_FLAG_RCU_IDLE,
 			.name			= "C7",
 			.desc			= "CPU core powered off",
 		},
@@ -295,6 +305,7 @@ static struct cpuidle_driver tegra_idle_driver = {
 			.target_residency	= 10000,
 			.power_usage		= 0,
 			.flags			= CPUIDLE_FLAG_TIMER_STOP |
+						  CPUIDLE_FLAG_RCU_IDLE   |
 						  CPUIDLE_FLAG_COUPLED,
 			.name			= "CC6",
 			.desc			= "CPU cluster powered off",
-- 
2.18.0

