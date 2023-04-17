Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B816E5093
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 21:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjDQTGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 15:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjDQTGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 15:06:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFF11FF3;
        Mon, 17 Apr 2023 12:05:57 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63d32d21f95so76969b3a.1;
        Mon, 17 Apr 2023 12:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758357; x=1684350357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBueJxAlG6y1fXZLE74AlFUiUcaS4JSfD7jE9xvrGEI=;
        b=izLBrfl9pU8gPsAnOkFmAv45xPNom1ln9VCR7+zmiNuEJG3nGnE6/GH4K3dVPJCMHd
         x7wkoVtQkqe6Fyl6kfIdB3OxuxMhtyZOYg3mhaOm+JpRcFJvJIh/n9LqBbme3xIodfyo
         Gsl46+yvjshwNLpYYf4l9G3J2FSbmu06LfbQXTHpbl0vwPWq6j2BcH7WjO6GqrkZyTrT
         ty3uNCj530X3dCIuDEpLDte6p9WkPnzzhNsDfoZgaxRq4AZ3eVwQV4uztfpoRdtJ0Ekr
         zZqNObpNjfRu8oa6TqPnmqNJUjOjvuyYw+jCq7/71iCCK617CPj9xRjKgfDSlB7npKFG
         0I8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758357; x=1684350357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBueJxAlG6y1fXZLE74AlFUiUcaS4JSfD7jE9xvrGEI=;
        b=Vj5gwshp8VNExVpssSB2Nu/Bn4uzbZWV0EGIpGsCQkj8ICK7RpLXeLs0hFy1cvLG+w
         Kd0V+PejVwHQCYhPbjRLzm3OafdYwZEt/wHnU84eTI800zeDmNGFgdVhej5XF1aJaah9
         IiT6PdiZ9Uh9y/np9INsuBlwWDa3rqGlYDIpwr6HabSQhRb4TzR1XeVx2XzqnmoC8Hay
         vhtDFsdjzAJgCBYsiwU0S1jgb2rHdl2AZPVCjHUCv+1fUUH9ergB990sb4/KZdMlWCOD
         PCnmvKrNP8O+eJb5N8l4yK98svBgZ4epueVXopGKeZjx0K9QS61PBdPxFVwgJSzMlse8
         P1RQ==
X-Gm-Message-State: AAQBX9eod1SDi6f6DANbs2KQRIOlodx2Qd7NyF7cTBeK30rwFjQy0g1Q
        v61wSGkiUUwrEKC+kuONxgM6kTGIjCU=
X-Google-Smtp-Source: AKy350YhVt7So0AR1UMzwcgn7grqW9ryFPzViDC+OqXmjiDhB4rjUfCmWDU7kveSBGiyQnPgH15ueA==
X-Received: by 2002:a05:6a20:440e:b0:f0:69de:6165 with SMTP id ce14-20020a056a20440e00b000f069de6165mr1633887pzb.4.1681758356745;
        Mon, 17 Apr 2023 12:05:56 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:05:56 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>, stable@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 2/7] lpfc: Fix double free in lpfc_cmpl_els_logo_acc caused by lpfc_nlp_not_used
Date:   Mon, 17 Apr 2023 12:15:53 -0700
Message-Id: <20230417191558.83100-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Smatch detected a double free path because lpfc_nlp_not_used releases an
ndlp object before reaching lpfc_nlp_put at the end of
lpfc_cmpl_els_logo_acc.

Remove the outdated lpfc_nlp_not_used routine.  In
lpfc_mbx_cmpl_ns_reg_login, replace the call with lpfc_nlp_put.  In
lpfc_cmpl_els_logo_acc, replace the call with lpfc_unreg_rpi and keep the
lpfc_nlp_put at the end of the routine.  If ndlp's rpi was registered, then
lpfc_unreg_rpi's completion routine performs the final ndlp clean up after
lpfc_nlp_put is called from lpfc_cmpl_els_logo_acc.  Otherwise if ndlp has
no rpi registered, the lpfc_nlp_put at the end of lpfc_cmpl_els_logo_acc is
the final ndlp clean up.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y3OefhyyJNKH%2Fiaf@kili/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |  1 -
 drivers/scsi/lpfc/lpfc_els.c     | 30 +++++++-----------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 24 +++---------------------
 3 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b833b983e69d..0b9edde26abd 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -134,7 +134,6 @@ void lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 				 struct lpfc_nodelist *ndlp);
 void lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  struct lpfc_iocbq *rspiocb);
