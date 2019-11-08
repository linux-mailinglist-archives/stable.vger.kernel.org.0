Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA2CF464C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfKHLlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:41:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732178AbfKHLla (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E096221D82;
        Fri,  8 Nov 2019 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213289;
        bh=P75uqMyjoRXnhEw5QxuO8/QYPU7dEevRD9g0hwqkyu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0ailCVtCuq+wC6opG8g7PSsdJUA7jlKW5/sUodhKEvQZcEFbR7DurUcJvsnvgK8G
         mvgT66fpDavbyJcdm+imR+C0gvAAsEotcTK4ubZ2Vo3ls6Y6IN72fcBf/B2kIQHW0B
         p7Hyo6i8PpCpejGslUROGZr2In0UrtW8zQSziWNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 149/205] scsi: lpfc: Fix errors in log messages.
Date:   Fri,  8 Nov 2019 06:36:56 -0500
Message-Id: <20191108113752.12502-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2879265f514b1f4154288243c91438ddbedb3ed4 ]

Message 6408 is displayed for each entry in an array, but the cpu and queue
numbers were incorrect for the entry.  Message 6001 includes an extraneous
character.

Resolve both issues

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 645ffb5332b4a..8ee585e453dcf 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -282,7 +282,7 @@ lpfc_nvme_delete_queue(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
-			"6001 ENTER.  lpfc_pnvme %p, qidx x%xi qhandle %p\n",
+			"6001 ENTER.  lpfc_pnvme %p, qidx x%x qhandle %p\n",
 			lport, qidx, handle);
 	kfree(handle);
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e2575c8ec93e8..4ca38bc5694c6 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1340,15 +1340,14 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 			idx = 0;
 	}
 
-	infop = phba->sli4_hba.nvmet_ctx_info;
-	for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
-		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
+			infop = lpfc_get_ctx_list(phba, i, j);
 			lpfc_printf_log(phba, KERN_INFO, LOG_NVME | LOG_INIT,
 					"6408 TOTAL NVMET ctx for CPU %d "
 					"MRQ %d: cnt %d nextcpu %p\n",
 					i, j, infop->nvmet_ctx_list_cnt,
 					infop->nvmet_ctx_next_cpu);
-			infop++;
 		}
 	}
 	return 0;
-- 
2.20.1

