Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C135266D
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 07:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBFcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 01:32:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58646 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhDBFcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 01:32:36 -0400
IronPort-SDR: mRNT3GLpO2N8Frunp3C/aZhRhmUPbi1puffvgX7j883+RJhawyfMyREYceTxq+Jmk1qlGmlXNH
 rKGh6yqm/eCq9+dLh+Q+Tj4cXPVGJuuFn6z31ALOHWyx2lGrxFUSRfgzWA9AcNDWxR6KJd4Le1
 Nzr7pYQJHmAx5/RAltOLeNA2A7wugFK2JbhMWSbUhd68i2ybyP64ibXaNs2GHFIvfcUmy3CQbo
 W4yVpDnkGv3VuPpdzbc5cGe0YRRFL/+ObpTFD58eiHcDfIaefc+HuECvJ1WC+X0WbFxgCTv9y4
 My4=
X-IronPort-AV: E=Sophos;i="5.81,298,1610434800"; 
   d="scan'208";a="121529705"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2021 22:32:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 22:32:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 1 Apr 2021 22:32:34 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Ash Izat <ash@ai0.uk>, <stable@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/1] pm80xx: Fix chip initialization failure
Date:   Fri, 2 Apr 2021 11:12:12 +0530
Message-ID: <20210402054212.17834-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Inbound and outbound queues are not properly configured and
that leads to MPI configuration failure.

Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")

Cc: stable@vger.kernel.org # 5.10+

Reported-and-tested-by: Ash Izat <ash@ai0.uk>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f70a470..31e5455d280c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -223,7 +223,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		PM8001_EVENT_LOG_SIZE;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_option		= 0x01;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
@@ -249,7 +249,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->inbnd_q_tbl[i].producer_idx		= 0;
 		pm8001_ha->inbnd_q_tbl[i].consumer_index	= 0;
 	}
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
@@ -671,9 +671,9 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	read_outbnd_queue_table(pm8001_ha);
 	/* update main config table ,inbound table and outbound table */
 	update_main_config_table(pm8001_ha);
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_inbnd_queue_table(pm8001_ha, i);
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_outbnd_queue_table(pm8001_ha, i);
 	/* 8081 controller donot require these operations */
 	if (deviceid != 0x8081 && deviceid != 0x0042) {
-- 
2.16.3

