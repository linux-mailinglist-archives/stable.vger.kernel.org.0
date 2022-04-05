Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1114F28ED
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiDEIXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiDEISA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B326B53CB;
        Tue,  5 Apr 2022 01:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA5DDB81B92;
        Tue,  5 Apr 2022 08:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E82EC385A0;
        Tue,  5 Apr 2022 08:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145972;
        bh=V24WKIPfPFIqO2VVsUEvIYTK3U7WGPSoWKs+2AsRAmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3FCCGUyZiHpJygwSw1L1QshgntwubhZX1hNEb26FJJyQZG9aHFUx/3pASzmGgVvC
         pl53ZQLOth6H5IOKKxukrIFe2X7/Br2qfffuzfSYOinD2ta03CfcpD48hWG4lM8z8i
         vphO0neZJMNdgzR5JrbUZRnefTZqzBUj0PT/X59M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0589/1126] scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
Date:   Tue,  5 Apr 2022 09:22:16 +0200
Message-Id: <20220405070424.921265640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit fd6d0e376211d7ed759db96b0fbd9a1cee67d462 ]

Make sure that the __le32 fields of struct sata_cmd are manipulated after
applying the correct endian conversion. That is, use cpu_to_le32() for
assigning values and le32_to_cpu() for consulting a field value.  In
particular, make sure that the calculations for the 4G boundary check are
done using CPU endianness and *not* little endian values. With these fixes,
many sparse warnings are removed.

While at it, fix some code identation and add blank lines after variable
declarations and in some other places to make this code more readable.

Link: https://lore.kernel.org/r/20220220031810.738362-12-damien.lemoal@opensource.wdc.com
Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 82 ++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 86c32e22f48e..0b4261735c03 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4540,7 +4540,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 q_index, cpu_id;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag = 0;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP = 0x0;
 	u32 dir;
@@ -4601,32 +4601,38 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			pm8001_chip_make_sg(task->scatter,
 						ccb->n_elem, ccb->buf_prd);
 			phys_addr = ccb->ccb_dma_handle;
