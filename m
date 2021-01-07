Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4202ED2A4
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbhAGOfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbhAGOdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF90D2333E;
        Thu,  7 Jan 2021 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029986;
        bh=yvAa67+CImCpDvS5FDLRYpaqyR8XInlQpBPfPloNPVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5pTADeeNTeTjgRwsLRNZ9YJ3Ko/3VAn13GkMl5UoSNCbsbiYikq6hVdpiTMXWKUM
         HYJgx9969u7jFvG2EVXX4q2hsj8GKZVEcGngMy9v+0KMpdBp670BpG4ZPIKtAzdQYy
         vaJBWFq757B3LmL5AhXAXgp5s79L66tm+AvVhQnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/20] scsi: ufs: Re-enable WriteBooster after device reset
Date:   Thu,  7 Jan 2021 15:34:07 +0100
Message-Id: <20210107143054.098061192@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit bd14bf0e4a084514aa62d24d2109e0f09a93822f ]

UFS 3.1 specification mentions that the WriteBooster flags listed below
will be set to their default values, i.e. disabled, after power cycle or
any type of reset event. Thus we need to reset the flag variables kept in
struct hba to align with the device status and ensure that
WriteBooster-related functions are configured properly after device reset.

Without this fix, WriteBooster will not be enabled successfully after by
ufshcd_wb_ctrl() after device reset because hba->wb_enabled remains true.

Flags required to be reset to default values:

 - fWriteBoosterEn: hba->wb_enabled

 - fWriteBoosterBufferFlushEn: hba->wb_buf_flush_enabled

 - fWriteBoosterBufferFlushDuringHibernate: No variable mapped

Link: https://lore.kernel.org/r/20201208135635.15326-2-stanley.chu@mediatek.com
Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index de97971e2d865..cd51553e522da 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1183,8 +1183,13 @@ static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 	if (hba->vops && hba->vops->device_reset) {
 		int err = hba->vops->device_reset(hba);
 
-		if (!err)
+		if (!err) {
 			ufshcd_set_ufs_dev_active(hba);
+			if (ufshcd_is_wb_allowed(hba)) {
+				hba->wb_enabled = false;
+				hba->wb_buf_flush_enabled = false;
+			}
+		}
 		if (err != -EOPNOTSUPP)
 			ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, err);
 	}
-- 
2.27.0



