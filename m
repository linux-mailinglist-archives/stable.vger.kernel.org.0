Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D24551BA1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244710AbiFTNO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343519AbiFTNNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:13:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7AF1E3DA;
        Mon, 20 Jun 2022 06:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C44DB61535;
        Mon, 20 Jun 2022 13:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB706C3411C;
        Mon, 20 Jun 2022 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730354;
        bh=ToUh3uw+d6OuQ3xQsEOfSMJFmNh46l4CiJEgdqIQs3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/M96afLJtI2moiWabkrbF84zM3YWL8xBr+H3m1gcCv7mswXed5mc2d2sxV8U2EED
         NP3BdOIPHJCL0aU1bRla+HPlrze1uP5jFNyRcaInJj7yNPFGO3aEIf+sspRFccnNuS
         h/BJzv4SaHILgPptX+FA6c4r0amL1Y3tk+Umr10w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/106] scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion
Date:   Mon, 20 Jun 2022 14:50:45 +0200
Message-Id: <20220620124725.159383225@linuxfoundation.org>
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

[ Upstream commit 2e7e9c0c1ec05f18d320ecc8a31eec59d2af1af9 ]

NVMe Asynchronous Event Request commands have no command timeout value per
specifications.

Set WQE option to allow a reduced FLUSH polling rate for I/O error
detection specifically for nvme_admin_async_event commands.

Link: https://lore.kernel.org/r/20220603174329.63777-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_nvme.c | 11 +++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7359505e6041..824fc8c08840 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4448,6 +4448,9 @@ struct wqe_common {
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
+#define wqe_ffrq_SHIFT         6
+#define wqe_ffrq_MASK          0x00000001
+#define wqe_ffrq_WORD          word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 66cb66aea2cf..4fb3dc5092f5 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1182,7 +1182,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
+	struct nvme_common_command *sqe;
+	struct lpfc_iocbq *pwqeq = &lpfc_ncmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
@@ -1239,8 +1240,14 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		cstat->control_requests++;
 	}
 
-	if (pnode->nlp_nvme_info & NLP_NVME_NSLER)
+	if (pnode->nlp_nvme_info & NLP_NVME_NSLER) {
 		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
+		sqe = &((struct nvme_fc_cmd_iu *)
+			nCmd->cmdaddr)->sqe.common;
+		if (sqe->opcode == nvme_admin_async_event)
+			bf_set(wqe_ffrq, &wqe->generic.wqe_com, 1);
+	}
+
 	/*
 	 * Finish initializing those WQE fields that are independent
 	 * of the nvme_cmnd request_buffer
-- 
2.35.1



