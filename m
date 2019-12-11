Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187A311B2A1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbfLKPfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388094AbfLKPfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4CF624656;
        Wed, 11 Dec 2019 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078518;
        bh=PUapq7A9/OUb4u2QU0C4bn2vpupibtTpKF043A5SH50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZMGsYjfVIKaAT5FMsH59Vgm9C6U2nIOeOFfgzzXADZwDTiZ3pJPjlt+Lpk2gBECI
         eLX4rdVtXvpR4h7pcbkVEtcgApSdFlLuldrrYjDKRQH5f3NdQJ5C5UNDjLO5YvVpEQ
         pRPIi07u8BxeGUNRqHsbIDDuZs+k9A04Nx7dTu5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/42] scsi: csiostor: Don't enable IRQs too early
Date:   Wed, 11 Dec 2019 10:34:35 -0500
Message-Id: <20191211153510.23861-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d6c9b31ac3064fbedf8961f120a4c117daa59932 ]

These are called with IRQs disabled from csio_mgmt_tmo_handler() so we
can't call spin_unlock_irq() or it will enable IRQs prematurely.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Link: https://lore.kernel.org/r/20191019085913.GA14245@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_lnode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index be5ee2d378155..957767d383610 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -301,6 +301,7 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_port_name *port_name;
 	uint8_t buf[64];
 	uint8_t *fc4_type;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi rhba cmd\n",
@@ -377,13 +378,13 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	len = (uint32_t)(pld - (uint8_t *)cmd);
 
 	/* Submit FDMI RPA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_done,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rpa req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /*
@@ -404,6 +405,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_rpl *reg_pl;
 	struct fs_fdmi_attrs *attrib_blk;
 	uint8_t buf[64];
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dprt cmd\n",
@@ -483,13 +485,13 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	attrib_blk->numattrs = htonl(numattrs);
 
 	/* Submit FDMI RHBA request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_rhba_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi rhba req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /*
@@ -504,6 +506,7 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	void *cmd;
 	struct fc_fdmi_port_name *port_name;
 	uint32_t len;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dhba cmd\n",
@@ -534,13 +537,13 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	len += sizeof(*port_name);
 
 	/* Submit FDMI request */
-	spin_lock_irq(&hw->lock);
+	spin_lock_irqsave(&hw->lock, flags);
 	if (csio_ln_mgmt_submit_req(fdmi_req, csio_ln_fdmi_dprt_cbfn,
 				FCOE_CT, &fdmi_req->dma_buf, len)) {
 		CSIO_INC_STATS(ln, n_fdmi_err);
 		csio_ln_dbg(ln, "Failed to issue fdmi dprt req\n");
 	}
-	spin_unlock_irq(&hw->lock);
+	spin_unlock_irqrestore(&hw->lock, flags);
 }
 
 /**
-- 
2.20.1

