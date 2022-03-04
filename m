Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D094CCCAE
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 05:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiCDExf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 23:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiCDExf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 23:53:35 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078DC3B3F5;
        Thu,  3 Mar 2022 20:52:42 -0800 (PST)
X-UUID: a9fa9b595d30426180269d85e18dfcb4-20220304
X-UUID: a9fa9b595d30426180269d85e18dfcb4-20220304
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 200241363; Fri, 04 Mar 2022 12:52:38 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 4 Mar 2022 12:52:37 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Mar 2022 12:52:36 +0800
From:   <yf.wang@mediatek.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
CC:     <wsd_upstream@mediatek.com>, Libo Kang <Libo.Kang@mediatek.com>,
        Ning Li <Ning.Li@mediatek.com>, Yong Wu <Yong.Wu@mediatek.com>,
        Yunfei Wang <yf.wang@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] iommu/iova: Free all CPU rcache for retry when iova alloc failure
Date:   Fri, 4 Mar 2022 12:46:34 +0800
Message-ID: <20220304044635.4273-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

In alloc_iova_fast function, if an iova alloc request fail,
it will free the iova ranges present in the percpu iova
rcaches and free global iova rcache and then retry, but
flushing CPU iova rcaches only for each online CPU, which
will cause incomplete rcache cleaning, and iova rcaches of
not online CPU cannot be flushed, because iova rcaches may
also lead to fragmentation of iova space, so the next retry
action may still be fail.

Based on the above, so need to flushing all iova rcaches
for each possible CPU, use for_each_possible_cpu instead of
for_each_online_cpu like in free_iova_rcaches function,
so that all rcaches can be completely released to try
replenishing IOVAs.

Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.4.*
---
 drivers/iommu/iova.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index b28c9435b898..5a0637cd7bc2 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -460,7 +460,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 
 		/* Try replenishing IOVAs by flushing rcache. */
 		flush_rcache = false;
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			free_cpu_cached_iovas(cpu, iovad);
 		free_global_cached_iovas(iovad);
 		goto retry;
-- 
2.18.0
