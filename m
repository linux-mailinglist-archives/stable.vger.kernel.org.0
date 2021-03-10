Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E39C333DC0
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhCJNYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232822AbhCJNY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C304064FD7;
        Wed, 10 Mar 2021 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382667;
        bh=X3yK/idqPR+LbLgv7H7UiBV/a2UUCMlIYVM/V5fbTvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bds3GqqOr06shFRNDif6Ic28OjhmQ5zM81Tn7sIvGsb5wYtFxvApOTkohpdWBOWVC
         Ktw2EMRPSud8rHbpaKMq752mWqu/vNzKYaEJdYFfGR0rfvQoe1KRUQRuFmyG18zRyV
         pDI6J53eO4RjukPbcIvanDFrA0wK087ybUi1vpGo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 18/36] scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Wed, 10 Mar 2021 14:23:31 +0100
Message-Id: <20210310132321.086618126@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 46ec9592ffd679fa26142dcb9e5119aad7e60b55 ]

Flush during hibern8 is sufficient on MediaTek platforms, thus enable
UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL to skip enabling
fWriteBoosterBufferFlush during WriteBooster initialization.

Link: https://lore.kernel.org/r/20201222072928.32328-1-stanley.chu@mediatek.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 80618af7c872..c55202b92a43 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -661,6 +661,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	/* Enable WriteBooster */
 	hba->caps |= UFSHCD_CAP_WB_EN;
+	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
 
 	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
-- 
2.30.1



