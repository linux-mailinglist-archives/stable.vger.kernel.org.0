Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279C31A596E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgDKXgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgDKXIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D9CF215A4;
        Sat, 11 Apr 2020 23:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646516;
        bh=5ltlsvjrcfXS85Oe+UcyH9K8yOz/IsHb28AJsSQLdl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUinirE6ug7QmSTW8wd1ZSxbgMFHww7w6YEZS/D3byCJod+DuBenE9xN6i7YChdho
         r8rv0kdyUelrdJotj9Q9k8UPaht+W2UzXRjU2Mu7/IC07f/TJc+h/ePCwp3P04OJiy
         1Msskz4kkL/i/vpn+CJ3pk43c83twjl7uqieDyCs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 073/121] scsi: qla2xxx: Handle NVME status iocb correctly
Date:   Sat, 11 Apr 2020 19:06:18 -0400
Message-Id: <20200411230706.23855-73-sashal@kernel.org>
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

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 3d582b34992ba2fe4065f01019f0c08d12916faa ]

Certain state flags bit combinations are not checked and not handled
correctly. Plus, do not log a normal underrun situation where there is
no frame drop.

Link: https://lore.kernel.org/r/20200226224022.24518-17-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 47 ++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9f91245504152..a1be3ef9411e4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1889,6 +1889,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct nvmefc_fcp_req *fd;
 	uint16_t        ret = QLA_SUCCESS;
 	uint16_t	comp_status = le16_to_cpu(sts->comp_status);
+	int		logit = 0;
 
 	iocb = &sp->u.iocb_cmd;
 	fcport = sp->fcport;
@@ -1899,6 +1900,12 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (unlikely(iocb->u.nvme.aen_op))
 		atomic_dec(&sp->vha->hw->nvme_active_aen_cnt);
 
+	if (unlikely(comp_status != CS_COMPLETE))
+		logit = 1;
+
+	fd->transferred_length = fd->payload_length -
+	    le32_to_cpu(sts->residual_len);
+
 	/*
 	 * State flags: Bit 6 and 0.
 	 * If 0 is set, we don't care about 6.
@@ -1909,8 +1916,20 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	 */
 	if (!(state_flags & (SF_FCP_RSP_DMA | SF_NVME_ERSP))) {
 		iocb->u.nvme.rsp_pyld_len = 0;
-	} else if ((state_flags & SF_FCP_RSP_DMA)) {
+	} else if ((state_flags & (SF_FCP_RSP_DMA | SF_NVME_ERSP)) ==
+			(SF_FCP_RSP_DMA | SF_NVME_ERSP)) {
+		/* Response already DMA'd to fd->rspaddr. */
 		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+	} else if ((state_flags & SF_FCP_RSP_DMA)) {
+		/*
+		 * Non-zero value in first 12 bytes of NVMe_RSP IU, treat this
+		 * as an error.
+		 */
+		iocb->u.nvme.rsp_pyld_len = 0;
+		fd->transferred_length = 0;
+		ql_dbg(ql_dbg_io, fcport->vha, 0x307a,
+			"Unexpected values in NVMe_RSP IU.\n");
+		logit = 1;
 	} else if (state_flags & SF_NVME_ERSP) {
 		uint32_t *inbuf, *outbuf;
 		uint16_t iter;
@@ -1933,16 +1952,28 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		iter = iocb->u.nvme.rsp_pyld_len >> 2;
 		for (; iter; iter--)
 			*outbuf++ = swab32(*inbuf++);
-	} else { /* unhandled case */
-	    ql_log(ql_log_warn, fcport->vha, 0x503a,
-		"NVME-%s error. Unhandled state_flags of %x\n",
-		sp->name, state_flags);
 	}
 
-	fd->transferred_length = fd->payload_length -
-	    le32_to_cpu(sts->residual_len);
+	if (state_flags & SF_NVME_ERSP) {
+		struct nvme_fc_ersp_iu *rsp_iu = fd->rspaddr;
+		u32 tgt_xfer_len;
 
-	if (unlikely(comp_status != CS_COMPLETE))
+		tgt_xfer_len = be32_to_cpu(rsp_iu->xfrd_len);
+		if (fd->transferred_length != tgt_xfer_len) {
+			ql_dbg(ql_dbg_io, fcport->vha, 0x3079,
+				"Dropped frame(s) detected (sent/rcvd=%u/%u).\n",
+				tgt_xfer_len, fd->transferred_length);
+			logit = 1;
+		} else if (comp_status == CS_DATA_UNDERRUN) {
+			/*
+			 * Do not log if this is just an underflow and there
+			 * is no data loss.
+			 */
+			logit = 0;
+		}
+	}
+
+	if (unlikely(logit))
 		ql_log(ql_log_warn, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
-- 
2.20.1

