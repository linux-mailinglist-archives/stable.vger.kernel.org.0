Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786AEA253C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfH2S3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:29:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbfH2SPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C262339E;
        Thu, 29 Aug 2019 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102501;
        bh=RWqFe7Un65rshSuXKt6U5B/SGrXFu6/jZLaCmJW8e9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qk3i03lW1cYcoDti60XM9YYZEygzcx01Sak7eCqBSAwwpGucPxWffdMhdfucol5gH
         qLHWGAh+f0paJEEfmV5jbTqqxOIl4AhI0YbwXwudAlv9RXyaeSbGO8GADBDPj5sGLm
         5VX0C4dmK6aecMIxFOfHIhMGCKYLVn5qes1vmRQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 52/76] scsi: lpfc: Mitigate high memory pre-allocation by SCSI-MQ
Date:   Thu, 29 Aug 2019 14:12:47 -0400
Message-Id: <20190829181311.7562-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 77ffd3465ba837e9dc714e17b014e77b2eae765a ]

When SCSI-MQ is enabled, the SCSI-MQ layers will do pre-allocation of MQ
resources based on shost values set by the driver. In newer cases of the
driver, which attempts to set nr_hw_queues to the cpu count, the
multipliers become excessive, with a single shost having SCSI-MQ
pre-allocation reaching into the multiple GBytes range.  NPIV, which
creates additional shosts, only multiply this overhead. On lower-memory
systems, this can exhaust system memory very quickly, resulting in a system
crash or failures in the driver or elsewhere due to low memory conditions.

After testing several scenarios, the situation can be mitigated by limiting
the value set in shost->nr_hw_queues to 4. Although the shost values were
changed, the driver still had per-cpu hardware queues of its own that
allowed parallelization per-cpu.  Testing revealed that even with the
smallish number for nr_hw_queues for SCSI-MQ, performance levels remained
near maximum with the within-driver affiinitization.

A module parameter was created to allow the value set for the nr_hw_queues
to be tunable.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 15 +++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 10 ++++++----
 drivers/scsi/lpfc/lpfc_sli4.h |  5 +++++
 4 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index aafcffaa25f71..4604e1bc334c0 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -822,6 +822,7 @@ struct lpfc_hba {
 	uint32_t cfg_cq_poll_threshold;
 	uint32_t cfg_cq_max_proc_limit;
 	uint32_t cfg_fcp_cpu_map;
+	uint32_t cfg_fcp_mq_threshold;
 	uint32_t cfg_hdw_queue;
 	uint32_t cfg_irq_chann;
 	uint32_t cfg_suppress_rsp;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d4c65e2109e2f..353da12d797ba 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5640,6 +5640,19 @@ LPFC_ATTR_RW(nvme_oas, 0, 0, 1,
 LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
 	     "Embed NVME Command in WQE");
 
+/*
+ * lpfc_fcp_mq_threshold: Set the maximum number of Hardware Queues
+ * the driver will advertise it supports to the SCSI layer.
+ *
+ *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
+ *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
+ *
+ * Value range is [0,128]. Default value is 8.
+ */
+LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
+	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
+	    "Set the number of SCSI Queues advertised");
+
 /*
  * lpfc_hdw_queue: Set the number of Hardware Queues the driver
  * will advertise it supports to the NVME and  SCSI layers. This also
@@ -5961,6 +5974,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_cq_poll_threshold,
 	&dev_attr_lpfc_cq_max_proc_limit,
 	&dev_attr_lpfc_fcp_cpu_map,
+	&dev_attr_lpfc_fcp_mq_threshold,
 	&dev_attr_lpfc_hdw_queue,
 	&dev_attr_lpfc_irq_chann,
 	&dev_attr_lpfc_suppress_rsp,
@@ -7042,6 +7056,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	/* Initialize first burst. Target vs Initiator are different. */
 	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
 	lpfc_nvmet_fb_size_init(phba, lpfc_nvmet_fb_size);
+	lpfc_fcp_mq_threshold_init(phba, lpfc_fcp_mq_threshold);
 	lpfc_hdw_queue_init(phba, lpfc_hdw_queue);
 	lpfc_irq_chann_init(phba, lpfc_irq_chann);
 	lpfc_enable_bbcr_init(phba, lpfc_enable_bbcr);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index eaaef682de251..2fd8f15f99975 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4308,10 +4308,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_cmd_len = 16;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ)
-			shost->nr_hw_queues = phba->cfg_hdw_queue;
-		else
-			shost->nr_hw_queues = phba->sli4_hba.num_present_cpu;
+		if (!phba->cfg_fcp_mq_threshold ||
+		    phba->cfg_fcp_mq_threshold > phba->cfg_hdw_queue)
+			phba->cfg_fcp_mq_threshold = phba->cfg_hdw_queue;
+
+		shost->nr_hw_queues = min_t(int, 2 * num_possible_nodes(),
+					    phba->cfg_fcp_mq_threshold);
 
 		shost->dma_boundary =
 			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 8e4fd1a98023c..986594ec40e2a 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -44,6 +44,11 @@
 #define LPFC_HBA_HDWQ_MAX	128
 #define LPFC_HBA_HDWQ_DEF	0
 
+/* FCP MQ queue count limiting */
+#define LPFC_FCP_MQ_THRESHOLD_MIN	0
+#define LPFC_FCP_MQ_THRESHOLD_MAX	128
+#define LPFC_FCP_MQ_THRESHOLD_DEF	8
+
 /* Common buffer size to accomidate SCSI and NVME IO buffers */
 #define LPFC_COMMON_IO_BUF_SZ	768
 
-- 
2.20.1

