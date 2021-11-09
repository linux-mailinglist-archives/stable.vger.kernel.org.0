Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCFA44B881
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345627AbhKIWor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345732AbhKIWmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83B8860524;
        Tue,  9 Nov 2021 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496647;
        bh=nzsXTx0P7obTY78Y1iLFMUWEmoTyHdi/l37FhHwOOc8=;
        h=From:To:Cc:Subject:Date:From;
        b=VuCzYLw9c5SD+YzJq1PhsXqqfe2FNg3L7WBHNFYyMtNOMdiC1Gvgc9fSYGGEY7hoC
         g/LYylLrMn3bSrFOQ7Jo7jSup6ie8oYo3f5GN1z3HQtbNrFwGaoWvXKBIqblWXeTvo
         N/S9qjFrMw6L3/f0lFFOLMD20CF40Ew0id3o4D7KOZhqminq7vsiiVugpXZXp/qHtY
         v3ugqTri84LE4kl+O3r6gipzZlvErlERhosHe9loVK5c5a2GtOsEczEt7d60tyfphT
         BOq1DH+OkyHPIbBQVhnsKSuVe6D7GFjiG4z5KjR3/f5ndfuPPs3vz9qkhtmS/nMibQ
         H87frBcA7BsLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/13] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Tue,  9 Nov 2021 17:23:52 -0500
Message-Id: <20211109222405.1236040-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 99154581b05c8fb22607afb7c3d66c1bace6aa5d ]

When parsing the txq list in lpfc_drain_txq(), the driver attempts to pass
the requests to the adapter. If such an attempt fails, a local "fail_msg"
string is set and a log message output.  The job is then added to a
completions list for cancellation.

Processing of any further jobs from the txq list continues, but since
"fail_msg" remains set, jobs are added to the completions list regardless
of whether a wqe was passed to the adapter.  If successfully added to
txcmplq, jobs are added to both lists resulting in list corruption.

Fix by clearing the fail_msg string after adding a job to the completions
list. This stops the subsequent jobs from being added to the completions
list unless they had an appropriate failure.

Link: https://lore.kernel.org/r/20210910233159.115896-2-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0e7915ecb85a5..5c847ef459cd1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17274,6 +17274,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0

