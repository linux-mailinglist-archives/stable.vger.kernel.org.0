Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC82121499
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfLPSMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730426AbfLPSMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:12:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692BF206E0;
        Mon, 16 Dec 2019 18:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519966;
        bh=dC3BKaGzyD47C+7JPgiEYv4kee05d9UvGB56Gy5Cp5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0upomm0TybHa99mzbrtJd//lqMknf7rq6RDy1heACa5Cra2QqZGYuxGcR4yvTEmji
         3ieTvMJW/RQzB378j3JFWG+oLF+kTax9GtqcujP+U+1LBRsG8/sCzOlkCtRzW0eIxg
         Nx9RBBDhCksGetViCCkT5nYR4eEU6JswAskhEA68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 142/180] scsi: qla2xxx: Fix hang in fcport delete path
Date:   Mon, 16 Dec 2019 18:49:42 +0100
Message-Id: <20191216174843.143052148@linuxfoundation.org>
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
index 2c617a34ae1e7..2f39ed9c66d64 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -396,9 +396,6 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
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



