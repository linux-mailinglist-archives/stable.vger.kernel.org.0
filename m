Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D832B0A4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhCCAiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351370AbhCBOWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0343B64FC1;
        Tue,  2 Mar 2021 11:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686361;
        bh=S90zOVBYVNTBiDdDro2mlZD3KG7wvAcanIK0Pxeg7WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+1pYb82Vmf6EsXYLMjYCmKy0pPXTw3IUOHZM/vHJWOUIQBMmnRDpeIs2XaDO6KPp
         h0McQ4R8v4yxpT7H2C/frOIIIljraA9JOej6oXquf0L2/0UgclWkz+eVnC4eGlnEp1
         YL3a1uCdfk3OSW2slN2isQjLCSjjDxCPjaNB8dxhQMYGqVwFpdme9wh2tbmB0au8jR
         HdZ0qEPEjziWlzlk1tDbU5SwsLRS5zagSDlXJphYc7kSMU65XIDHj8z/GSxZmMiwTt
         KGDt+RUyy9QbUByH66b5/wMZV/khnKw3MeHnh8HMu+Wwud/qULtJ0kXV18s8wTQNNu
         N09ofAfO3BCEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/13] scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling
Date:   Tue,  2 Mar 2021 06:59:03 -0500
Message-Id: <20210302115903.63458-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit d28d48c699779973ab9a3bd0e5acfa112bd4fdef ]

If iscsi_prep_scsi_cmd_pdu() fails we try to add it back to the cmdqueue,
but we leave it partially setup. We don't have functions that can undo the
pdu and init task setup. We only have cleanup_task which can clean up both
parts. So this has us just fail the cmd and go through the standard cleanup
routine and then have the SCSI midlayer retry it like is done when it fails
in the queuecommand path.

Link: https://lore.kernel.org/r/20210207044608.27585-2-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f7e1af90849b..fffaf9b3476d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1569,14 +1569,9 @@ check_mgmt:
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
-			if (rc == -ENOMEM || rc == -EACCES) {
-				spin_lock_bh(&conn->taskqueuelock);
-				list_add_tail(&conn->task->running,
-					      &conn->cmdqueue);
-				conn->task = NULL;
-				spin_unlock_bh(&conn->taskqueuelock);
-				goto done;
-			} else
+			if (rc == -ENOMEM || rc == -EACCES)
+				fail_scsi_task(conn->task, DID_IMM_RETRY);
+			else
 				fail_scsi_task(conn->task, DID_ABORT);
 			spin_lock_bh(&conn->taskqueuelock);
 			continue;
-- 
2.30.1

