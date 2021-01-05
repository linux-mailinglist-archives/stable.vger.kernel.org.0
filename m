Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C901A2EA209
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbhAEBAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhAEBAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AF622581;
        Tue,  5 Jan 2021 00:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808360;
        bh=p9/ot+8cguDCXR5x0/upe/u3QXAAv78RzEbKzbOalkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svheP+Tyk14UERaRZr5m5f8EgIKooDiM3f/1QjdqTZ71wMXiwjJTww/Ed3dAzlpih
         Yvu2CNN382yrF2twrjy8PvntLMBcYJ56g6OBAJZYaHgwGRZ9t8Vcvrq8usI7pTjFaS
         Zsl/dsVnoKCFXshPmEqg253oOOiGcFfdpP4OzeIrkAf2hxeVxPWpyCBpK8dt1ubRYN
         o/zNpOr7nnq0bV7SUQcvG6K13LT29pbfs+FQg3l6eWJSro1mTX4R2bkrejOsfnphpC
         VhZl7MrMjiWwEhAamZDZyYYSCVJzfHOYasWEPE97C3YSpA6u+um+JtpmVYbelX10NW
         h1icjcjHqNHDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randall Huang <huangrandall@google.com>,
        kernel test robot <lkp@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Leo Liou <leoliou@google.com>,
        Jaegeuk Kim <jaegeuk@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/17] scsi: ufs: Clear UAC for RPMB after ufshcd resets
Date:   Mon,  4 Jan 2021 19:59:01 -0500
Message-Id: <20210105005915.3954208-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randall Huang <huangrandall@google.com>

[ Upstream commit 1918651f2d7e8d58c9b7c49755c61e41ed655009 ]

If RPMB is not provisioned, we may see RPMB failure after UFS
suspend/resume.  Inject request_sense to clear uac in ufshcd reset flow.

Link: https://lore.kernel.org/r/20201201041402.3860525-1-jaegeuk@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Randall Huang <huangrandall@google.com>
Signed-off-by: Leo Liou <leoliou@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d7e9c4bc80478..ec7005bcf61d8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -220,6 +220,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
@@ -6842,7 +6843,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	/* Establish the link again and restore the device */
 	err = ufshcd_probe_hba(hba, false);
-
+	if (!err)
+		ufshcd_clear_ua_wluns(hba);
 out:
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -8274,13 +8276,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * handling context.
 	 */
 	hba->host->eh_noresume = 1;
-	if (hba->wlun_dev_clr_ua) {
-		ret = ufshcd_send_request_sense(hba, sdp);
-		if (ret)
-			goto out;
-		/* Unit attention condition is cleared now */
-		hba->wlun_dev_clr_ua = false;
-	}
+	ufshcd_clear_ua_wluns(hba);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -8301,7 +8297,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
-out:
+
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
 	return ret;
-- 
2.27.0

