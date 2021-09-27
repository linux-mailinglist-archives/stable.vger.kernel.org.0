Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C138F419C2C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbhI0R0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237946AbhI0RYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92EC761378;
        Mon, 27 Sep 2021 17:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762925;
        bh=+tS63+rwMVzO6bxrbef1zvTZNArwiR1BtIhtuecDoIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdBo5M9mFYOF7WamzmKb7uSLAqdn+BzjL4EFKhk47HXZ+zJmsecOJ1x6CPMYQT9G2
         bxa1NqdXjGWq/arHos0AxP1HISm8ZQMT88BY3UBOhTCZJISGmsP2U+6/4jOlO4dguu
         4rXL8v3e6Bk6/6ohWGVceJ3lXULXvUf7yKHJfxug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 103/162] scsi: ufs: Revert "Utilize Transfer Request List Completion Notification Register"
Date:   Mon, 27 Sep 2021 19:02:29 +0200
Message-Id: <20210927170237.007691307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1f522c5049016cfea4f9d131ae9089e6fdba3980 ]

Using the UTRLCNR register involves two MMIO accesses in the hot path while
using the doorbell register only involves a single MMIO access. Since MMIO
accesses take time, do not use the UTRLCNR register. The spinlock
contention on the SCSI host lock that is reintroduced by this commit will
be addressed later.

This reverts commit 6f7151729647e58ac7c522081255fd0c07b38105.

Link: https://lore.kernel.org/r/20210722033439.26550-12-bvanassche@acm.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 52 +++++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h |  5 ----
 drivers/scsi/ufs/ufshci.h |  1 -
 3 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 15ac5fa14805..b43abba84a6f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2112,6 +2112,7 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
@@ -2120,19 +2121,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
-	if (ufshcd_has_utrlcnr(hba)) {
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	} else {
-		unsigned long flags;
-
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	set_bit(task_tag, &hba->outstanding_reqs);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -5282,17 +5274,17 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_trc_handler - handle transfer requests completion
+ * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @use_utrlcnr: get completed requests from UTRLCNR
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs = 0;
+	unsigned long completed_reqs, flags;
+	u32 tr_doorbell;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5305,24 +5297,10 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
-	if (use_utrlcnr) {
-		u32 utrlcnr;
-
-		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
-		if (utrlcnr) {
-			ufshcd_writel(hba, utrlcnr,
-				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
-			completed_reqs = utrlcnr;
-		}
-	} else {
-		unsigned long flags;
-		u32 tr_doorbell;
-
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -5804,7 +5782,7 @@ out:
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_trc_handler(hba, false);
+	ufshcd_transfer_req_compl(hba);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6445,7 +6423,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba));
+		retval |= ufshcd_transfer_req_compl(hba);
 
 	return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 194755c9ddfe..86d4765a17b8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1160,11 +1160,6 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
-static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
-{
-	return (hba->ufs_version >= ufshci_version(3, 0));
-}
-
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
 			bool up, enum ufs_notify_change_status status)
 {
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 5affb1fce5ad..de95be5d11d4 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -39,7 +39,6 @@ enum {
 	REG_UTP_TRANSFER_REQ_DOOR_BELL		= 0x58,
 	REG_UTP_TRANSFER_REQ_LIST_CLEAR		= 0x5C,
 	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP	= 0x60,
-	REG_UTP_TRANSFER_REQ_LIST_COMPL		= 0x64,
 	REG_UTP_TASK_REQ_LIST_BASE_L		= 0x70,
 	REG_UTP_TASK_REQ_LIST_BASE_H		= 0x74,
 	REG_UTP_TASK_REQ_DOOR_BELL		= 0x78,
-- 
2.33.0



