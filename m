Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677A129B7C7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794616AbgJ0PQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796133AbgJ0PPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:15:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F4120657;
        Tue, 27 Oct 2020 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811752;
        bh=XNBNPHCWavZrEu5SlajFZldWJA/rSGH/UWI9X1BQniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgnLo63oxkqHHlfd2bbyPKJWuA2yDEbvQHQQLaUA+99CKxlPARap8B1oOYyFQpuv3
         pXxIAEA5EX4PUPRxQspEU/A80zfR60V4T0l3sKmQgItCTE7fuIenXWmvPQaoySRhkj
         gWpS26oxhh5JncEmFfk+ieMeVGKSXq3u0RyKgqKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 604/633] scsi: qedi: Fix list_del corruption while removing active I/O
Date:   Tue, 27 Oct 2020 14:55:47 +0100
Message-Id: <20201027135551.148241734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 28b35d17f9f8573d4646dd8df08917a4076a6b63 ]

While aborting the I/O, the firmware cleanup task timed out and driver
deleted the I/O from active command list. Some time later the firmware
sent the cleanup task response and driver again deleted the I/O from
active command list causing firmware to send completion for non-existent
I/O and list_del corruption of active command list.

Add fix to check if I/O is present before deleting it from the active
command list to ensure firmware sends valid I/O completion and protect
against list_del corruption.

Link: https://lore.kernel.org/r/20200908095657.26821-4-mrangankar@marvell.com
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 32586800620bd..90aa64604ad78 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -825,8 +825,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_clear_task_idx(qedi_conn->qedi, rtid);
 
 			spin_lock(&qedi_conn->list_lock);
-			list_del_init(&dbg_cmd->io_cmd);
-			qedi_conn->active_cmd_count--;
+			if (likely(dbg_cmd->io_cmd_in_list)) {
+				dbg_cmd->io_cmd_in_list = false;
+				list_del_init(&dbg_cmd->io_cmd);
+				qedi_conn->active_cmd_count--;
+			}
 			spin_unlock(&qedi_conn->list_lock);
 			qedi_cmd->state = CLEANUP_RECV;
 			wake_up_interruptible(&qedi_conn->wait_queue);
@@ -1244,6 +1247,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 		qedi_conn->cmd_cleanup_req++;
 		qedi_iscsi_cleanup_task(ctask, true);
 
+		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 		QEDI_WARN(&qedi->dbg_ctx,
@@ -1455,8 +1459,11 @@ static void qedi_tmf_work(struct work_struct *work)
 	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
 	spin_lock(&qedi_conn->list_lock);
-	list_del_init(&cmd->io_cmd);
-	qedi_conn->active_cmd_count--;
+	if (likely(cmd->io_cmd_in_list)) {
+		cmd->io_cmd_in_list = false;
+		list_del_init(&cmd->io_cmd);
+		qedi_conn->active_cmd_count--;
+	}
 	spin_unlock(&qedi_conn->list_lock);
 
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-- 
2.25.1



