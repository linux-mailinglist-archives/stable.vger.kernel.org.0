Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B36DF6495
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfKJDBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729241AbfKJC4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E339F224FE;
        Sun, 10 Nov 2019 02:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354103;
        bh=a0Ur+5kxtgHPxEjJZ9sSIDYPySqFtWB6JXtylGDi0lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzqbkMQqFRzxB/LCN/K0RFQNtJ3D6LsxYGdxtmJ8YUganKrh5eeCqUxx4dbUGtnLL
         sTFxl0ALVCkm6cKKJJB1T4m57dwZw/yFmlSYsn/VhcEkY8gMUWZXxvtFEVMFuCPWGM
         h1xQy3T/sMRmiaMEOjdQs3OJvIOf6teabqkLoQaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 094/109] scsi: NCR5380: Use DRIVER_SENSE to indicate valid sense data
Date:   Sat,  9 Nov 2019 21:45:26 -0500
Message-Id: <20191110024541.31567-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 070356513963be6196142acff56acc8359069fa1 ]

When sense data is valid, call set_driver_byte(cmd, DRIVER_SENSE).  Otherwise
some callers of scsi_execute() will ignore sense data.  Don't set DID_ERROR or
DID_RESET just because sense data is missing.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5f26aa2875bd9..00397e89d652d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -513,11 +513,12 @@ static void complete_cmd(struct Scsi_Host *instance,
 
 	if (hostdata->sensing == cmd) {
 		/* Autosense processing ends here */
-		if ((cmd->result & 0xff) != SAM_STAT_GOOD) {
+		if (status_byte(cmd->result) != GOOD) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-			set_host_byte(cmd, DID_ERROR);
-		} else
+		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+			set_driver_byte(cmd, DRIVER_SENSE);
+		}
 		hostdata->sensing = NULL;
 	}
 
@@ -2271,7 +2272,6 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (list_del_cmd(&hostdata->autosense, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from sense queue\n", cmd);
-		set_host_byte(cmd, DID_ERROR);
 		complete_cmd(instance, cmd);
 	}
 
@@ -2350,7 +2350,6 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	list_for_each_entry(ncmd, &hostdata->autosense, list) {
 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
 
-		set_host_byte(cmd, DID_RESET);
 		cmd->scsi_done(cmd);
 	}
 	INIT_LIST_HEAD(&hostdata->autosense);
-- 
2.20.1

