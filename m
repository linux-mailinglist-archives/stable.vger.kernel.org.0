Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245884073E2
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 01:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhIJXdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbhIJXdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 19:33:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D5C061574;
        Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id dw14so1492496pjb.1;
        Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uNt0QAxuKO6+FYL7vNETK+bdI7sWgzN3S59lbqChJtc=;
        b=lcx2UnmquHfH3ywNLVF34isiqgeMqqpjdbgYEak5/bS/b0YcTT5JLK3ZSeg+vK89lK
         IpOXdGjD1CtfviBroZ2MSX7OhWyyg2nUUNbr0amghI2gN+D9MlqqoLTsTl4dQRSuUhD0
         8IQx6eQfgq+CuSmjV5GyP8qwPwTlaXrvNvT9FmjnCXoLrkh5rpZ8m6YeMt0LAX42M+bq
         JwAoUjvcsuvz8xdPgSouLjlLfjZPG2he7Kz3jsGsx2zf2uS1jD2yvWVrz1if19tNFREF
         mCKBit7q8CWrcB/nNh8IzZw8xS/JLPa08RyAQDitnBim9Y5Cc84aUFGa/6SWlfZLA8pk
         fVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uNt0QAxuKO6+FYL7vNETK+bdI7sWgzN3S59lbqChJtc=;
        b=3U7CeFJ7sBavGS0w+sR0/r76jAFMwXa5OGCw4As4q9IeKtBcjtGX73/eI7+5hU2ffh
         exxdXqucis5Rmmb+3BanJXAMZeAxh+ZyGxdC40eiT70AkYB0RO1PpjWbJetW48bhx2Yn
         +vORR4DbfC4D9eomRN0SSIwqRfOXYW/oofx5NFk8CsdgqMFUBPw9/LQN+CfYioJwzHdQ
         Va/eYgbJeUTgI9pqaF00HNSoU4XbExNFb3LwasgI7gq0n/tTJ37rtt/ytPR7P/qIGEr8
         XoeIrLLCN9o5HUbsl1oSxTOrgiBQFVKF0iXEWSo9rVoqM3D+g6snEwcv4fMJargHDOc5
         ZC1A==
X-Gm-Message-State: AOAM530Vie2uR4J7Ut2BJZtnRnVP940pvP4FBg/7rng+1V0h4pUWiJo7
        BHz463289Z/tPHCXIMatHXlx1QNWavaStV4r
X-Google-Smtp-Source: ABdhPJyKVTQpRmHNQ6eD/rUxxDXSgW3HSQzloNtA0zUSUuO+6VE7pcYlbIRSawMmCzVTnwyQnnrV7A==
X-Received: by 2002:a17:90b:3a8e:: with SMTP id om14mr147644pjb.192.1631316729039;
        Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/14] lpfc: Don't release final kref on Fport node while ABTS outstanding
Date:   Fri, 10 Sep 2021 16:31:47 -0700
Message-Id: <20210910233159.115896-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In a rarely executed path, FLOGI failure, there is a refcounting error.
If FLOGI completed with an error, typically a timeout, the initial
completion handler would remove the job reference. However, the job
completion isn't the actual end of the job/exchange as the timeout
usually initiates an ABTS, and upon that ABTS completion, a final
completion is sent. The driver removes the reference again in the
final completion. Thus the imbalance.

In the buggy cases, if there was a link bounce while the delayed
response is outstanding, the fport node may be referenced again
but there was no additional reference as it is already present. The
delayed completion then occurs and removes the last reference freeing
the node and causing issues in the link up processed that is using the
node.

Fix this scenario by removing the snippet that removed the reference
in the initial flogi completion. The bad snippet was poorly trying to
identify the flogi as ok to do so by realizing the node was not
registered with either SCSI or NVME transport.

Fixes: 618e2ee146d4 ("scsi: lpfc: Fix FLOGI failure due to accessing a freed node")
Cc: <stable@vger.kernel.org> # v5.13+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 11 +++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 10 ++++++----
 drivers/scsi/lpfc/lpfc_nvme.c    |  5 +++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1254a575fd47..df5fc223ddb2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1059,9 +1059,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_TRACE_EVENT,
 				 "0150 FLOGI failure Status:x%x/x%x "
-				 "xri x%x TMO:x%x\n",
+				 "xri x%x TMO:x%x refcnt %d\n",
 				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 cmdiocb->sli4_xritag, irsp->ulpTimeout);
+				 cmdiocb->sli4_xritag, irsp->ulpTimeout,
+				 kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
 		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
@@ -1122,12 +1123,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0101 FLOGI completes successfully, I/O tag:x%x, "
-			 "xri x%x Data: x%x x%x x%x x%x x%x x%x x%x\n",
+			 "xri x%x Data: x%x x%x x%x x%x x%x x%x x%x %d\n",
 			 cmdiocb->iotag, cmdiocb->sli4_xritag,
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution,
 			 vport->port_state, vport->fc_flag,
-			 sp->cmn.priority_tagging);
+			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
 	if (sp->cmn.priority_tagging)
 		vport->vmid_flag |= LPFC_VMID_ISSUE_QFPA;
@@ -1205,8 +1206,6 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
-		lpfc_nlp_put(ndlp);
 	if (!lpfc_error_lost_link(irsp)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7195ca0275f9..6f2e07c30f98 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4449,8 +4449,9 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3183 %s rport x%px DID x%x, role x%x\n",
-			 __func__, rport, rport->port_id, rport->roles);
+			 "3183 %s rport x%px DID x%x, role x%x refcnt %d\n",
+			 __func__, rport, rport->port_id, rport->roles,
+			 kref_read(&ndlp->kref));
 
 	if ((rport->scsi_target_id != -1) &&
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
@@ -4475,8 +4476,9 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "3184 rport unregister x%06x, rport x%px "
-			 "xptflg x%x\n",
-			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags);
+			 "xptflg x%x refcnt %d\n",
+			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
+			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
 	lpfc_nlp_put(ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 73a3568ff17e..bd88477f9b82 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -209,8 +209,9 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	 * calling state machine to remove the node.
 	 */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			"6146 remoteport delete of remoteport x%px\n",
-			remoteport);
+			 "6146 remoteport delete of remoteport x%px, ndlp x%px "
+			 "DID x%x xflags x%x\n",
+			 remoteport, ndlp, ndlp->nlp_DID, ndlp->fc4_xpt_flags);
 	spin_lock_irq(&ndlp->lock);
 
 	/* The register rebind might have occurred before the delete
-- 
2.26.2

