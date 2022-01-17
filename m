Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F657490D89
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242347AbiAQRDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241799AbiAQRCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE4A6119F;
        Mon, 17 Jan 2022 17:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9BFC36AED;
        Mon, 17 Jan 2022 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438932;
        bh=Y4ZVPC9JgMkic69D/SYjuLk7XJOUJS7KtSR9xJSVSd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlqYiDUhQIT+4m6A1zV31wcVHltE5Np7uuqmGm5BnAQZ+8WyzNXKtVwcS6SPbRY5H
         irx2EhzWJnq0S9mSxl+GIojZOdCrodKoy6wfF2tJHahmf3njxkRBXo4/84bDC86ZAt
         B9CsIpd6v6IO3zlQ5mKgKdtXz6nFvbrrnT5/MNSOB1EgjTcZJTIg/XIN9aN+kJS7j0
         r8QkJgsKv70zxlsQaAAxADoRUDV5cFSNXyZMzucnWsjiDbzMAvo39sUIJGIIDW1I3+
         QcM1JnZLxbZY0kpLsAprq9SuVGsPyllRHdwWO/8ieqPPgtxFMN1XfWfbXGyfWGNH6G
         CShwsTeiV2S2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/44] scsi: lpfc: Fix leaked lpfc_dmabuf mbox allocations with NPIV
Date:   Mon, 17 Jan 2022 12:01:03 -0500
Message-Id: <20220117170127.1471115-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit f0d3919697492950f57a26a1093aee53880d669d ]

During rmmod testing, messages appeared indicating lpfc_mbuf_pool entries
were still busy. This situation was only seen doing rmmod after at least 1
vport (NPIV) instance was created and destroyed. The number of messages
scaled with the number of vports created.

When a vport is created, it can receive a PLOGI from another initiator
Nport.  When this happens, the driver prepares to ack the PLOGI and
prepares an RPI for registration (via mbx cmd) which includes an mbuf
allocation. During the unsolicited PLOGI processing and after the RPI
preparation, the driver recognizes it is one of the vport instances and
decides to reject the PLOGI. During the LS_RJT preparation for the PLOGI,
the mailbox struct allocated for RPI registration is freed, but the mbuf
that was also allocated is not released.

Fix by freeing the mbuf with the mailbox struct in the LS_RJT path.

As part of the code review to figure the issue out a couple of other areas
where found that also would not have released the mbuf. Those are cleaned
up as well.

Link: https://lore.kernel.org/r/20211204002644.116455-2-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 6 +++++-
 drivers/scsi/lpfc/lpfc_init.c      | 8 ++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f7197b7161d52..6d7b9571f5c03 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6877,6 +6877,7 @@ static int
 lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 {
 	LPFC_MBOXQ_t *mbox = NULL;
+	struct lpfc_dmabuf *mp;
 	int rc;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -6892,8 +6893,11 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a0;
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		goto issue_mbox_fail;
+	}
 
 	return 0;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0fee8d590b0c4..2bbd1be6cc5d4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5314,8 +5314,10 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	 */
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED)
+		if (rc == MBX_NOT_FINISHED) {
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			goto out_free_dmabuf;
+		}
 		return;
 	}
 	/*
@@ -6266,8 +6268,10 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	}
 
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		goto out_free_dmabuf;
+	}
 	return;
 
 out_free_dmabuf:
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 27263f02ab9f6..7d717a4ac14d1 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -322,6 +322,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
+	struct lpfc_dmabuf *mp;
 	uint64_t nlp_portwwn = 0;
 	uint32_t *lp;
 	IOCB_t *icmd;
@@ -571,6 +572,11 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * a default RPI.
 		 */
 		if (phba->sli_rev == LPFC_SLI_REV4) {
+			mp = (struct lpfc_dmabuf *)login_mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
 			mempool_free(login_mbox, phba->mbox_mem_pool);
 			login_mbox = NULL;
 		} else {
-- 
2.34.1

