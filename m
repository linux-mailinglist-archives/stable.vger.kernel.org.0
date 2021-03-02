Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0E632B0D2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhCCAjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351411AbhCBOW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F9F64FCC;
        Tue,  2 Mar 2021 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686374;
        bh=c1cd63hbhjSLcRxTtytJhfWOencZB9u8ztclFFA8eHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6fgQStLmsW38k2prpeebTwm3gYiB4oZHEboqmFrEygb4K4ysw6ZYPSpMrWUV4OuU
         dKR0ftp9GWoxxyILFTtGEYd7J5fmSXBsFWn2xRhUtshpXmAvKDdeMgC+nVCdQ77Luy
         HPBguAEIhrXOAkl8G2nvXq9PNBGbGIY50QbMDOCPhhEvef7cgHDE0ap1q1+u7WX9PM
         heezA5ptuz3Fm+pEBe9gWbbdOjL4+dl7QsSgTxkwtQPZhR9pQKVN2/NNtILtpGiQcy
         Jxz7yrGPJ/LLCg3Vhl2NQz0ydGB8MCO2OLLmCOdNmYsh61g2iY7N4luHTwZonGME0I
         VXLMaPB2gqNuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/10] scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling
Date:   Tue,  2 Mar 2021 06:59:21 -0500
Message-Id: <20210302115921.63636-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115921.63636-1-sashal@kernel.org>
References: <20210302115921.63636-1-sashal@kernel.org>
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
index a84b473d4a08..c0c8b97f6e90 100644
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

