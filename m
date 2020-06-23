Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E237205EEA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbgFWU12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbgFWU1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B40B206C3;
        Tue, 23 Jun 2020 20:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944035;
        bh=OawpyKz8cvpjMBzYjkduS4+n6MkUnUmUoMX2bh1R1Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rgztejrjIgMioAMByzduxGA+SvPBDOWOF98RlEAoopaXNCS35g2Gm6OFIyKJK5PS
         7BuPovdcqOrlA5FQ5zvvmOA5IBRwiORe7KECHsGpEEeI8lHyQc6eBLsL+AO5d5dp5Q
         gOpKWvqxpP6OqBzdCvFpyY15EIVheNrKojXfRusI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/314] scsi: target: loopback: Fix READ with data and sensebytes
Date:   Tue, 23 Jun 2020 21:55:25 +0200
Message-Id: <20200623195345.072941550@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3305b47fdf536..16d5a4e117a27 100644
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



