Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB4A16735B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbgBUILe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732716AbgBUILd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDD1920578;
        Fri, 21 Feb 2020 08:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272693;
        bh=smdyYfJRPQwe1RxXTYhgVM9lN9Z/T1rea3MJaDFvqCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7zzvoTEwwVVND3kjma++S3kKNmJQ/dZd2h2BgcStLh8+/0lK3pJd+IlFreDaQ9rY
         ZHGjeG6QepyAYToqzDCAoudU5xMcvC7gD0gRHLywydAsRv4mt9DXpt158/AEtZI95Z
         m6lTEBUHCzyPhvUCfZaqHZ9tNisbTpvE7XlqjbZw=
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
Subject: [PATCH 5.4 239/344] scsi: ufs-mediatek: add apply_dev_quirks variant operation
Date:   Fri, 21 Feb 2020 08:40:38 +0100
Message-Id: <20200221072411.022942787@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index 0f6ff33ce52ee..d4a8be5ffd528 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -13,6 +13,7 @@
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
+#include "ufs_quirks.h"
 #include "unipro.h"
 #include "ufs-mediatek.h"
 
@@ -286,6 +287,15 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
@@ -298,6 +308,7 @@ static struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.link_startup_notify = ufs_mtk_link_startup_notify,
 	.pwr_change_notify   = ufs_mtk_pwr_change_notify,
+	.apply_dev_quirks    = ufs_mtk_apply_dev_quirks,
 	.suspend             = ufs_mtk_suspend,
 	.resume              = ufs_mtk_resume,
 };
-- 
2.20.1



