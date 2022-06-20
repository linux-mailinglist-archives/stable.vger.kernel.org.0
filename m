Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4081551CEF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbiFTNVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344766AbiFTNT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB75360E2;
        Mon, 20 Jun 2022 06:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C80D6154F;
        Mon, 20 Jun 2022 13:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E393C3411B;
        Mon, 20 Jun 2022 13:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730347;
        bh=JicjRnQMDRin8zmcJ7QBb5GWds4gk7oiwtluZKwMO9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7OxvxGWJpJkp66wG/UFFNDCMX2JkUT/+gB/ksTucQ6kptGuq8dlYFhkop5AKzw58
         Z0MW4Q8BDTJjVFIDdidgA8U7Ojjo5d9RWi8IEwU4zrym1BMWhPlY6j5xLop7PfyVcD
         ttc21bI3MO6YIvK5kPZg5hn/NORhn+pY3hU+ItUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/106] scsi: lpfc: Resolve NULL ptr dereference after an ELS LOGO is aborted
Date:   Mon, 20 Jun 2022 14:50:43 +0200
Message-Id: <20220620124725.098592639@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit b1b3440f437b75fb2a9b0cfe58df461e40eca474 ]

A use-after-free crash can occur after an ELS LOGO is aborted.

Specifically, a nodelist structure is freed and then
ndlp->vport->cfg_log_verbose is dereferenced in lpfc_nlp_get() when the
discovery state machine is mistakenly called a second time with
NLP_EVT_DEVICE_RM argument.

Rework lpfc_cmpl_els_logo() to prevent the duplicate calls to release a
nodelist structure.

Link: https://lore.kernel.org/r/20220603174329.63777-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ce28c4a30460..5f44a0763f37 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2955,18 +2955,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
-		lpfc_els_free_iocb(phba, cmdiocb);
-		lpfc_nlp_put(ndlp);
-
-		/* Presume the node was released. */
-		return;
+		goto out_rsrc_free;
 	}
 
 out:
-	/* Driver is done with the IO.  */
-	lpfc_els_free_iocb(phba, cmdiocb);
-	lpfc_nlp_put(ndlp);
-
 	/* At this point, the LOGO processing is complete. NOTE: For a
 	 * pt2pt topology, we are assuming the NPortID will only change
 	 * on link up processing. For a LOGO / PLOGI initiated by the
@@ -2993,6 +2985,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4], irsp->ulpTimeout,
 				 vport->num_disc_nodes);
+
+		lpfc_els_free_iocb(phba, cmdiocb);
+		lpfc_nlp_put(ndlp);
+
 		lpfc_disc_start(vport);
 		return;
 	}
@@ -3009,6 +3005,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 	}
+out_rsrc_free:
+	/* Driver is done with the I/O. */
+	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.35.1



