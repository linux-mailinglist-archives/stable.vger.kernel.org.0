Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0EF44B670
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344151AbhKIW1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344176AbhKIWZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F19F61881;
        Tue,  9 Nov 2021 22:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496372;
        bh=pwYooDjxk7XjEE9LvlQ9MxKn6KoJEb7RHxwEpdhgtkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7K96Ll++MVZLBrnobaER0DCUdR7qbzGwM6kzO/trJ2NhKdc7I9k+R+Lk3BZ32TJu
         uh/L2z/5y/9LbOJnFKAkJP3W1I8c8s8EBmPPF2hkob9wZo3agSVWwEeeRJJE6pYPrO
         Tpj2zpHjAoeqCYdcOz0HeJTKyFqBMwdN5dq2bXDeXg8wt0WR8zbXUJfGRMA3/7acHO
         pIJy57xxrSBQy7TVCzwnq/E1CFhuexcNVVzfHTtv/ZPsq7YiVZ+ZFI+vJhwAERP/0B
         fh8heEe44aFJ8HDRu6KySl9f0Xv4CExdSw9ZJlN/mxEsjL46RsP/o1dGRN+7oT+wjA
         Jc2AnoYaS11wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 13/75] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Tue,  9 Nov 2021 17:18:03 -0500
Message-Id: <20211109221905.1234094-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index f530d8fe7a8ce..260e09b8ba38d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20357,6 +20357,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0

