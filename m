Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5020A3C55E4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbhGLIMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354024AbhGLIDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1097160241;
        Mon, 12 Jul 2021 07:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076773;
        bh=5v5D2miKnQEouNl2yw0dyhYbXP93u5ncEFONRKx9NXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKdq+epRIsn0eVN04cefk2eDaRdXjDeT5L+QuXh/54V22WOXEhMAOggBZgRJauIno
         mrx9PrkiS+b74gy5zZIY3skZEPdc49+HoxTm4I/xReQI4HzrnabFIgGSIdT+anaVrw
         6QRHaimceOpyo5pqXlFyt4zdz3GumOOPOOlUvNyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 786/800] scsi: lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
Date:   Mon, 12 Jul 2021 08:13:29 +0200
Message-Id: <20210712061050.449257694@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 4012baeab6ca22b7f7beb121b6d0da0a62942fdd upstream.

When lpfc is handling a solicited and unsolicited PLOGI with another
initiator, the remote initiator is never recovered. The node for the
initiator is erroneouosly removed and all resources released.

In lpfc_cmpl_els_plogi(), when lpfc_els_retry() returns a failure code, the
driver is calling the state machine with a device remove event because the
remote port is not currently registered with the SCSI or NVMe
transports. The issue is that on a PLOGI "collision" the driver correctly
aborts the solicited PLOGI and allows the unsolicited PLOGI to complete the
process, but this process is interrupted with a device_rm event.

Introduce logic in the PLOGI completion to capture the PLOGI collision
event and jump out of the routine.  This will avoid removal of the node.
If there is no collision, the normal node removal will occur.

Fixes: 	52edb2caf675 ("scsi: lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails")
Cc: <stable@vger.kernel.org> # v5.11+
Link: https://lore.kernel.org/r/20210514195559.119853-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_els.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1998,9 +1998,20 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
-		/* As long as this node is not registered with the scsi or nvme
-		 * transport, it is no longer an active node.  Otherwise
-		 * devloss handles the final cleanup.
+		/* If a PLOGI collision occurred, the node needs to continue
+		 * with the reglogin process.
+		 */
+		spin_lock_irq(&ndlp->lock);
+		if ((ndlp->nlp_flag & (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI)) &&
+		    ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE) {
+			spin_unlock_irq(&ndlp->lock);
+			goto out;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		/* No PLOGI collision and the node is not registered with the
+		 * scsi or nvme transport. It is no longer an active node. Just
+		 * start the device remove process.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 			spin_lock_irq(&ndlp->lock);
@@ -4620,6 +4631,10 @@ out:
 	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
 	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
 		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_drop_node(vport, ndlp);
 	}
 


