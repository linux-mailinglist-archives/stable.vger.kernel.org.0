Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677A5745DE
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiGNHbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 03:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiGNHbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 03:31:14 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBF530F7F;
        Thu, 14 Jul 2022 00:31:13 -0700 (PDT)
X-UUID: 932b742c3a0648f9b5f4477775c95999-20220714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:257bfe7c-b61a-482f-a1e8-442ce3a16703,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:0f94e32,CLOUDID:e9514664-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 932b742c3a0648f9b5f4477775c95999-20220714
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1739704461; Thu, 14 Jul 2022 15:31:06 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 14 Jul 2022 15:31:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 14 Jul 2022 15:31:05 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>,
        "Mel Gorman" <mgorman@suse.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <yj.chiang@mediatek.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 5.4] sched/rt: Disable RT_RUNTIME_SHARE by default
Date:   Thu, 14 Jul 2022 15:30:52 +0800
Message-ID: <20220714073055.15049-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@redhat.com>

commit 2586af1ac187f6b3a50930a4e33497074e81762d upstream.

The RT_RUNTIME_SHARE sched feature enables the sharing of rt_runtime
between CPUs, allowing a CPU to run a real-time task up to 100% of the
time while leaving more space for non-real-time tasks to run on the CPU
that lend rt_runtime.

The problem is that a CPU can easily borrow enough rt_runtime to allow
a spinning rt-task to run forever, starving per-cpu tasks like kworkers,
which are non-real-time by design.

This patch disables RT_RUNTIME_SHARE by default, avoiding this problem.
The feature will still be present for users that want to enable it,
though.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Wei Wang <wvw@google.com>
Link: https://lkml.kernel.org/r/b776ab46817e3db5d8ef79175fa0d71073c051c7.1600697903.git.bristot@redhat.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 2410db5e9a35..66c74aa4753e 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -77,7 +77,7 @@ SCHED_FEAT(WARN_DOUBLE_CLOCK, false)
 SCHED_FEAT(RT_PUSH_IPI, true)
 #endif
 
-SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(ATTACH_AGE_LOAD, true)
 
-- 
2.18.0

