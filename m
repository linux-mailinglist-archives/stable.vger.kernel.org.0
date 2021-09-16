Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3924B40E5E6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344276AbhIPRQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344390AbhIPRNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B280F61263;
        Thu, 16 Sep 2021 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810325;
        bh=3QmECldtHr1IgJyWG/9e3DT2CbZjRu4GNBs9oAMSUXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwIigM8+nrkkZWDyCGvaVqbf45jYL1QszP91/vVyCQhilPZSL2lJC/dhX+BkOyg45
         GSuXYuRUxbAF2tzylXqZeyj6rV4m6dLCP3XoDOW/NCiRRHS1w7ep6jAI0r+bMQ5Geu
         F2r96uhbx6LBNmjFRWhn+AVc3/rRYB6ENt9N0SB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 092/432] scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
Date:   Thu, 16 Sep 2021 17:57:21 +0200
Message-Id: <20210916155813.896454635@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 8a686f26eaa4b8a5c494b6b69e8a97815e3ffb82 ]

>From Documentation/scheduler/completion.rst: "When a completion is declared
as a local variable within a function, then the initialization should
always use DECLARE_COMPLETION_ONSTACK() explicitly, not just to make
lockdep happy, but also to make it clear that limited scope had been
considered and is intentional."

Link: https://lore.kernel.org/r/20210722033439.26550-6-bvanassche@acm.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 179227180961..0fe559ddc789 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2949,11 +2949,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
 	struct request_queue *q = hba->cmd_queue;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err;
 	int tag;
-	struct completion wait;
 
 	down_read(&hba->clk_scaling_lock);
 
@@ -2978,7 +2978,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -3985,14 +3984,13 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  */
 static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
-	struct completion uic_async_done;
+	DECLARE_COMPLETION_ONSTACK(uic_async_done);
 	unsigned long flags;
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
-	init_completion(&uic_async_done);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6665,11 +6663,11 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum query_opcode desc_op)
 {
 	struct request_queue *q = hba->cmd_queue;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 	int tag;
-	struct completion wait;
 	u8 upiu_flags;
 
 	down_read(&hba->clk_scaling_lock);
@@ -6687,7 +6685,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
-- 
2.30.2



