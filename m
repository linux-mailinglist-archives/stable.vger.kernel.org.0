Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0110BE0F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbfK0UwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729887AbfK0UwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88BB121774;
        Wed, 27 Nov 2019 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887919;
        bh=Ip6hU7yXg9AcHOr9vr8JdMkTGx+/SfF3tqPyui4JfNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W00pJEVproSXbytRSm5bPbDzYqniyiGnhJZp/CdIwbw5p73GhZpWGpkgg9elgLl3z
         IPjvrGkmLUYVdIvc4yyO+EY/JXFe4mNfd8Echa++tgxLLF8vHG1Kku8StBwfrne4ZE
         WoyWZ9xbF42VBQT71CGx4d1HM6dfzb8LAZxUrSzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/211] scsi: lpfc: Correct loss of fc4 type on remote port address change
Date:   Wed, 27 Nov 2019 21:31:19 +0100
Message-Id: <20191127203107.814390844@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/scsi/lpfc/lpfc_els.c       | 26 +++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c |  5 +++--
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 95449f97101d3..e5db20e8979d5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1550,8 +1550,10 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	 */
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
+	/* return immediately if the WWPN matches ndlp */
 	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
 		return ndlp;
+
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
 						       GFP_KERNEL);
@@ -1560,9 +1562,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
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
@@ -1611,6 +1617,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
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
@@ -1732,6 +1746,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
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
index a0658d1582287..043bca6449cd0 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2829,8 +2829,9 @@ lpfc_disc_state_machine(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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



