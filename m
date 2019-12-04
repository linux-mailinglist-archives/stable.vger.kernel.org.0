Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D5C113475
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfLDSCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbfLDSCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:06 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E431620659;
        Wed,  4 Dec 2019 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482525;
        bh=DUQCaYRYJxw4H/dUD32qfJyMO43H3B6fvOK9Cv0MDnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOdjECJu6+wNkAfU8ptTv+sVUTFPU0dL9GIOzRIYickUSQx15adVHKUJ4IViDcqMh
         3heoUK2gXRghr1gisO/14S8AkIzKd1mrlar5eMCzpMWxKwUqHhZm8ChCcOjY21A8TG
         1rKaYkx8IzJKuX7lGTTbxKH7P/NKe26S0AkzqZbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/209] scsi: lpfc: Fix kernel Oops due to null pring pointers
Date:   Wed,  4 Dec 2019 18:54:02 +0100
Message-Id: <20191204175323.573147912@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index bc61cc8bc6f02..03e95a3216c8c 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1239,6 +1239,12 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
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
index e5db20e8979d5..a31f87eb1e621 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1337,6 +1337,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			Fabric_DID);
 
 	pring = lpfc_phba_elsring(phba);
+	if (unlikely(!pring))
+		return -EIO;
 
 	/*
 	 * Check the txcmplq for an iocb that matches the nport the driver is
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 15bcd00dd7a23..c69c2a2b2eadf 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1773,7 +1773,12 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
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
index ebf7d3cda3677..62bea4ffdc25a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4421,6 +4421,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
 
 	rc = lpfc_sli4_brdreset(phba);
+	if (rc)
+		return rc;
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
-- 
2.20.1



