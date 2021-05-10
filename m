Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415C037833B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhEJKnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhEJKl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11DE161972;
        Mon, 10 May 2021 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642727;
        bh=/z5dTUJjzmVUsgl8hevEc3fL8woqrdFfRIFbIj23xeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OibW7Aps9yaOHrx71PqBEHQOtyQ/gfW0FGQFt64yz56kqsIf6u79rFHYufW8jvmVh
         fCSd2hLNofRWS646eU3wsgvSj7tRX8cMccWCtcarFsmgkKqb9u+OfSs0e/9/VoMNrS
         1/xQw73zPDzegPFUOT0zvOJIXHFHnZTgI4VT5xV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 026/299] scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()
Date:   Mon, 10 May 2021 12:17:03 +0200
Message-Id: <20210510102005.713431021@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 6641df81ab799f28a5d564f860233dd26cca0d93 upstream.

    RIP: 0010:kmem_cache_free+0xfa/0x1b0
    Call Trace:
       qla2xxx_mqueuecommand+0x2b5/0x2c0 [qla2xxx]
       scsi_queue_rq+0x5e2/0xa40
       __blk_mq_try_issue_directly+0x128/0x1d0
       blk_mq_request_issue_directly+0x4e/0xb0

Fix incorrect call to free srb in qla2xxx_mqueuecommand(), as srb is now
allocated by upper layers. This fixes smatch warning of srb unintended
free.

Link: https://lore.kernel.org/r/20210329085229.4367-7-njavali@marvell.com
Fixes: af2a0c51b120 ("scsi: qla2xxx: Fix SRB leak on switch command timeout")
Cc: stable@vger.kernel.org # 5.5
Reported-by: Laurence Oberman <loberman@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1008,8 +1008,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
-		if (rval == QLA_INTERFACE_ERROR)
-			goto qc24_free_sp_fail_command;
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1021,11 +1019,6 @@ qc24_host_busy_free_sp:
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
-qc24_free_sp_fail_command:
-	sp->free(sp);
-	CMD_SP(cmd) = NULL;
-	qla2xxx_rel_qpair_sp(sp->qpair, sp);
-
 qc24_fail_command:
 	cmd->scsi_done(cmd);
 


