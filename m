Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E57242AAC
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 17:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbfFLPTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 11:19:23 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:63575 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727419AbfFLPTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 11:19:23 -0400
X-UUID: 59f437fa7ced4ef4b30133056feeb33a-20190612
X-UUID: 59f437fa7ced4ef4b30133056feeb33a-20190612
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 892612023; Wed, 12 Jun 2019 23:19:09 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 12 Jun 2019 23:19:07 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 12 Jun 2019 23:19:07 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <evgreen@chromium.org>, <beanhuo@micron.com>,
        <marc.w.gonzalez@free.fr>, <ygardi@codeaurora.org>,
        <subhashj@codeaurora.org>, <sthumma@codeaurora.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] scsi: ufs: Avoid runtime suspend possibly being blocked forever
Date:   Wed, 12 Jun 2019 23:19:05 +0800
Message-ID: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UFS runtime suspend can be triggered after pm_runtime_enable()
is invoked in ufshcd_pltfrm_init(). However if the first runtime
suspend is triggered before binding ufs_hba structure to ufs
device structure via platform_set_drvdata(), then UFS runtime
suspend will be no longer triggered in the future because its
dev->power.runtime_error was set in the first triggering and does
not have any chance to be cleared.

To be more clear, dev->power.runtime_error is set if hba is NULL
in ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback()
where dev->power.runtime_error is set as -EINVAL. In this case, any
future rpm_suspend() for UFS device fails because
rpm_check_suspend_allowed() fails due to non-zero
dev->power.runtime_error.

To resolve this issue, make sure the first UFS runtime suspend
get valid "hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM
only after hba is successfully bound to UFS device structure.

Fixes: 62694735ca95 ([SCSI] ufs: Add runtime PM support for UFS host controller driver)
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8a74ec30c3d2..d7d521b394c3 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -430,24 +430,21 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto out_disable_rpm;
+		goto dealloc_host;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 dealloc_host:
 	ufshcd_dealloc_host(hba);
 out:
-- 
2.18.0

