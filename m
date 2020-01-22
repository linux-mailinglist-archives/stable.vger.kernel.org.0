Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB5D14568C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbgAVN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731736AbgAVN1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:43 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26CCA24125;
        Wed, 22 Jan 2020 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699661;
        bh=CH0d82njfd6dXZt7w82IU9YuXt0MSTfzLT4l9Y2AGrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8VNZSLnJAMNUNZuQYjXMXUSDDrbv18QIwqGvl6dlC6bnHCk4ObMU/+Feh6oTKlRH
         I+koYkfkYYW2OTSlfS1tZ3ZXvPV0hCN8kDWHoU/yLzd6rkWG0G/PK6OEo/a9BScflh
         l2Mu606o7FhWGZH6vAMhJueb1CojYwPj5t0ePiUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 211/222] scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
Date:   Wed, 22 Jan 2020 10:29:57 +0100
Message-Id: <20200122092848.803750833@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 35a635af54ce79881eb35ba20b64dcb1e81b0389 upstream.

In lpfc_release_io_buf, an lpfc_io_buf is returned to the 'available' pool
before any associated sgl or cmd and rsp buffers are returned via their
respective 'put' routines.  If xri rebalancing occurs and an lpfc_io_buf
structure is reused quickly, there may be a race condition between release
of old and association of new resources.

Re-ordered lpfc_release_io_buf to release sgl and cmd/rsp
buffer lists before releasing the lpfc_io_buf structure for re-use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Link: https://lore.kernel.org/r/20190922035906.10977-17-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_sli.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20108,6 +20108,13 @@ void lpfc_release_io_buf(struct lpfc_hba
 	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
 	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
+	if (phba->cfg_xpsgl && !phba->nvmet_support &&
+	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
+		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
+
+	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
+		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
+
 	if (phba->cfg_xri_rebalancing) {
 		if (lpfc_ncmd->expedite) {
 			/* Return to expedite pool */
@@ -20172,13 +20179,6 @@ void lpfc_release_io_buf(struct lpfc_hba
 		spin_unlock_irqrestore(&qp->io_buf_list_put_lock,
 				       iflag);
 	}
-
-	if (phba->cfg_xpsgl && !phba->nvmet_support &&
-	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
-		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
-
-	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
-		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
 }
 
 /**


