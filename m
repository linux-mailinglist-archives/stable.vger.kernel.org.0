Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6083D304AAF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbhAZE7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbhAYSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59DB22460;
        Mon, 25 Jan 2021 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600622;
        bh=2G6Rn/gY2Xs3mtp8EI9OyKOISUUsP/Wfg/cSZ0Fc9Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZw+pNaVrvNlspyfb+EZ/TULMrMcFY+Kusri6+dv9rw10OhxgB1jdAWuBT/ZMmYfQ
         rN44lI9EcoJ433epoPZGViwxftZfUMDl+tr9ViiQQQ3c2nCQobugzKNtoMQBAsP/Xx
         glgJhn+AzSJY9xSDbJH5ATRA5d1tpIo2g8VYH1Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/199] scsi: ufs: Fix tm request when non-fatal error happens
Date:   Mon, 25 Jan 2021 19:38:27 +0100
Message-Id: <20210125183219.855785587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit eeb1b55b6e25c5f7265ff45cd050f3bc2cc423a4 ]

When non-fatal error like line-reset happens, ufshcd_err_handler() starts
to abort tasks by ufshcd_try_to_abort_task(). When it tries to issue a task
management request, we hit two warnings:

WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 blk_mq_get_tag+0x438/0x46c

After fixing the above warnings we hit another tm_cmd timeout which may be
caused by unstable controller state:

__ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out

Then, ufshcd_err_handler() enters full reset, and kernel gets stuck. It
turned out ufshcd_print_trs() printed too many messages on console which
requires CPU locks. Likewise hba->silence_err_logs, we need to avoid too
verbose messages. This is actually not an error case.

Link: https://lore.kernel.org/r/20210107185316.788815-3-jaegeuk@kernel.org
Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 974a4f339ede2..8132893284670 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4913,7 +4913,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	} /* end of switch */
 
-	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
+	if ((host_byte(result) != DID_OK) &&
+	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -6208,9 +6209,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (enabled_intr_status && retval == IRQ_NONE) {
-		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
-					__func__, intr_status);
+	if (enabled_intr_status && retval == IRQ_NONE &&
+				!ufshcd_eh_in_progress(hba)) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
+					__func__,
+					intr_status,
+					hba->ufs_stats.last_intr_status,
+					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
@@ -6254,7 +6259,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
 	req->end_io_data = &wait;
 	free_slot = req->tag;
 	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
-- 
2.27.0



