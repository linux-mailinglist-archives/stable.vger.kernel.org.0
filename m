Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D730F49DF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfKHMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732783AbfKHLl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7902F222C6;
        Fri,  8 Nov 2019 11:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213287;
        bh=b90uXpMLnXRJMerP3Cb6DgNgXJP5ikB+ykae6gNjThE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0TNswMHZbUUY/CJ3Ui1ZIS2nC+gK8gz5a3kPDzuozzWFEFMjkhOux/rsWOXq6hEZ
         i3GUl7zjZ3ewgfRF3/lyZYG7JLewrAut8E9ASbwOgCkTXinlHqVYdEHBNxIwqOjE6/
         Bg0kELJLi/ZqrCXHLjI6zksDzKwY/yObNRexzQZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 147/205] scsi: lpfc: Fix GFT_ID and PRLI logic for RSCN
Date:   Fri,  8 Nov 2019 06:36:54 -0500
Message-Id: <20191108113752.12502-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a6619fd8238c1..394ffbe9cb6d7 100644
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

