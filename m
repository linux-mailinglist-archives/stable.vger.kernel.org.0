Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3696583C5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiL1Qvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbiL1QvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:51:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9A115735
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE5D6157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E411C433D2;
        Wed, 28 Dec 2022 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245959;
        bh=3QygPbOXrloJ/eEA4PsZVoyc71NYwiZTvrK7NjXB2D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3aEy1/M9atWNBnmNK80YtMvxqN+d0eKvObssEqW0xGDk3Wq2K9//Y7IGlMBxzq3Z
         W6mXQOawQz/2m7pizNpomO5mP6UK2KtLHNWzWG8+V4ARQx2rHSLNuO2rL1gpfpLKa8
         SZzRLIYzMsRmVOHO4EJGJIqtnASf/ZNdyfLhh+OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Mike Mcgowan <mike.mcgowan@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Kumar Meiyappan <Kumar.Meiyappan@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0987/1073] scsi: smartpqi: Correct device removal for multi-actuator devices
Date:   Wed, 28 Dec 2022 15:42:55 +0100
Message-Id: <20221228144354.909046799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>

[ Upstream commit cc9befcbbb5ebce77726f938508700d913530035 ]

Correct device count for multi-actuator drives which can cause kernel
panics.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike Mcgowan <mike.mcgowan@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/166793531872.322537.9003385780343419275.stgit@brunhilda
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 33 +++++++++++++++++++--------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e550b12e525a..c8235f15728b 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1130,7 +1130,7 @@ struct pqi_scsi_dev {
 	u8	phy_id;
 	u8	ncq_prio_enable;
 	u8	ncq_prio_support;
-	u8	multi_lun_device_lun_count;
+	u8	lun_count;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
 	u32	next_bypass_group[RAID_MAP_MAX_DATA_DISKS_PER_ROW];
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 898b0054cfa1..e011d82172d5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1610,9 +1610,7 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		&id_phys->alternate_paths_phys_connector,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
-	device->multi_lun_device_lun_count = id_phys->multi_lun_device_lun_count;
-	if (!device->multi_lun_device_lun_count)
-		device->multi_lun_device_lun_count = 1;
+	device->lun_count = id_phys->multi_lun_device_lun_count;
 	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
 		id_phys->phy_count)
 		device->phy_id =
@@ -1746,7 +1744,7 @@ static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
 	return offline;
 }
 
-static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
+static int pqi_get_device_info_phys_logical(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
 {
@@ -1763,6 +1761,20 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
+static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device,
+	struct bmic_identify_physical_device *id_phys)
+{
+	int rc;
+
+	rc = pqi_get_device_info_phys_logical(ctrl_info, device, id_phys);
+
+	if (rc == 0 && device->lun_count == 0)
+		device->lun_count = 1;
+
+	return rc;
+}
+
 static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
@@ -1897,7 +1909,7 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
 	int rc;
 	int lun;
 
-	for (lun = 0; lun < device->multi_lun_device_lun_count; lun++) {
+	for (lun = 0; lun < device->lun_count; lun++) {
 		rc = pqi_device_wait_for_pending_io(ctrl_info, device, lun,
 			PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
 		if (rc)
@@ -2076,6 +2088,7 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 	existing_device->sas_address = new_device->sas_address;
 	existing_device->queue_depth = new_device->queue_depth;
 	existing_device->device_offline = false;
+	existing_device->lun_count = new_device->lun_count;
 
 	if (pqi_is_logical_device(existing_device)) {
 		existing_device->is_external_raid_device = new_device->is_external_raid_device;
@@ -2108,10 +2121,6 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
 		memcpy(existing_device->box, new_device->box, sizeof(existing_device->box));
 		memcpy(existing_device->phys_connector, new_device->phys_connector, sizeof(existing_device->phys_connector));
-
-		existing_device->multi_lun_device_lun_count = new_device->multi_lun_device_lun_count;
-		if (existing_device->multi_lun_device_lun_count == 0)
-			existing_device->multi_lun_device_lun_count = 1;
 	}
 }
 
@@ -6484,6 +6493,12 @@ static void pqi_slave_destroy(struct scsi_device *sdev)
 		return;
 	}
 
+	device->lun_count--;
+	if (device->lun_count > 0) {
+		mutex_unlock(&ctrl_info->scan_mutex);
+		return;
+	}
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 	list_del(&device->scsi_device_list_entry);
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
-- 
2.35.1



