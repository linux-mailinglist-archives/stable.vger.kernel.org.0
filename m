Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C56469B2
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 08:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLHHZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 02:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLHHZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 02:25:36 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105C4732E;
        Wed,  7 Dec 2022 23:25:27 -0800 (PST)
X-UUID: 4638bad552b94b469f998fe11a725c7a-20221208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=OjZLXYmkStH9EABwbJjLU6KYW4sA6HNHYj8sP4pBtR8=;
        b=pM22wGBXCl/B+1VnxzIJBaJcDhOB4QKrKNJ/wOXT3CFSuCyoMB9jxP9w+ldXCUo7Wj+xS4UdPR+OmEDsUssZskwNft9mJAv2+qm64S88mmmc1gHgEi2KWeVH7csjo06C+IuSE/PAWx8aUnuo+JBmAduO6DokknhhqsibRwCzF/Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:9599383a-5f03-46dc-9b17-0aa0b77351b0,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.14,REQID:9599383a-5f03-46dc-9b17-0aa0b77351b0,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:dcaaed0,CLOUDID:19a1e616-b863-49f8-8228-cbdfeedd1fa4,B
        ulkID:221208152524IKPRWPIZ,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 4638bad552b94b469f998fe11a725c7a-20221208
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 5588006; Thu, 08 Dec 2022 15:25:23 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 8 Dec 2022 15:25:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 8 Dec 2022 15:25:22 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
Date:   Thu, 8 Dec 2022 15:25:20 +0800
Message-ID: <20221208072520.26210-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When SSU/enter hibern8 fail in wlun suspend flow, trigger error
handler and return busy to break the suspend.
If not, wlun runtime pm status become error and the consumer will
stuck in runtime suspend status.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b1f59a5fe632..31ed3fdb5266 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6070,6 +6070,14 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_force_error_recovery(struct ufs_hba *hba) 
+{
+	spin_lock_irq(hba->host->host_lock);
+	hba->force_reset = true;
+	ufshcd_schedule_eh_work(hba);
+	spin_unlock_irq(hba->host->host_lock);
+}
+
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
 	down_write(&hba->clk_scaling_lock);
@@ -9049,6 +9057,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 		if (!hba->dev_info.b_rpm_dev_flush_capable) {
 			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
+			if (ret && pm_op != UFS_SHUTDOWN_PM) {
+				/*
+				 * If return err in suspend flow, IO will hang.
+				 * Trigger error handler and break suspend for
+				 * error recovery.
+				 */
+				ufshcd_force_error_recovery(hba);
+				ret = -EBUSY;
+			}
 			if (ret)
 				goto enable_scaling;
 		}
@@ -9060,6 +9077,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 */
 	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
 	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
+	if (ret && pm_op != UFS_SHUTDOWN_PM) {
+		/*
+		 * If return err in suspend flow, IO will hang.
+		 * Trigger error handler and break suspend for
+		 * error recovery.
+		 */
+		ufshcd_force_error_recovery(hba);
+		ret = -EBUSY;
+	}
 	if (ret)
 		goto set_dev_active;
 
-- 
2.18.0

