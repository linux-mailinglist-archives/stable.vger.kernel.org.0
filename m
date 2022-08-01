Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9875586A6E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiHAMQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiHAMQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:16:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D074A7B7B2;
        Mon,  1 Aug 2022 04:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 163EBB81177;
        Mon,  1 Aug 2022 11:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D51EC433D6;
        Mon,  1 Aug 2022 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355118;
        bh=BCSZ5FcxKHLnLX9QYsEZYRemGsHyujug8mJ30WI0Syo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0rfW4RclhbNf+tvS4I3B1d3x042P1gRiaI8jRt3P2Y0A4QJPWlH13VpEuibFTvmr
         yp3/zWn77eS/pBU7KCDfYnfnB9wwZlSedOmr07/zOZonnqG9WNRp/WlXs2ycP3mdQU
         gOXnlX6GbnwAQJTUmjJ1U0CNgsoXVavtAA3/ImQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 70/88] scsi: ufs: Support clearing multiple commands at once
Date:   Mon,  1 Aug 2022 13:47:24 +0200
Message-Id: <20220801114141.237012467@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d1a7644648b7cdacaf8d1013a4285001911e9bc8 ]

Modify ufshcd_clear_cmd() such that it supports clearing multiple commands
at once instead of one command at a time. This change will be used in a
later patch to reduce the time spent in the reset handler.

Link: https://lore.kernel.org/r/20220613214442.212466-3-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 452ad0612067..a34c1fab0246 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -734,17 +734,28 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
+ * ufshcd_utrl_clear() - Clear requests from the controller request list.
  * @hba: per adapter instance
- * @pos: position of the bit to be cleared
+ * @mask: mask with one bit set for each request to be cleared
  */
-static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
+static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 mask)
 {
 	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
-		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
-	else
-		ufshcd_writel(hba, ~(1 << pos),
-				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+		mask = ~mask;
+	/*
+	 * From the UFSHCI specification: "UTP Transfer Request List CLear
+	 * Register (UTRLCLR): This field is bit significant. Each bit
+	 * corresponds to a slot in the UTP Transfer Request List, where bit 0
+	 * corresponds to request slot 0. A bit in this field is set to ‘0’
+	 * by host software to indicate to the host controller that a transfer
+	 * request slot is cleared. The host controller
+	 * shall free up any resources associated to the request slot
+	 * immediately, and shall set the associated bit in UTRLDBR to ‘0’. The
+	 * host software indicates no change to request slots by setting the
+	 * associated bits in this field to ‘1’. Bits in this field shall only
+	 * be set ‘1’ or ‘0’ by host software when UTRLRSR is set to ‘1’."
+	 */
+	ufshcd_writel(hba, ~mask, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -2853,16 +2864,19 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
-static int
-ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
+/*
+ * Clear all the requests from the controller for which a bit has been set in
+ * @mask and wait until the controller confirms that these requests have been
+ * cleared.
+ */
+static int ufshcd_clear_cmds(struct ufs_hba *hba, u32 mask)
 {
 	int err = 0;
 	unsigned long flags;
-	u32 mask = 1 << tag;
 
 	/* clear outstanding transaction before retry */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_utrl_clear(hba, tag);
+	ufshcd_utrl_clear(hba, mask);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
@@ -2953,7 +2967,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
-		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
+		if (!ufshcd_clear_cmds(hba, 1U << lrbp->task_tag))
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
 		/*
@@ -6988,7 +7002,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
 		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmd(hba, pos);
+			err = ufshcd_clear_cmds(hba, 1U << pos);
 			if (err)
 				break;
 			__ufshcd_transfer_req_compl(hba, 1U << pos);
@@ -7090,7 +7104,7 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		goto out;
 	}
 
-	err = ufshcd_clear_cmd(hba, tag);
+	err = ufshcd_clear_cmds(hba, 1U << tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
 			__func__, tag, err);
-- 
2.35.1



