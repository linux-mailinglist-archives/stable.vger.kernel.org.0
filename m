Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3C45C450
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351588AbhKXNrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351230AbhKXNpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4207563310;
        Wed, 24 Nov 2021 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758831;
        bh=6ihV7+OEOF2MZG7aA57b/NjEKuL8r16e1rIClyXObL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruLVooKmd1rzv0Y/yDlrqNeNLbQzVcpFjl29MUkhr8aCgUA1o9ON0sc287jnSWHEQ
         etFY+e0N3t/+8wosnSpFRMJjlubcekhDufp/0oiHwoXEywJ8Lp+FyQVAXfL+bN1AsU
         Tt1Tds0j3D22d/Hn7BcnmQPFzWnvDb8VhCWq1AFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Mike McGowen <mike.mcgowen@microchip.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/279] scsi: smartpqi: Add controller handshake during kdump
Date:   Wed, 24 Nov 2021 12:55:30 +0100
Message-Id: <20211124115720.217603013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

[ Upstream commit 9ee5d6e9ac52a3c8625697535f8e35864d9fd38c ]

Correct kdump hangs when controller is locked up.

There are occasions when a controller reboot (controller soft reset) is
issued when a controller firmware crash dump is in progress.

This leads to incomplete controller firmware crash dump:

 - When the controller crash dump is in progress, and a kdump is initiated,
   the driver issues inbound doorbell reset to bring back the controller in
   SIS mode.

 - If the controller is in locked up state, the inbound doorbell reset does
   not work causing controller initialization failures. This results in the
   driver hanging waiting for SIS mode.

To avoid an incomplete controller crash dump, add in a controller crash
dump handshake:

 - Controller will indicate start and end of the controller crash dump by
   setting some register bits.

 - Driver will look these bits when a kdump is initiated.  If a controller
   crash dump is in progress, the driver will wait for the controller crash
   dump to complete before issuing the controller soft reset then complete
   driver initialization.

Link: https://lore.kernel.org/r/20210928235442.201875-3-don.brace@microchip.com
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Acked-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 41 +++++++++++++++++++--
 drivers/scsi/smartpqi/smartpqi_sis.c  | 51 +++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |  1 +
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca3..a5453f5e87c3e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -234,15 +234,46 @@ static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
 	return pqi_scsi3addr_equal(scsi3addr, RAID_CTLR_LUNID);
 }
 
+#define PQI_DRIVER_SCRATCH_PQI_MODE			0x1
+#define PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED		0x2
+
 static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(struct pqi_ctrl_info *ctrl_info)
 {
-	return sis_read_driver_scratch(ctrl_info);
+	return sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_PQI_MODE ? PQI_MODE : SIS_MODE;
 }
 
 static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_mode mode)
 {
-	sis_write_driver_scratch(ctrl_info, mode);
+	u32 driver_scratch;
+
+	driver_scratch = sis_read_driver_scratch(ctrl_info);
+
+	if (mode == PQI_MODE)
+		driver_scratch |= PQI_DRIVER_SCRATCH_PQI_MODE;
+	else
+		driver_scratch &= ~PQI_DRIVER_SCRATCH_PQI_MODE;
+
+	sis_write_driver_scratch(ctrl_info, driver_scratch);
+}
+
+static inline bool pqi_is_fw_triage_supported(struct pqi_ctrl_info *ctrl_info)
+{
+	return (sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED) != 0;
+}
+
+static inline void pqi_save_fw_triage_setting(struct pqi_ctrl_info *ctrl_info, bool is_supported)
+{
+	u32 driver_scratch;
+
+	driver_scratch = sis_read_driver_scratch(ctrl_info);
+
+	if (is_supported)
+		driver_scratch |= PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
+	else
+		driver_scratch &= ~PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
+
+	sis_write_driver_scratch(ctrl_info, driver_scratch);
 }
 
 static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
@@ -7301,6 +7332,7 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		ctrl_info->unique_wwid_in_report_phys_lun_supported =
 			firmware_feature->enabled;
 		break;
+		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7627,6 +7659,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	u32 product_id;
 
 	if (reset_devices) {
+		if (pqi_is_fw_triage_supported(ctrl_info)) {
+			rc = sis_wait_for_fw_triage_completion(ctrl_info);
+			if (rc)
+				return rc;
+		}
 		sis_soft_reset(ctrl_info);
 		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
 	} else {
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index d63c46a8e38bb..8acd3a80f5822 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -51,12 +51,20 @@
 #define SIS_BASE_STRUCT_REVISION		9
 #define SIS_BASE_STRUCT_ALIGNMENT		16
 
+#define SIS_CTRL_KERNEL_FW_TRIAGE		0x3
 #define SIS_CTRL_KERNEL_UP			0x80
 #define SIS_CTRL_KERNEL_PANIC			0x100
 #define SIS_CTRL_READY_TIMEOUT_SECS		180
 #define SIS_CTRL_READY_RESUME_TIMEOUT_SECS	90
 #define SIS_CTRL_READY_POLL_INTERVAL_MSECS	10
 
+enum sis_fw_triage_status {
+	FW_TRIAGE_NOT_STARTED = 0,
+	FW_TRIAGE_STARTED,
+	FW_TRIAGE_COND_INVALID,
+	FW_TRIAGE_COMPLETED
+};
+
 #pragma pack(1)
 
 /* for use with SIS_CMD_INIT_BASE_STRUCT_ADDRESS command */
@@ -419,12 +427,55 @@ u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info)
 	return readl(&ctrl_info->registers->sis_driver_scratch);
 }
 
+static inline enum sis_fw_triage_status
+	sis_read_firmware_triage_status(struct pqi_ctrl_info *ctrl_info)
+{
+	return ((enum sis_fw_triage_status)(readl(&ctrl_info->registers->sis_firmware_status) &
+		SIS_CTRL_KERNEL_FW_TRIAGE));
+}
+
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
 {
 	writel(SIS_SOFT_RESET,
 		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
 }
 
+#define SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS		300
+#define SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS		1
+
+int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+	enum sis_fw_triage_status status;
+	unsigned long timeout;
+
+	timeout = (SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	while (1) {
+		status = sis_read_firmware_triage_status(ctrl_info);
+		if (status == FW_TRIAGE_COND_INVALID) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"firmware triage condition invalid\n");
+			rc = -EINVAL;
+			break;
+		} else if (status == FW_TRIAGE_NOT_STARTED ||
+			status == FW_TRIAGE_COMPLETED) {
+			rc = 0;
+			break;
+		}
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"timed out waiting for firmware triage status\n");
+			rc = -ETIMEDOUT;
+			break;
+		}
+
+		ssleep(SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS);
+	}
+
+	return rc;
+}
+
 static void __attribute__((unused)) verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index d29c1352a826a..c1db93054c863 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -28,5 +28,6 @@ void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
 u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
+int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info);
 
 #endif	/* _SMARTPQI_SIS_H */
-- 
2.33.0



