Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3893C2EF3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhGJCaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234065AbhGJC3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64F56142C;
        Sat, 10 Jul 2021 02:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883924;
        bh=bx2NjaHIi7EIzUuk5t5pEMwJV/11m704jcJmZ6JoNMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ttk6fO5hvI7xc+wP3IB71hayRvQcEjnAJ6nRLgqJi9+X4VGLXcMTWQZlDaBfO90Ru
         rhPn/jqh6qnUecZ4BhFD/nfFgIGOci8cOejJp4NnMkHlUrFD1XAyFPlXW/eF67mXJZ
         83iLp87NwlzcrPUX7ldY/wDf9oUORi0Xo113gncSZCVyJ1mBMPBhHpLyuQCyKbD2k+
         tTNvKHk22lqzwwNYPSrLOEsfQXJsaoLs3toBWhGiooVo+eHMmZFL0Csf9L2xUl42aS
         HXKh8M3cmN70TKcbfuRusNUs80Wywbtm/505e1O7w2wzS25z/QEscw0J+MZHII0aZ7
         /wZnPalO6/xYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 42/93] scsi: qedi: Fix TMF session block/unblock use
Date:   Fri,  9 Jul 2021 22:23:36 -0400
Message-Id: <20210710022428.3169839-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 2819b4ae2873d50fd55292877b0231ec936c3b2e ]

Drivers shouldn't be calling block/unblock session for tmf handling because
the functions can change the session state from under libiscsi.
iscsi_queuecommand's call to iscsi_prep_scsi_cmd_pdu->
iscsi_check_tmf_restrictions will prevent new cmds from being sent to qedi
after we've started handling a TMF. So we don't need to try and block it in
the driver, and we can remove these block calls.

Link: https://lore.kernel.org/r/20210525181821.7617-25-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c12bb2dd5ff9..4c87640e6a91 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.30.2

