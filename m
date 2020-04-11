Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5EE1A56E9
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgDKXTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbgDKXN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6200215A4;
        Sat, 11 Apr 2020 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646839;
        bh=7LYKt0FSsSfMmBKisjUpbUPSckbTl4TjeNRfR0FDIRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvZT+XJHTHgKqojNQirwfjPS/2q6074Z6a8mLvw5hexYAOH7Qw9LXcWeOYVnCcKPH
         7unqtiedc32uf9trMwrVqv500FF0DKgWkwvlI0ieQ8McXVrQN0bnVA4yAH2ig9wEmt
         shaFnhMhFANqPyKj1QXf6uimWkHwDKr6PLxbS9o4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Biradar <Sagar.Biradar@microchip.com>,
        Balsundar P <balsundar.p@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 27/37] scsi: aacraid: Disabling TM path and only processing IOP reset
Date:   Sat, 11 Apr 2020 19:13:16 -0400
Message-Id: <20200411231327.26550-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index a284527999c55..65a5cd6a5f961 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -771,7 +771,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
 		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
-	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
+	} else
 		return -EINVAL;
 
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 053a31c5485f3..e0e728d0dd5e7 100644
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
2.20.1

