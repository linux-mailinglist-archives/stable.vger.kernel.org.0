Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749D129B8EF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802101AbgJ0Pph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760829AbgJ0Pa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBF320728;
        Tue, 27 Oct 2020 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812625;
        bh=YxubElHCnHLxaw+s0cJTn88MBLKvWvKGAU+fkaTe9Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+rxdfyaztwnq9zlIWeVQ/D0LC6RU/+ls1NF7x0QPARYtP7sd4dWq2MuozG2odAgj
         BqdZ1qA5PqoU7qF5ZA9H0vfw9H6cYWVKPE/T6BHmdlqDfBvZL4DIL1v0cFq6De+FAa
         psuIsUOvLxrIGWirO1vff2cpQ1aejoKtvMwzHyCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 244/757] scsi: ufs: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
Date:   Tue, 27 Oct 2020 14:48:14 +0100
Message-Id: <20201027135502.032457448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 0a50b95315f8f..6b661135c03b5 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -672,13 +672,7 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 
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



