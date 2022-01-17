Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF1490CFE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbiAQRAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbiAQQ74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10E12B81147;
        Mon, 17 Jan 2022 16:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76E7C36AE3;
        Mon, 17 Jan 2022 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438793;
        bh=dFxVt+CCaKAIh5laUX5e+SmQL/wfV4Qkpyftoa/psZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfsBXn7iq4tRF84/rYjsfJ0OJUU1Yfgg0+fRnf4t6eGw6abvitpl6Nv9qy/6SDIaY
         ahDEjJxCYq4fOmWKuFsL2d4Ccniv4v7XPOeNk6dzRnromYcISyt/JFmPNEXr41oqHC
         v/S5UqPW8A1GAaTmMLOAUHXrg7T9pCSPnQHbGvnJ1b7FVYc81/ecCexv4iPHapQnWd
         YnV2YgvQWrt1gdG6t21PeRDSwQrEKOyRjxXnG3mgT9FEr001ogN41Cb+EbB52X4iYV
         7KVpuCTPqFdYgQ4D5pUVrK3PhuOscRvkYgrw4pzoMvpQsFfCiTnm+URpO3C6tUWB1a
         dxNkqNsRy7o5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 24/52] scsi: lpfc: Trigger SLI4 firmware dump before doing driver cleanup
Date:   Mon, 17 Jan 2022 11:58:25 -0500
Message-Id: <20220117165853.1470420-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7dd2e2a923173d637c272e483966be8e96a72b64 ]

Extraneous teardown routines are present in the firmware dump path causing
altered states in firmware captures.

When a firmware dump is requested via sysfs, trigger the dump immediately
without tearing down structures and changing adapter state.

The driver shall rely on pre-existing firmware error state clean up
handlers to restore the adapter.

