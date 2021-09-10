Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4016E40607A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhIJARe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhIJARY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61AB1610A3;
        Fri, 10 Sep 2021 00:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232974;
        bh=5wT4zBVukEMyX/IIdNppK+WSIKXrt8fuOa2dbxjJr4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ima3GrRgp/Et42UZawLVzzXgS9f7/WCM0ywrl3cHCZx6wTyJBSG49bKuKrYyJ8T0D
         gaHcRZrWdZsdf87/xS0C+cYjcnVEzklccXMBUdIa5P89zLr6WX6l8jI+20wXABVFHw
         f9psbDFFSxkQFFKadfNTnFCZhqCVuD6YbtviQxfhRuKseNVFgrcz74SPHQSdOL8XkT
         fen6tF7aOkyJ6W1z5BsqingFcu2BioLhNKbGvXe4j4v6epnO0sYyZz65d4FZJ8Miu4
         JzBotT2gvcAnNYvUiRQzGTNqiijL2FQTcRDfNhDRRx89k3732A2BCDXNW5/CNwEVXD
         xh52kKcg0rZTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 11/99] scsi: lpfc: Fix NULL ptr dereference with NPIV ports for RDF handling
Date:   Thu,  9 Sep 2021 20:14:30 -0400
Message-Id: <20210910001558.173296-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2d338eb55b14ab9d245e8b1d982adecca8c4c613 ]

RDF ELS handling for NPIV ports may result in an incorrect NDLP reference
count.  In the event of a persistent link down, this may lead to premature
release of an NDLP structure and subsequent NULL ptr dereference panic.

Remove extraneous lpfc_nlp_put() call in NPIV port RDF processing.

Link: https://lore.kernel.org/r/20210707184351.67872-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b0c443a0cf92..b1ca6f8e5970 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3413,7 +3413,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		return 1;
 	}
 
-	/* Keep the ndlp just in case RDF is being sent */
 	return 0;
 }
 
@@ -3657,11 +3656,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
-	/* RDF ELS is not required on an NPIV VN_Port.  */
-	if (vport->port_type == LPFC_NPIV_PORT) {
-		lpfc_nlp_put(ndlp);
+	/* RDF ELS is not required on an NPIV VN_Port. */
+	if (vport->port_type == LPFC_NPIV_PORT)
 		return -EACCES;
-	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RDF);
-- 
2.30.2

