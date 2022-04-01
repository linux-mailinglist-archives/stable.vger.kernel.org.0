Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5894EF06D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347548AbiDAOf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347753AbiDAOdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63265288A8D;
        Fri,  1 Apr 2022 07:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6BC361CA5;
        Fri,  1 Apr 2022 14:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BBEC2BBE4;
        Fri,  1 Apr 2022 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823438;
        bh=FJGCEiI2OqaMv4O0SL/amgrZcVxz2Vj5DqhUh6urstc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crh2vZV8rkH04xucP7T4MYkOmN/PVKZOR2wi7jmEDDZXCL5p4C7wabaxFkx70gRey
         tdewHNElCzWRf6FBGhkzEGQFEZdFb/i4dBOJDFiCprPkvYeCx3REV0OurTCF7Cdmj+
         RURURQEJFnAOmS/kd0ndWT6vo4j0/FyrLMIgSYehEDF8743QudGmSZGScG7qlRj2aL
         j612u10rvIJjRha5Sadv67yqoakil05h96Kf3EquaRXUkwR+bzHaaUeN7CXOmw8fsd
         IxWBRBVF15V/EveeUPM/l7kUUyNLhPgULB8HBgKqoBec+BxelwLPxmc5ViNUuRm9mk
         OywPI0rMC/fUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 095/149] scsi: pm8001: Fix tag values handling
Date:   Fri,  1 Apr 2022 10:24:42 -0400
Message-Id: <20220401142536.1948161-95-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 7fb23a785ba38dea907323a039123f231195b297 ]

The function pm8001_tag_alloc() determines free tags using the function
find_first_zero_bit() which can return 0 when the first bit of the bitmap
being inspected is 0. As such, tag 0 is a valid tag value that should not
be dismissed as invalid. Fix the functions pm8001_work_fn(),
mpi_sata_completion(), pm8001_mpi_task_abort_resp() and
pm8001_open_reject_retry() to not dismiss 0 tags as invalid.

The value 0xffffffff is used for invalid tags for unused ccb information
structures. Add the macro definition PM8001_INVALID_TAG to define this
value.

Link: https://lore.kernel.org/r/20220220031810.738362-20-damien.lemoal@opensource.wdc.com
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 52 +++++++++++--------------------
 drivers/scsi/pm8001/pm8001_init.c |  3 +-
 drivers/scsi/pm8001/pm8001_sas.c  | 13 ++++----
 drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  5 ---
 5 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index da9cac6671a3..e12b3ea4153a 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1522,7 +1522,6 @@ void pm8001_work_fn(struct work_struct *work)
 	case IO_XFER_ERROR_BREAK:
 	{	/* This one stashes the sas_task instead */
 		struct sas_task *t = (struct sas_task *)pm8001_dev;
-		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
 		unsigned long flags, flags1;
@@ -1544,8 +1543,8 @@ void pm8001_work_fn(struct work_struct *work)
 		/* Search for a possible ccb that matches the task */
 		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
 			ccb = &pm8001_ha->ccb_info[i];
-			tag = ccb->ccb_tag;
-			if ((tag != 0xFFFFFFFF) && (ccb->task == t))
+			if ((ccb->ccb_tag != PM8001_INVALID_TAG) &&
+			    (ccb->task == t))
 				break;
 		}
 		if (!ccb) {
@@ -1567,11 +1566,11 @@ void pm8001_work_fn(struct work_struct *work)
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
 			pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
 				   t, pw->handler, ts->resp, ts->stat);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
@@ -1580,7 +1579,6 @@ void pm8001_work_fn(struct work_struct *work)
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
 	{	/* This one stashes the sas_task instead */
 		struct sas_task *t = (struct sas_task *)pm8001_dev;
-		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
 		unsigned long flags, flags1;
@@ -1614,8 +1612,8 @@ void pm8001_work_fn(struct work_struct *work)
 		/* Search for a possible ccb that matches the task */
 		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
 			ccb = &pm8001_ha->ccb_info[i];
-			tag = ccb->ccb_tag;
-			if ((tag != 0xFFFFFFFF) && (ccb->task == t))
+			if ((ccb->ccb_tag != PM8001_INVALID_TAG) &&
+			    (ccb->task == t))
 				break;
 		}
 		if (!ccb) {
@@ -1686,19 +1684,13 @@ void pm8001_work_fn(struct work_struct *work)
 		struct task_status_struct *ts;
 		struct sas_task *task;
 		int i;
-		u32 tag, device_id;
+		u32 device_id;
 
 		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
 			ccb = &pm8001_ha->ccb_info[i];
 			task = ccb->task;
 			ts = &task->task_status;
-			tag = ccb->ccb_tag;
-			/* check if tag is NULL */
-			if (!tag) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					"tag Null\n");
-				continue;
-			}
+
 			if (task != NULL) {
 				dev = task->dev;
 				if (!dev) {
@@ -1707,10 +1699,11 @@ void pm8001_work_fn(struct work_struct *work)
 					continue;
 				}
 				/*complete sas task and update to top layer */
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb,
+						     ccb->ccb_tag);
 				ts->resp = SAS_TASK_COMPLETE;
 				task->task_done(task);
