Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDD121776
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfLPSG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbfLPSG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CACB206EC;
        Mon, 16 Dec 2019 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519616;
        bh=ZZCNl37csOKpEgVnThWHBvPhhL0/QSl1yVvj8Y5NkzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnxeaD8TN1bclfoY7rIyhaDbgC87VXSUn/Ubbf8IuJaxswJEFl3v/FVdbfsPa3x3s
         nQKT4qKicr+hyjezYXhZHqrCk/1xsXbfAiAbhq0OU7aOmtUyw1Cngj31RVKITjvB4d
         7xjyEen5CP3FRjHz0PQgV/Lf57ElGCrcMBbGHTrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/140] scsi: qla2xxx: Fix hang in fcport delete path
Date:   Mon, 16 Dec 2019 18:49:27 +0100
Message-Id: <20191216174812.764367641@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit f00b3428a801758243693e046b34226e92bc56b3 ]

A hang was observed in the fcport delete path when the device was
responding slow and an issue-lip path (results in session termination) was
taken.

Fix this by issuing logo requests unconditionally.

PID: 19491  TASK: ffff8e23e67bb150  CPU: 0   COMMAND: "kworker/0:0"
 #0 [ffff8e2370297bf8] __schedule at ffffffffb4f7dbb0
 #1 [ffff8e2370297c88] schedule at ffffffffb4f7e199
 #2 [ffff8e2370297c98] schedule_timeout at ffffffffb4f7ba68
 #3 [ffff8e2370297d40] msleep at ffffffffb48ad9ff
 #4 [ffff8e2370297d58] qlt_free_session_done at ffffffffc0c32052 [qla2xxx]
 #5 [ffff8e2370297e20] process_one_work at ffffffffb48bcfdf
 #6 [ffff8e2370297e68] worker_thread at ffffffffb48bdca6
 #7 [ffff8e2370297ec8] kthread at ffffffffb48c4f81

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index df91847d20cd0..9cb5527d3d8f1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -291,9 +291,6 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		return rval;
-
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
-- 
2.20.1



