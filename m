Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D527C89D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgI2MD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgI2Lie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7847D221EC;
        Tue, 29 Sep 2020 11:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379498;
        bh=lkg8m6S1AERhd6OentmklbggICnz3oY6EXh/TQXZc0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJZFLX+ExrEzGbdlNpdPVXUNYpb5vdYf1l5zYTRrmtduxzMEjhEcVK3v0RRFHuKK4
         1c+ffMNc/4bo6KOEzhRhKKunOyIS8nMkaPcV6OmppKlVUA1H2m9sR2A8B5S7Vmbr3g
         8bg768YM4Az9iOkA7xBDmMPPbpEbXhFs/2sIroD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        Balsundar P <balsundar.p@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/388] scsi: aacraid: Disabling TM path and only processing IOP reset
Date:   Tue, 29 Sep 2020 12:58:12 +0200
Message-Id: <20200929110018.272511040@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index 2142a649e865b..90fb17c5dd69c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -728,7 +728,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
 		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
-	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
+	} else
 		return -EINVAL;
 
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4a858789e6c5e..514aed38b5afe 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -723,7 +723,11 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
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
@@ -902,11 +906,11 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
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
@@ -921,7 +925,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
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
@@ -960,11 +969,11 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
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
@@ -981,6 +990,13 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
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
@@ -1033,7 +1049,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 		}
 	}
 
-	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
+	pr_err("%s: Host bus reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
 	/*
 	 * Check the health of the controller
-- 
2.25.1



