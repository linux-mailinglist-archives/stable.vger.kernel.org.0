Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E91040636E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbhIJAqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233868AbhIJAV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ED8B61101;
        Fri, 10 Sep 2021 00:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233247;
        bh=+FuR5Dh6Qmv5Vug9uDWpQ3Y1dH/oe7aaVHx8/31ZWEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UroPebyyDoqisluem+KvktrZdbI/QhWlkjaNkBUPxLLM2lyUD/Ig1TVYNXxhgW57y
         eHjjiEhMKgkJoMOnJ2DuHUPTqfY8fUHjXahr5xnECGnx3+AQW+X6Fhyp49mjQ2kIZi
         g3obXKaUFVVdmAVVMz32Z6ca+llWB/k1aX9cxhsPGSKpU9actlcqF9ae4qX9Ofxydy
         wBR2Eli1FfIW26IVhmuNKpa37LUaSBKuFxhO2vyTuJ1aExTErYs62BAFm2t0tl2jQT
         OGcbyprfCyoxgxlirpkVnQQO8FG1LXvNewuxZrsRD2nMMDx5B4lhzl1/P6jrTP6iJd
         Pt8fAMjAvhJCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 13/53] scsi: ufs: Verify UIC locking requirements at runtime
Date:   Thu,  9 Sep 2021 20:19:48 -0400
Message-Id: <20210910002028.175174-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 35c7d874f5993db04ce3aa310ae088f14b801eda ]

Instead of documenting the locking requirements of the UIC code as
comments, use lockdep_assert_held() such that lockdep verifies the lockdep
requirements at runtime if lockdep is enabled.

Link: https://lore.kernel.org/r/20210722033439.26550-8-bvanassche@acm.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 +++++++++-------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 854c96e63007..b9ed7115a721 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2084,15 +2084,15 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
+ * ufshcd_dispatch_uic_cmd - Dispatch an UIC command to the Unipro layer
  * @hba: per adapter instance
  * @uic_cmd: UIC command
- *
- * Mutex must be held.
  */
 static inline void
 ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+
 	WARN_ON(hba->active_uic_cmd);
 
 	hba->active_uic_cmd = uic_cmd;
@@ -2110,11 +2110,10 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 }
 
 /**
- * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
+ * ufshcd_wait_for_uic_cmd - Wait for completion of an UIC command
  * @hba: per adapter instance
  * @uic_cmd: UIC command
  *
- * Must be called with mutex held.
  * Returns 0 only if success.
  */
 static int
@@ -2123,6 +2122,8 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+
 	if (wait_for_completion_timeout(&uic_cmd->done,
 					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
@@ -2152,14 +2153,15 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  * @uic_cmd: UIC command
  * @completion: initialize the completion only if this is set to true
  *
- * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
- * with mutex held and host_lock locked.
  * Returns 0 only if success.
  */
 static int
 __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 		      bool completion)
 {
+	lockdep_assert_held(&hba->uic_cmd_mutex);
+	lockdep_assert_held(hba->host->host_lock);
+
 	if (!ufshcd_ready_for_uic_cmd(hba)) {
 		dev_err(hba->dev,
 			"Controller not ready to accept UIC commands\n");
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 812aa348751e..899a674b49fd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -636,7 +636,7 @@ struct ufs_hba_variant_params {
  * @priv: pointer to variant specific private data
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for uic command
+ * @uic_cmd_mutex: mutex for UIC command
  * @tmf_tag_set: TMF tag set.
  * @tmf_queue: Used to allocate TMF tags.
  * @pwr_done: completion for power mode change
-- 
2.30.2

