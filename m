Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431B61BCA9C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgD1Shk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgD1Shj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADE320730;
        Tue, 28 Apr 2020 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099057;
        bh=DBCoHq1pUUXe19Asr0Dm91UNM40bfUwDjA7pO/gFfsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dq+T1R09bZ58Ib0gkLDyouxiSuBvzTQzPmDAZMB2My/625l/e/1hu5IYjxDymQI6x
         Gi6a7uG/E3VGCx/MIsiS0WYOGevXAAlLxhl342XY9rneKYsNyTfErEmWGMb9XOZR1L
         vkrOM1kBNSG3iex5v2X3C9Z0RWKeTf+sN+8w//xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Benesh <scott.benesh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/168] scsi: smartpqi: fix controller lockup observed during force reboot
Date:   Tue, 28 Apr 2020 20:23:45 +0200
Message-Id: <20200428182238.347561649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

[ Upstream commit 0530736e40a0695b1ee2762e2684d00549699da4 ]

Link: https://lore.kernel.org/r/157048748297.11757.3872221216800537383.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |   9 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 126 ++++++++++++++++++++++----
 2 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 79d2af36f6552..2aa81b22f2695 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1130,8 +1130,9 @@ struct pqi_ctrl_info {
 	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
-	bool		in_shutdown;
+	bool		block_device_reset;
 	bool		in_ofa;
+	bool		in_shutdown;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
@@ -1173,6 +1174,7 @@ struct pqi_ctrl_info {
 	struct          pqi_ofa_memory *pqi_ofa_mem_virt_addr;
 	dma_addr_t      pqi_ofa_mem_dma_handle;
 	void            **pqi_ofa_chunk_virt_addr;
+	atomic_t	sync_cmds_outstanding;
 };
 
 enum pqi_ctrl_mode {
@@ -1423,6 +1425,11 @@ static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 	return ctrl_info->block_requests;
 }
 
+static inline bool pqi_device_reset_blocked(struct pqi_ctrl_info *ctrl_info)
+{
+	return ctrl_info->block_device_reset;
+}
+
 void pqi_sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	struct sas_rphy *rphy);
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ea5409bebf578..793793343950e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -249,6 +249,11 @@ static inline void pqi_ctrl_unblock_requests(struct pqi_ctrl_info *ctrl_info)
 	scsi_unblock_requests(ctrl_info->scsi_host);
 }
 
+static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->block_device_reset = true;
+}
+
 static unsigned long pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info,
 	unsigned long timeout_msecs)
 {
@@ -331,6 +336,16 @@ static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
 	return device->in_remove && !ctrl_info->in_shutdown;
 }
 
+static inline void pqi_ctrl_shutdown_start(struct pqi_ctrl_info *ctrl_info)
+{
+	ctrl_info->in_shutdown = true;
+}
+
+static inline bool pqi_ctrl_in_shutdown(struct pqi_ctrl_info *ctrl_info)
+{
+	return ctrl_info->in_shutdown;
+}
+
 static inline void pqi_schedule_rescan_worker_with_delay(
 	struct pqi_ctrl_info *ctrl_info, unsigned long delay)
 {
@@ -360,6 +375,11 @@ static inline void pqi_cancel_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 	cancel_delayed_work_sync(&ctrl_info->rescan_work);
 }
 
+static inline void pqi_cancel_event_worker(struct pqi_ctrl_info *ctrl_info)
+{
+	cancel_work_sync(&ctrl_info->event_work);
+}
+
 static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 {
 	if (!ctrl_info->heartbeat_counter)
@@ -4122,6 +4142,8 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 	}
 
+	atomic_inc(&ctrl_info->sync_cmds_outstanding);
+
 	io_request = pqi_alloc_io_request(ctrl_info);
 
 	put_unaligned_le16(io_request->index,
@@ -4168,6 +4190,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	pqi_free_io_request(io_request);
 
+	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 out:
 	up(&ctrl_info->sync_request_sem);
 
@@ -5402,7 +5425,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 
 	pqi_ctrl_busy(ctrl_info);
 	if (pqi_ctrl_blocked(ctrl_info) || pqi_device_in_reset(device) ||
-	    pqi_ctrl_in_ofa(ctrl_info)) {
+	    pqi_ctrl_in_ofa(ctrl_info) || pqi_ctrl_in_shutdown(ctrl_info)) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -5650,6 +5673,18 @@ static int pqi_ctrl_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 }
 
+static int pqi_ctrl_wait_for_pending_sync_cmds(struct pqi_ctrl_info *ctrl_info)
+{
+	while (atomic_read(&ctrl_info->sync_cmds_outstanding)) {
+		pqi_check_ctrl_health(ctrl_info);
+		if (pqi_ctrl_offline(ctrl_info))
+			return -ENXIO;
+		usleep_range(1000, 2000);
+	}
+
+	return 0;
+}
+
 static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 	void *context)
 {
@@ -5787,17 +5822,17 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 		shost->host_no, device->bus, device->target, device->lun);
 
 	pqi_check_ctrl_health(ctrl_info);
