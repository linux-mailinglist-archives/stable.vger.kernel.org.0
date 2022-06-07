Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412FB5404F8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345858AbiFGRUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbiFGRUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:20:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF9A1053CF;
        Tue,  7 Jun 2022 10:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4074CE2010;
        Tue,  7 Jun 2022 17:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0958C385A5;
        Tue,  7 Jun 2022 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622420;
        bh=631zzXTjK8+QjjXWIJaDYj6zf8tmyXSMCDUzq7AasZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwPtMw91ECrAPfveq6LhLsSEsChGdq9DWGiFtcjABfmxSYDzzw+uopzYd1raL28vl
         RqXkSAVC4Gld+EeLh22i6j79Lf37TiAMsevTpc208B9XsTJn0CAMc3h1/oUfns2dO6
         B8pHIPT3cdTcbstwblMfah1v8DoCnNQVNfLiccfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/452] scsi: lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
Date:   Tue,  7 Jun 2022 18:58:29 +0200
Message-Id: <20220607164910.097999125@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 646db1a560f44236b7278b822ca99a1d3b6ea72c ]

If no handler is found in lpfc_complete_unsol_iocb() to match the rctl of a
received frame, the frame is dropped and resources are leaked.

Fix by returning resources when discarding an unhandled frame type.  Update
lpfc_fc_frame_check() handling of NOP basic link service.

Link: https://lore.kernel.org/r/20220426181419.9154-1-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a50f870c5f72..755d68b98160 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17445,7 +17445,6 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_RCTL_ELS_REP:	/* extended link services reply */
 	case FC_RCTL_ELS4_REQ:	/* FC-4 ELS request */
 	case FC_RCTL_ELS4_REP:	/* FC-4 ELS reply */
-	case FC_RCTL_BA_NOP:  	/* basic link service NOP */
 	case FC_RCTL_BA_ABTS: 	/* basic link service abort */
 	case FC_RCTL_BA_RMC: 	/* remove connection */
 	case FC_RCTL_BA_ACC:	/* basic accept */
@@ -17466,6 +17465,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 		fc_vft_hdr = (struct fc_vft_header *)fc_hdr;
 		fc_hdr = &((struct fc_frame_header *)fc_vft_hdr)[1];
 		return lpfc_fc_frame_check(phba, fc_hdr);
+	case FC_RCTL_BA_NOP:	/* basic link service NOP */
 	default:
 		goto drop;
 	}
@@ -18284,12 +18284,14 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 	if (!lpfc_complete_unsol_iocb(phba,
 				      phba->sli4_hba.els_wq->pring,
 				      iocbq, fc_hdr->fh_r_ctl,
-				      fc_hdr->fh_type))
+				      fc_hdr->fh_type)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2540 Ring %d handler: unexpected Rctl "
 				"x%x Type x%x received\n",
 				LPFC_ELS_RING,
 				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+		lpfc_in_buf_free(phba, &seq_dmabuf->dbuf);
+	}
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-- 
2.35.1



