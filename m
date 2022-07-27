Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A28581DE5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 05:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiG0DFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 23:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiG0DFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 23:05:37 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1738C65F2;
        Tue, 26 Jul 2022 20:05:30 -0700 (PDT)
X-UUID: 8ddcca28f3e343a7a983e1893a6d9012-20220727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:aec9c1b2-c3a7-4584-adb0-8181bf0455eb,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:100
X-CID-INFO: VERSION:1.1.8,REQID:aec9c1b2-c3a7-4584-adb0-8181bf0455eb,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,ACT
        ION:quarantine,TS:100
X-CID-META: VersionHash:0f94e32,CLOUDID:26e71fee-db04-4499-9fdf-04ef44b9468c,C
        OID:631231a736d5,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 8ddcca28f3e343a7a983e1893a6d9012-20220727
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 868283021; Wed, 27 Jul 2022 11:05:29 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 27 Jul 2022 11:05:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 27 Jul 2022 11:05:28 +0800
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
Subject: [PATCH v5] ufs: core: correct ufshcd_shutdown flow
Date:   Wed, 27 Jul 2022 11:05:26 +0800
Message-ID: <20220727030526.31022-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

After ufshcd_wl_shutdown set device power off and link off,
ufshcd_shutdown could turn off clock/power.

Also remove pm_runtime_get_sync.
The reason why here can remove pm_runtime_get_sync is because,
(1) ufshcd_wl_shutdown -> pm_runtime_get_sync, will resume hba->dev too.
(2) device resume(turn on clk/power) is not required, even if device is in RPM_SUSPENDED.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..d13c76983555 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9462,12 +9462,8 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
 int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
-		goto out;
-
-	pm_runtime_get_sync(hba->dev);
+		ufshcd_suspend(hba);
 
-	ufshcd_suspend(hba);
-out:
 	hba->is_powered = false;
 	/* allow force shutdown even in case of errors */
 	return 0;
-- 
2.18.0

