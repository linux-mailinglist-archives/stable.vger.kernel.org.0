Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F97B4290E6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhJKOOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243363AbhJKOLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873A761167;
        Mon, 11 Oct 2021 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960979;
        bh=tylNBaavHTGJxRQcOsHD4fN9b4EwM6+jOO0m7Z2pCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8k7B83oIxStjzXL8qJxPw0yyefGOaDjlb05n2Eg/5NxElgk4yvkKl6jvlzTDyNHd
         tLNUlgI1O6LySUR8q4ab4e0OoCrUE/5tXaduJYTnc8GMKSy3svOCZSHytEzYNyAltg
         FwaRoxvCYo7vngFFSyY+MV+Wi9hyD93+iP6CRQPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 130/151] scsi: iscsi: Fix iscsi_task use after free
Date:   Mon, 11 Oct 2021 15:46:42 +0200
Message-Id: <20211011134522.008274880@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 258aad75c62146453d03028a44f2f1590d58e1f6 ]

Commit d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")
added iscsi_get_conn()/iscsi_put_conn() calls during abort handling but
then also changed the handling of the case where we detect an already
completed task where we now end up doing a goto to the common put/cleanup
code. This results in a iscsi_task use after free, because the common
cleanup code will do a put on the iscsi_task.

This reverts the goto and moves the iscsi_get_conn() to after we've checked
if the iscsi_task is valid.

Link: https://lore.kernel.org/r/20211004210608.9962-1-michael.christie@oracle.com
Fixes: d39df158518c ("scsi: iscsi: Have abort handler get ref to conn")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4683c183e9d4..5bc91d34df63 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2281,11 +2281,6 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
-	conn = session->leadconn;
-	iscsi_get_conn(conn->cls_conn);
-	conn->eh_abort_cnt++;
-	age = session->age;
-
 	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task || !task->sc) {
@@ -2293,8 +2288,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 
 		spin_unlock(&session->back_lock);
-		goto success;
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		return SUCCESS;
 	}
+
+	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
+	conn->eh_abort_cnt++;
+	age = session->age;
+
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
-- 
2.33.0



