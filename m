Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24CD452249
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377423AbhKPBKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245149AbhKOTTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE34632CF;
        Mon, 15 Nov 2021 18:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000967;
        bh=tQ7qWPEVOEg4kiVcmn9b+VfEVYGmGzhnhWvEBl+gq0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuUZX9JBJ4u0kuWOw+dR8uoXNOvuK4827jDIyZYk8+yJ+6bos7sGIBbMqBQ1Xoy46
         X/zO+cK7NneUsPBhRZNke+n60SXSAG5G90RtzcwvJfTvwsCGiTp1714HGhr7IbbcdV
         lT66C+xOOABEdsYYG5Io1bvRygHs2hWS9cyw6Onk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 011/917] scsi: lpfc: Dont release final kref on Fport node while ABTS outstanding
Date:   Mon, 15 Nov 2021 17:51:46 +0100
Message-Id: <20211115165429.109842172@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 982fc3965d1350d3332e04046b0e101006184ba9 upstream.

In a rarely executed path, FLOGI failure, there is a refcounting error.  If
FLOGI completed with an error, typically a timeout, the initial completion
handler would remove the job reference. However, the job completion isn't
the actual end of the job/exchange as the timeout usually initiates an
ABTS, and upon that ABTS completion, a final completion is sent. The driver
removes the reference again in the final completion. Thus the imbalance.

In the buggy cases, if there was a link bounce while the delayed response
is outstanding, the fport node may be referenced again but there was no
additional reference as it is already present. The delayed completion then
occurs and removes the last reference freeing the node and causing issues
in the link up processed that is using the node.

Fix this scenario by removing the snippet that removed the reference in the
initial FLOGI completion. The bad snippet was poorly trying to identify the
FLOGI as OK to do so by realizing the node was not registered with either
SCSI or NVMe transport.

Link: https://lore.kernel.org/r/20210910233159.115896-3-jsmart2021@gmail.com
Fixes: 618e2ee146d4 ("scsi: lpfc: Fix FLOGI failure due to accessing a freed node")
Cc: <stable@vger.kernel.org> # v5.13+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_els.c     |   11 +++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c |   10 ++++++----
 drivers/scsi/lpfc/lpfc_nvme.c    |    5 +++--
 3 files changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1059,9 +1059,10 @@ stop_rr_fcf_flogi:
 
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
@@ -1122,12 +1123,12 @@ stop_rr_fcf_flogi:
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
@@ -1205,8 +1206,6 @@ flogifail:
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
-		lpfc_nlp_put(ndlp);
 	if (!lpfc_error_lost_link(irsp)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4449,8 +4449,9 @@ lpfc_register_remote_port(struct lpfc_vp
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3183 %s rport x%px DID x%x, role x%x\n",
-			 __func__, rport, rport->port_id, rport->roles);
+			 "3183 %s rport x%px DID x%x, role x%x refcnt %d\n",
+			 __func__, rport, rport->port_id, rport->roles,
+			 kref_read(&ndlp->kref));
 
 	if ((rport->scsi_target_id != -1) &&
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
@@ -4475,8 +4476,9 @@ lpfc_unregister_remote_port(struct lpfc_
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "3184 rport unregister x%06x, rport x%px "
-			 "xptflg x%x\n",
-			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags);
+			 "xptflg x%x refcnt %d\n",
+			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
+			 kref_read(&ndlp->kref));
 
 	fc_remote_port_delete(rport);
 	lpfc_nlp_put(ndlp);
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -209,8 +209,9 @@ lpfc_nvme_remoteport_delete(struct nvme_
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


