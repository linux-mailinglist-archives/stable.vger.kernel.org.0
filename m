Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6DA328ABC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhCASWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239508AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A49CC65043;
        Mon,  1 Mar 2021 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619072;
        bh=uh+GEYAxWCm4fYNH3X7nASMCRkC6hW8pPCfDbV0Tot4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIiGRrlpO7P9rk/3eo0BC7O9ka0wDSm/OXobHEcgJWOtKsgoS726oYavSmx1q/6jj
         fKaVFNR2BsHjTyP6OgmiMKAuAtL9IJMFp483Dt55ncKTu0/TF1n4NfLWALBfa8ViWH
         wKH+AvXUmkS/KIRa8ZZNFlhQ6KV8MBqAQfPcwNng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/663] scsi: lpfc: Fix ancient double free
Date:   Mon,  1 Mar 2021 17:09:29 +0100
Message-Id: <20210301161157.729734977@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0be310979e5e1272d4c5b557642df4da4ce7eba4 ]

The "pmb" pointer is freed at the start of the function and then freed
again in the error handling code.

Link: https://lore.kernel.org/r/YA6E8rO51hE56SVw@mwanda
Fixes: 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of SLI-3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9746d2f4fcfad..f4a672e549716 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1154,13 +1154,14 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport *vport = pmb->vport;
 	LPFC_MBOXQ_t *sparam_mb;
 	struct lpfc_dmabuf *sparam_mp;
+	u16 status = pmb->u.mb.mbxStatus;
 	int rc;
 
-	if (pmb->u.mb.mbxStatus)
-		goto out;
-
 	mempool_free(pmb, phba->mbox_mem_pool);
 
+	if (status)
+		goto out;
+
 	/* don't perform discovery for SLI4 loopback diagnostic test */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
 	    !(phba->hba_flag & HBA_FCOE_MODE) &&
@@ -1223,12 +1224,10 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 out:
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-			 "0306 CONFIG_LINK mbxStatus error x%x "
-			 "HBA state x%x\n",
-			 pmb->u.mb.mbxStatus, vport->port_state);
-sparam_out:
-	mempool_free(pmb, phba->mbox_mem_pool);
+			 "0306 CONFIG_LINK mbxStatus error x%x HBA state x%x\n",
+			 status, vport->port_state);
 
+sparam_out:
 	lpfc_linkdown(phba);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.27.0



