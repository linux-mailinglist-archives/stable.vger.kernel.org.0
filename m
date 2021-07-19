Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6283CE0A7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347485AbhGSPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346396AbhGSPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B880C60200;
        Mon, 19 Jul 2021 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710068;
        bh=bx2NjaHIi7EIzUuk5t5pEMwJV/11m704jcJmZ6JoNMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xc1RWiU2wh5CsU7qMCp6CW456PtKGWnzEatZn5vTsvY9F0bVcph+INoqLAiNfBtGK
         VbFJz+fef1hZB7giSw69DB5BtzjSBCro3JZbj+msPuOaETVf6/tKKloHRce6JM7ksn
         j8RlVUNDuIzaubHBAWlQU53fLVNY2Lj7CGCHySUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/243] scsi: qedi: Fix TMF session block/unblock use
Date:   Mon, 19 Jul 2021 16:51:31 +0200
Message-Id: <20210719144942.926360586@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



