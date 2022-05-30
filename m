Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1344A537BEB
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiE3N2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiE3N1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:27:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE2E82176;
        Mon, 30 May 2022 06:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 523DE60E2D;
        Mon, 30 May 2022 13:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1814C3411A;
        Mon, 30 May 2022 13:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917148;
        bh=Ft6p9kGIOkJkapwXK6jXCxSUMdE+m/EftAbFKlr8HL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC7wdZabFLp+/rWhgkJVmq11Fmvb4CjBVhkABVHQu5LVQJCYZ8zaTIoK6ww+nppLn
         qf+VeqmzAS3hjnm6l33LyZRtyJvRRNZZBLNLFWwlYPtGAmIKC4d0KV/dC02ys/kakk
         qven2PvzkIY+w2n58f/6u48PZahwmLkiMG85xNbD11rGKyomRZw0wayao3XIC6aax3
         EnmJbS6Z/Fpz/rtpHHuBmVOZqj0WSEAe3La2BiDi5Wi2rxLxISK84Q2attgpuNKbUe
         boTY1e4z2myAwx/RTN7SiE6MVgi8Dh/cbtMrz8aHiD5HqLMWD0l32R7yqaJg/CmviB
         G+DV3OuZ71CIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 037/159] scsi: lpfc: Fix null pointer dereference after failing to issue FLOGI and PLOGI
Date:   Mon, 30 May 2022 09:22:22 -0400
Message-Id: <20220530132425.1929512-37-sashal@kernel.org>
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

[ Upstream commit 577a942df3de2666f6947bdd3a5c9e8d30073424 ]

If lpfc_issue_els_flogi() fails and returns non-zero status, the node
reference count is decremented to trigger the release of the nodelist
structure. However, if there is a prior registration or dev-loss-evt work
pending, the node may be released prematurely.  When dev-loss-evt
completes, the released node is referenced causing a use-after-free null
pointer dereference.

Similarly, when processing non-zero ELS PLOGI completion status in
lpfc_cmpl_els_plogi(), the ndlp flags are checked for a transport
registration before triggering node removal.  If dev-loss-evt work is
pending, the node may be released prematurely and a subsequent call to
lpfc_dev_loss_tmo_handler() results in a use after free ndlp dereference.

Add test for pending dev-loss before decrementing the node reference count
for FLOGI, PLOGI, PRLI, and ADISC handling.

Link: https://lore.kernel.org/r/20220412222008.126521-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 51 +++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 872a26376ccb..46a01a51b207 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1532,10 +1532,13 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 	}
 
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
-		/* This decrement of reference count to node shall kick off
-		 * the release of the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1578,10 +1581,13 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 	}
 
 	if (lpfc_issue_els_fdisc(vport, ndlp, 0)) {
-		/* decrement node reference count to trigger the release of
-		 * the node.
+		/* A node reference should be retained while registered with a
+		 * transport or dev-loss-evt work is pending.
+		 * Otherwise, decrement node reference to trigger release.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+			lpfc_nlp_put(ndlp);
 		return 0;
 	}
 	return 1;
@@ -1983,6 +1989,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int disc;
 	struct serv_parm *sp = NULL;
 	u32 ulp_status, ulp_word4, did, iotag;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2071,19 +2078,21 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			spin_unlock_irq(&ndlp->lock);
 			goto out;
 		}
-		spin_unlock_irq(&ndlp->lock);
 
 		/* No PLOGI collision and the node is not registered with the
 		 * scsi or nvme transport. It is no longer an active node. Just
 		 * start the device remove process.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -2294,6 +2303,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 loglevel;
 	u32 ulp_status;
 	u32 ulp_word4;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2370,14 +2380,18 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * it is no longer an active node.  Otherwise devloss
 		 * handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
 		    !ndlp->fc4_prli_sent) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else {
 		/* Good status, call state machine.  However, if another
 		 * PRLI is outstanding, don't call the state machine
@@ -2749,6 +2763,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp;
 	int  disc;
 	u32 ulp_status, ulp_word4, tmo;
+	bool release_node = false;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2815,13 +2830,17 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * transport, it is no longer an active node. Otherwise
 		 * devloss handles the final cleanup.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
-			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			spin_unlock_irq(&ndlp->lock);
+			if (!(ndlp->nlp_flag & NLP_IN_DEV_LOSS))
+				release_node = true;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		if (release_node)
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
-		}
 	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-- 
2.35.1

