Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A98450EE6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhKOSVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241120AbhKOSS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9654B633F1;
        Mon, 15 Nov 2021 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998657;
        bh=LluAd/Pe+7uhq2V/i6PcC3oKufA6n/JyoIfU3o3FZrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYneKoa7CC2PYQxmXb9d8Tnpgewg+OgjGoNlLoTE/OpJt/uraxE3UWoRVWQ3UY25o
         VsYtJLUBkGSVWA0+1C3VQhZ0DuXV1qZizRIxRxPxsvMd5L7z1eYlbz5uIZHLnrzBsS
         x4qTutCT9Q3fz90mtL+SpK6hVOx/8tm3MNNoWifw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.14 013/849] scsi: qla2xxx: Fix use after free in eh_abort path
Date:   Mon, 15 Nov 2021 17:51:36 +0100
Message-Id: <20211115165420.449946498@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 3d33b303d4f3b74a71bede5639ebba3cfd2a2b4d upstream.

In eh_abort path driver prematurely exits the call to upper layer. Check
whether command is aborted / completed by firmware before exiting the call.

9 [ffff8b1ebf803c00] page_fault at ffffffffb0389778
  [exception RIP: qla2x00_status_entry+0x48d]
  RIP: ffffffffc04fa62d  RSP: ffff8b1ebf803cb0  RFLAGS: 00010082
  RAX: 00000000ffffffff  RBX: 00000000000e0000  RCX: 0000000000000000
  RDX: 0000000000000000  RSI: 00000000000013d8  RDI: fffff3253db78440
  RBP: ffff8b1ebf803dd0   R8: ffff8b1ebcd9b0c0   R9: 0000000000000000
  R10: ffff8b1e38a30808  R11: 0000000000001000  R12: 00000000000003e9
  R13: 0000000000000000  R14: ffff8b1ebcd9d740  R15: 0000000000000028
  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
10 [ffff8b1ebf803cb0] enqueue_entity at ffffffffafce708f
11 [ffff8b1ebf803d00] enqueue_task_fair at ffffffffafce7b88
12 [ffff8b1ebf803dd8] qla24xx_process_response_queue at ffffffffc04fc9a6
[qla2xxx]
13 [ffff8b1ebf803e78] qla24xx_msix_rsp_q at ffffffffc04ff01b [qla2xxx]
14 [ffff8b1ebf803eb0] __handle_irq_event_percpu at ffffffffafd50714

Link: https://lore.kernel.org/r/20210908164622.19240-10-njavali@marvell.com
Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Co-developed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Co-developed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1237,6 +1237,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	uint32_t ratov_j;
 	struct qla_qpair *qpair;
 	unsigned long flags;
+	int fast_fail_status = SUCCESS;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1245,9 +1246,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
+	/* Save any FAST_IO_FAIL value to return later if abort succeeds */
 	ret = fc_block_scsi_eh(cmd);
 	if (ret != 0)
-		return ret;
+		fast_fail_status = ret;
 
 	sp = scsi_cmd_priv(cmd);
 	qpair = sp->qpair;
@@ -1255,7 +1257,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	vha->cmd_timeout_cnt++;
 
 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
-		return SUCCESS;
+		return fast_fail_status != SUCCESS ? fast_fail_status : FAILED;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	sp->comp = &comp;
@@ -1290,7 +1292,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			    __func__, ha->r_a_tov/10);
 			ret = FAILED;
 		} else {
-			ret = SUCCESS;
+			ret = fast_fail_status;
 		}
 		break;
 	default:


