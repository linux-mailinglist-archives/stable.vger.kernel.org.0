Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACEA1AC688
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgDPOBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbgDPOBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88DF2078B;
        Thu, 16 Apr 2020 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045672;
        bh=94cz29se5LLA8ncjoWOVfAgIgJ6gJN3JLCLKs+vL0ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiLAI08Y2IIf99KMUXilBxJDQA7tfPuypOgI/7BK2wCc2LpB9gwfY7uPLeso366UN
         r0Q8sOo8Jzvngh0cyYUhpRwmvE2PxBJxcFezDmMJl2W9Xepw0/ZR9hdH7RTKoU+grB
         cK9t4oAwHWmcjNVTe1OVbC5FSh5CIvttQVDBCqAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 191/254] scsi: lpfc: Fix broken Credit Recovery after driver load
Date:   Thu, 16 Apr 2020 15:24:40 +0200
Message-Id: <20200416131350.178570156@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 835214f5d5f516a38069bc077c879c7da00d6108 upstream.

When driver is set to enable bb credit recovery, the switch displayed the
setting as inactive.  If the link bounces, it switches to Active.

During link up processing, the driver currently does a MBX_READ_SPARAM
followed by a MBX_CONFIG_LINK. These mbox commands are queued to be
executed, one at a time and the completion is processed by the worker
thread.  Since the MBX_READ_SPARAM is done BEFORE the MBX_CONFIG_LINK, the
BB_SC_N bit is never set the the returned values. BB Credit recovery status
only gets set after the driver requests the feature in CONFIG_LINK, which
is done after the link up. Thus the ordering of READ_SPARAM needs to follow
the CONFIG_LINK.

Fix by reordering so that READ_SPARAM is done after CONFIG_LINK.  Added a
HBA_DEFER_FLOGI flag so that any FLOGI handling waits until after the
READ_SPARAM is done so that the proper BB credit value is set in the FLOGI
payload.

Fixes: 6bfb16208298 ("scsi: lpfc: Fix configuration of BB credit recovery in service parameters")
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20200128002312.16346-4-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc.h         |    1 
 drivers/scsi/lpfc/lpfc_hbadisc.c |   59 +++++++++++++++++++++++++--------------
 2 files changed, 40 insertions(+), 20 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -749,6 +749,7 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
+#define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1163,13 +1163,16 @@ lpfc_mbx_cmpl_local_config_link(struct l
 	}
 
 	/* Start discovery by sending a FLOGI. port_state is identically
-	 * LPFC_FLOGI while waiting for FLOGI cmpl
+	 * LPFC_FLOGI while waiting for FLOGI cmpl. Check if sending
+	 * the FLOGI is being deferred till after MBX_READ_SPARAM completes.
 	 */
-	if (vport->port_state != LPFC_FLOGI)
-		lpfc_initial_flogi(vport);
-	else if (vport->fc_flag & FC_PT2PT)
-		lpfc_disc_start(vport);
-
+	if (vport->port_state != LPFC_FLOGI) {
+		if (!(phba->hba_flag & HBA_DEFER_FLOGI))
+			lpfc_initial_flogi(vport);
+	} else {
+		if (vport->fc_flag & FC_PT2PT)
+			lpfc_disc_start(vport);
+	}
 	return;
 
 out:
@@ -3094,6 +3097,14 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hb
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* Check if sending the FLOGI is being deferred to after we get
+	 * up to date CSPs from MBX_READ_SPARAM.
+	 */
+	if (phba->hba_flag & HBA_DEFER_FLOGI) {
+		lpfc_initial_flogi(vport);
+		phba->hba_flag &= ~HBA_DEFER_FLOGI;
+	}
 	return;
 
 out:
@@ -3224,6 +3235,23 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	}
 
 	lpfc_linkup(phba);
+	sparam_mbox = NULL;
+
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
+	}
+
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!sparam_mbox)
 		goto out;
@@ -3244,20 +3272,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		goto out;
 	}
 
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
-	} else {
+	if (phba->hba_flag & HBA_FCOE_MODE) {
 		vport->port_state = LPFC_VPORT_UNKNOWN;
 		/*
 		 * Add the driver's default FCF record at FCF index 0 now. This
@@ -3314,6 +3329,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
+	} else {
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
+		    !(phba->link_flag & LS_LOOPBACK_MODE))
+			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */


