Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A68C6A9409
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCCJ03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCCJZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:25:55 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D49457C3;
        Fri,  3 Mar 2023 01:25:36 -0800 (PST)
X-UUID: 57841836b9a511ed945fc101203acc17-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vdekVTpo3BnkDXcjiGV3jzfc/4pX+DxY56QvRtM7y5o=;
        b=bmuRX0ibtm57RW6QySzUKSuB546AW9ChSoM8iJ3xM5WIERPau/+qKJIjU6FJNQB8Rl/6u5yuqEpv1CuRHuHT0kEuf1ZwpIyDzWw8npNdNd7yQyOKOYfBQ4RmcQhMEfkInWmY+BJPD4zFr4VORNosPrG7Eo9FGPU1/Z6ktn4Tapo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:b757c10e-74e6-41d6-97cf-242deb3f6d5a,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:25b5999,CLOUDID:5b2b3d27-564d-42d9-9875-7c868ee415ec,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 57841836b9a511ed945fc101203acc17-20230303
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1425578257; Fri, 03 Mar 2023 17:25:30 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 17:25:29 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 17:25:29 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 07/10] cpuidle, armada: Push RCU-idle into driver
Date:   Fri, 3 Mar 2023 17:23:29 +0800
Message-ID: <20230303092347.4825-8-cheng-jui.wang@mediatek.com>
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

commit 4ce40e9dbe83153f60d7e4ccd24a1eb4f8264f6a upstream.

Doing RCU-idle outside the driver, only to then temporarily enable it
again before going idle is suboptimal.

Notably the cpu_pm_*() calls implicitly re-enable RCU for a bit.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230112195539.946630819@infradead.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
---
 drivers/cpuidle/cpuidle-mvebu-v7.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-mvebu-v7.c b/drivers/cpuidle/cpuidle-mvebu-v7.c
index 01a856971f05..c9568aa9410c 100644
--- a/drivers/cpuidle/cpuidle-mvebu-v7.c
+++ b/drivers/cpuidle/cpuidle-mvebu-v7.c
@@ -36,7 +36,10 @@ static int mvebu_v7_enter_idle(struct cpuidle_device *dev,
 	if (drv->states[index].flags & MVEBU_V7_FLAG_DEEP_IDLE)
 		deepidle = true;
 
+	ct_idle_enter();
 	ret = mvebu_v7_cpu_suspend(deepidle);
+	ct_idle_exit();
+
 	cpu_pm_exit();
 
 	if (ret)
@@ -49,6 +52,7 @@ static struct cpuidle_driver armadaxp_idle_driver = {
 	.name			= "armada_xp_idle",
 	.states[0]		= ARM_CPUIDLE_WFI_STATE,
 	.states[1]		= {
+		.flags			= CPUIDLE_FLAG_RCU_IDLE,
 		.enter			= mvebu_v7_enter_idle,
 		.exit_latency		= 100,
 		.power_usage		= 50,
@@ -57,6 +61,7 @@ static struct cpuidle_driver armadaxp_idle_driver = {
 		.desc			= "CPU power down",
 	},
 	.states[2]		= {
+		.flags			= CPUIDLE_FLAG_RCU_IDLE,
 		.enter			= mvebu_v7_enter_idle,
 		.exit_latency		= 1000,
 		.power_usage		= 5,
@@ -72,6 +77,7 @@ static struct cpuidle_driver armada370_idle_driver = {
 	.name			= "armada_370_idle",
 	.states[0]		= ARM_CPUIDLE_WFI_STATE,
 	.states[1]		= {
+		.flags			= CPUIDLE_FLAG_RCU_IDLE,
 		.enter			= mvebu_v7_enter_idle,
 		.exit_latency		= 100,
 		.power_usage		= 5,
@@ -87,6 +93,7 @@ static struct cpuidle_driver armada38x_idle_driver = {
 	.name			= "armada_38x_idle",
 	.states[0]		= ARM_CPUIDLE_WFI_STATE,
 	.states[1]		= {
+		.flags			= CPUIDLE_FLAG_RCU_IDLE,
 		.enter			= mvebu_v7_enter_idle,
 		.exit_latency		= 10,
 		.power_usage		= 5,
-- 
2.18.0

