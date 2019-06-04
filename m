Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FAE353D2
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFDX2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbfFDXYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E642085A;
        Tue,  4 Jun 2019 23:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690682;
        bh=tdSrWIy4DC2t2x/iLG/sP6Hhwa0Bj24s0xyzUozoz9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng52HnKGUdDYpqQSk3BOmxWXwRH/+qGiku2ofuFVbMSwZJMx7YeuZ4f8Izl6+0+8Y
         fee6SPik+PZATmCggPcTWSWSnxmrWBWpvWP4bRcV5PN1ydUJy4atpbL1Dvl4l/dexl
         hC6LcDdFA4TsYzLw+49AvMNpLtSwFhrTBp6qpJgU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/24] scsi: lpfc: add check for loss of ndlp when sending RRQ
Date:   Tue,  4 Jun 2019 19:24:04 -0400
Message-Id: <20190604232416.7479-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232416.7479-1-sashal@kernel.org>
References: <20190604232416.7479-1-sashal@kernel.org>
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

