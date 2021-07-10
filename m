Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BB43C2F34
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhGJCay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhGJC2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBDD561428;
        Sat, 10 Jul 2021 02:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883914;
        bh=EQL+z2y8V0vyOoeW4ZJQ+VOfvXcJ6N9ZyM0hxqmH47Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6ARyIpC+9s2SQdoUrGj/xSAsiY8AF/0iI4gL5aa9z1v5k7UGKd50TVLvhm5LNtTl
         jnG+Qx6yGcD274wmzRmuhRIR+tCvoMSUw+kcxMZxJEYC+zQWMV2+z7slnpuZE9jZqp
         yTGKaxcad5uI7l0wYhbcGPd6zaGQ8Tjwgp3aFZhrFh8EIIKw59mk1a6MKCHi8mVGlr
         QBZkYJp0TakKeuJuPNQw1h+5CQKBooa5A+mFw2J7UmcZk8AiiELaZUJN2RcAZtpJM7
         9UXKG4afLQGu41wRS6niQKln+u0Q66TPJ3b9AOJSatXGP2MimIfk7uLK4SDZSArpVY
         klXWYl+5U486w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        kernel test robot <lkp@intel.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 35/93] scsi: megaraid_sas: Early detection of VD deletion through RaidMap update
Date:   Fri,  9 Jul 2021 22:23:29 -0400
Message-Id: <20210710022428.3169839-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit ae6874ba4b43c5a00065f48599811a09d33b873d ]

Consider the case where a VD is deleted and the targetID of that VD is
assigned to a newly created VD. If the sequence of deletion/addition of VD
happens very quickly there is a possibility that second event (VD add)
occurs even before the driver processes the first event (VD delete).  As
event processing is done in deferred context the device list remains the
same (but targetID is re-used) so driver will not learn the VD
deletion/additon. I/Os meant for the older VD will be directed to new VD
which may lead to data corruption.

Make driver detect the deleted VD as soon as possible based on the RaidMap
update and block further I/O to that device.

Link: https://lore.kernel.org/r/20210528131307.25683-4-chandrakanth.patil@broadcom.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 12 ++++
 drivers/scsi/megaraid/megaraid_sas_base.c | 83 ++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fp.c   |  6 +-
 3 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5e4137f10e0e..6b8ec57e8bdf 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2259,6 +2259,15 @@ enum MR_PERF_MODE {
 		 (mode) == MR_LATENCY_PERF_MODE ? "Latency" : \
 		 "Unknown")
 