Link: https://lore.kernel.org/r/20211204002644.116455-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  2 +-
 drivers/scsi/lpfc/lpfc_attr.c    | 62 ++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  8 ++++-
 drivers/scsi/lpfc/lpfc_sli.c     |  6 ----
 4 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 2f8e6d0a926fe..54c58392fd5d0 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1023,7 +1023,6 @@ struct lpfc_hba {
 #define HBA_DEVLOSS_TMO         0x2000 /* HBA in devloss timeout */
 #define HBA_RRQ_ACTIVE		0x4000 /* process the rrq active list */
 #define HBA_IOQ_FLUSH		0x8000 /* FCP/NVME I/O queues being flushed */
-#define HBA_FW_DUMP_OP		0x10000 /* Skips fn reset before FW dump */
 #define HBA_RECOVERABLE_UE	0x20000 /* Firmware supports recoverable UE */
 #define HBA_FORCED_LINK_SPEED	0x40000 /*
 					 * Firmware supports Forced Link Speed
@@ -1040,6 +1039,7 @@ struct lpfc_hba {
 #define HBA_HBEAT_TMO		0x8000000 /* HBEAT initiated after timeout */
 #define HBA_FLOGI_OUTSTANDING	0x10000000 /* FLOGI is outstanding */
 
+	struct completion *fw_dump_cmpl; /* cmpl event tracker for fw_dump */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index dd4c51b6ef4e2..7a7f17d71811b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1709,25 +1709,25 @@ lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 	before_fc_flag = phba->pport->fc_flag;
 	sriov_nr_virtfn = phba->cfg_sriov_nr_virtfn;
 
-	/* Disable SR-IOV virtual functions if enabled */
-	if (phba->cfg_sriov_nr_virtfn) {
-		pci_disable_sriov(pdev);
-		phba->cfg_sriov_nr_virtfn = 0;
-	}
+	if (opcode == LPFC_FW_DUMP) {
+		init_completion(&online_compl);
+		phba->fw_dump_cmpl = &online_compl;
+	} else {
+		/* Disable SR-IOV virtual functions if enabled */
+		if (phba->cfg_sriov_nr_virtfn) {
+			pci_disable_sriov(pdev);
+			phba->cfg_sriov_nr_virtfn = 0;
+		}
 
-	if (opcode == LPFC_FW_DUMP)
-		phba->hba_flag |= HBA_FW_DUMP_OP;
+		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
-	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
+		if (status != 0)
+			return status;
 
-	if (status != 0) {
-		phba->hba_flag &= ~HBA_FW_DUMP_OP;
-		return status;
+		/* wait for the device to be quiesced before firmware reset */
+		msleep(100);
 	}
 
-	/* wait for the device to be quiesced before firmware reset */
-	msleep(100);
-
 	reg_val = readl(phba->sli4_hba.conf_regs_memmap_p +
 			LPFC_CTL_PDEV_CTL_OFFSET);
 
@@ -1756,24 +1756,42 @@ lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"3153 Fail to perform the requested "
 				"access: x%x\n", reg_val);
+		if (phba->fw_dump_cmpl)
+			phba->fw_dump_cmpl = NULL;
 		return rc;
 	}
 
 	/* keep the original port state */
-	if (before_fc_flag & FC_OFFLINE_MODE)
-		goto out;
-
-	init_completion(&online_compl);
-	job_posted = lpfc_workq_post_event(phba, &status, &online_compl,
-					   LPFC_EVT_ONLINE);
-	if (!job_posted)
+	if (before_fc_flag & FC_OFFLINE_MODE) {
+		if (phba->fw_dump_cmpl)
+			phba->fw_dump_cmpl = NULL;
 		goto out;
+	}
 
-	wait_for_completion(&online_compl);
+	/* Firmware dump will trigger an HA_ERATT event, and
+	 * lpfc_handle_eratt_s4 routine already handles bringing the port back
+	 * online.
+	 */
+	if (opcode == LPFC_FW_DUMP) {
+		wait_for_completion(phba->fw_dump_cmpl);
+	} else  {
+		init_completion(&online_compl);
+		job_posted = lpfc_workq_post_event(phba, &status, &online_compl,
+						   LPFC_EVT_ONLINE);
+		if (!job_posted)
+			goto out;
 
+		wait_for_completion(&online_compl);
+	}
 out:
 	/* in any case, restore the virtual functions enabled as before */
 	if (sriov_nr_virtfn) {
+		/* If fw_dump was performed, first disable to clean up */
+		if (opcode == LPFC_FW_DUMP) {
+			pci_disable_sriov(pdev);
+			phba->cfg_sriov_nr_virtfn = 0;
+		}
+
 		sriov_err =
 			lpfc_sli_probe_sriov_nr_virtfn(phba, sriov_nr_virtfn);
 		if (!sriov_err)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9fe6e5b386ce3..5e54ec503f18b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -869,10 +869,16 @@ lpfc_work_done(struct lpfc_hba *phba)
 	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
 		lpfc_sli4_post_async_mbox(phba);
 
-	if (ha_copy & HA_ERATT)
+	if (ha_copy & HA_ERATT) {
 		/* Handle the error attention event */
 		lpfc_handle_eratt(phba);
 
+		if (phba->fw_dump_cmpl) {
+			complete(phba->fw_dump_cmpl);
+			phba->fw_dump_cmpl = NULL;
+		}
+	}
+
 	if (ha_copy & HA_MBATT)
 		lpfc_sli_handle_mb_event(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5dedb3de271d8..513a78d08b1d5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5046,12 +5046,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba)
 	phba->fcf.fcf_flag = 0;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* SLI4 INTF 2: if FW dump is being taken skip INIT_PORT */
-	if (phba->hba_flag & HBA_FW_DUMP_OP) {
-		phba->hba_flag &= ~HBA_FW_DUMP_OP;
-		return rc;
-	}
-
 	/* Now physically reset the device */
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0389 Performing PCI function reset!\n");
-- 
2.34.1

