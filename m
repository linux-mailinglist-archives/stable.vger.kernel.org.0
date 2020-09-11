Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4328026694E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgIKUCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 16:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgIKUB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 16:01:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38679C061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 13:01:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t7so2224278pjd.3
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYYXSMgbEBiquEkbfhvV5VJwd9+XhX8oh+NLUwmyPJ8=;
        b=PMeyXkkjMhNl5i05nbrES1dKGN3AI/CV7sxTHN2Rpb1+G/0IX2LPBr1BYWFiKSLTgF
         722ylEauaEeaqayrqD5XH4fqD6IMN4o4doYalKaT5HDMIQhs253LBNHe2ef+SAH1YPGR
         mXqAmONQ2/seQYyYtKvhGnySvEo6fGV+6h34s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYYXSMgbEBiquEkbfhvV5VJwd9+XhX8oh+NLUwmyPJ8=;
        b=q0NBsVbSf0iu6HJyHoQPau9injuzd+JWUZDNlpLfeA/KdKnBMhOhyJoD2G9QU6oopm
         dpyONkghRnDFTob89tiq1/SOlwZd1c98RcIU2RewV/TsnxvHsC/xfDm35gRq4YjucoFO
         oGM+RzGsU6j1vzm6wLSXkouHlfYjSo+Zvw7uM/6ebng6Y3kzWDtakovXCO3BujpWVAIj
         m0K945y1+i5G29YfhNTVYS9uzSPn96lps84F6bAdxdevbe0tqVX+ZA0mmxT/KmuUl1ok
         pzcOl13++OjiVXFNyx7xrLZ4eM8jS9oJrFKAwZcZFQQCC4jMhSDfpxXZhTY5IwyixK+N
         FJJg==
X-Gm-Message-State: AOAM531D15Inm4h12ImvzyDjHUsroFkYoBqwmQ7BF0sZpU1GYBGuWhzI
        920NzZZvH7cLb667C4rvbhT7Ng==
X-Google-Smtp-Source: ABdhPJywlhXz4+cecijANgXxvE+aGa7LVJiWMiUQxpV/HdFumX141HetRkJmcAjeLRMHz+X4oCA7pw==
X-Received: by 2002:a17:902:8d84:b029:d1:9bc8:258c with SMTP id v4-20020a1709028d84b02900d19bc8258cmr4138796plo.18.1599854518387;
        Fri, 11 Sep 2020 13:01:58 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s22sm3331442pfd.90.2020.09.11.13.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 13:01:56 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Fix initial FLOGI failure due to BBSCN not supported
Date:   Fri, 11 Sep 2020 13:01:47 -0700
Message-Id: <20200911200147.110826-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Initial FLOGIs are failing with the following message:
 lpfc 0000:13:00.1: 1:(0):0820 FLOGI Failed (x300). BBCredit Not Supported

In a prior patch, the READ_SPARAM command was re-ordered to post after
CONFIG_LINK as the driver is expected to update the driver's copy of
the service parameters for the FLOGI payload. if the bb-credit recovery
feature is enabled, this is fine. But on adapters were bb-credit recovery
isn't enabled, it would cause the FLOGI to fail.

Fix by restoring the original command order (READ_SPARAM before
CONFIG_LINK), and after issuing CONFIG_LINK, detect bb-credit recovery
support and reissuing READ_SPARAM to obtain the updated service parameters
(effectively adding in the fix command order).

Fixes: 692fc8380ca0 ("scsi: lpfc: Fix broken Credit Recovery after driver load")
CC: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 76 ++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 142a02114479..bf06d8549bd3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -71,6 +71,7 @@ static void lpfc_disc_timeout_handler(struct lpfc_vport *);
 static void lpfc_disc_flush_list(struct lpfc_vport *vport);
 static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
+static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -1138,11 +1139,13 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -1167,12 +1170,42 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
@@ -1184,6 +1217,7 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 "0306 CONFIG_LINK mbxStatus error x%x "
 			 "HBA state x%x\n",
 			 pmb->u.mb.mbxStatus, vport->port_state);
+sparam_out:
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	lpfc_linkdown(phba);
@@ -3239,21 +3273,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
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
@@ -3274,7 +3293,20 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
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
@@ -3331,10 +3363,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
-	} else {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
-		    !(phba->link_flag & LS_LOOPBACK_MODE))
-			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */
-- 
2.26.2

