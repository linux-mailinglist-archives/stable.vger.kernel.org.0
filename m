Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F516F49EC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbfKHMGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731564AbfKHLlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB88B222CB;
        Fri,  8 Nov 2019 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213281;
        bh=YTlxT0xhObld43kZ6Inn0eRYl+hSodKE+Pd8IjkbeNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijgPy0pcnCOEcOsFedKkeMKdR+MqC6+66EcHvRPWjGHrAySnRxmkC/F8Lfppw98CD
         ttWl6Br9rbEArfQMMDsJsYZ4doKyU8WRev6ADYbei5S9PlpoYOGHWUBWveoBCzP3Dv
         SAS5JBAvlQgNWEUS6RGQLpIDn/wRgfz7o7TuNCpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 142/205] scsi: qla2xxx: Increase abort timeout value
Date:   Fri,  8 Nov 2019 06:36:49 -0500
Message-Id: <20191108113752.12502-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 8bccfe0d21b5adbba6ec4fe1776160b80d09f78a ]

Abort IOCB request can take up to 40s or 2 ABTS timeout.  We will wait for
ABTS response for 20s. On a timeout, second ABTS can go out with another 20s
timeout. On 2nd ABTS timeout FW will automatically do Logout.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 733a55c09b1ca..8f502505aa796 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1789,7 +1789,8 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 
 	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
 	init_completion(&abt_iocb->u.abt.comp);
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
+	/* FW can send 2 x ABTS's timeout/20s */
+	qla2x00_init_timer(sp, 42);
 
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 	abt_iocb->u.abt.req_que_no = cpu_to_le16(cmd_sp->qpair->req->id);
-- 
2.20.1

