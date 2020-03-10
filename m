Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0366D17FB9F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgCJNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731956AbgCJNO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6A47208E4;
        Tue, 10 Mar 2020 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846098;
        bh=u5+Vg2yfAlzpgILsxMkOEolNoK2PS64jZe6xICgGDfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLrJJPese5Ry0URLKJ/xF/gkFwoHVJ2nXQuA5QVMVziqFiSt+4r8prwWqrIIEd5Z6
         T5KPSeaOB2wTUw7Vjzg3L19I1avqsX7ICLHB1S0BDaKs579rZxgVgDszJKgnsEpcTk
         gFm/L1fbUg5lcmdC1ajjoC85aOIiJpnPgI5WgPS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 86/86] scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive
Date:   Tue, 10 Mar 2020 13:45:50 +0100
Message-Id: <20200310124535.513334751@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Ukey <deepak.ukey@microchip.com>

commit 196ba6629cf95e51403337235d09742fcdc3febd upstream.

Disabling the SATA drive interface cause kernel panic. When the drive
Interface is disabled, device should be deregistered after aborting all
pending I/Os. Also changed the port recovery timeout to 10000 ms for
PM8006 controller.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/pm8001/pm8001_sas.c |    6 +++++-
 drivers/scsi/pm8001/pm80xx_hwi.c |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -866,6 +866,8 @@ static void pm8001_dev_gone_notify(struc
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 				dev, 1, 0);
+			while (pm8001_dev->running_req)
+				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
@@ -1238,8 +1240,10 @@ int pm8001_abort_task(struct sas_task *t
 			PM8001_MSG_DBG(pm8001_ha,
 				pm8001_printk("Waiting for Port reset\n"));
 			wait_for_completion(&completion_reset);
-			if (phy->port_reset_status)
+			if (phy->port_reset_status) {
+				pm8001_dev_gone_notify(dev);
 				goto out;
+			}
 
 			/*
 			 * 4. SATA Abort ALL
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -604,7 +604,7 @@ static void update_main_config_table(str
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=
 					0x0000ffff;
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
-					0x140000;
+					CHIP_8006_PORT_RECOVERY_TIMEOUT;
 	}
 	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
 			pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -228,6 +228,8 @@
 #define SAS_MAX_AIP                     0x200000
 #define IT_NEXUS_TIMEOUT       0x7D0
 #define PORT_RECOVERY_TIMEOUT  ((IT_NEXUS_TIMEOUT/100) + 30)
+/* Port recovery timeout, 10000 ms for PM8006 controller */
+#define CHIP_8006_PORT_RECOVERY_TIMEOUT 0x640000
 
 #ifdef __LITTLE_ENDIAN_BITFIELD
 struct sas_identify_frame_local {


