Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A5554184C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379320AbiFGVL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379951AbiFGVLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C717521682F;
        Tue,  7 Jun 2022 11:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76063B82018;
        Tue,  7 Jun 2022 18:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8210C385A2;
        Tue,  7 Jun 2022 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627953;
        bh=uBJsSL0dyV/euH9wSsRXymgQdHcQOPUzRb7f6NJVMeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn8IMquUjPrnpP12iVQcejOIoiZrimE3RgUMTsRU9zW0UYw6yATsOWYJfsWwDtHXA
         c6E1uTukmmkt3ar/gGqQlGULVGYJpQQDbCOtgbarlShNDUIBq4c7Rd9Eirje4EaEaE
         iI+P8r5ckxTyrDzlcSuuZ+CSzZqlOA89Cl1l5cgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 112/879] scsi: lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
Date:   Tue,  7 Jun 2022 18:53:50 +0200
Message-Id: <20220607165005.949318007@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 09a45f8ecf3f..a174e06bd96e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18124,7 +18124,6 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_RCTL_ELS_REP:	/* extended link services reply */
 	case FC_RCTL_ELS4_REQ:	/* FC-4 ELS request */
 	case FC_RCTL_ELS4_REP:	/* FC-4 ELS reply */
-	case FC_RCTL_BA_NOP:  	/* basic link service NOP */
 	case FC_RCTL_BA_ABTS: 	/* basic link service abort */
 	case FC_RCTL_BA_RMC: 	/* remove connection */
 	case FC_RCTL_BA_ACC:	/* basic accept */
@@ -18145,6 +18144,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 		fc_vft_hdr = (struct fc_vft_header *)fc_hdr;
 		fc_hdr = &((struct fc_frame_header *)fc_vft_hdr)[1];
 		return lpfc_fc_frame_check(phba, fc_hdr);
+	case FC_RCTL_BA_NOP:	/* basic link service NOP */
 	default:
 		goto drop;
 	}
@@ -18959,12 +18959,14 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
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



