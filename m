Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5DC29B032
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757233AbgJ0OQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757226AbgJ0OQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C0422263;
        Tue, 27 Oct 2020 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808211;
        bh=8yHdRGj2/9Sfgc6fcwYzlH5G2QZh3n45m0COG9acsDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcMHDwLt3UDauZ/j/E8jYY8PUnMUNW3E8fa6c/GWFYATP/xGEUOnM9dHzEYCaR2me
         sMbMHlLg8yVUGyb2CTOjXDCaEWqDnYoR3mV8Y2X7Sm/1EGGWt8uA8nFSzukTG/nha4
         NoKgv/r3IcBWm3or38+a9S2Vuj6l43EeKRGV8+Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/191] scsi: qedi: Protect active command list to avoid list corruption
Date:   Tue, 27 Oct 2020 14:50:31 +0100
Message-Id: <20201027134918.195128456@linuxfoundation.org>
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

[ Upstream commit c0650e28448d606c84f76c34333dba30f61de993 ]

Protect active command list for non-I/O commands like login response,
logout response, text response, and recovery cleanup of active list to
avoid list corruption.

Link: https://lore.kernel.org/r/20200908095657.26821-5-mrangankar@marvell.com
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c    | 8 ++++++++
 drivers/scsi/qedi/qedi_iscsi.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 2e5e04a7623fa..e688300faeefd 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -62,6 +62,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -72,6 +73,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
@@ -127,6 +129,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
@@ -137,6 +140,7 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 			  cmd->task_id, qedi_conn->iscsi_conn_id,
 			  &cmd->io_cmd);
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
@@ -231,11 +235,13 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 
 	tmf_hdr = (struct iscsi_tm *)qedi_cmd->task->hdr;
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(qedi_cmd->io_cmd_in_list)) {
 		qedi_cmd->io_cmd_in_list = false;
 		list_del_init(&qedi_cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
@@ -299,11 +305,13 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
+	spin_lock(&qedi_conn->list_lock);
 	if (likely(cmd->io_cmd_in_list)) {
 		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 4d7971c3f339b..c55fb411c8a55 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -983,11 +983,13 @@ static void qedi_cleanup_active_cmd_list(struct qedi_conn *qedi_conn)
 {
 	struct qedi_cmd *cmd, *cmd_tmp;
 
+	spin_lock(&qedi_conn->list_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &qedi_conn->active_cmd_list,
 				 io_cmd) {
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 	}
+	spin_unlock(&qedi_conn->list_lock);
 }
 
 static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
-- 
2.25.1



