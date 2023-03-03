Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1456A93ED
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCCJZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCCJZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:25:13 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB4B2D17D;
        Fri,  3 Mar 2023 01:24:55 -0800 (PST)
X-UUID: 3e51e5beb9a511eda06fc9ecc4dadd91-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=euxPKuYLhPTVh9ngivHIKL/kZ3tV5PNQ27t0ey9mzGs=;
        b=ifOapB4YJ68gvsnZvKOXsgNfmdo11uRntI84LZS4RxtCNwwJ7HhLFGHSitFO/rKzTkdjRWoSxFgXXD7qQAfChMdaU1DNKEaupbTZpJUyF+lGGm1TvyXoilXARIJK6MUsbW9nf054S72zTzGGGvh8esVexr8WOGGcBl5lFDgaz34=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:61787ae0-d8c9-428b-aa6a-f15d629a3074,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:25b5999,CLOUDID:456babf4-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: 3e51e5beb9a511eda06fc9ecc4dadd91-20230303
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1092691571; Fri, 03 Mar 2023 17:24:48 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 17:24:47 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 17:24:47 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 01/10] cpuidle/poll: Ensure IRQs stay disabled after cpuidle_state::enter() calls
Date:   Fri, 3 Mar 2023 17:23:23 +0800
Message-ID: <20230303092347.4825-2-cheng-jui.wang@mediatek.com>
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

commit 5e26aa93391195a64871db5d96d7163f0062ca4f upstream.

Make cpuidle_state::enter() methods IRQ state invariant on exit.

Additionally make sure to use raw_local_irq_*() methods since this
cpuidle callback will be called with RCU already disabled.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20230112195539.515253662@infradead.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
---
 drivers/cpuidle/poll_state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index f7e83613ae94..1f578ed09c73 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -17,7 +17,7 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 	dev->poll_time_limit = false;
 
-	local_irq_enable();
+	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
 		unsigned int loop_count = 0;
 		u64 limit;
@@ -36,6 +36,8 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			}
 		}
 	}
+	raw_local_irq_disable();
+
 	current_clr_polling();
 
 	return index;
-- 
2.18.0

