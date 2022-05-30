Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D71537D30
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiE3NhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiE3Nfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08866941B3;
        Mon, 30 May 2022 06:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0524FB80DA7;
        Mon, 30 May 2022 13:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F72DC3411F;
        Mon, 30 May 2022 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917320;
        bh=242D0h+7US9qoAxy4aP+hGItDh1JMCe93gIbKSuD2uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0sMP/goh0Ybu+mhHlPJoM+I+tApHhYrmbrkqKZAZFLt0Eb9IkP+FcF02W2CPzoLu
         mh7aNXNzxeOkv9InUYEXpMslGSOrbQ5TyQuRFgj0cpGWdHsEofWDmteSovxVXC0GEE
         B6IBlCt5JmGejS8BVsLryvK1cdZoeMkocZ+MJzXumNjB1bsHQIw/jG9+jutKnSzeNN
         WO3kyDEZ02wpUpiXEsXRQq5m7vcnoZ4DX1IdNLqFO9lz2wJKrZKPV313KMCGXq2X2P
         ZWCLjwIrXV7uXgNP5AaBNYo8BwN9aRMgkEmEFx4QEkp3UjFBu6a8f8fx79eT/iR8Tj
         xIAwkZb7PN7CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 093/159] scsi: lpfc: Inhibit aborts if external loopback plug is inserted
Date:   Mon, 30 May 2022 09:23:18 -0400
Message-Id: <20220530132425.1929512-93-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit ead76d4c09b89f4c8d632648026a476a5a34fde8 ]

After running a short external loopback test, when the external loopback is
removed and a normal cable inserted that is directly connected to a target
device, the system oops in the llpfc_set_rrq_active() routine.

When the loopback was inserted an FLOGI was transmit. As we're looped back,
we receive the FLOGI request. The FLOGI is ABTS'd as we recognize the same
wppn thus understand it's a loopback. However, as the ABTS sends address
information the port is not set to (fffffe), the ABTS is dropped on the
wire. A short 1 frame loopback test is run and completes before the ABTS
times out. The looback is unplugged and the new cable plugged in, and the
an FLOGI to the new device occurs and completes. Due to a mixup in ref
counting the completion of the new FLOGI releases the fabric ndlp. Then the
original ABTS completes and references the released ndlp generating the
oops.

Correct by no-op'ing the ABTS when in loopback mode (it will be dropped
anyway). Added a flag to track the mode to recognize when it should be
no-op'd.

Link: https://lore.kernel.org/r/20220506035519.50908-5-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_els.c     | 12 ++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c     |  8 +++++---
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 0025760230e5..da5e91a91151 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1025,6 +1025,7 @@ struct lpfc_hba {
 #define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
 #define LS_MDS_LOOPBACK       0x10	/* MDS Diagnostics Link Up (Loopback) */
 #define LS_CT_VEN_RPA         0x20	/* Vendor RPA sent to switch */
+#define LS_EXTERNAL_LOOPBACK  0x40	/* External loopback plug inserted */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 46a01a51b207..9545a35f0777 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1387,6 +1387,9 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->hba_flag |= (HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	/* Check for a deferred FLOGI ACC condition */
 	if (phba->defer_flogi_acc_flag) {
 		/* lookup ndlp for received FLOGI */
@@ -8182,6 +8185,9 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t fc_flag = 0;
 	uint32_t port_state = 0;
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	cmd = *lp++;
 	sp = (struct serv_parm *) lp;
 
@@ -8233,6 +8239,12 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			return 1;
 		}
 
+		/* External loopback plug insertion detected */
+		phba->link_flag |= LS_EXTERNAL_LOOPBACK;
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_LIBDFC,
+				 "1119 External Loopback plug detected\n");
+
 		/* abort the flogi coming back to ourselves
 		 * due to external loopback on the port.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2b877dff5ed4..6b6b3790d7b5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1221,6 +1221,9 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	phba->defer_flogi_acc_flag = false;
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_SCAN_DONE);
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a174e06bd96e..11f907278f09 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12202,7 +12202,8 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	if (phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
-	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN))
+	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN) ||
+	    (phba->link_flag & LS_EXTERNAL_LOOPBACK))
 		ia = true;
 	else
 		ia = false;
@@ -12661,7 +12662,8 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		ndlp = lpfc_cmd->rdata->pnode;
 
 		if (lpfc_is_link_up(phba) &&
-		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE))
+		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE) &&
+		    !(phba->link_flag & LS_EXTERNAL_LOOPBACK))
 			ia = false;
 		else
 			ia = true;
@@ -21126,7 +21128,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
 
-	if (!lpfc_is_link_up(phba))
+	if (!lpfc_is_link_up(phba) || (phba->link_flag & LS_EXTERNAL_LOOPBACK))
 		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
 	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
 	abtswqe->abort_cmd.rsrvd5 = 0;
-- 
2.35.1

