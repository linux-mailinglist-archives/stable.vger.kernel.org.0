Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55A227C799
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgI2LpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgI2LpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19453206F7;
        Tue, 29 Sep 2020 11:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379906;
        bh=aIWFsTayFUhKqrCsf4H3+ezdQTHwjkKAY/nmD9936E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tb26Ci3Ra0fto13bnzE+xdvb/Whsl6o0BwtuekwnKMAp/fA91btvYj/UFYY+DbVA1
         x3C8zP4Zm9/HB+heSZ9N/MxkrNUAYv9nkeO6D0Nfn17+KU6nsYMXlgQAEiOlOfS4jw
         tYoR0g3ZPy++xXoRCX+IruKjflJDwzoIbeR+vI/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 369/388] scsi: lpfc: Fix initial FLOGI failure due to BBSCN not supported
Date:   Tue, 29 Sep 2020 13:01:40 +0200
Message-Id: <20200929110028.328001972@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit 7f04839ec4483563f38062b4dd90253e45447198 upstream.

Initial FLOGIs are failing with the following message:

 lpfc 0000:13:00.1: 1:(0):0820 FLOGI Failed (x300). BBCredit Not Supported

In a prior patch, the READ_SPARAM command was re-ordered to post after
CONFIG_LINK as the driver is expected to update the driver's copy of the
service parameters for the FLOGI payload. If the bb-credit recovery feature
is enabled, this is fine. But on adapters were bb-credit recovery isn't
enabled, it would cause the FLOGI to fail.

Fix by restoring the original command order (READ_SPARAM before
CONFIG_LINK), and after issuing CONFIG_LINK, detect bb-credit recovery
support and reissuing READ_SPARAM to obtain the updated service parameters
(effectively adding in the fix command order).

[mkp: corrected SHA]

Link: https://lore.kernel.org/r/20200911200147.110826-1-james.smart@broadcom.com
Fixes: 835214f5d5f5 ("scsi: lpfc: Fix broken Credit Recovery after driver load")
CC: <stable@vger.kernel.org> # v5.7+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_hbadisc.c |   76 ++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 24 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -73,6 +73,7 @@ static void lpfc_disc_timeout_handler(st
 static void lpfc_disc_flush_list(struct lpfc_vport *vport);
 static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
+static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -1134,11 +1135,13 @@ out:
 	return;
 }
 
-
 void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
+	LPFC_MBOXQ_t *sparam_mb;
+	struct lpfc_dmabuf *sparam_mp;
+	int rc;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1163,12 +1166,42 @@ lpfc_mbx_cmpl_local_config_link(struct l
 	}
 
 	/* Start discovery by sending a FLOGI. port_state is identically
-	 * LPFC_FLOGI while waiting for FLOGI cmpl. Check if sending
-	 * the FLOGI is being deferred till after MBX_READ_SPARAM completes.
+	 * LPFC_FLOGI while waiting for FLOGI cmpl.
 	 */
 	if (vport->port_state != LPFC_FLOGI) {
-		if (!(phba->hba_flag & HBA_DEFER_FLOGI))
+		/* Issue MBX_READ_SPARAM to update CSPs before FLOGI if
+		 * bb-credit recovery is in place.
+		 */
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
+		    !(phba->link_flag & LS_LOOPBACK_MODE)) {
+			sparam_mb = mempool_alloc(phba->mbox_mem_pool,
+						  GFP_KERNEL);
+			if (!sparam_mb)
+				goto sparam_out;
+
+			rc = lpfc_read_sparam(phba, sparam_mb, 0);
+			if (rc) {
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+			sparam_mb->vport = vport;
+			sparam_mb->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
+			rc = lpfc_sli_issue_mbox(phba, sparam_mb, MBX_NOWAIT);
+			if (rc == MBX_NOT_FINISHED) {
+				sparam_mp = (struct lpfc_dmabuf *)
+						sparam_mb->ctx_buf;
+				lpfc_mbuf_free(phba, sparam_mp->virt,
+					       sparam_mp->phys);
+				kfree(sparam_mp);
+				sparam_mb->ctx_buf = NULL;
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+
+			phba->hba_flag |= HBA_DEFER_FLOGI;
+		}  else {
 			lpfc_initial_flogi(vport);
+		}
 	} else {
 		if (vport->fc_flag & FC_PT2PT)
 			lpfc_disc_start(vport);
@@ -1180,6 +1213,7 @@ out:
 			 "0306 CONFIG_LINK mbxStatus error x%x "
 			 "HBA state x%x\n",
 			 pmb->u.mb.mbxStatus, vport->port_state);
+sparam_out:
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	lpfc_linkdown(phba);
@@ -3237,21 +3271,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	lpfc_linkup(phba);
 	sparam_mbox = NULL;
 
-	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (!cfglink_mbox)
-			goto out;
-		vport->port_state = LPFC_LOCAL_CFG_LINK;
-		lpfc_config_link(phba, cfglink_mbox);
-		cfglink_mbox->vport = vport;
-		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
-			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
-			goto out;
-		}
-	}
-
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!sparam_mbox)
 		goto out;
@@ -3272,7 +3291,20 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		goto out;
 	}
 
-	if (phba->hba_flag & HBA_FCOE_MODE) {
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!cfglink_mbox)
+			goto out;
+		vport->port_state = LPFC_LOCAL_CFG_LINK;
+		lpfc_config_link(phba, cfglink_mbox);
+		cfglink_mbox->vport = vport;
+		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
+		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+			goto out;
+		}
+	} else {
 		vport->port_state = LPFC_VPORT_UNKNOWN;
 		/*
 		 * Add the driver's default FCF record at FCF index 0 now. This
@@ -3329,10 +3361,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
-	} else {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
-		    !(phba->link_flag & LS_LOOPBACK_MODE))
-			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */


