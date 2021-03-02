Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60032AFBF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhCCA2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383890AbhCBMcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3FA64FD3;
        Tue,  2 Mar 2021 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686386;
        bh=IQBGzu1sOP0A/ObU5lRQLkP9xwgGMHoo0W0ieTGoynY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyMcdMMbVhnbt+FUp9FepcERShcxGEXsGo+BkVilZlSfwfXs3Ki9rR/Ul4TH/vb/p
         J8d1tolnYmrxUO2rH2NAp9Y8qSfVWv3mgx18mCcDjl8VQeWxblZOeirwpJdSdhMYZa
         8PZG70y2HyEEABH6Gfp0Bf/J3CeIjyjhgooH5go+MIevktQRHdvSkW6A3T/Yy2kHsn
         w5ezCMi9pMx9Zncd0YYkLSh6ZRrIqOlk+DW9MSvYfCe63lib02iIAe76L1Yuwz2Q/z
         q1Wxqxq9FeLvLyWtYwHhvpcTaizgVwgDcNjv7a7z4llk3yLdLNjTZWWPwHTi6LOe1M
         l+iGg6jKw/XuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 8/8] scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling
Date:   Tue,  2 Mar 2021 06:59:35 -0500
Message-Id: <20210302115935.63777-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115935.63777-1-sashal@kernel.org>
References: <20210302115935.63777-1-sashal@kernel.org>
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
index 36e415487fe5..444f58589f33 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1568,14 +1568,9 @@ check_mgmt:
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

