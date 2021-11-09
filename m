Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B719A44B56B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245690AbhKIWUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245477AbhKIWUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8563361151;
        Tue,  9 Nov 2021 22:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496234;
        bh=0fiA1A8GW3+YmcHBMu76vJF5AO1wkbJXbd7SxR6ngTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTa7vKB9OpZU/1b3HSQaq5oemrQcOmiiircjJNhO1nazywhgmxRlTNPIB63Hn9Y07
         yg+o2WtmGj1w7piENdeVViR2w+NKSEGLBWlJh5ZZla/8DUwUNiUWVmQoYwniJKSGpv
         HHto4GvFvDwMWTucUfTbDetkaZOzseq+T9ALVQmS/L9Nw8NFxFeeMcep8rz6er93kL
         cw9EX7V4DLOiWZiHBxlNItj6aD1I0uYluJjtvpMRdRnyYh5prYqnsPXTqyrvfLyMU/
         DltXu9j3JKtNWMhBhAbw1GtgeC2QpaPSllaxaIMrtET+OKS82UbIWAuatNa3HXsE0H
         hckNdz9maTPyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/82] scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
Date:   Tue,  9 Nov 2021 17:15:31 -0500
Message-Id: <20211109221641.1233217-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 026a1196a54d5..d0593291b21c9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21107,6 +21107,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.33.0