-int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_vport *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_vport *);
 void lpfc_disc_start(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6a15f879e517..a3c8550e9985 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5205,14 +5205,9 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
  *
  * This routine is the completion callback function to the Logout (LOGO)
  * Accept (ACC) Response ELS command. This routine is invoked to indicate
- * the completion of the LOGO process. It invokes the lpfc_nlp_not_used() to
- * release the ndlp if it has the last reference remaining (reference count
- * is 1). If succeeded (meaning ndlp released), it sets the iocb ndlp
- * field to NULL to inform the following lpfc_els_free_iocb() routine no
- * ndlp reference count needs to be decremented. Otherwise, the ndlp
- * reference use-count shall be decremented by the lpfc_els_free_iocb()
- * routine. Finally, the lpfc_els_free_iocb() is invoked to release the
- * IOCB data structure.
+ * the completion of the LOGO process. If the node has transitioned to NPR,
+ * this routine unregisters the RPI if it is still registered. The
+ * lpfc_els_free_iocb() is invoked to release the IOCB data structure.
  **/
 static void
 lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -5253,19 +5248,9 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
 			goto out;
 
-		/* NPort Recovery mode or node is just allocated */
-		if (!lpfc_nlp_not_used(ndlp)) {
-			/* A LOGO is completing and the node is in NPR state.
-			 * Just unregister the RPI because the node is still
-			 * required.
-			 */
+		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
 			lpfc_unreg_rpi(vport, ndlp);
-		} else {
-			/* Indicate the node has already released, should
-			 * not reference to it from within lpfc_els_free_iocb.
-			 */
-			cmdiocb->ndlp = NULL;
-		}
+
 	}
  out:
 	/*
@@ -5285,9 +5270,8 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * RPI (Remote Port Index) mailbox command to the @phba. It simply releases
  * the associated lpfc Direct Memory Access (DMA) buffer back to the pool and
  * decrements the ndlp reference count held for this completion callback
- * function. After that, it invokes the lpfc_nlp_not_used() to check
- * whether there is only one reference left on the ndlp. If so, it will
- * perform one more decrement and trigger the release of the ndlp.
+ * function. After that, it invokes the lpfc_drop_node to check
+ * whether it is appropriate to release the node.
  **/
 void
 lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5ba3a9ad9501..67bfdddb897c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4333,13 +4333,14 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 		/* If the node is not registered with the scsi or nvme
 		 * transport, remove the fabric node.  The failed reg_login
-		 * is terminal.
+		 * is terminal and forces the removal of the last node
+		 * reference.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
 			spin_unlock_irq(&ndlp->lock);
-			lpfc_nlp_not_used(ndlp);
+			lpfc_nlp_put(ndlp);
 		}
 
 		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
@@ -6704,25 +6705,6 @@ lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 	return ndlp ? kref_put(&ndlp->kref, lpfc_nlp_release) : 0;
 }
 
-/* This routine free's the specified nodelist if it is not in use
- * by any other discovery thread. This routine returns 1 if the
- * ndlp has been freed. A return value of 0 indicates the ndlp is
- * not yet been released.
- */
-int
-lpfc_nlp_not_used(struct lpfc_nodelist *ndlp)
-{
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
-		"node not used:   did:x%x flg:x%x refcnt:x%x",
-		ndlp->nlp_DID, ndlp->nlp_flag,
-		kref_read(&ndlp->kref));
-
-	if (kref_read(&ndlp->kref) == 1)
-		if (lpfc_nlp_put(ndlp))
-			return 1;
-	return 0;
-}
-
 /**
  * lpfc_fcf_inuse - Check if FCF can be unregistered.
  * @phba: Pointer to hba context object.
-- 
2.38.0

