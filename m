Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A4E548F27
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbiFMN7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379894AbiFMN5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78232495C;
        Mon, 13 Jun 2022 04:37:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE07C61046;
        Mon, 13 Jun 2022 11:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCFAC34114;
        Mon, 13 Jun 2022 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120246;
        bh=Ex+e9/qLX4kzTYZbR3+QhEHr3b8O+kj9evKNUAxbhyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5SDbcLkD9ZCQtfnflJkXj9vLoR3tGGgv9VCuc85jMb60Imk9TqaJcux4ydFeU91z
         C2Wz5iRVVr8OYLIR/VJgheWDAItPF72a2TdxNyIQpDScx7Ohq24G9FZcfhmEB5t8CQ
         +H3yry22Lue8IfEXMmn8ZspVHFbQSCmq6NPOL+nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.18 302/339] scsi: lpfc: Resolve some cleanup issues following abort path refactoring
Date:   Mon, 13 Jun 2022 12:12:07 +0200
Message-Id: <20220613094935.919738177@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

commit 24e1f056677eefe834d5dcf61905cce857ca4b19 upstream.

Refactoring and consolidation of abort paths:

 - lpfc_sli4_abort_fcp_cmpl() and lpfc_sli_abort_fcp_cmpl() are combined
  into a single generic lpfc_sli_abort_fcp_cmpl() routine.  Thus, remove
  extraneous lpfc_sli4_abort_fcp_cmpl() prototype declaration.

 - lpfc_nvme_abort_fcreq_cmpl() abort completion routine is called with a
  mismatched argument type.  This may result in misleading log message
  content.  Update to the correct argument type of lpfc_iocbq instead of
  lpfc_wcqe_complete.  The lpfc_wcqe_complete should be derived from the
  lpfc_iocbq structure.

Link: https://lore.kernel.org/r/20220603174329.63777-3-jsmart2021@gmail.com
Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_crtn.h |    4 +---
 drivers/scsi/lpfc/lpfc_nvme.c |    6 ++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -418,8 +418,6 @@ int lpfc_sli_issue_iocb_wait(struct lpfc
 			     uint32_t);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
 			     struct lpfc_iocbq *);
-void lpfc_sli4_abort_fcp_cmpl(struct lpfc_hba *h, struct lpfc_iocbq *i,
-			      struct lpfc_wcqe_complete *w);
 
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
@@ -627,7 +625,7 @@ void lpfc_nvmet_invalidate_host(struct l
 			struct lpfc_nodelist *ndlp);
 void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdiocb,
-				struct lpfc_wcqe_complete *abts_cmpl);
+				struct lpfc_iocbq *rspiocb);
 void lpfc_create_multixri_pools(struct lpfc_hba *phba);
 void lpfc_create_destroy_pools(struct lpfc_hba *phba);
 void lpfc_move_xri_pvt_to_pbl(struct lpfc_hba *phba, u32 hwqid);
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1741,7 +1741,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_l
  * lpfc_nvme_abort_fcreq_cmpl - Complete an NVME FCP abort request.
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
- * @abts_cmpl: Pointer to wcqe complete object.
+ * @rspiocb: Pointer to response iocb object.
  *
  * This is the callback function for any NVME FCP IO that was aborted.
  *
@@ -1750,8 +1750,10 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_l
  **/
 void
 lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-			   struct lpfc_wcqe_complete *abts_cmpl)
+			   struct lpfc_iocbq *rspiocb)
 {
+	struct lpfc_wcqe_complete *abts_cmpl = &rspiocb->wcqe_cmpl;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 			"6145 ABORT_XRI_CN completing on rpi x%x "
 			"original iotag x%x, abort cmd iotag x%x "


