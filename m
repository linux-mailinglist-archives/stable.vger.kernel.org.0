Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699F2121493
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbfLPSMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbfLPSMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFA6206B7;
        Mon, 16 Dec 2019 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519954;
        bh=2oSPk7Am9vJP6YaoyozVS/wigGzoum5Po323ansRbRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4gPVigcdEJcj7VChHGUfKgYfDaAc9BOIPx/HQpG3+akr1zfim0JxeekwA3Fj297X
         76YBOMfgvBpNoP+fOFnPa8eRwEZGcfeBnv6X6o1MWy/XDdm2EzatSkOH4YDYRNX1C8
         f/R1NN0xY37XF+buWxF/KR86DYivxSZ+Se38sUNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 137/180] scsi: qla2xxx: Do command completion on abort timeout
Date:   Mon, 16 Dec 2019 18:49:37 +0100
Message-Id: <20191216174842.564991975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 71c80b75ce8f08c0978ce9a9816b81b5c3ce5e12 ]

On switch, fabric and mgt command timeout, driver send Abort to tell FW to
return the original command.  If abort is timeout, then return both Abort
and original command for cleanup.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Link: https://lore.kernel.org/r/20191105150657.8092-3-hmadhani@marvell.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bb1c7b2d0ac1f..674ee2afe2b52 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -543,6 +543,7 @@ typedef struct srb {
 	const char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
+	struct srb *cmd_sp;
 	struct list_head elem;
 	u32 gen1;	/* scratch */
 	u32 gen2;	/* scratch */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5df604fae7593..a75a40b14140a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -103,8 +103,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	u32 handle;
 	unsigned long flags;
 
+	if (sp->cmd_sp)
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout - cmd hdl=%x, cmd type=%x hdl=%x, type=%x\n",
+		    sp->cmd_sp->handle, sp->cmd_sp->type,
+		    sp->handle, sp->type);
+	else
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout 2 - hdl=%x, type=%x\n",
+		    sp->handle, sp->type);
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
+		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
+		    sp->cmd_sp))
+			qpair->req->outstanding_cmds[handle] = NULL;
+
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
@@ -113,6 +127,9 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	if (sp->cmd_sp)
+		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+
 	abt->u.abt.comp_status = CS_TIMEOUT;
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
 }
@@ -147,6 +164,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
 	sp->qpair = cmd_sp->qpair;
+	sp->cmd_sp = cmd_sp;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-- 
2.20.1



