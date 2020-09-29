Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE44327CBA7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732412AbgI2M3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgI2La6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:30:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF7C23B06;
        Tue, 29 Sep 2020 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378695;
        bh=Bp78cPVYjAliFs3m7XinnVw6ioVm945uiqpP/Ng4ObE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gW4l/rtnvu3khbQz8rNiNkjVLxq9xOHChsXeWgh0SPD9GdQ8Cea6i0CHOfX1+0SIK
         +qdvAIgmkrCPRmLTrIXeMisuI7jvlpGgzuULAHq2CHipnGg07ZYOISW8djJ/c2Vf/o
         Q2uZNdoQVw9MacsrxcX++aX8m3dmzuT6GtZvoWx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        Balsundar P <balsundar.p@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/245] scsi: aacraid: Disabling TM path and only processing IOP reset
Date:   Tue, 29 Sep 2020 12:59:15 +0200
Message-Id: <20200929105952.063582441@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Biradar <Sagar.Biradar@microchip.com>

[ Upstream commit bef18d308a2215eff8c3411a23d7f34604ce56c3 ]

Fixes the occasional adapter panic when sg_reset is issued with -d, -t, -b
and -H flags.  Removal of command type HBA_IU_TYPE_SCSI_TM_REQ in
aac_hba_send since iu_type, request_id and fib_flags are not populated.
Device and target reset handlers are made to send TMF commands only when
reset_state is 0.

Link: https://lore.kernel.org/r/1581553771-25796-1-git-send-email-Sagar.Biradar@microchip.com
Reviewed-by: Sagar Biradar <Sagar.Biradar@microchip.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/commsup.c |  2 +-
 drivers/scsi/aacraid/linit.c   | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index b7588de4484e5..4cb6ee6e1212e 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -743,7 +743,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
 		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
-	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
+	} else
 		return -EINVAL;
 
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1046947064a0b..0142547aaadd2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -736,7 +736,11 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		status = aac_hba_send(HBA_IU_TYPE_SCSI_TM_REQ, fib,
 				  (fib_callback) aac_hba_callback,
 				  (void *) cmd);
-
+		if (status != -EINPROGRESS) {
+			aac_fib_complete(fib);
+			aac_fib_free(fib);
+			return ret;
+		}
 		/* Wait up to 15 secs for completion */
 		for (count = 0; count < 15; ++count) {
 			if (cmd->SCp.sent_command) {
@@ -915,11 +919,11 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
 	info = &aac->hba_map[bus][cid];
 
-	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
-	    info->reset_state > 0)
+	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
+	 !(info->reset_state > 0)))
 		return FAILED;
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+	pr_err("%s: Host device reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
 	fib = aac_fib_alloc(aac);
@@ -934,7 +938,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	status = aac_hba_send(command, fib,
 			      (fib_callback) aac_tmf_callback,
 			      (void *) info);
-
+	if (status != -EINPROGRESS) {
+		info->reset_state = 0;
+		aac_fib_complete(fib);
+		aac_fib_free(fib);
+		return ret;
+	}
 	/* Wait up to 15 seconds for completion */
 	for (count = 0; count < 15; ++count) {
 		if (info->reset_state == 0) {
@@ -973,11 +982,11 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
 	info = &aac->hba_map[bus][cid];
 
-	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
-	    info->reset_state > 0)
+	if (!(info->devtype == AAC_DEVTYPE_NATIVE_RAW &&
+	 !(info->reset_state > 0)))
 		return FAILED;
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+	pr_err("%s: Host target reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
 	fib = aac_fib_alloc(aac);
@@ -994,6 +1003,13 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 			      (fib_callback) aac_tmf_callback,
 			      (void *) info);
 
+	if (status != -EINPROGRESS) {
+		info->reset_state = 0;
+		aac_fib_complete(fib);
+		aac_fib_free(fib);
+		return ret;
+	}
+
 	/* Wait up to 15 seconds for completion */
 	for (count = 0; count < 15; ++count) {
 		if (info->reset_state <= 0) {
@@ -1046,7 +1062,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 		}
 	}
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
+	pr_err("%s: Host bus reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
 	/*
 	 * Check the health of the controller
-- 
2.25.1



