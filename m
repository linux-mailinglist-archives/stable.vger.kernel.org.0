Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703A244B836
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345103AbhKIWlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345112AbhKIWjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:39:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3C761B1D;
        Tue,  9 Nov 2021 22:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496597;
        bh=DXPJin+CE2xZp1acdbPmxh1Z4QPChmnWizcEkUFwARI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmBFhfys5Qd1BI+foOuUzeurh5jPCwzZnEgHYzNwaKIamAVXYDN7Z6zrlTM+owFBD
         x2keYT70jtTvwm/Ls1JbrtusFle8liyrTg543+w2CWEPvWXEeGwwsK/0N/CX9EFI4J
         kIhiwn8+ssHJIdXNx0gAYAWZMjMcsOv/VCafiRALJnSC5QAYAe3YfnFYPrV/H0ynL4
         nUX6Pxy8l5Y+DnYYsK8ROtfOvt4EsSNBbksmVcfZAhSEbdcXbLO9pvwyYyFv2zaUys
         2aMihgI6/G+p0hbWrfYN46Hcy6zIwdIVED7iKqScZ5U9Wt6fPr+uyTAgBETb4G9/KU
         u63w17o0q59cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/21] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Tue,  9 Nov 2021 17:22:52 -0500
Message-Id: <20211109222311.1235686-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
index 40d6537e64dd6..e72fc88aeb40e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19171,6 +19171,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0

