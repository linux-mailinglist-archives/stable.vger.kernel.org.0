Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ACA29C52F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824780AbgJ0SFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757235AbgJ0OQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5C4206F7;
        Tue, 27 Oct 2020 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808213;
        bh=OUQmJVpfkCPr55FpPCnjaFc5PMQInHYf5iAnutgfJ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrtRHRJVlBoVfdAopLkVcoJcCBaINR9OU+CUu2pPEZgaQda43vRl5qHWB0u3OWb6u
         pCPu4bl3nUL4NbLRg5rQivxs2f9QyjQGFk12wW0Pr3N43PZbwJ11GkWcUitMqNwdVa
         c44uPXw22neyXssMoPpKRWojcIhTgWLM7gbPwN9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 177/191] scsi: qedi: Fix list_del corruption while removing active I/O
Date:   Tue, 27 Oct 2020 14:50:32 +0100
Message-Id: <20201027134918.245634608@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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
index e688300faeefd..e8f2c662471e0 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -844,8 +844,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
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
@@ -1265,6 +1268,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 		qedi_conn->cmd_cleanup_req++;
 		qedi_iscsi_cleanup_task(ctask, true);
 
+		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 		QEDI_WARN(&qedi->dbg_ctx,
@@ -1478,8 +1482,11 @@ static void qedi_tmf_work(struct work_struct *work)
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



