Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8E1677A1
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgBUHzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgBUHzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C386222C4;
        Fri, 21 Feb 2020 07:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271720;
        bh=5tGjCaR0U/4Sbp7vkRaZfh3f9+5qvqqeBO9WpmTPe1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygHF0y8Q+HJ0x0TnwU0udJJLuM7f83JRscktqh/Gx52B325bVgOGzuE6BM6Wg60l4
         R/RnoQQ+UPfqaV7paknmJrB3ja4sCKUReS5akltDtXlsnEkKvwVn8vq1HJW3mUySQb
         Ej+Zr5NxeAoHjXZ11n3/bluqW7U6GM9FFYtxzV6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 272/399] scsi: ufs-mediatek: add apply_dev_quirks variant operation
Date:   Fri, 21 Feb 2020 08:39:57 +0100
Message-Id: <20200221072428.629053490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit ea92c32bd336efba89c5b09cf609e6e26e963796 ]

Add vendor-specific variant callback "apply_dev_quirks" to MediaTek UFS
driver.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/1578726707-6596-3-git-send-email-stanley.chu@mediatek.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 83e28edc3ac5b..8a21f49caf0d9 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -13,6 +13,7 @@
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
+#include "ufs_quirks.h"
 #include "unipro.h"
 #include "ufs-mediatek.h"
 
@@ -289,6 +290,15 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba,
+				    struct ufs_dev_desc *card)
+{
+	if (card->wmanufacturerid == UFS_VENDOR_SAMSUNG)
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
+
+	return 0;
+}
+
 /**
  * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
  *
@@ -301,6 +311,7 @@ static struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.link_startup_notify = ufs_mtk_link_startup_notify,
 	.pwr_change_notify   = ufs_mtk_pwr_change_notify,
+	.apply_dev_quirks    = ufs_mtk_apply_dev_quirks,
 	.suspend             = ufs_mtk_suspend,
 	.resume              = ufs_mtk_resume,
 };
-- 
2.20.1



