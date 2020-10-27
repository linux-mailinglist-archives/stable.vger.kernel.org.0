Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034E929C09E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818069AbgJ0RRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbgJ0O5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDFB22284;
        Tue, 27 Oct 2020 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810626;
        bh=Td4XOqgLXcE0pbmFvb041fBx68MQZDxGSpkPKWfgxf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpbKmXPUmJj0kpBk28PZ/lyI8OEsUqCslaC4xeeQSfFdd7MJZeZcK9NXeuviAK4jJ
         miwGXsGjDykP/p18/hEIONJfWz5qGKIpkVvD+rJKtJaGoCYB6iuELD++FquHkXPByE
         uY3rUbU6y2IPyuREEkwXtybrcmHxc6DRsNE8ZrGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 205/633] scsi: ufs: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
Date:   Tue, 27 Oct 2020 14:49:08 +0100
Message-Id: <20201027135532.305102833@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit a3e40b80dc951057033dce86f0e675b2b822b513 ]

Simply add HOST_PA_TACTIVATE quirk back since it was incorrectly removed
before.

Link: https://lore.kernel.org/r/20200908064507.30774-3-stanley.chu@mediatek.com
Fixes: 47d054580a75 ("scsi: ufs-mediatek: fix HOST_PA_TACTIVATE quirk for Samsung UFS Devices")
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d56ce8d97d4e8..7ad127f213977 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -585,13 +585,7 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 
 static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 {
-	struct ufs_dev_info *dev_info = &hba->dev_info;
-	u16 mid = dev_info->wmanufacturerid;
-
 	ufshcd_fixup_dev_quirks(hba, ufs_mtk_dev_fixups);
-
-	if (mid == UFS_VENDOR_SAMSUNG)
-		hba->dev_quirks &= ~UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
 }
 
 /**
-- 
2.25.1



