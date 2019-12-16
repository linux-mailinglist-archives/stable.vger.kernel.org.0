Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D072A12169B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbfLPSMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbfLPSMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB94206E0;
        Mon, 16 Dec 2019 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519952;
        bh=/cv/6abJU3XvKGPnuAB8xlGpmyFKElwPZzPYxBS/kAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EssGKJirLt2EGxUxdRAAz1JaW12BmX6yYpKgGtIo3CXielwhoXT5avdyOXnfqrjjD
         LDv8eHdYVmiAX6CTGRTd1/dPfnsN1Pnehgq1XkEk6utk9Tcbl/F1deEpe8ulkfICj8
         qanRUKWv6T0CosgyJcKi6k8845PI2xPCUTfv8T0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 136/180] scsi: qla2xxx: Fix abort timeout race condition.
Date:   Mon, 16 Dec 2019 18:49:36 +0100
Message-Id: <20191216174842.426476124@linuxfoundation.org>
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

[ Upstream commit 0c6df59061b23c7a951836d23977be34e896d3da ]

If an abort times out, the Abort IOCB completion and Abort timer can race
against each other. This patch provides unique error code for timer path to
allow proper cleanup.

[mkp: typo]

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a2922b17b55b0..bb1c7b2d0ac1f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4629,6 +4629,7 @@ struct secure_flash_update_block_pk {
 #define QLA_SUSPENDED			0x106
 #define QLA_BUSY			0x107
 #define QLA_ALREADY_REGISTERED		0x109
+#define QLA_OS_TIMER_EXPIRED		0x10a
 
 #define NVRAM_DELAY()		udelay(10)
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index afc890bc50e4f..5df604fae7593 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -99,9 +99,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
 {
 	srb_t *sp = data;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
+	struct qla_qpair *qpair = sp->qpair;
+	u32 handle;
+	unsigned long flags;
+
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
+		/* removing the abort */
+		if (qpair->req->outstanding_cmds[handle] == sp) {
+			qpair->req->outstanding_cmds[handle] = NULL;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
 	abt->u.abt.comp_status = CS_TIMEOUT;
-	sp->done(sp, QLA_FUNCTION_TIMEOUT);
+	sp->done(sp, QLA_OS_TIMER_EXPIRED);
 }
 
 static void qla24xx_abort_sp_done(void *ptr, int res)
@@ -109,7 +122,8 @@ static void qla24xx_abort_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
-	if (del_timer(&sp->u.iocb_cmd.timer)) {
+	if ((res == QLA_OS_TIMER_EXPIRED) ||
+	    del_timer(&sp->u.iocb_cmd.timer)) {
 		if (sp->flags & SRB_WAKEUP_ON_COMP)
 			complete(&abt->u.abt.comp);
 		else
-- 
2.20.1