+enum MEGASAS_LD_TARGET_ID_STATUS {
+	LD_TARGET_ID_INITIAL,
+	LD_TARGET_ID_ACTIVE,
+	LD_TARGET_ID_DELETED,
+};
+
+#define MEGASAS_TARGET_ID(sdev)						\
+	(((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id)
+
 struct megasas_instance {
 
 	unsigned int *reply_map;
@@ -2323,6 +2332,9 @@ struct megasas_instance {
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
+	u8 ld_tgtid_status[MEGASAS_MAX_LD_IDS];
+	u8 ld_ids_prev[MEGASAS_MAX_LD_IDS];
+	u8 ld_ids_from_raidmap[MEGASAS_MAX_LD_IDS];
 	s8 init_id;
 
 	u16 max_num_sge;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e58b0e558981..1a70cc995c28 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -127,6 +127,8 @@ static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
 static void megasas_get_pd_info(struct megasas_instance *instance,
 				struct scsi_device *sdev);
+static void
+megasas_set_ld_removed_by_fw(struct megasas_instance *instance);
 
 /*
  * PCI ID table for all supported controllers
@@ -421,6 +423,12 @@ megasas_decode_evt(struct megasas_instance *instance)
 			(class_locale.members.locale),
 			format_class(class_locale.members.class),
 			evt_detail->description);
+
+	if (megasas_dbg_lvl & LD_PD_DEBUG)
+		dev_info(&instance->pdev->dev,
+			 "evt_detail.args.ld.target_id/index %d/%d\n",
+			 evt_detail->args.ld.target_id, evt_detail->args.ld.ld_index);
+
 }
 
 /*
@@ -1764,6 +1772,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	u32 ld_tgt_id;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
@@ -1790,17 +1799,21 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		}
 	}
 
-	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
+	mr_device_priv_data = scmd->device->hostdata;
+	if (!mr_device_priv_data ||
+	    (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
-	mr_device_priv_data = scmd->device->hostdata;
-	if (!mr_device_priv_data) {
-		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
-		return 0;
+	if (MEGASAS_IS_LOGICAL(scmd->device)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(scmd->device);
+		if (instance->ld_tgtid_status[ld_tgt_id] == LD_TARGET_ID_DELETED) {
+			scmd->result = DID_NO_CONNECT << 16;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
 	}
 
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
@@ -2080,7 +2093,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 
 static int megasas_slave_alloc(struct scsi_device *sdev)
 {
-	u16 pd_index = 0;
+	u16 pd_index = 0, ld_tgt_id;
 	struct megasas_instance *instance ;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
@@ -2105,6 +2118,14 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 					GFP_KERNEL);
 	if (!mr_device_priv_data)
 		return -ENOMEM;
+
+	if (MEGASAS_IS_LOGICAL(sdev)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
+		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_ACTIVE;
+		if (megasas_dbg_lvl & LD_PD_DEBUG)
+			sdev_printk(KERN_INFO, sdev, "LD target ID %d created.\n", ld_tgt_id);
+	}
+
 	sdev->hostdata = mr_device_priv_data;
 
 	atomic_set(&mr_device_priv_data->r1_ldio_hint,
@@ -2114,6 +2135,19 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 
 static void megasas_slave_destroy(struct scsi_device *sdev)
 {
+	u16 ld_tgt_id;
+	struct megasas_instance *instance;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+
+	if (MEGASAS_IS_LOGICAL(sdev)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
+		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_DELETED;
+		if (megasas_dbg_lvl & LD_PD_DEBUG)
+			sdev_printk(KERN_INFO, sdev,
+				    "LD target ID %d removed from OS stack\n", ld_tgt_id);
+	}
+
 	kfree(sdev->hostdata);
 	sdev->hostdata = NULL;
 }
@@ -3472,6 +3506,22 @@ megasas_complete_abort(struct megasas_instance *instance,
 	}
 }
 
+static void
+megasas_set_ld_removed_by_fw(struct megasas_instance *instance)
+{
+	uint i;
+
+	for (i = 0; (i < MEGASAS_MAX_LD_IDS); i++) {
+		if (instance->ld_ids_prev[i] != 0xff &&
+		    instance->ld_ids_from_raidmap[i] == 0xff) {
+			if (megasas_dbg_lvl & LD_PD_DEBUG)
+				dev_info(&instance->pdev->dev,
+					 "LD target ID %d removed from RAID map\n", i);
+			instance->ld_tgtid_status[i] = LD_TARGET_ID_DELETED;
+		}
+	}
+}
+
 /**
  * megasas_complete_cmd -	Completes a command
  * @instance:			Adapter soft state
@@ -3634,9 +3684,13 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				fusion->fast_path_io = 0;
 			}
 
+			if (instance->adapter_type >= INVADER_SERIES)
+				megasas_set_ld_removed_by_fw(instance);
+
 			megasas_sync_map_info(instance);
 			spin_unlock_irqrestore(instance->host->host_lock,
 					       flags);
+
 			break;
 		}
 		if (opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
@@ -8777,8 +8831,10 @@ megasas_aen_polling(struct work_struct *work)
 	union megasas_evt_class_locale class_locale;
 	int event_type = 0;
 	u32 seq_num;
+	u16 ld_target_id;
 	int error;
 	u8  dcmd_ret = DCMD_SUCCESS;
+	struct scsi_device *sdev1;
 
 	if (!instance) {
 		printk(KERN_ERR "invalid instance!\n");
@@ -8801,12 +8857,23 @@ megasas_aen_polling(struct work_struct *work)
 			break;
 
 		case MR_EVT_LD_OFFLINE:
-		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
+			ld_target_id = instance->evt_detail->args.ld.target_id;
+			sdev1 = scsi_device_lookup(instance->host,
+						   MEGASAS_MAX_PD_CHANNELS +
+						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
+						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
+						   0);
+			if (sdev1)
+				megasas_remove_scsi_device(sdev1);
+
+			event_type = SCAN_VD_CHANNEL;
+			break;
 		case MR_EVT_LD_CREATED:
 			event_type = SCAN_VD_CHANNEL;
 			break;
 
+		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
 		case MR_EVT_FOREIGN_CFG_IMPORTED:
 		case MR_EVT_LD_STATE_CHANGE:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index b6c08d620033..83f69c33b01a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -349,6 +349,10 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 
 	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
 
+	memcpy(instance->ld_ids_prev,
+	       instance->ld_ids_from_raidmap,
+	       sizeof(instance->ld_ids_from_raidmap));
+	memset(instance->ld_ids_from_raidmap, 0xff, MEGASAS_MAX_LD_IDS);
 	/*Convert Raid capability values to CPU arch */
 	for (i = 0; (num_lds > 0) && (i < MAX_LOGICAL_DRIVES_EXT); i++) {
 		ld = MR_TargetIdToLdGet(i, drv_map);
@@ -359,7 +363,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 
 		raid = MR_LdRaidGet(ld, drv_map);
 		le32_to_cpus((u32 *)&raid->capability);
-
+		instance->ld_ids_from_raidmap[i] = i;
 		num_lds--;
 	}
 
-- 
2.30.2

