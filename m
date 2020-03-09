Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCC317DD43
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 11:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgCIKRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 06:17:45 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42728 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgCIKRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 06:17:45 -0400
Received: by mail-ed1-f65.google.com with SMTP id n18so11328800edw.9
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 03:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OxJ9nVIBPnktLaS7KTQtbSI87soZw/fzkRft+9BGw8M=;
        b=V3nU2InK5oUN/oz9AIbk0LRizslVPPa7IWiU9dHmunxbCHgAk+FcrYMN5kG47/oU6z
         3nbmX5pSTaiXW8CQ7EdYa+41y3RTDfiz6rVAVmacMJC1vlFRIVrtE+21HFTLN6AfzgvD
         VwSNb7Iu5BZ79ZQUeMm+0gW+Y5eRvd8/P2ul4XXQEg7N1a1hkkRU1wB/9w4+08WJbBKg
         uN8LrpNzjyOrMz+ianclVhQAh3Xz7GycZkM2vd5xPfMJORvsoHO/CH89Cona9PqB6gUg
         icL+3GN9Q0WTnN9QvSBG8xy7xlFjmyaJXzWOUpeyis+/Ppiwi9Xox/dmLKKtVZSpbE1E
         i2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OxJ9nVIBPnktLaS7KTQtbSI87soZw/fzkRft+9BGw8M=;
        b=LKriqyWjhlAqrFJNElJ3fF9HTKjfUMM6XAgeOc1byxWIT4W9C2YowD2pEfDnUpTMIk
         0I9zhXl3pO/o++eTj/CBjqi96IsPAZnp44mMOSVexmGhMCKmzmaZ0AeyRHC3TgOcyV0T
         /nD+lGEgp//VUEeGEXtA4VVgS5vwTzvFLvZbr8sJ6CWsgJMxT8NWaBIDCOlbVXB4Lkw+
         5MvAcNWDlmeHCpOyrw2uWRshOn858NOmhueO4fC+J+n9JyF0OS0Y1/2xps9PXhP7Ys4+
         rUlq03Cc8ZqRRWMmprmxXOxDl2MXto5rwZkQXm2Ea3XkFMIMpDcLURu6P3GP4MEn7q2N
         juBw==
X-Gm-Message-State: ANhLgQ0s943v6V3ID74o/qSqWipa4yGxDqYwQGP136u27LIk6t0CKur3
        wy4GGfSrjE1HveXRTRj7TR4LUHnVxaA=
X-Google-Smtp-Source: ADFU+vsRIBBCPSWBV8MNjVmFZInbT8ljezHqoHuvCtRKkAfx35fBfu3TeHXyiOWPUvUzm1hKidEuPQ==
X-Received: by 2002:a50:c043:: with SMTP id u3mr14707837edd.253.1583749062429;
        Mon, 09 Mar 2020 03:17:42 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:1934:edf1:9b2c:8a6c])
        by smtp.gmail.com with ESMTPSA id p20sm1317409ejf.6.2020.03.09.03.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:17:41 -0700 (PDT)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [stable-4.19 2/2] scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive
Date:   Mon,  9 Mar 2020 11:17:39 +0100
Message-Id: <20200309101739.32483-3-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Ukey <deepak.ukey@microchip.com>

commit 196ba6629cf95e51403337235d09742fcdc3febd upstream

Disabling the SATA drive interface cause kernel panic. When the drive
Interface is disabled, device should be deregistered after aborting all
pending I/Os. Also changed the port recovery timeout to 10000 ms for
PM8006 controller.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 6 +++++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 59feda261e08..5be4212312cb 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -866,6 +866,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 				dev, 1, 0);
+			while (pm8001_dev->running_req)
+				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
@@ -1238,8 +1240,10 @@ int pm8001_abort_task(struct sas_task *task)
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
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index bd945d832eb8..fd5f9892f3ac 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -604,7 +604,7 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=
 					0x0000ffff;
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
-					0x140000;
+					CHIP_8006_PORT_RECOVERY_TIMEOUT;
 	}
 	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
 			pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 7dd2699d0efb..bbe1747234ff 100644
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
-- 
2.17.1

