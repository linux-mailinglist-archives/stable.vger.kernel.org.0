Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0931D581E2E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 05:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiG0DVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 23:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiG0DVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 23:21:18 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBBD248E8;
        Tue, 26 Jul 2022 20:21:17 -0700 (PDT)
X-UUID: 1429017a8fbf4357885e2b24aa255190-20220727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:40db339d-f865-4c48-9ede-34f63baad5d3,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:3a6e20ee-db04-4499-9fdf-04ef44b9468c,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 1429017a8fbf4357885e2b24aa255190-20220727
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1129967393; Wed, 27 Jul 2022 11:21:12 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 27 Jul 2022 11:21:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 27 Jul 2022 11:21:11 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH v4] ufs: core: fix lockdep warning of clk_scaling_lock
Date:   Wed, 27 Jul 2022 11:21:10 +0800
Message-ID: <20220727032110.31168-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

There have a lockdep warning like below in current flow, and have deadlock issue.
kworker/u16:0:  Possible unsafe locking scenario:

kworker/u16:0:        CPU0                    CPU1
kworker/u16:0:        ----                    ----
kworker/u16:0:   lock(&hba->clk_scaling_lock);
kworker/u16:0:                                lock(&hba->dev_cmd.lock);
kworker/u16:0:                                lock(&hba->clk_scaling_lock);
kworker/u16:0:   lock(&hba->dev_cmd.lock);
kworker/u16:0:

Before this patch clk_scaling_lock was held in reader mode during the ufshcd_wb_toggle() call.
With this patch applied clk_scaling_lock is not held while ufshcd_wb_toggle() is called.

This is safe because ufshcd_wb_toggle will held clk_scaling_lock in reader mode "again" in flow
ufshcd_wb_toggle -> __ufshcd_wb_toggle -> ufshcd_query_flag_retry -> ufshcd_query_flag ->
ufshcd_exec_dev_cmd -> down_read(&hba->clk_scaling_lock);
The protect should enough and make sure clock is not change while send command.

ufshcd_wb_toggle can protected by hba->clk_scaling.is_allowed to make sure
ufshcd_devfreq_scale function not run concurrently.

Fixes: 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts from unexpected clock scaling")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..aa57126fdb49 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -272,6 +272,7 @@ static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
+static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow);
 
 static inline void ufshcd_enable_irq(struct ufs_hba *hba)
 {
@@ -1249,12 +1250,10 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	if (writelock)
-		up_write(&hba->clk_scaling_lock);
-	else
-		up_read(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1271,7 +1270,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-	bool is_writelock = true;
+	bool wb_toggle = false;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
@@ -1300,13 +1299,19 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	/* Disable clk_scaling until ufshcd_wb_toggle finish */
+	hba->clk_scaling.is_allowed = false;
+	wb_toggle = true;
 
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, is_writelock);
+	ufshcd_clock_scaling_unprepare(hba);
+
+	/* Enable Write Booster if we have scaled up else disable it */
+	if (wb_toggle) {
+		ufshcd_wb_toggle(hba, scale_up);
+		ufshcd_clk_scaling_allow(hba, true);
+	}
+
 	return ret;
 }
 
-- 
2.18.0

