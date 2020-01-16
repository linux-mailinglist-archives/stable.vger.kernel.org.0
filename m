Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B2C13F5D9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388943AbgAPRGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388936AbgAPRGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A96F21582;
        Thu, 16 Jan 2020 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194389;
        bh=4W8VS8IETV5SxqetcRr+1EcIZttD2EodDWDUmxYf8kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gnw4XYdIAmyeUpSg3M4VAi0D51WU2VD+oZKWLxAY7zUfwL34FfHxcp5KIlTJ86Ww
         /RsMEEKPoxitVDkjaCJvm3t7TQvd1zlsDzCKWiIyB3HAoDgBgdzNcrdLyzL9DXSKBF
         ce0bcUXOBP+71uwtD8jVccGtbAvLz3ExeImkXr90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 317/671] scsi: qla2xxx: Fix error handling in qlt_alloc_qfull_cmd()
Date:   Thu, 16 Jan 2020 11:59:15 -0500
Message-Id: <20200116170509.12787-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bbbe1996620b..c925ca787537 100644
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

