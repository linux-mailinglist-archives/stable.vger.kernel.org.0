Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA7111EFA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfLCWtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbfLCWsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DA920684;
        Tue,  3 Dec 2019 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413334;
        bh=5OFALbIDb8eXWNwurlmOoA4VXFWnYSTmhbkEbDEyHfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpuHwfVut/EWF6lUEvjrYQK/Wcg9CPDtwqxeiVMHrSGrtsBYh7A3hAGpQZIgmnp/J
         F8xRUOtaufaKi40yW5+9eomugwiAm0YX3AfZ7RrmcrB0IhMp8+/Fe3gnkKZ6ONTdox
         FJ244GtnO1SQlAf06H5pH9ez0ecL1kbIg+Ab62uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/321] scsi: lpfc: Fix kernel Oops due to null pring pointers
Date:   Tue,  3 Dec 2019 23:31:54 +0100
Message-Id: <20191203223429.608239560@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5a9eeff57f340238c39c95d8e7e54c96fc722de7 ]

Driver is hitting null pring pointers in lpfc_do_work().

Pointer assignment occurs based on SLI-revision. If recovering after an
error, its possible the sli revision for the port was cleared, making the
lpfc_phba_elsring() not return a ring pointer, thus the null pointer.

Add SLI revision checking to lpfc_phba_elsring() and status checking to all
callers.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      | 6 ++++++
 drivers/scsi/lpfc/lpfc_els.c  | 2 ++
 drivers/scsi/lpfc/lpfc_init.c | 7 ++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index ebcfcbb8b4ccc..a62e85cb62eb2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1236,6 +1236,12 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 static inline struct lpfc_sli_ring *
 lpfc_phba_elsring(struct lpfc_hba *phba)
 {
+	/* Return NULL if sli_rev has become invalid due to bad fw */
+	if (phba->sli_rev != LPFC_SLI_REV4  &&
+	    phba->sli_rev != LPFC_SLI_REV3  &&
+	    phba->sli_rev != LPFC_SLI_REV2)
+		return NULL;
+
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (phba->sli4_hba.els_wq)
 			return phba->sli4_hba.els_wq->pring;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 222fa9b7f4788..ea2aa5f55ca44 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1343,6 +1343,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			Fabric_DID);
 
 	pring = lpfc_phba_elsring(phba);
+	if (unlikely(!pring))
+		return -EIO;
 
 	/*
 	 * Check the txcmplq for an iocb that matches the nport the driver is
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a7d3e532e0f58..da63c026ba460 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1801,7 +1801,12 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 	lpfc_offline(phba);
 	/* release interrupt for possible resource change */
 	lpfc_sli4_disable_intr(phba);
-	lpfc_sli_brdrestart(phba);
+	rc = lpfc_sli_brdrestart(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6309 Failed to restart board\n");
+		return rc;
+	}
 	/* request and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3361ae75578f2..755803ff6cfef 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4640,6 +4640,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
 
 	rc = lpfc_sli4_brdreset(phba);
+	if (rc)
+		return rc;
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
-- 
2.20.1



