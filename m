Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5812F0CA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgABWTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbgABWS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBD521582;
        Thu,  2 Jan 2020 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003538;
        bh=Joc9FjlSiz2Sy+hMBbPoK+XA6jLYij35zDIdJ/OEV14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjtFmDiQD7ZS9y9tkWHayrdYXdAgGzyVJaNn9zgsCuqQlZfXhIMA2J40WQI35pqYr
         6S+N6F56Aea7J/zMK4dADAQPrBkA4f/k7vgTNzzdk2+ovM58ONdbagpMneXlk0M5rH
         uZBBisN+d+evFWOU76ran7y6PHiCfSPOiY1TpDFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/114] scsi: csiostor: Dont enable IRQs too early
Date:   Thu,  2 Jan 2020 23:06:23 +0100
Message-Id: <20200102220030.277009455@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cc5611efc7a9..a8e29e3d3572 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -301,6 +301,7 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_port_name *port_name;
 	uint8_t buf[64];
 	uint8_t *fc4_type;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi rhba cmd\n",
@@ -385,13 +386,13 @@ csio_ln_fdmi_rhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
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
@@ -412,6 +413,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	struct fc_fdmi_rpl *reg_pl;
 	struct fs_fdmi_attrs *attrib_blk;
 	uint8_t buf[64];
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dprt cmd\n",
@@ -491,13 +493,13 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
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
@@ -512,6 +514,7 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
 	void *cmd;
 	struct fc_fdmi_port_name *port_name;
 	uint32_t len;
+	unsigned long flags;
 
 	if (fdmi_req->wr_status != FW_SUCCESS) {
 		csio_ln_dbg(ln, "WR error:%x in processing fdmi dhba cmd\n",
@@ -542,13 +545,13 @@ csio_ln_fdmi_dhba_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
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



