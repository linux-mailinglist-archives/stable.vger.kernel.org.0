Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17C27C944
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgI2MJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbgI2Lhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28CA8206E5;
        Tue, 29 Sep 2020 11:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379334;
        bh=Ittz/wxGC9/mPG2IeyB9vgmU2CwAvg/OtpsciejW1Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir2DgeRRfZSYDV73wHPa8pyId3CpUJl+7W0codOmKPBUeZKBVH8Gqwe6lctOpYi/C
         F17Cbb/26YXG4JbpWrmKBOD8mO2LSbyP5mLzAM5RKM3M9JBUcqJK/cZCSn0pnp6APo
         KgDAOpTGl93jEAbVdkkyP1+WN3Mu6Gj4C6n5mrY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/388] scsi: ufs: Make ufshcd_add_command_trace() easier to read
Date:   Tue, 29 Sep 2020 12:57:00 +0200
Message-Id: <20200929110014.792957109@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e4d2add7fd5bc64ee3e388eabe6b9e081cb42e11 ]

Since the lrbp->cmd expression occurs multiple times, introduce a new local
variable to hold that pointer. This patch does not change any
functionality.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191224220248.30138-3-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5e502e1605549..020a93a40a982 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -334,27 +334,27 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	u8 opcode = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
-		if (lrbp->cmd)
+		if (cmd)
 			ufshcd_add_cmd_upiu_trace(hba, tag, str);
 		return;
 	}
 
-	if (lrbp->cmd) { /* data phase exists */
+	if (cmd) { /* data phase exists */
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str);
-		opcode = (u8)(*lrbp->cmd->cmnd);
+		opcode = cmd->cmnd[0];
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (lrbp->cmd->request && lrbp->cmd->request->bio)
-				lba =
-				  lrbp->cmd->request->bio->bi_iter.bi_sector;
+			if (cmd->request && cmd->request->bio)
+				lba = cmd->request->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		}
-- 
2.25.1



