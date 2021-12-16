Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABBC476E84
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 11:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhLPKHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 05:07:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:14308 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233509AbhLPKHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 05:07:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639649272; x=1671185272;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Lld2WtEUnVaUe+c5AF+Oi53Ky5X+ewlFYq8AJTHpbUc=;
  b=C9RnPDpgNUT7Xt9ytq6fw9nw0bGfnvBQQoEjg9syuHGh9Ep9k64DHhG6
   ao17/FujPy1iGOcowOq6DQrxZKO9lXokn1SJpqpBskSCmVxdrxn2zZ3tM
   V0wCKclo4l/Gi/o57MRE+MWrvi1tvM0trCWkVzwmMEJwMYW70P86Smpla
   eUSCNu16nvtfNPBV8lW68/ZqPZKNiwSqzTDAQuxhmPHo71JG2kiYsCKY1
   4HfmOcnT+Qto1+TaXc6C6Ud/G9UV7HBjFGDaqoEtrFp2/ovGYzE/U+lV7
   Z8aNq94yyyQkjioV3JLzyO64zjl8diYgu8dTGdwHzm+wzE4lPalhTjeDR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219467951"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219467951"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 02:07:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="545923183"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2021 02:07:50 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15] scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION
Date:   Thu, 16 Dec 2021 12:07:49 +0200
Message-Id: <20211216100749.202131-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit af21c3fd5b3ec540a97b367a70b26616ff7e0c55 upstream.

Note for stable: This patch is required if commit edc0596cc04bf ("scsi:
ufs: core: Stop clearing UNIT ATTENTIONS") has been cherry-picked.

Commit 57d104c153d3 ("ufs: add UFS power management support") made the UFS
driver submit a REQUEST SENSE command before submitting a power management
command to a WLUN to clear the POWER ON unit attention. Instead of
submitting a REQUEST SENSE command before submitting a power management
command, retry the power management command until it succeeds.

This is the preparation to get rid of all UNIT ATTENTION code which should
be handled by users.

Link: https://lore.kernel.org/r/20211001182015.1347587-2-jaegeuk@kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Adrian: For stable]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 55f2e4d6f10b..31adf25e57b0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8477,7 +8477,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret;
+	int ret, retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8510,8 +8510,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+	for (retries = 3; retries > 0; --retries) {
+		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+		if (!scsi_status_is_check_condition(ret) ||
+				!scsi_sense_valid(&sshdr) ||
+				sshdr.sense_key != UNIT_ATTENTION)
+			break;
+	}
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.25.1