-			sata_cmd.enc_addr_low = lower_32_bits(phys_addr);
-			sata_cmd.enc_addr_high = upper_32_bits(phys_addr);
+			sata_cmd.enc_addr_low =
+				cpu_to_le32(lower_32_bits(phys_addr));
+			sata_cmd.enc_addr_high =
+				cpu_to_le32(upper_32_bits(phys_addr));
 			sata_cmd.enc_esgl = cpu_to_le32(1 << 31);
 		} else if (task->num_scatter == 1) {
 			u64 dma_addr = sg_dma_address(task->scatter);
-			sata_cmd.enc_addr_low = lower_32_bits(dma_addr);
-			sata_cmd.enc_addr_high = upper_32_bits(dma_addr);
+
+			sata_cmd.enc_addr_low =
+				cpu_to_le32(lower_32_bits(dma_addr));
+			sata_cmd.enc_addr_high =
+				cpu_to_le32(upper_32_bits(dma_addr));
 			sata_cmd.enc_len = cpu_to_le32(task->total_xfer_len);
 			sata_cmd.enc_esgl = 0;
+
 			/* Check 4G Boundary */
-			start_addr = cpu_to_le64(dma_addr);
-			end_addr = (start_addr + sata_cmd.enc_len) - 1;
-			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high != sata_cmd.enc_addr_high) {
+			end_addr = dma_addr + le32_to_cpu(sata_cmd.enc_len) - 1;
+			end_addr_low = lower_32_bits(end_addr);
+			end_addr_high = upper_32_bits(end_addr);
+			if (end_addr_high != le32_to_cpu(sata_cmd.enc_addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
-					   start_addr, sata_cmd.enc_len,
+					   dma_addr,
+					   le32_to_cpu(sata_cmd.enc_len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
 				sata_cmd.enc_addr_low =
-					lower_32_bits(phys_addr);
+					cpu_to_le32(lower_32_bits(phys_addr));
 				sata_cmd.enc_addr_high =
-					upper_32_bits(phys_addr);
+					cpu_to_le32(upper_32_bits(phys_addr));
 				sata_cmd.enc_esgl =
 					cpu_to_le32(1 << 31);
 			}
@@ -4637,7 +4643,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			sata_cmd.enc_esgl = 0;
 		}
 		/* XTS mode. All other fields are 0 */
-		sata_cmd.key_index_mode = 0x6 << 4;
+		sata_cmd.key_index_mode = cpu_to_le32(0x6 << 4);
+
 		/* set tweak values. Should be the start lba */
 		sata_cmd.twk_val0 =
 			cpu_to_le32((sata_cmd.sata_fis.lbal_exp << 24) |
@@ -4663,31 +4670,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			phys_addr = ccb->ccb_dma_handle;
 			sata_cmd.addr_low = lower_32_bits(phys_addr);
 			sata_cmd.addr_high = upper_32_bits(phys_addr);
-			sata_cmd.esgl = cpu_to_le32(1 << 31);
+			sata_cmd.esgl = cpu_to_le32(1U << 31);
 		} else if (task->num_scatter == 1) {
 			u64 dma_addr = sg_dma_address(task->scatter);
+
 			sata_cmd.addr_low = lower_32_bits(dma_addr);
 			sata_cmd.addr_high = upper_32_bits(dma_addr);
 			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
 			sata_cmd.esgl = 0;
+
 			/* Check 4G Boundary */
-			start_addr = cpu_to_le64(dma_addr);
-			end_addr = (start_addr + sata_cmd.len) - 1;
-			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
+			end_addr = dma_addr + le32_to_cpu(sata_cmd.len) - 1;
+			end_addr_low = lower_32_bits(end_addr);
+			end_addr_high = upper_32_bits(end_addr);
 			if (end_addr_high != sata_cmd.addr_high) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=0x%016llx data_len=0x%xend_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
-					   start_addr, sata_cmd.len,
+					   dma_addr,
+					   le32_to_cpu(sata_cmd.len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
-				sata_cmd.addr_low =
-					lower_32_bits(phys_addr);
-				sata_cmd.addr_high =
-					upper_32_bits(phys_addr);
-				sata_cmd.esgl = cpu_to_le32(1 << 31);
+				sata_cmd.addr_low = lower_32_bits(phys_addr);
+				sata_cmd.addr_high = upper_32_bits(phys_addr);
+				sata_cmd.esgl = cpu_to_le32(1U << 31);
 			}
 		} else if (task->num_scatter == 0) {
 			sata_cmd.addr_low = 0;
@@ -4695,27 +4702,28 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
 			sata_cmd.esgl = 0;
 		}
+
 		/* scsi cdb */
 		sata_cmd.atapi_scsi_cdb[0] =
 			cpu_to_le32(((task->ata_task.atapi_packet[0]) |
-			(task->ata_task.atapi_packet[1] << 8) |
-			(task->ata_task.atapi_packet[2] << 16) |
-			(task->ata_task.atapi_packet[3] << 24)));
+				     (task->ata_task.atapi_packet[1] << 8) |
+				     (task->ata_task.atapi_packet[2] << 16) |
+				     (task->ata_task.atapi_packet[3] << 24)));
 		sata_cmd.atapi_scsi_cdb[1] =
 			cpu_to_le32(((task->ata_task.atapi_packet[4]) |
-			(task->ata_task.atapi_packet[5] << 8) |
-			(task->ata_task.atapi_packet[6] << 16) |
-			(task->ata_task.atapi_packet[7] << 24)));
+				     (task->ata_task.atapi_packet[5] << 8) |
+				     (task->ata_task.atapi_packet[6] << 16) |
+				     (task->ata_task.atapi_packet[7] << 24)));
 		sata_cmd.atapi_scsi_cdb[2] =
 			cpu_to_le32(((task->ata_task.atapi_packet[8]) |
-			(task->ata_task.atapi_packet[9] << 8) |
-			(task->ata_task.atapi_packet[10] << 16) |
-			(task->ata_task.atapi_packet[11] << 24)));
+				     (task->ata_task.atapi_packet[9] << 8) |
+				     (task->ata_task.atapi_packet[10] << 16) |
+				     (task->ata_task.atapi_packet[11] << 24)));
 		sata_cmd.atapi_scsi_cdb[3] =
 			cpu_to_le32(((task->ata_task.atapi_packet[12]) |
-			(task->ata_task.atapi_packet[13] << 8) |
-			(task->ata_task.atapi_packet[14] << 16) |
-			(task->ata_task.atapi_packet[15] << 24)));
+				     (task->ata_task.atapi_packet[13] << 8) |
+				     (task->ata_task.atapi_packet[14] << 16) |
+				     (task->ata_task.atapi_packet[15] << 24)));
 	}
 
 	/* Check for read log for failed drive and return */
-- 
2.34.1