-			} else if (tag != 0xFFFFFFFF) {
+			} else if (ccb->ccb_tag != PM8001_INVALID_TAG) {
 				/* complete the internal commands/non-sas task */
 				pm8001_dev = ccb->device;
 				if (pm8001_dev->dcompletion) {
@@ -1718,7 +1711,7 @@ void pm8001_work_fn(struct work_struct *work)
 					pm8001_dev->dcompletion = NULL;
 				}
 				complete(pm8001_ha->nvmd_completion);
-				pm8001_tag_free(pm8001_ha, tag);
+				pm8001_tag_free(pm8001_ha, ccb->ccb_tag);
 			}
 		}
 		/* Deregister all the device ids  */
@@ -2314,11 +2307,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	param = le32_to_cpu(psataPayload->param);
 	tag = le32_to_cpu(psataPayload->tag);
 
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
-		return;
-	}
-
 	ccb = &pm8001_ha->ccb_info[tag];
 	t = ccb->task;
 	pm8001_dev = ccb->device;
@@ -3053,7 +3041,7 @@ void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
 		   device_id, pds, nds, status);
 	complete(pm8001_dev->setds_completion);
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
 
@@ -3071,7 +3059,7 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				dlen_status);
 	}
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
 
@@ -3098,7 +3086,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		 * freed by requesting path anywhere.
 		 */
 		ccb->task = NULL;
-		ccb->ccb_tag = 0xFFFFFFFF;
+		ccb->ccb_tag = PM8001_INVALID_TAG;
 		pm8001_tag_free(pm8001_ha, tag);
 		return;
 	}
@@ -3144,7 +3132,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	complete(pm8001_ha->nvmd_completion);
 	pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
 
@@ -3557,7 +3545,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	}
 	complete(pm8001_dev->dcompletion);
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, htag);
 	return 0;
 }
@@ -3629,7 +3617,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 	}
 	kfree(ccb->fw_control_context);
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 	complete(pm8001_ha->nvmd_completion);
 	return 0;
@@ -3665,10 +3653,6 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	status = le32_to_cpu(pPayload->status);
 	tag = le32_to_cpu(pPayload->tag);
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, " TAG NULL. RETURNING !!!\n");
-		return -1;
-	}
 
 	scp = le32_to_cpu(pPayload->scp);
 	ccb = &pm8001_ha->ccb_info[tag];
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index d8a2121cb8d9..d2a2593f669d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1216,10 +1216,11 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 			goto err_out;
 		}
 		pm8001_ha->ccb_info[i].task = NULL;
-		pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
+		pm8001_ha->ccb_info[i].ccb_tag = PM8001_INVALID_TAG;
 		pm8001_ha->ccb_info[i].device = NULL;
 		++pm8001_ha->tags_num;
 	}
+
 	return 0;
 
 err_out_noccb:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 32edda3e55c6..c1f871561b32 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -567,7 +567,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 
 	task->lldd_task = NULL;
 	ccb->task = NULL;
-	ccb->ccb_tag = 0xFFFFFFFF;
+	ccb->ccb_tag = PM8001_INVALID_TAG;
 	ccb->open_retry = 0;
 	pm8001_tag_free(pm8001_ha, ccb_idx);
 }
@@ -952,9 +952,11 @@ void pm8001_open_reject_retry(
 		struct task_status_struct *ts;
 		struct pm8001_device *pm8001_dev;
 		unsigned long flags1;
-		u32 tag;
 		struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[i];
 
+		if (ccb->ccb_tag == PM8001_INVALID_TAG)
+			continue;
+
 		pm8001_dev = ccb->device;
 		if (!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED))
 			continue;
@@ -966,9 +968,6 @@ void pm8001_open_reject_retry(
 				continue;
 		} else if (pm8001_dev != device_to_close)
 			continue;
-		tag = ccb->ccb_tag;
-		if (!tag || (tag == 0xFFFFFFFF))
-			continue;
 		task = ccb->task;
 		if (!task || !task->task_done)
 			continue;
@@ -989,11 +988,11 @@ void pm8001_open_reject_retry(
 				& SAS_TASK_STATE_ABORTED))) {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
 		} else {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			task->task_done(task);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index a17da1cebce1..1791cdf30276 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -738,6 +738,8 @@ void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
 
+#define PM8001_INVALID_TAG	((u32)-1)
+
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
 			struct sas_task *task, struct pm8001_ccb_info *ccb,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f6b9253e626b..00c95ea480ad 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2402,11 +2402,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 	param = le32_to_cpu(psataPayload->param);
 	tag = le32_to_cpu(psataPayload->tag);
 
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
-		return;
-	}
-
 	ccb = &pm8001_ha->ccb_info[tag];
 	t = ccb->task;
 	pm8001_dev = ccb->device;
-- 
2.34.1

