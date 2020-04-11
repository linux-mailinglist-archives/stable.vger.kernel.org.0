Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986521A5926
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgDKXJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgDKXJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B783B217D8;
        Sat, 11 Apr 2020 23:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646548;
        bh=wOm6rMiOMk63monrsQgu+88dDlJcauWZEKzEvhYOGQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL+rYk7urz6E8Blqi5Hx4y/MB5TcQCDX6qb1qR/RYGRmeDVAS098s0wGQrIVh66jk
         k7YHL5r7xq2/2G4tH0lHAft2Iv+Vps9m4c6WM1dl1YWXTRqOCtGAVdQGuZ0CO2lh71
         NvdebVG6D1Kv5CryQNdDJm4Vk18df0QmItXx5Y8g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 099/121] scsi: qla2xxx: Return appropriate failure through BSG Interface
Date:   Sat, 11 Apr 2020 19:06:44 -0400
Message-Id: <20200411230706.23855-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hernandez <mhernandez@marvell.com>

[ Upstream commit 1b81e7f3019d632a707e07927e946ffbbc102910 ]

This patch ensures flash updates API calls return possible failure
status through BSG interface to the application.

Link: https://lore.kernel.org/r/20200226224022.24518-7-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |  9 +++++++--
 drivers/scsi/qla2xxx/qla_sup.c | 13 ++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index cbaf178fc9796..f06e499796976 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1505,10 +1505,15 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	    bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
 	    ha->optrom_region_size);
 
-	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+	rval = ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
 
-	bsg_reply->result = DID_OK;
+	if (rval) {
+		bsg_reply->result = -EINVAL;
+		rval = -EINVAL;
+	} else {
+		bsg_reply->result = DID_OK;
+	}
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index bbe90354f49b0..07f0d8669806d 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2686,7 +2686,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	uint32_t sec_mask, rest_addr, fdata;
 	void *optrom = NULL;
 	dma_addr_t optrom_dma;
-	int rval;
+	int rval, ret;
 	struct secure_flash_update_block *sfub;
 	dma_addr_t sfub_dma;
 	uint32_t offset = faddr << 2;
@@ -2942,11 +2942,12 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 write_protect:
 	ql_log(ql_log_warn + ql_dbg_verbose, vha, 0x7095,
 	    "Protect flash...\n");
-	rval = qla24xx_protect_flash(vha);
-	if (rval) {
+	ret = qla24xx_protect_flash(vha);
+	if (ret) {
 		qla81xx_fac_semaphore_access(vha, FAC_SEMAPHORE_UNLOCK);
 		ql_log(ql_log_warn, vha, 0x7099,
 		    "Failed protect flash\n");
+		rval = QLA_COMMAND_ERROR;
 	}
 
 	if (reset_to_rom == true) {
@@ -2954,10 +2955,12 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 
-		rval = qla2x00_wait_for_hba_online(vha);
-		if (rval != QLA_SUCCESS)
+		ret = qla2x00_wait_for_hba_online(vha);
+		if (ret != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0xffff,
 			    "Adapter did not come out of reset\n");
+			rval = QLA_COMMAND_ERROR;
+		}
 	}
 
 done:
-- 
2.20.1

