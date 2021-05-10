Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C923788B8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhEJLXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237181AbhEJLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64A486191D;
        Mon, 10 May 2021 11:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644866;
        bh=P5Vuo367urhk92Inb82RHvFIqce4ht1NRWrwdnpRAcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKvElPlMbSxhCWVAP039uuBAjmhvA+rN8wd6TiUn7NUm+uUBHCCQ4bQR9Iicp/I1P
         I6H1K89OOJz8vsX66yddjnUwMV7qEEXOxU/1VgmEmyQLFiRo88JIYjT5xDtwXTWUQ1
         hIfmvDvG00yI918ALhVi90nM/nIiufUYPZfDekWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 255/384] scsi: lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
Date:   Mon, 10 May 2021 12:20:44 +0200
Message-Id: <20210510102023.281491117@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit f866eb06c087125619457b53e9211a9e758f64f7 ]

Call traces are being seen that result from a nodelist structure ref
counting error. They are typically seen after transmission of an LS_RJT ELS
response.

Aged code in lpfc_cmpl_els_rsp() calls lpfc_nlp_not_used() which, if the
ndlp reference count is exactly 1, will decrement the reference count.
Previously lpfc_nlp_put() was within lpfc_els_free_iocb(), and the 'put'
within the free would only be invoked if cmdiocb->context1 was not NULL.
Since the nodelist structure reference count is decremented when exiting
lpfc_cmpl_els_rsp() the lpfc_nlp_not_used() calls are no longer required.
Calling them is causing the reference count issue.

Fix by removing the lpfc_nlp_not_used() calls.

Link: https://lore.kernel.org/r/20210412013127.2387-4-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 64 +-----------------------------------
 1 file changed, 1 insertion(+), 63 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 04c002eea446..fd18ac2acc13 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4454,10 +4454,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
  * nlp_flag bitmap in the ndlp data structure, if the mbox command reference
  * field in the command IOCB is not NULL, the referred mailbox command will
  * be send out, and then invokes the lpfc_els_free_iocb() routine to release
- * the IOCB. Under error conditions, such as when a LS_RJT is returned or a
- * link down event occurred during the discovery, the lpfc_nlp_not_used()
- * routine shall be invoked trying to release the ndlp if no other threads
- * are currently referring it.
+ * the IOCB.
  **/
 static void
 lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -4467,10 +4464,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = ndlp ? ndlp->vport : NULL;
 	struct Scsi_Host  *shost = vport ? lpfc_shost_from_vport(vport) : NULL;
 	IOCB_t  *irsp;
-	uint8_t *pcmd;
 	LPFC_MBOXQ_t *mbox = NULL;
 	struct lpfc_dmabuf *mp = NULL;
-	uint32_t ls_rjt = 0;
 
 	irsp = &rspiocb->iocb;
 
@@ -4482,18 +4477,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (cmdiocb->context_un.mbox)
 		mbox = cmdiocb->context_un.mbox;
 
-	/* First determine if this is a LS_RJT cmpl. Note, this callback
-	 * function can have cmdiocb->contest1 (ndlp) field set to NULL.
-	 */
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
-	if (ndlp && (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
-		/* A LS_RJT associated with Default RPI cleanup has its own
-		 * separate code path.
-		 */
-		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			ls_rjt = 1;
-	}
-
 	/* Check to see if link went down during discovery */
 	if (!ndlp || lpfc_els_chk_latt(vport)) {
 		if (mbox) {
@@ -4504,15 +4487,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
-		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate the node has already released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
 		goto out;
 	}
 
@@ -4590,29 +4564,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				"Data: x%x x%x x%x\n",
 				ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 				ndlp->nlp_rpi);
-
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
-		} else {
-			/* Do not drop node for lpfc_els_abort'ed ELS cmds */
-			if (!lpfc_error_lost_link(irsp) &&
-			    ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				if (lpfc_nlp_not_used(ndlp)) {
-					ndlp = NULL;
-					/* Indicate node has already been
-					 * released, should not reference
-					 * to it from within the routine
-					 * lpfc_els_free_iocb.
-					 */
-					cmdiocb->context1 = NULL;
-				}
-			}
 		}
 		mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
 		if (mp) {
@@ -4628,19 +4579,6 @@ out:
 			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
 		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(&ndlp->lock);
-
-		/* If the node is not being used by another discovery thread,
-		 * and we are sending a reject, we are done with it.
-		 * Release driver reference count here and free associated
-		 * resources.
-		 */
-		if (ls_rjt)
-			if (lpfc_nlp_not_used(ndlp))
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.30.2



