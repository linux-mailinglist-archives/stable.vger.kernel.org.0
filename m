Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C107A1AC850
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgDPPGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408817AbgDPNwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563882063A;
        Thu, 16 Apr 2020 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045121;
        bh=hDL60ZE/KPb1rBhVBfw2gW9qxX0LLGCOEybMnmAnzYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl/Gf4uk4I9ODaau6hXmX1HWwKSz1ZRz5M6DzCPgmliIasuZHtBAwCYibVMRe1Ivo
         T8z4Vk6ZFlJ6CUEaNV8H3bdT7gavWaI/wA6UZWV6CjqU5NrG7fJTik+H8kr/DeFNs2
         94Tmt0ue+I+fUAR0T+sHtG+0DO97aEqK84/f3f00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/232] scsi: lpfc: Fix broken Credit Recovery after driver load
Date:   Thu, 16 Apr 2020 15:25:19 +0200
Message-Id: <20200416131343.655236486@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 835214f5d5f516a38069bc077c879c7da00d6108 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c | 59 +++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e492ca2d0b8be..8943d42fc406e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -742,6 +742,7 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
+#define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3f7df471106e9..799db8a785c21 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1163,13 +1163,16 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -3094,6 +3097,14 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -3224,6 +3235,23 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
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
@@ -3244,20 +3272,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
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
@@ -3314,6 +3329,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
+	} else {
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
+		    !(phba->link_flag & LS_LOOPBACK_MODE))
+			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */
-- 
2.20.1



