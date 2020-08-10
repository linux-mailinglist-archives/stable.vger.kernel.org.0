Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E62240846
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHJPTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgHJPTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:19:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A782075F;
        Mon, 10 Aug 2020 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072762;
        bh=EP9Okr7xDA55KwDoO7VqIqRa+YFrbS3z5zBlSRM50YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h547IKXRad3/pQauDm+el74twHa+QmK8+Gubpm99+j4R+wN3+kvgjQi9akwGuBRy1
         Q+1ASTXXWYBa5dmDjEe+DLpNEapvD/4Q9ZMNkSltaU0jT+pWteoIGUc5Eoldn1LzXL
         DwQFTUS1cWZGZudIk4gSnuMWXEwmtECgYqwhV5yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <Avri.Altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 01/38] scsi: ufs: Fix and simplify setup_xfer_req variant operation
Date:   Mon, 10 Aug 2020 17:18:51 +0200
Message-Id: <20200810151803.982776426@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

commit 6edfdcfe285e499994b94a0f93e1f46ab2398162 upstream.

Add missing setup_xfer_req() call in ufshcd_issue_devman_upiu_cmd() in
ufs-bsg path. Relocate existing setup_xfer_req() calls to a common place,
i.e., ufshcd_send_command(), to simplify the driver.

Link: https://lore.kernel.org/r/20200706060707.32608-3-stanley.chu@mediatek.com
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1925,8 +1925,11 @@ static void ufshcd_clk_scaling_update_bu
 static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
-	hba->lrb[task_tag].issue_time_stamp = ktime_get();
-	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
+	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+
+	lrbp->issue_time_stamp = ktime_get();
+	lrbp->compl_time_stamp = ktime_set(0, 0);
+	ufshcd_vops_setup_xfer_req(hba, task_tag, (lrbp->cmd ? true : false));
 	ufshcd_add_command_trace(hba, task_tag, "send");
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
@@ -2536,7 +2539,6 @@ static int ufshcd_queuecommand(struct Sc
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, true);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2723,7 +2725,6 @@ static int ufshcd_exec_dev_cmd(struct uf
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, false);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 


