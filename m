Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A121333DEF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhCJNZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhCJNYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1196564FDC;
        Wed, 10 Mar 2021 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382674;
        bh=VBBtXgNqdF9iNjBKKGSmHIW+yN5i8KFxP1cLRxPc5HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyAjM7U0ExVSD012/nb5rRJh8vssijJfSOaIgTN2kFIhYuLqFGeS5GdPbeRycuO5g
         VRJIqf2MBAH7jh7333DsWDm/wy0l8kkcI7qdof/3qxBouPPI7BjI0EOlJJhtxI1Uwr
         Abl79XcQF0Xf3vb+Uslsx4a97uifYCoKwqtY/8EY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 22/36] scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts
Date:   Wed, 10 Mar 2021 14:23:35 +0100
Message-Id: <20210310132321.205838523@linuxfoundation.org>
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

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit a967ddb22d94eb476ccef983b5f2730fa4d184d0 ]

Set optimized values for the following timeouts:

 - FC0_PROTECTION_TIMER
 - TC0_REPLAY_TIMER
 - AFC0_REQUEST_TIMER

Exynos doesn't yet use traffic class #1.

Link: https://lore.kernel.org/r/a0ff44f665a4f31d2f945fd71de03571204c576c.1608513782.git.kwmad.kim@samsung.com
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-exynos.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff14588..5ca21d1550df 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -640,6 +640,11 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		}
 	}
 
+	/* setting for three timeout values for traffic class #0 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+
 	return 0;
 out:
 	return ret;
@@ -1236,7 +1241,8 @@ struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCI_QUIRK_BROKEN_HCE |
 				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
-				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL,
+				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
-- 
2.30.1



