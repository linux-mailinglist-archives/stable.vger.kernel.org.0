Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49B49358
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFQVaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730007AbfFQVaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:30:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12C22063F;
        Mon, 17 Jun 2019 21:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560807012;
        bh=aazJYGrz2iUlZa/5wKLAAWD16u2z/Nge9o8zQ4IdQ3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbOlOroKRNC+FPf8zwbmRormBOvh127TPt+s1BMin5gaPKCPTITPhep+en5+WsZDB
         W22xVWKinrXA9AiBXCQd9AOdKoj8GB58f9xhJ0LNDKeJQhIMtfrzChm2gaZO9YyjDW
         0b5QidBqbm83HlzRiMEJ3Qfg1DH7mvoYU3mYiKyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/53] scsi: lpfc: add check for loss of ndlp when sending RRQ
Date:   Mon, 17 Jun 2019 23:10:13 +0200
Message-Id: <20190617210750.887781305@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
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
index 57cddbc4a977..ddd29752d96d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7065,7 +7065,10 @@ int
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



