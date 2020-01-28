Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6A214AD22
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 01:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgA1AXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 19:23:32 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56025 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 19:23:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so590779wmj.5;
        Mon, 27 Jan 2020 16:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QMOXMCbSyvr06qT9HdUn84didr31n2GxaHyd15OfwlQ=;
        b=iJNvvOxXctMrNeTJ5+kwi1uLZ3pxvgvZTbKSf6PzOKTuCM9JDT//fmPh9TIop04FGI
         uR7/p6DeI/dOWtCY8B/4L5y4zbfsXGhBq+glhpHjGhKkUEUmNAgZN8gZY7MGjgnQyBrG
         TNSsVyuZ60STbwFL9oaJ1OpjSC/JYzRHzRpf8gr/Czn2smGK2vZ4zI004UEmnRwbB9st
         /zauuEKPpTdWxD2mcEW19aPaddDS9UDj7srV4xGQcO8nrz9YlgDFmxMUqakLwE4vRmPg
         HDks2nQIV5sBKOpEwsB/r7JR8Jf5ByaWj2oTfnj57AmNAnerSj+aCio7vRZLfdKgh3lT
         0qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QMOXMCbSyvr06qT9HdUn84didr31n2GxaHyd15OfwlQ=;
        b=SZvDVXLGe59JRebii7OPFPtApZyWo+dr7qlv2qIjxoJW54WHUxc+1ZxK2s+CKC5PzU
         lkElDZaeYNt1S6sm+5a8Y3kEAAlEscglZw0/La9biHPBFh8yH7W3KTRWz04PUes5Sny6
         hX+efjcF+E1jMj2bfR3Yzdxo+ty9A5JLXNDzFpNGHeBhNV2uhz1AnHtF3/zu5gCiKmny
         dgqX03hMV922HkcdxqpwcuvF0effEjOZHdwSqRELH9IoB0pxJRHMFbIjsE5cb77v6YgN
         ad97+NWWxxpyB1+Ld5h/UdNaSx3dAUQ9+GH9L+x8ORuoI/TdXwZLOT4vo3DmFrxbmLm4
         Mjag==
X-Gm-Message-State: APjAAAU8jMSHd6/L5tn5eIw3m4G9vY8w17zvMAVKKZqQjXxtU8MssfxX
        f8Ma4o/iil+jf2Z1CogjPXuW2+8w
X-Google-Smtp-Source: APXvYqxIqksR/PwHnXuBnNa/zguEE0JgobbHTVj93Z/ht+I+iCA6j3fYAdxk2WGGlaRmWaKYJjW+5A==
X-Received: by 2002:a7b:cd86:: with SMTP id y6mr1312039wmj.5.1580171008003;
        Mon, 27 Jan 2020 16:23:28 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:27 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/12] lpfc: Fix broken Credit Recovery after driver load
Date:   Mon, 27 Jan 2020 16:23:03 -0800
Message-Id: <20200128002312.16346-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When driver is set to enable bb credit recovery, the switch displayed
the setting as inactive.  If the link bounces, it switches to Active.

During link up processing, the driver currently does a MBX_READ_SPARAM
followed by a MBX_CONFIG_LINK. These mbox commands are queued to be
executed, one at a time and the completion is processed by the worker
thread.  Since the MBX_READ_SPARAM is done BEFORE the MBX_CONFIG_LINK,
the BB_SC_N bit is never set the the returned values. BB Credit recovery
status only gets set after the driver requests the feature in
CONFIG_LINK, which is done after the link up. Thus the ordering of
READ_SPARAM needs to follow the CONFIG_LINK.

Fix by reordering so that READ_SPARAM is done after CONFIG_LINK.
Added a HBA_DEFER_FLOGI flag so that any FLOGI handling waits until
after the READ_SPARAM is done so that the proper BB credit value is
set in the FLOGI payload.

Fixes: 6bfb16208298 ("scsi: lpfc: Fix configuration of BB credit recovery in service parameters")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c | 59 ++++++++++++++++++++++++++--------------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 04d73e2be373..3f2cb17c4574 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -749,6 +749,7 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
+#define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index dcc8999c6a68..6a2bdae0e52a 100644
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
2.13.7

