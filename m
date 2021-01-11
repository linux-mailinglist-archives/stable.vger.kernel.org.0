Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A932F13D4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbhAKNPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbhAKNPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9EF2255F;
        Mon, 11 Jan 2021 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370903;
        bh=p9/ot+8cguDCXR5x0/upe/u3QXAAv78RzEbKzbOalkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1I39n8joY1uLNd++TIcrPds4/2u5jEfTfQVXeNu920TLeoo2dfnmTmVo9Z2b6HN2Y
         4WZ6WX3kbtLa4ql0QpBV1gFTtaKiK66movFQQnqG7/0D9v8Xycy0PIM7J6tCJlZFn/
         OBOTatGAOhZg3Hz6QjrXT+l49Rvg2/0lPVgWG3Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Randall Huang <huangrandall@google.com>,
        Leo Liou <leoliou@google.com>,
        Jaegeuk Kim <jaegeuk@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/145] scsi: ufs: Clear UAC for RPMB after ufshcd resets
Date:   Mon, 11 Jan 2021 14:01:18 +0100
Message-Id: <20210111130051.130824665@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



