Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CE4F37E9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359648AbiDELUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349092AbiDEJtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F757A9979;
        Tue,  5 Apr 2022 02:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C381861368;
        Tue,  5 Apr 2022 09:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D48C385A2;
        Tue,  5 Apr 2022 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151640;
        bh=4+OOZNBD90ZNePompwNJGdjG59rQyPZqbutp8dZK1EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg62MQWUY8Wc0EBVq1GuUy8GMxl3YILYGbnrCltOIkLlb7b2SPrE3Oy1f8ZFXMorS
         /HiUN+4RPQEWwXZsmHVc+zUSSwO7B4cSKPy/5FLN97dGim/AipkWiCh4TmjnZOfkiZ
         5JM51aP2REjBv4I2pqMRFf0rIG6V7O4aTdP1dy4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/913] scsi: pm8001: Fix NCQ NON DATA command task initialization
Date:   Tue,  5 Apr 2022 09:25:49 +0200
Message-Id: <20220405070354.453440981@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit aa028141ab0bc62c44a84d42f09db35d82df82a2 ]

In the pm8001_chip_sata_req() and pm80xx_chip_sata_req() functions, all
tasks with a DMA direction of DMA_NONE (no data transfer) are initialized
using the ATAP value 0x04. However, NCQ NON DATA commands, while being
DMA_NONE commands are NCQ commands and need to be initialized using the
value 0x07 for ATAP, similarly to other NCQ commands.

Make sure that NCQ NON DATA command tasks are initialized similarly to
other NCQ commands by also testing the task "use_ncq" field in addition to
the DMA direction. While at it, reorganize the code into a chain of if -
else if - else to avoid useless affectations and debug messages.

Link: https://lore.kernel.org/r/20220220031810.738362-15-damien.lemoal@opensource.wdc.com
Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++-------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index bad0c8b8cbe1..e9c77c945752 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4278,22 +4278,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32  opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	if (task->data_dir == DMA_NONE) {
+
+	if (task->data_dir == DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP = 0x04;  /* no data*/
 		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
-		if (task->ata_task.dma_xfer) {
+		if (task->ata_task.use_ncq &&
+		    dev->sata_dev.class != ATA_DEV_ATAPI) {
+			ATAP = 0x07; /* FPDMA */
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
+		} else if (task->ata_task.dma_xfer) {
 			ATAP = 0x06; /* DMA */
 			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP = 0x05; /* PIO*/
 			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
-		if (task->ata_task.use_ncq &&
-			dev->sata_dev.class != ATA_DEV_ATAPI) {
-			ATAP = 0x07; /* FPDMA */
-			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
-		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c6e4812e6591..043a2cc4d4de 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4552,22 +4552,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
 	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
 
-	if (task->data_dir == DMA_NONE) {
+	if (task->data_dir == DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP = 0x04; /* no data*/
 		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
-		if (task->ata_task.dma_xfer) {
+		if (task->ata_task.use_ncq &&
+		    dev->sata_dev.class != ATA_DEV_ATAPI) {
+			ATAP = 0x07; /* FPDMA */
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
+		} else if (task->ata_task.dma_xfer) {
 			ATAP = 0x06; /* DMA */
 			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP = 0x05; /* PIO*/
 			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
-		if (task->ata_task.use_ncq &&
-		    dev->sata_dev.class != ATA_DEV_ATAPI) {
-			ATAP = 0x07; /* FPDMA */
-			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
-		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
-- 
2.34.1