-	if (pqi_ctrl_offline(ctrl_info)) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"controller %u offlined - cannot send device reset\n",
-			ctrl_info->ctrl_id);
+	if (pqi_ctrl_offline(ctrl_info) ||
+		pqi_device_reset_blocked(ctrl_info)) {
 		rc = FAILED;
 		goto out;
 	}
 
 	pqi_wait_until_ofa_finished(ctrl_info);
 
+	atomic_inc(&ctrl_info->sync_cmds_outstanding);
 	rc = pqi_device_reset(ctrl_info, device);
+	atomic_dec(&ctrl_info->sync_cmds_outstanding);
 
 out:
 	dev_err(&ctrl_info->pci_dev->dev,
@@ -6119,7 +6154,8 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 
 	ctrl_info = shost_to_hba(sdev->host);
 
-	if (pqi_ctrl_in_ofa(ctrl_info))
+	if (pqi_ctrl_in_ofa(ctrl_info) ||
+		pqi_ctrl_in_shutdown(ctrl_info))
 		return -EBUSY;
 
 	switch (cmd) {
@@ -7074,13 +7110,20 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
+#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
 
-	rc = pqi_force_sis_mode(ctrl_info);
-	if (rc)
-		return rc;
+	if (reset_devices) {
+		sis_soft_reset(ctrl_info);
+		msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
+	} else {
+		rc = pqi_force_sis_mode(ctrl_info);
+		if (rc)
+			return rc;
+	}
 
 	/*
 	 * Wait until the controller is ready to start accepting SIS
@@ -7514,6 +7557,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
+	atomic_set(&ctrl_info->sync_cmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
@@ -7787,8 +7831,6 @@ static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
 		0, NULL, NO_TIMEOUT);
 }
 
-#define PQI_POST_RESET_DELAY_B4_MSGU_READY	5000
-
 static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info)
 {
 	msleep(PQI_POST_RESET_DELAY_B4_MSGU_READY);
@@ -7956,28 +7998,74 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 	pqi_remove_ctrl(ctrl_info);
 }
 
+static void pqi_crash_if_pending_command(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned int i;
+	struct pqi_io_request *io_request;
+	struct scsi_cmnd *scmd;
+
+	for (i = 0; i < ctrl_info->max_io_slots; i++) {
+		io_request = &ctrl_info->io_request_pool[i];
+		if (atomic_read(&io_request->refcount) == 0)
+			continue;
+		scmd = io_request->scmd;
+		WARN_ON(scmd != NULL); /* IO command from SML */
+		WARN_ON(scmd == NULL); /* Non-IO cmd or driver initiated*/
+	}
+}
+
 static void pqi_shutdown(struct pci_dev *pci_dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
 
 	ctrl_info = pci_get_drvdata(pci_dev);
-	if (!ctrl_info)
-		goto error;
+	if (!ctrl_info) {
+		dev_err(&pci_dev->dev,
+			"cache could not be flushed\n");
+		return;
+	}
+
+	pqi_disable_events(ctrl_info);
+	pqi_wait_until_ofa_finished(ctrl_info);
+	pqi_cancel_update_time_worker(ctrl_info);
+	pqi_cancel_rescan_worker(ctrl_info);
+	pqi_cancel_event_worker(ctrl_info);
+
+	pqi_ctrl_shutdown_start(ctrl_info);
+	pqi_ctrl_wait_until_quiesced(ctrl_info);
+
+	rc = pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"wait for pending I/O failed\n");
+		return;
+	}
+
+	pqi_ctrl_block_device_reset(ctrl_info);
+	pqi_wait_until_lun_reset_finished(ctrl_info);
 
 	/*
 	 * Write all data in the controller's battery-backed cache to
 	 * storage.
 	 */
 	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
-	pqi_free_interrupts(ctrl_info);
-	pqi_reset(ctrl_info);
-	if (rc == 0)
+	if (rc)
+		dev_err(&pci_dev->dev,
+			"unable to flush controller cache\n");
+
+	pqi_ctrl_block_requests(ctrl_info);
+
+	rc = pqi_ctrl_wait_for_pending_sync_cmds(ctrl_info);
+	if (rc) {
+		dev_err(&pci_dev->dev,
+			"wait for pending sync cmds failed\n");
 		return;
+	}
+
+	pqi_crash_if_pending_command(ctrl_info);
+	pqi_reset(ctrl_info);
 
-error:
-	dev_warn(&pci_dev->dev,
-		"unable to flush controller cache\n");
 }
 
 static void pqi_process_lockup_action_param(void)
-- 
2.20.1



