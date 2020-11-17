Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298B72B5FD1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgKQM6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgKQM5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 370BC2464E;
        Tue, 17 Nov 2020 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617867;
        bh=/MUdipLcb4JkvDppPS27UAP/oB9I9J9uiNiR54nSO1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jylpcKqVW8hCDlNBLEKHqzy4fCLj0xMN0eJpwOXUzR+abXIhUiHlztSivdwvtF1C4
         9zobbYxRTq8Tp31tZAeO/abolv6l1QqH00Icf2hAPNGgGWSxgJ1VmHddV63WoGgCtR
         SCz22s6E1dc0Ehe5/815A1jVtKqfAQvgjoMcrSDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Hongwu Su <hongwus@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 2/6] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
Date:   Tue, 17 Nov 2020 07:57:39 -0500
Message-Id: <20201117125743.599974-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125743.599974-1-sashal@kernel.org>
References: <20201117125743.599974-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit da3fecb0040324c08f1587e5bff1f15f36be1872 ]

The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
decreased back in ufshcd_ungate_work() in a paired way. However, if
specific ufshcd_hold/release sequences are met, it is possible that
scsi_block_reqs_cnt is increased twice but only one ungate work is
queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() and
ufshcd_ungate_work() in a paired way, increase it only if queue_work()
returns true.

Link: https://lore.kernel.org/r/1604384682-15837-2-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b2cbdd01ab10b..a63119c35fde8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1592,12 +1592,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * work and to enable clocks.
 		 */
 	case CLKS_OFF:
-		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		queue_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.ungate_work);
+		if (queue_work(hba->clk_gating.clk_gating_workq,
+			       &hba->clk_gating.ungate_work))
+			ufshcd_scsi_block_requests(hba);
 		/*
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
-- 
2.27.0

