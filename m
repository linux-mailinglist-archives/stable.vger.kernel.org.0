Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41EB4121AA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350824AbhITSHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358577AbhITSHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B87361A3A;
        Mon, 20 Sep 2021 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158288;
        bh=wFUqVaxrZp6e54TxAJ8IMZ0lei79O43bzWtLNiN//ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgZZtWPdG1OzCj487rkdx0XPbdx2HSBxET3vsfH510iE1wz/NVbTjliiLqSxOERxe
         JIZrbEEVMSSMkFmgXPH3joJD88pa9NZLdYSaTXWmnmSDTo9VTSNFLexw72eCzRZ4Ej
         38gFvwC4K04EswuXHY8z923x3bqs3QFkeiQr3uVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/260] scsi: qedf: Fix error codes in qedf_alloc_global_queues()
Date:   Mon, 20 Sep 2021 18:41:13 +0200
Message-Id: <20210920163932.972946826@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ccc89737aa6b9f248cf1623014038beb6c2b7f56 ]

This driver has some left over "return 1" on failure style code mixed with
"return negative error codes" style code.  The caller doesn't care so we
should just convert everything to return negative error codes.

Then there was a problem that there were two variables used to store error
codes which just resulted in confusion.  If qedf_alloc_bdq() returned a
negative error code, we accidentally returned success instead of
propagating the error code.  So get rid of the "rc" variable and use
"status" every where.

Also remove the "status = 0" initialization so that these sorts of bugs
will be detected by the compiler in the future.

Link: https://lore.kernel.org/r/20210810085023.GA23998@kili
Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7a6306f8483e..c95e04cc6424 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2894,7 +2894,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -2906,7 +2906,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 */
 	if (!qedf->num_queues) {
 		QEDF_ERR(&(qedf->dbg_ctx), "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/*
@@ -2914,7 +2914,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 * addresses of our queues
 	 */
 	if (!qedf->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
 		goto mem_alloc_failure;
 	}
@@ -2930,8 +2930,8 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		   "qedf->global_queues=%p.\n", qedf->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedf_alloc_bdq(qedf);
-	if (rc) {
+	status = qedf_alloc_bdq(qedf);
+	if (status) {
 		QEDF_ERR(&qedf->dbg_ctx, "Unable to allocate bdq.\n");
 		goto mem_alloc_failure;
 	}
-- 
2.30.2



