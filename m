Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B088E10143A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfKSFbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbfKSFbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A409321939;
        Tue, 19 Nov 2019 05:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141495;
        bh=gyovKEJDIxFAEIjb17nh3x7/Yg6QmLy7lLSCyOMePiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN8lCv28dg0zabcJOvQiLJa91kDpZvJ9yTBAh5i/v50xUWYtUeppI+XmxgPwLI1mg
         VbI0232Qluh/5uw1h80LTeg5KZLDtcLYfRp1iBznNm1wjtyka8e1LFz+8v7ZUKgI09
         TNQmJwN/x5Le/ps7AckcvMyuawnt0zbIWPBP37LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/422] scsi: lpfc: Fix GFT_ID and PRLI logic for RSCN
Date:   Tue, 19 Nov 2019 06:16:15 +0100
Message-Id: <20191119051409.978098883@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 01a8aed6a009625282b6265880f6b20cbd7a9c70 ]

Driver only sends NVME PRLI to a device that also supports FCP.  This resuls
in remote ports that don't have fc_remote_ports created for them. The driver
is clearing the nlp_fc4_type for a ndlp at the wrong time.

Fix by moving the nlp_fc4_type clearing to the discovery engine in the
DEVICE_RECOVERY state. Also ensure that rport registration is done for all
nlp_fc4_types.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c        | 5 -----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 3 +++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index d909d90035bb2..384f5cd7c3c81 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -471,11 +471,6 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 				"Parse GID_FTrsp: did:x%x flg:x%x x%x",
 				Did, ndlp->nlp_flag, vport->fc_flag);
 
-			/* Don't assume the rport is always the previous
-			 * FC4 type.
-			 */
-			ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
-
 			/* By default, the driver expects to support FCP FC4 */
 			if (fc4_type == FC_TYPE_FCP)
 				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ccdd82b1123f7..db183d1f34ab2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4198,7 +4198,7 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (new_state ==  NLP_STE_MAPPED_NODE ||
 	    new_state == NLP_STE_UNMAPPED_NODE) {
-		if (ndlp->nlp_fc4_type & NLP_FC4_FCP ||
+		if (ndlp->nlp_fc4_type ||
 		    ndlp->nlp_DID == Fabric_DID ||
 		    ndlp->nlp_DID == NameServer_DID ||
 		    ndlp->nlp_DID == FDMI_DID) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ae6301c796785..c15f3265eefeb 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2323,6 +2323,7 @@ lpfc_device_recov_unmap_node(struct lpfc_vport *vport,
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
+	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 
@@ -2400,6 +2401,7 @@ lpfc_device_recov_mapped_node(struct lpfc_vport *vport,
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
+	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
 	spin_unlock_irq(shost->host_lock);
 	lpfc_disc_set_adisc(vport, ndlp);
 	return ndlp->nlp_state;
@@ -2657,6 +2659,7 @@ lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
+	ndlp->nlp_fc4_type &= ~(NLP_FC4_FCP | NLP_FC4_NVME);
 	spin_unlock_irq(shost->host_lock);
 	return ndlp->nlp_state;
 }
-- 
2.20.1



