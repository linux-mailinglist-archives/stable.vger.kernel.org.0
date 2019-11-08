Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A0F49DD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbfKHMFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389459AbfKHLl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6184222CE;
        Fri,  8 Nov 2019 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213288;
        bh=CxMd0H4p3VQzZUSiZPmnNe8aQlpthgB19KGLnWY0qB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgMWdzb925R9rQNJkE3cKm6PtEpbciOuY/OJiSRFvgXZl/mFP+TYqRCrEDZZrdPgz
         lvqmHVQClXsXAE2Mk/35pQkBDxDgGzqujm3tcT6lizGrwHBvyKG3q5ciOG57FkmvL/
         zG5q/BrPx/GUbowYOxxt6OUXLFjtMROmUTqxQFqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 148/205] scsi: lpfc: Correct invalid EQ doorbell write on if_type=6
Date:   Fri,  8 Nov 2019 06:36:55 -0500
Message-Id: <20191108113752.12502-148-sashal@kernel.org>
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

[ Upstream commit aad59d5d34738d6fd8c359df8048a84cd443e504 ]

During attachment, the driver writes the EQ doorbell to disable potential
interrupts from an EQ. The current EQ doorbell format used for clearing the
interrupt is incorrect and uses an if_type=2 format, making the operation act
on the wrong EQ.

Correct the code to use the proper if_type=6 EQ doorbell format.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a490e63c94b67..e704297618e06 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -392,11 +392,7 @@ lpfc_sli4_if6_eq_clr_intr(struct lpfc_queue *q)
 	struct lpfc_register doorbell;
 
 	doorbell.word0 = 0;
-	bf_set(lpfc_eqcq_doorbell_eqci, &doorbell, 1);
-	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_EVENT);
-	bf_set(lpfc_eqcq_doorbell_eqid_hi, &doorbell,
-		(q->queue_id >> LPFC_EQID_HI_FIELD_SHIFT));
-	bf_set(lpfc_eqcq_doorbell_eqid_lo, &doorbell, q->queue_id);
+	bf_set(lpfc_if6_eq_doorbell_eqid, &doorbell, q->queue_id);
 	writel(doorbell.word0, q->phba->sli4_hba.EQDBregaddr);
 }
 
-- 
2.20.1

