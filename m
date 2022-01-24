Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EFF49A30F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386884AbiAXXtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46378 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454535AbiAXVdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8912B81188;
        Mon, 24 Jan 2022 21:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6736C340E4;
        Mon, 24 Jan 2022 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059983;
        bh=UAjvnhTZ2Yn5EHOvdWzEPrFzvMqBIFWTeR/luTOCF24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlfP+4xjHb3Z7W5gchzDF72Lrf7xEZDa6et5uscVWw9uGDttsCQAyAIwjFiIv/smj
         9r72BWXzHyKLhlNfPoOzBbZ5Iqib9ZEQKr+YEyb0vEeeYIgKHIjztm8MkDgnl5gl3C
         7fxkYkjz2sPSqFnPlTBHn5ExRy2sC/TxpO6ng+m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0767/1039] scsi: hisi_sas: Prevent parallel FLR and controller reset
Date:   Mon, 24 Jan 2022 19:42:36 +0100
Message-Id: <20220124184151.096712073@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Liu <liuqi115@huawei.com>

[ Upstream commit 16775db613c2bdea09705dcb876942c0641a1098 ]

If we issue a controller reset command during executing a FLR a hung task
may be found:

 Call trace:
  __switch_to+0x158/0x1cc
  __schedule+0x2e8/0x85c
  schedule+0x7c/0x110
  schedule_timeout+0x190/0x1cc
  __down+0x7c/0xd4
  down+0x5c/0x7c
  hisi_sas_task_exec+0x510/0x680 [hisi_sas_main]
  hisi_sas_queue_command+0x24/0x30 [hisi_sas_main]
  smp_execute_task_sg+0xf4/0x23c [libsas]
  sas_smp_phy_control+0x110/0x1e0 [libsas]
  transport_sas_phy_reset+0xc8/0x190 [libsas]
  phy_reset_work+0x2c/0x40 [libsas]
  process_one_work+0x1dc/0x48c
  worker_thread+0x15c/0x464
  kthread+0x160/0x170
  ret_from_fork+0x10/0x18

This is a race condition which occurs when the FLR completes first.

Here the host HISI_SAS_RESETTING_BIT flag out gets of sync as
HISI_SAS_RESETTING_BIT is not always cleared with the hisi_hba.sem held, so
now only set/unset HISI_SAS_RESETTING_BIT under hisi_hba.sem .

Link: https://lore.kernel.org/r/1639579061-179473-7-git-send-email-john.garry@huawei.com
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 +++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f206c433de325..8a13bc08d6575 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1581,7 +1581,6 @@ void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba)
 {
 	struct Scsi_Host *shost = hisi_hba->shost;
 
-	down(&hisi_hba->sem);
 	hisi_hba->phy_state = hisi_hba->hw->get_phys_state(hisi_hba);
 
 	scsi_block_requests(shost);
@@ -1606,9 +1605,9 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	if (hisi_hba->reject_stp_links_msk)
 		hisi_sas_terminate_stp_reject(hisi_hba);
 	hisi_sas_reset_init_all_devices(hisi_hba);
-	up(&hisi_hba->sem);
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
+	up(&hisi_hba->sem);
 
 	hisi_sas_rescan_topology(hisi_hba, hisi_hba->phy_state);
 }
@@ -1619,8 +1618,11 @@ static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->hw->soft_reset)
 		return -1;
 
-	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
+	down(&hisi_hba->sem);
+	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
+		up(&hisi_hba->sem);
 		return -1;
+	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0ef6c21bf0811..11a44d9dd9b2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4848,6 +4848,7 @@ static void hisi_sas_reset_prepare_v3_hw(struct pci_dev *pdev)
 	int rc;
 
 	dev_info(dev, "FLR prepare\n");
+	down(&hisi_hba->sem);
 	set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 	hisi_sas_controller_reset_prepare(hisi_hba);
 
-- 
2.34.1



