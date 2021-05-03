Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194E9371992
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhECQhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhECQgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BD37613BA;
        Mon,  3 May 2021 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059739;
        bh=16VyapXb1HW+Q296oL36abpmwD6a8vwloM8LfqYD2r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGYszyKKJ1elIIb4M51NwInETSC0h1fvr1aV1xmt9//xpTQijhLCE+oimaC1YPVgP
         aTjM6VV0pm8acXiAZy/vCEsmznmtShQFdttT9mjGTua0rk8nFAs6NV21Z7ufM5W6y3
         XhQTvQ0zegjSEeQ2FP6Shy6lmI8qFuLqKmOXQqsks4BeO9hahfSFJmZiw9K17jCOdH
         i6qHySW1Q3sO0mpuOVwQWqyf7guCGJtVglBOX6qtNvujEqMGef+VQM7tNR/qtkE/4+
         zjFAXOipdrOKn618JDvXyP6XZV+u6zNqikMjo+LsmyjnmbC2RaSEV7IiMBTsiUGDip
         2WDaljmrrxMbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 016/134] scsi: lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Mon,  3 May 2021 12:33:15 -0400
Message-Id: <20210503163513.2851510-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 148bc64d38fe314475a074c4f757ec9d84537d1c ]

An unlikely error exit path from lpfc_els_retry() returns incorrect status
to a caller, erroneously indicating that a retry has been successfully
issued or scheduled.

Change error exit path to indicate no retry.

Link: https://lore.kernel.org/r/20210301171821.3427-12-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f0a758138ae8..beb2fcd2d8e7 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3829,7 +3829,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
-			return 1;
+			return 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-- 
2.30.2

