Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694F63C5097
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbhGLHdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344820AbhGLH3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC0261457;
        Mon, 12 Jul 2021 07:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074752;
        bh=EYGa0PkifKMKbP5yFImhOHHpGqbUZ+0I7gUgSrrc6H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCl4ffkC4N/2P1JpFcpqUhx2WVI389K70v+bnKQaq1BFtyQ5qgvg4hHgfHFn75Caw
         wzI1NfkV+hZISwjAS1fC+CjpTlICSQ8OgY1s0vxyufkrt4b0CAs5XhLPx6BSKxFaK8
         qPcSknB8dXsWQI4OPKHYneHJnDRT4Z28UDvZeWUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 686/700] scsi: lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
Date:   Mon, 12 Jul 2021 08:12:49 +0200
Message-Id: <20210712061048.923585489@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
@@ -1985,9 +1985,20 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
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
@@ -4612,6 +4623,10 @@ out:
 	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
 	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
 		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_drop_node(vport, ndlp);
 	}
 


