Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92755DF38
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiF1CTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243369AbiF1CT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F0A22BDD;
        Mon, 27 Jun 2022 19:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B58B81C10;
        Tue, 28 Jun 2022 02:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BFAC341CB;
        Tue, 28 Jun 2022 02:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382762;
        bh=0eEks71eq30jxvu7+hjsZIbLr6Ginp7ugJUnTaqFP2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4VGGUk5ENNNcK/gWYAJKQuo+p7R+YbKbPhJdsFmwyO44jkUIM/3ZaO/ysvyrK49F
         AZZANAIIZe7quUSkJJR3LpMi7hPUB4sEhicjWB9EGJHuRxfEBhsdPVaVKgCLdWjJzq
         qQEm0HwTVohGQmsNFTNjyM617zSk6m5y6COgedTj0dqftfIVylJZuKSAgYY2mbpQzy
         HK9A2Ycmo70k0/HjhKwCLERBZAiQtMMNcWsBY3nh3zFtMNmpEmCR1X99UpbOXCzv2d
         xEefS1DgB2yhy8Ou8yaHaUX2lFc/cBS7dsgr9Y5Mai1bvLRYxkh1eV1uVgH6f3DhY7
         Q4zxl6RK5h0kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        daejun7.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 16/53] scsi: ufs: Fix a race between the interrupt handler and the reset handler
Date:   Mon, 27 Jun 2022 22:18:02 -0400
Message-Id: <20220628021839.594423-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2acd76e7b8596e307fcec8fc6bc5fe5ab174749a ]

Prevent that both the interrupt handler and the reset handler try to
complete a request at the same time. This patch is the result of an
analysis of the following crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.107-android13-4-00051-g1e48e8970cca-ab8664745 #1
pc : ufshcd_release_scsi_cmd+0x30/0x46c
lr : __ufshcd_transfer_req_compl+0x4fc/0x9c0
Call trace:
 ufshcd_release_scsi_cmd+0x30/0x46c
 __ufshcd_transfer_req_compl+0x4fc/0x9c0
 ufshcd_poll+0xf0/0x208
 ufshcd_sl_intr+0xb8/0xf0
 ufshcd_intr+0x168/0x2f4
 __handle_irq_event_percpu+0xa0/0x30c
 handle_irq_event+0x84/0x178
 handle_fasteoi_irq+0x150/0x2e8
 __handle_domain_irq+0x114/0x1e4
 gic_handle_irq.31846+0x58/0x300
 el1_irq+0xe4/0x1c0
 cpuidle_enter_state+0x3ac/0x8c4
 do_idle+0x2fc/0x55c
 cpu_startup_entry+0x84/0x90
 kernel_init+0x0/0x310
 start_kernel+0x0/0x608
 start_kernel+0x4ec/0x608

Link: https://lore.kernel.org/r/20220613214442.212466-4-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f08586a4470c..02a122738686 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6970,14 +6970,14 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_eh_device_reset_handler - device reset handler registered to
- *                                    scsi layer.
+ * ufshcd_eh_device_reset_handler() - Reset a single logical unit.
  * @cmd: SCSI command pointer
  *
  * Returns SUCCESS/FAILED
  */
 static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
+	unsigned long flags, pending_reqs = 0, not_cleared = 0;
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	u32 pos;
@@ -6996,14 +6996,24 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	}
 
 	/* clear the commands that were pending for corresponding LUN */
-	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmds(hba, 1U << pos);
-			if (err)
-				break;
-			__ufshcd_transfer_req_compl(hba, 1U << pos);
-		}
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
+		if (hba->lrb[pos].lun == lun)
+			__set_bit(pos, &pending_reqs);
+	hba->outstanding_reqs &= ~pending_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (ufshcd_clear_cmds(hba, pending_reqs) < 0) {
+		spin_lock_irqsave(&hba->outstanding_lock, flags);
+		not_cleared = pending_reqs &
+			ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		hba->outstanding_reqs |= not_cleared;
+		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+		dev_err(hba->dev, "%s: failed to clear requests %#lx\n",
+			__func__, not_cleared);
 	}
+	__ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared);
 
 out:
 	hba->req_abort_count = 0;
-- 
2.35.1

