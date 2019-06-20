Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D704D5B4
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfFTSAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfFTSAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:00:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7650F21530;
        Thu, 20 Jun 2019 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053613;
        bh=WsPLfgBAEBmpTq68qUbNRWJh0JBq5hVy9+FUFKzH7gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDwe7ksfjOxCIGkDdeccfqPnjXRf/KdUqKD2xOinpuq1YJuF77US60sJlPK7z6iGT
         8xU05jlvcBnqYChlvRsvx6A5AAMKe7ItWWTT+PLut2HF/js0TY5Us3iwRad7pPJftQ
         okZl3ubr+j48yFNZrSVQz0h1YAlxzM+iljFA8Lsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 51/84] scsi: lpfc: add check for loss of ndlp when sending RRQ
Date:   Thu, 20 Jun 2019 19:56:48 +0200
Message-Id: <20190620174346.566882359@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 398c9a0a5ade..82a690924f5e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6498,7 +6498,10 @@ int
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



