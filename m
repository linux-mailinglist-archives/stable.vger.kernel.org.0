Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3D34F37E4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359633AbiDELU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349090AbiDEJtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B61A995E;
        Tue,  5 Apr 2022 02:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4E79B81C19;
        Tue,  5 Apr 2022 09:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35991C385A1;
        Tue,  5 Apr 2022 09:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151634;
        bh=sYf+t7656CgLm8+KoM7bCiP2p1CO2fDUCQ1xVOK+Q7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNeiZpn9xE5TtThU+hv2K8FqqnP+415pdIfiN1itR0fZyaFkLjat82RnOkRFPuqU4
         Q37/pPD0Qr8QL+XPFEJXXl6dy3odUX4z8MHPwbQ7LBju97WiqbhWG69Gd2pbh5082C
         l4Krt8b9pqzd+UBkukEPZfBtISoW5lkSiQq+x4qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/913] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Tue,  5 Apr 2022 09:25:47 +0200
Message-Id: <20220405070354.393333268@linuxfoundation.org>
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

[ Upstream commit 970404cc5744b1033b6ee601be4ef0e2d1fbcf72 ]

Make sure that the __le32 fields of struct ssp_ini_io_start_req are
manipulated after applying the correct endian conversion. That is, use
cpu_to_le32() for assigning values and le32_to_cpu() for consulting a field
value. In particular, make sure that the calculations for the 4G boundary
check are done using CPU endianness and *not* little endian values. With
these fixes, many sparse warnings are removed.

While at it, add blank lines after variable declarations and in some other
places to make this code more readable.

Link: https://lore.kernel.org/r/20220220031810.738362-11-damien.lemoal@opensource.wdc.com
Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 41 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index e606a9b1c3af..d7a27627fce0 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4381,13 +4381,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	struct ssp_ini_io_start_req ssp_cmd;
 	u32 tag = ccb->ccb_tag;
 	int ret;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	struct inbound_queue_table *circularQ;
 	u32 q_index, cpu_id;
 	u32 opc = OPC_INB_SSPINIIOSTART;
+
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
+
 	/* data address domain added for spcv; set to 0 by host,
 	 * used internally by controller
 	 * 0 for SAS 1.1 and SAS 2.0 compatible TLR
@@ -4398,7 +4400,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	ssp_cmd.device_id = cpu_to_le32(pm8001_dev->device_id);
 	ssp_cmd.tag = cpu_to_le32(tag);
 	if (task->ssp_task.enable_first_burst)
-		ssp_cmd.ssp_iu.efb_prio_attr |= 0x80;
+		ssp_cmd.ssp_iu.efb_prio_attr = 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
@@ -4430,21 +4432,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
 		} else if (task->num_scatter == 1) {
 			u64 dma_addr = sg_dma_address(task->scatter);
+
 			ssp_cmd.enc_addr_low =
 				cpu_to_le32(lower_32_bits(dma_addr));
 			ssp_cmd.enc_addr_high =
 				cpu_to_le32(upper_32_bits(dma_addr));
 			ssp_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.enc_esgl = 0;
+
 			/* Check 4G Boundary */
-			start_addr = cpu_to_le64(dma_addr);
-			end_addr = (start_addr + ssp_cmd.enc_len) - 1;
-			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high != ssp_cmd.enc_addr_high) {
+			end_addr = dma_addr + le32_to_cpu(ssp_cmd.enc_len) - 1;
+			end_addr_low = lower_32_bits(end_addr);
+			end_addr_high = upper_32_bits(end_addr);
+
+			if (end_addr_high != le32_to_cpu(ssp_cmd.enc_addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
-					   start_addr, ssp_cmd.enc_len,
+					   dma_addr,
+					   le32_to_cpu(ssp_cmd.enc_len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
@@ -4453,7 +4458,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =
 					cpu_to_le32(upper_32_bits(phys_addr));
-				ssp_cmd.enc_esgl = cpu_to_le32(1<<31);
+				ssp_cmd.enc_esgl = cpu_to_le32(1U<<31);
 			}
 		} else if (task->num_scatter == 0) {
 			ssp_cmd.enc_addr_low = 0;
@@ -4461,8 +4466,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.enc_esgl = 0;
 		}
+
 		/* XTS mode. All other fields are 0 */
-		ssp_cmd.key_cmode = 0x6 << 4;
+		ssp_cmd.key_cmode = cpu_to_le32(0x6 << 4);
+
 		/* set tweak values. Should be the start lba */
 		ssp_cmd.twk_val0 = cpu_to_le32((task->ssp_task.cmd->cmnd[2] << 24) |
 						(task->ssp_task.cmd->cmnd[3] << 16) |
@@ -4484,20 +4491,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.esgl = cpu_to_le32(1<<31);
 		} else if (task->num_scatter == 1) {
 			u64 dma_addr = sg_dma_address(task->scatter);
+
 			ssp_cmd.addr_low = cpu_to_le32(lower_32_bits(dma_addr));
 			ssp_cmd.addr_high =
 				cpu_to_le32(upper_32_bits(dma_addr));
 			ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.esgl = 0;
+
 			/* Check 4G Boundary */
-			start_addr = cpu_to_le64(dma_addr);
-			end_addr = (start_addr + ssp_cmd.len) - 1;
-			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high != ssp_cmd.addr_high) {
+			end_addr = dma_addr + le32_to_cpu(ssp_cmd.len) - 1;
+			end_addr_low = lower_32_bits(end_addr);
+			end_addr_high = upper_32_bits(end_addr);
+			if (end_addr_high != le32_to_cpu(ssp_cmd.addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
-					   start_addr, ssp_cmd.len,
+					   dma_addr,
+					   le32_to_cpu(ssp_cmd.len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
-- 
2.34.1



