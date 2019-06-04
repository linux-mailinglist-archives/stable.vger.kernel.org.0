Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9F735444
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfFDXcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfFDXWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F4820862;
        Tue,  4 Jun 2019 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690565;
        bh=bVL5XE/t5xd48IGr1qdwkcaiwJG1oAw4Msey13+p20w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr1bVgQnPwhlyGpCqEFb3/B742c1DTrmQ93tjq17Mi1LMTXp5rdpJ/kI4Q3hevEzA
         Wkt9KPPCrle7+GYaO84N/CxIFdV8XMhTWgB6vMLRAteFVHqjJPHrfJHyezBjJaajTN
         Gu44n/ptWuAdn8w4fiK0PX3PAEVjAZ9F4s6xPiNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 20/60] scsi: lpfc: add check for loss of ndlp when sending RRQ
Date:   Tue,  4 Jun 2019 19:21:30 -0400
Message-Id: <20190604232212.6753-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit c8cb261a072c88ca1aff0e804a30db4c7606521b ]

There was a missing qualification of a valid ndlp structure when calling to
send an RRQ for an abort.  Add the check.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fc077cb87900..965f8a1a8f67 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7338,7 +7338,10 @@ int
 lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
 {
 	struct lpfc_nodelist *ndlp = lpfc_findnode_did(rrq->vport,
-							rrq->nlp_DID);
+						       rrq->nlp_DID);
+	if (!ndlp)
+		return 1;
+
 	if (lpfc_test_rrq_active(phba, ndlp, rrq->xritag))
 		return lpfc_issue_els_rrq(rrq->vport, ndlp,
 					 rrq->nlp_DID, rrq);
-- 
2.20.1

