Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7564015B5FC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 01:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgBMAk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 19:40:27 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57544 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgBMAk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 19:40:27 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Sagar.Biradar@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Sagar.Biradar@microchip.com";
  x-sender="Sagar.Biradar@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Sagar.Biradar@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Sagar.Biradar@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VshFThL2DK1SpMOzQEMXVIlZGFqCdWQ5q3ePvjPM6idNCPfvKBzXIuk/GC2RezyZ+B2jLPFlkm
 jK+z+gtbnINRTc6YU64vLQIjLOg+w5S5SiS1m3O9ZvGySPtLt4feYaE655URccwBwz4Z365mU7
 h+GLWxLKyZlZYExq7V/3K5PLnDmWs8V+jGN571l+K7fQz3pd5lBuLAZKnUhp+OuaJA0YCSsOKU
 Q8p2iGgb6MUicO2X2u61duSDSzG2aWVtlIAvab5XQ0bEn3ilK1P9NBsUcmyoEwqs/aFKYZY2LQ
 4pE=
X-IronPort-AV: E=Sophos;i="5.70,434,1574146800"; 
   d="scan'208";a="66509747"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2020 17:40:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Feb 2020 17:40:25 -0700
Received: from LinuxBuild.microsemi.net (10.10.85.251) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 12 Feb 2020 17:40:26 -0700
From:   Sagar Biradar <Sagar.Biradar@microchip.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>
CC:     Sagar Biradar <Sagar.Biradar@microchip.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, Balsundar P <balsundar.p@microsemi.com>
Subject: [PATCH] aacraid: Disabling TM path and only processing IOP reset
Date:   Wed, 12 Feb 2020 16:29:31 -0800
Message-ID: <1581553771-25796-1-git-send-email-Sagar.Biradar@microchip.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes the occasional adapter panic when sg_reset is 
issued with -d, -t, -b and -H flags.
Removal of command type HBA_IU_TYPE_SCSI_TM_REQ in aac_hba_send since 
iu_type, request_id and fib_flags are not populated.
Device and target reset handlers made to send TMF commands only when 
reset_state is 0.

Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
Reviewed-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/commsup.c |  2 +-
 drivers/scsi/aacraid/linit.c   | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 5a8a999..5118bee 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -729,7 +729,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
 		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
-	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
+	} else
 		return -EINVAL;
 
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ee6bc2f..9130e03 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -731,7 +731,11 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		status = aac_hba_send(HBA_IU_TYPE_SCSI_TM_REQ, fib,
 				  (fib_callback) aac_hba_callback,
 				  (void *) cmd);
-
+		if (status != -EINPROGRESS) {
+			aac_fib_complete(fib);
+			aac_fib_free(fib);
+			return ret;
+		}
 		/* Wait up to 15 secs for completion */
 		for (count = 0; count < 15; ++count) {
 			if (cmd->SCp.sent_command) {
@@ -910,11 +914,11 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
 	info = &aac->hba_map[bus][cid];
 
-	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
-	    info->reset_state > 0)
+	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
+	 !(info->reset_state > 0)))
 		return FAILED;
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+	pr_err("%s: Host device reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
 	fib = aac_fib_alloc(aac);
@@ -929,7 +933,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	status = aac_hba_send(command, fib,
 			      (fib_callback) aac_tmf_callback,
 			      (void *) info);
-
+	if (status != -EINPROGRESS) {
+		info->reset_state = 0;
+		aac_fib_complete(fib);
+		aac_fib_free(fib);
+		return ret;
+	}
 	/* Wait up to 15 seconds for completion */
 	for (count = 0; count < 15; ++count) {
 		if (info->reset_state == 0) {
@@ -968,11 +977,11 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
 	info = &aac->hba_map[bus][cid];
 
-	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
-	    info->reset_state > 0)
+	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
+	 !(info->reset_state > 0)))
 		return FAILED;
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+	pr_err("%s: Host target reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
 	fib = aac_fib_alloc(aac);
@@ -989,6 +998,13 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 			      (fib_callback) aac_tmf_callback,
 			      (void *) info);
 
+	if (status != -EINPROGRESS) {
+		info->reset_state = 0;
+		aac_fib_complete(fib);
+		aac_fib_free(fib);
+		return ret;
+	}
+
 	/* Wait up to 15 seconds for completion */
 	for (count = 0; count < 15; ++count) {
 		if (info->reset_state <= 0) {
@@ -1041,7 +1057,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 		}
 	}
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
+	pr_err("%s: Host bus reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
 	/*
 	 * Check the health of the controller
-- 
1.8.3.1

