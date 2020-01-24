Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A31414843A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390286AbgAXLSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390315AbgAXLSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:35 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF73B20704;
        Fri, 24 Jan 2020 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864715;
        bh=3SRzaMwcdBamF7xF1o8992iLruhVXeqpGpMiK6xp+Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WBXUGDMQNIE1Qux5vgK/C3owJLuLaN9mVNj2cdY1Ew2hdnQe5K/LRVrwA+NSQV+3
         glGl+de8mVIrW07oDBAHN9EO3RieRI+0H6HoxaIGlqy12fW1/y+iEOVxY+Tc1i71MG
         NOc2TOwMvfrEYmJPN47xiR0kpWWpbYXr6JqYA2/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 332/639] scsi: qla2xxx: Fix error handling in qlt_alloc_qfull_cmd()
Date:   Fri, 24 Jan 2020 10:28:22 +0100
Message-Id: <20200124093128.693385771@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c04466c17142d5eb566984372b9a5003d1900fe3 ]

The test "if (!cmd)" is not useful because it is guaranteed that cmd !=
NULL.  Instead of testing the cmd pointer, rely on the tag to decide
whether or not command allocation failed.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: 33e799775593 ("qla2xxx: Add support for QFull throttling and Term Exchange retry") # v3.18.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bbbe1996620bf..c925ca7875374 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5334,11 +5334,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	se_sess = sess->se_sess;
 
 	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
-	if (tag < 0)
-		return;
-
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
-	if (!cmd) {
+	if (tag < 0) {
 		ql_dbg(ql_dbg_io, vha, 0x3009,
 			"qla_target(%d): %s: Allocation of cmd failed\n",
 			vha->vp_idx, __func__);
@@ -5353,6 +5349,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 		return;
 	}
 
+	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
 	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
 
 	qlt_incr_num_pend_cmds(vha);
-- 
2.20.1



