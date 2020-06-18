Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67C1FE76D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgFRBML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgFRBML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDC121974;
        Thu, 18 Jun 2020 01:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442730;
        bh=n77+mRGJzhZkF3sMpgr1Vq43gLpGDv+qKc9vyAuvuic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBWMPVsHr1befN8TNPY2htXhwn39vqM1E8in6+14n/O7J62tMis8TlDOK63IkWzc3
         M6U4VtpyoVw65dB4ouG9pqRClewh1mtf/o4KnuDbN0CjiaZDQ/c/35plLzoYlWoG4q
         7JVzVMIe9cky9fMEJEtEIQA0ppV3fJ+mO8T4JxEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 186/388] scsi: target: loopback: Fix READ with data and sensebytes
Date:   Wed, 17 Jun 2020 21:04:43 -0400
Message-Id: <20200618010805.600873-186-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit c68a56736c129f5dd1632856956f9c3e04bae200 ]

We use tcm_loop with tape emulations running on tcmu.

In case application reads a short tape block with a longer READ, or a long
tape block with a short READ, according to SCC spec data has to be
tranferred _and_ sensebytes with ILI set and information field containing
the residual count. Similar problem also exists when using fixed block
size in READ.

Up to now tcm_loop is not prepared to handle sensebytes if input data is
provided, as in tcm_loop_queue_data_in() it only sets SAM_STAT_GOOD and, if
necessary, the residual count.

To fix the bug, the same handling for sensebytes as present in
tcm_loop_queue_status() must be done in tcm_loop_queue_data_in() also.

After adding this handling, the two function now are nearly identical, so I
created a single function with two wrappers.

Link: https://lore.kernel.org/r/20200428182617.32726-1-bstroesser@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/loopback/tcm_loop.c | 36 +++++++++++++-----------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3305b47fdf53..16d5a4e117a2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -545,32 +545,15 @@ static int tcm_loop_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+static int tcm_loop_queue_data_or_status(const char *func,
+		struct se_cmd *se_cmd, u8 scsi_status)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
 	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
-
-	sc->result = SAM_STAT_GOOD;
-	set_host_byte(sc, DID_OK);
-	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
-	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
-		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
-	return 0;
-}
-
-static int tcm_loop_queue_status(struct se_cmd *se_cmd)
-{
-	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-				struct tcm_loop_cmd, tl_se_cmd);
-	struct scsi_cmnd *sc = tl_cmd->sc;
-
-	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
+		 func, sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
@@ -581,7 +564,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 		sc->result = SAM_STAT_CHECK_CONDITION;
 		set_driver_byte(sc, DRIVER_SENSE);
 	} else
-		sc->result = se_cmd->scsi_status;
+		sc->result = scsi_status;
 
 	set_host_byte(sc, DID_OK);
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
@@ -591,6 +574,17 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
+static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__, se_cmd, SAM_STAT_GOOD);
+}
+
+static int tcm_loop_queue_status(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__,
+					     se_cmd, se_cmd->scsi_status);
+}
+
 static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-- 
2.25.1

