Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1E1214E7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbfLPSQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbfLPSQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0839D207FF;
        Mon, 16 Dec 2019 18:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520171;
        bh=xS8Y5k8sZBEYPLKkLbYUbQl4P9YoLy1v1ipp5f+HbOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=By1cDNWjyfZ2RfTJhk4clzaCxiHzk2RSXm3f026dn328Kc1Bj2M9kzgxyRzGWjLWH
         YP72aT+oun9MPJME2cnVSrBvmV87IGC4lnBbjvIXy7SySM8J6jiznl6uIZn0qQvrkF
         Lv+Qr2NNNiNNLf40Qy6XI3shFLopzAb+hFIto3p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 007/177] scsi: qla2xxx: Do command completion on abort timeout
Date:   Mon, 16 Dec 2019 18:47:43 +0100
Message-Id: <20191216174812.584590986@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 71c80b75ce8f08c0978ce9a9816b81b5c3ce5e12 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -604,6 +604,7 @@ typedef struct srb {
 	const char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
+	struct srb *cmd_sp;
 	struct list_head elem;
 	u32 gen1;	/* scratch */
 	u32 gen2;	/* scratch */
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -101,8 +101,22 @@ static void qla24xx_abort_iocb_timeout(v
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
@@ -111,6 +125,9 @@ static void qla24xx_abort_iocb_timeout(v
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	if (sp->cmd_sp)
+		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+
 	abt->u.abt.comp_status = CS_TIMEOUT;
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
 }
@@ -142,6 +159,7 @@ static int qla24xx_async_abort_cmd(srb_t
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
 	sp->qpair = cmd_sp->qpair;
+	sp->cmd_sp = cmd_sp;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 


