Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508ED66C56C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAPQGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjAPQFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:05:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9824492
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB9F2B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE4EC433EF;
        Mon, 16 Jan 2023 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885026;
        bh=qGoY/juyP+JW62BA6zmGEwNX9OuerpgTYnTvz5C/fCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoaOWIMrvu64RkssTDr2yQmcYciRRnNIQcgWDCe4tGBPsA+iB/fIbLRlogDGt4IEY
         zkLSfFhHPW/Bv08FfborOCkuFfIMJJNAIx7f5iNNV9vRsII8FRjSjk0+R2dQHqYiEw
         WKkOI3m8HN+OU4VR43vqoZzsoLH+EFTU7cwBl/FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/86] scsi: ufs: Stop using the clock scaling lock in the error handler
Date:   Mon, 16 Jan 2023 16:51:21 +0100
Message-Id: <20230116154749.026889613@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5675c381ea51360b4968b78f23aefda73e3de90d ]

Instead of locking and unlocking the clock scaling lock, surround the
command queueing code with an RCU reader lock and call synchronize_rcu().
This patch prepares for removal of the clock scaling lock.

Link: https://lore.kernel.org/r/20211203231950.193369-16-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 1a5665fc8d7a ("scsi: ufs: core: WLUN suspend SSU/enter hibern8 fail recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a428b8145dcc..6dd341674110 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2700,6 +2700,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/*
+	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
+	 * calls.
+	 */
+	rcu_read_lock();
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
@@ -2766,7 +2772,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	ufshcd_send_command(hba, tag);
+
 out:
+	rcu_read_unlock();
+
 	up_read(&hba->clk_scaling_lock);
 
 	if (ufs_trigger_eh()) {
@@ -5952,8 +5961,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
-- 
2.35.1



