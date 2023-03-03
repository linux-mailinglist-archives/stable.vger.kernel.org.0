Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE346A93EF
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCCJZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCCJZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:25:39 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE657D24;
        Fri,  3 Mar 2023 01:25:17 -0800 (PST)
X-UUID: 4be222acb9a511ed945fc101203acc17-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ksYXpcLRpyhSF2BCe6z2U0gcUedKGDwO8T2OIU6P68o=;
        b=nZkwvpzBLeBHTWsRQGIM2m0jnQeaCbo/drr3iLgfi6ylcl5lvp6/HCCB/Z9+pLkH2JeQtZL0D0jDqIB/9RJ0XNp5pX2QrCSzSsw4tOz1Wd1mrKLIAzRucVV6i9Sw8lj2/fAE1xALggFOOJzGs6V4CTr8cx1UFslxo9sBmprh2E8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:729e9142-281b-4380-bde8-04e35560c591,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:53,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:28
X-CID-INFO: VERSION:1.1.20,REQID:729e9142-281b-4380-bde8-04e35560c591,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:53,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:28
X-CID-META: VersionHash:25b5999,CLOUDID:ef273d27-564d-42d9-9875-7c868ee415ec,B
        ulkID:2303031725130DEM1UT0,BulkQuantity:0,Recheck:0,SF:38|29|28|100|17|19|
        48|101|102,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,B
        EC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 4be222acb9a511ed945fc101203acc17-20230303
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 860502259; Fri, 03 Mar 2023 17:25:11 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 17:25:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 17:25:09 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>, Anup Patel <anup@brainfault.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
        <linux-pm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 02/10] cpuidle, riscv: Push RCU-idle into driver
Date:   Fri, 3 Mar 2023 17:23:24 +0800
Message-ID: <20230303092347.4825-3-cheng-jui.wang@mediatek.com>
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

commit 8e9ab9e8da1eae61fdff35690d998eaf8cd527dc upstream.

Doing RCU-idle outside the driver, only to then temporarily enable it
again, at least twice, before going idle is suboptimal.

That is, once implicitly through the cpu_pm_*() calls and once
explicitly doing ct_irq_*_irqon().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230112195539.637185846@infradead.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
---
 drivers/cpuidle/cpuidle-riscv-sbi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-riscv-sbi.c b/drivers/cpuidle/cpuidle-riscv-sbi.c
index 05fe2902df9a..cbdbb11b972b 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -121,12 +121,12 @@ static int __sbi_enter_domain_idle_state(struct cpuidle_device *dev,
 		return -1;
 
 	/* Do runtime PM to manage a hierarchical CPU toplogy. */
-	ct_irq_enter_irqson();
 	if (s2idle)
 		dev_pm_genpd_suspend(pd_dev);
 	else
 		pm_runtime_put_sync_suspend(pd_dev);
-	ct_irq_exit_irqson();
+
+	ct_idle_enter();
 
 	if (sbi_is_domain_state_available())
 		state = sbi_get_domain_state();
@@ -135,12 +135,12 @@ static int __sbi_enter_domain_idle_state(struct cpuidle_device *dev,
 
 	ret = sbi_suspend(state) ? -1 : idx;
 
-	ct_irq_enter_irqson();
+	ct_idle_exit();
+
 	if (s2idle)
 		dev_pm_genpd_resume(pd_dev);
 	else
 		pm_runtime_get_sync(pd_dev);
-	ct_irq_exit_irqson();
 
 	cpu_pm_exit();
 
@@ -251,6 +251,7 @@ static int sbi_dt_cpu_init_topology(struct cpuidle_driver *drv,
 	 * of a shared state for the domain, assumes the domain states are all
 	 * deeper states.
 	 */
+	drv->states[state_count - 1].flags |= CPUIDLE_FLAG_RCU_IDLE;
 	drv->states[state_count - 1].enter = sbi_enter_domain_idle_state;
 	drv->states[state_count - 1].enter_s2idle =
 					sbi_enter_s2idle_domain_idle_state;
-- 
2.18.0

