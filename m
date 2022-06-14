Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A130E54A432
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351850AbiFNCGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351136AbiFNCFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:05:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3AA344E9;
        Mon, 13 Jun 2022 19:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84DA560B65;
        Tue, 14 Jun 2022 02:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0730C341C0;
        Tue, 14 Jun 2022 02:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172327;
        bh=FySxWglw/TlKcPHGpAQCpAV7XsSrIar/QamJPszHPnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NO8Gse+rLEhpmFSAt5EINO/sB1yOxuJzjqYd/M7I2dVDvGeMT0I9V1Bb2smuWhZ7b
         m2SQ7f2TyGIedPzSgY53X3lf2okpuWCZ/cRZob+jvRwWn7Yluzc+s+xJe8NWjvCUtB
         W47FlsaxjveDjKM2AMV1MyUjbHrjyXfPBrXySL3tBA5t/g+pzeku8DJj90ZEzVdWT2
         T2bWqdi+q/AmfF94dj/QaouNUCVlOP/lgfxKtUtVQqFtD0Mr07V/BknsjkGeV4YHSr
         zyC5jW3JxK8QVryhPeWsJpyRawA87LOnEwPAjhKWqFPCSTq1jYoYwKXVhbJaDBZRrF
         aP28jAn09gunw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 26/47] scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion
Date:   Mon, 13 Jun 2022 22:04:19 -0400
Message-Id: <20220614020441.1098348-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 02e230ed6280..e7daef550095 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4488,6 +4488,9 @@ struct wqe_common {
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
index 8d26f207ebd2..491050b2260a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1194,7 +1194,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
+	struct nvme_common_command *sqe;
+	struct lpfc_iocbq *pwqeq = &lpfc_ncmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
@@ -1251,8 +1252,14 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
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

