Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D71041200A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353939AbhITRsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349299AbhITRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D0A161351;
        Mon, 20 Sep 2021 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157818;
        bh=mAhMm/WuB3DXx3pILyFdCxG6w/ejDLp/FNjRZhPNX2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stWISsdlQUucl2dd1xsJ0gtBla2CP14dQOXkpvQt0loN1Wn2Y2b6P4Ax+Zxm/xD+V
         Zehctv5qTUE4ZoUUUub0nC2aGSCt6Yi0Cj25v8MCa540+8pCP3A3IP8Q8WV++PSJJs
         W3xgykDp01DY/iXSiSyZCGEJ1y6LCdH2GrNeDYsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/293] scsi: qedi: Fix error codes in qedi_alloc_global_queues()
Date:   Mon, 20 Sep 2021 18:42:07 +0200
Message-Id: <20210920163938.930942898@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4dbe57d46d54a847875fa33e7d05877bb341585e ]

This function had some left over code that returned 1 on error instead
negative error codes.  Convert everything to use negative error codes.  The
caller treats all non-zero returns the same so this does not affect run
time.

A couple places set "rc" instead of "status" so those error paths ended up
returning success by mistake.  Get rid of the "rc" variable and use
"status" everywhere.

Remove the bogus "status = 0" initialization, as a future proofing measure
so the compiler will warn about uninitialized error codes.

Link: https://lore.kernel.org/r/20210810084753.GD23810@kili
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 7665fd641886..ab66e1f0fdfa 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1507,7 +1507,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -1518,14 +1518,14 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 	 */
 	if (!qedi->num_queues) {
 		QEDI_ERR(&qedi->dbg_ctx, "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/* Make sure we allocated the PBL that will contain the physical
 	 * addresses of our queues
 	 */
 	if (!qedi->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		goto mem_alloc_failure;
 	}
 
@@ -1540,13 +1540,13 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		  "qedi->global_queues=%p.\n", qedi->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedi_alloc_bdq(qedi);
-	if (rc)
+	status = qedi_alloc_bdq(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate DMA coherent buffers for NVM_ISCSI_CFG */
-	rc = qedi_alloc_nvm_iscsi_cfg(qedi);
-	if (rc)
+	status = qedi_alloc_nvm_iscsi_cfg(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate a CQ and an associated PBL for each MSI-X
-- 
2.30.2



