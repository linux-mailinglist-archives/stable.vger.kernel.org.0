Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0DA2504D7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgHXRIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgHXQiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BEEC230FF;
        Mon, 24 Aug 2020 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287053;
        bh=qE5+wB2yQNTZu6+yGf54rLByZbGAm2LMJTgJXfl/Omk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx3okUA1aKV+4KYfY8Us73CUH7cMJUBCuMpe/xQXU4a3ZbcCQNlaNpySzeNrq+x3a
         iriCkGu4flDixg+dI4S9w0NZroQlEppQTUEp7eLKBEDoTMhF9a6yg5hxLT5lH2xlX4
         E5NmQaOlBkAG++wmK4mt2qS9Iq9qbe42XHm1dAA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 42/54] scsi: qla2xxx: Fix null pointer access during disconnect from subsystem
Date:   Mon, 24 Aug 2020 12:36:21 -0400
Message-Id: <20200824163634.606093-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 83949613fac61e8e37eadf8275bf072342302f4e ]

NVMEAsync command is being submitted to QLA while the same NVMe controller
is in the middle of reset. The reset path has deleted the association and
freed aen_op->fcp_req.private. Add a check for this private pointer before
issuing the command.

...
 6 [ffffb656ca11fce0] page_fault at ffffffff8c00114e
    [exception RIP: qla_nvme_post_cmd+394]
    RIP: ffffffffc0d012ba  RSP: ffffb656ca11fd98  RFLAGS: 00010206
    RAX: ffff8fb039eda228  RBX: ffff8fb039eda200  RCX: 00000000000da161
    RDX: ffffffffc0d4d0f0  RSI: ffffffffc0d26c9b  RDI: ffff8fb039eda220
    RBP: 0000000000000013   R8: ffff8fb47ff6aa80   R9: 0000000000000002
    R10: 0000000000000000  R11: ffffb656ca11fdc8  R12: ffff8fb27d04a3b0
    R13: ffff8fc46dd98a58  R14: 0000000000000000  R15: ffff8fc4540f0000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 7 [ffffb656ca11fe08] nvme_fc_start_fcp_op at ffffffffc0241568 [nvme_fc]
 8 [ffffb656ca11fe50] nvme_fc_submit_async_event at ffffffffc0241901 [nvme_fc]
 9 [ffffb656ca11fe68] nvme_async_event_work at ffffffffc014543d [nvme_core]
10 [ffffb656ca11fe98] process_one_work at ffffffff8b6cd437
11 [ffffb656ca11fed8] worker_thread at ffffffff8b6cdcef
12 [ffffb656ca11ff10] kthread at ffffffff8b6d3402
13 [ffffb656ca11ff50] ret_from_fork at ffffffff8c000255

--
PID: 37824  TASK: ffff8fb033063d80  CPU: 20  COMMAND: "kworker/u97:451"
 0 [ffffb656ce1abc28] __schedule at ffffffff8be629e3
 1 [ffffb656ce1abcc8] schedule at ffffffff8be62fe8
 2 [ffffb656ce1abcd0] schedule_timeout at ffffffff8be671ed
 3 [ffffb656ce1abd70] wait_for_completion at ffffffff8be639cf
 4 [ffffb656ce1abdd0] flush_work at ffffffff8b6ce2d5
 5 [ffffb656ce1abe70] nvme_stop_ctrl at ffffffffc0144900 [nvme_core]
 6 [ffffb656ce1abe80] nvme_fc_reset_ctrl_work at ffffffffc0243445 [nvme_fc]
 7 [ffffb656ce1abe98] process_one_work at ffffffff8b6cd437
 8 [ffffb656ce1abed8] worker_thread at ffffffff8b6cdb50
 9 [ffffb656ce1abf10] kthread at ffffffff8b6d3402
10 [ffffb656ce1abf50] ret_from_fork at ffffffff8c000255

Link: https://lore.kernel.org/r/20200806111014.28434-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 4886d247df6f6..1ba05d8871518 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -535,6 +535,11 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	struct nvme_private *priv = fd->private;
 	struct qla_nvme_rport *qla_rport = rport->private;
 
+	if (!priv) {
+		/* nvme association has been torn down */
+		return rval;
+	}
+
 	fcport = qla_rport->fcport;
 
 	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
-- 
2.25.1

