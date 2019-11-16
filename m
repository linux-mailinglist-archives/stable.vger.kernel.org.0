Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C874CFF221
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfKPQRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbfKPPqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:50 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4532081E;
        Sat, 16 Nov 2019 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919209;
        bh=qO9MfmesJuaNT05xFsTSSd6cDJaB/XiUkjqx41nGQTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4OHsI88S3x1rvy1FDtbDGrCa4lrbSwuE2HTcEr0hKbXpT9IzSuQGLnXAMwxm9s7q
         aP2DXslPghlMbSX6YEG6dYaQuu0eecU3Rb25BKDBP9+Dmkb9qC7zXfJNjA5suCJNWz
         1+AjcDUlOLDXzFUg0RLcH500MSwhQ9R26MZaWWW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 214/237] scsi: lpfc: Correct loss of fc4 type on remote port address change
Date:   Sat, 16 Nov 2019 10:40:49 -0500
Message-Id: <20191116154113.7417-214-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d83ca3ea833d7a66d49225e4191c4e37cab8f079 ]

An address change for a remote port cause PRLI for the wrong protocol
to be sent.  The node copy done in the discovery code skipped copying
the fc4 protocols supported as well.

Fix the copy logic for the address change.  Beefed up log messages in
this area as well.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 27 +++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  5 +++--
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e263a486b1c6c..222fa9b7f4788 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1556,8 +1556,10 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	 */
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
+	/* return immediately if the WWPN matches ndlp */
 	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
 		return ndlp;
+
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
 						       GFP_KERNEL);
@@ -1566,9 +1568,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			       phba->cfg_rrq_xri_bitmap_sz);
 	}
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-		 "3178 PLOGI confirm: ndlp %p x%x: new_ndlp %p\n",
-		 ndlp, ndlp->nlp_DID, new_ndlp);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_NODE,
+			 "3178 PLOGI confirm: ndlp x%x x%x x%x: "
+			 "new_ndlp x%x x%x x%x\n",
+			 ndlp->nlp_DID, ndlp->nlp_flag,  ndlp->nlp_fc4_type,
+			 (new_ndlp ? new_ndlp->nlp_DID : 0),
+			 (new_ndlp ? new_ndlp->nlp_flag : 0),
+			 (new_ndlp ? new_ndlp->nlp_fc4_type : 0));
 
 	if (!new_ndlp) {
 		rc = memcmp(&ndlp->nlp_portname, name,
@@ -1617,6 +1623,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			       phba->cfg_rrq_xri_bitmap_sz);
 	}
 
+	/* At this point in this routine, we know new_ndlp will be
+	 * returned. however, any previous GID_FTs that were done
+	 * would have updated nlp_fc4_type in ndlp, so we must ensure
+	 * new_ndlp has the right value.
+	 */
+	if (vport->fc_flag & FC_FABRIC)
+		new_ndlp->nlp_fc4_type = ndlp->nlp_fc4_type;
+
 	lpfc_unreg_rpi(vport, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
 	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
@@ -1666,7 +1680,6 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		if (ndlp->nrport) {
 			ndlp->nrport = NULL;
 			lpfc_nlp_put(ndlp);
-			new_ndlp->nlp_fc4_type = ndlp->nlp_fc4_type;
 		}
 
 		/* We shall actually free the ndlp with both nlp_DID and
@@ -1740,6 +1753,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	    active_rrqs_xri_bitmap)
 		mempool_free(active_rrqs_xri_bitmap,
 			     phba->active_rrq_pool);
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_NODE,
+			 "3173 PLOGI confirm exit: new_ndlp x%x x%x x%x\n",
+			 new_ndlp->nlp_DID, new_ndlp->nlp_flag,
+			 new_ndlp->nlp_fc4_type);
+
 	return new_ndlp;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ae6301c796785..f72a0d628bd3d 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2865,8 +2865,9 @@ lpfc_disc_state_machine(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* DSM in event <evt> on NPort <nlp_DID> in state <cur_state> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0211 DSM in event x%x on NPort x%x in "
-			 "state %d Data: x%x\n",
-			 evt, ndlp->nlp_DID, cur_state, ndlp->nlp_flag);
+			 "state %d Data: x%x x%x\n",
+			 evt, ndlp->nlp_DID, cur_state,
+			 ndlp->nlp_flag, ndlp->nlp_fc4_type);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
 		 "DSM in:          evt:%d ste:%d did:x%x",
-- 
2.20.1

